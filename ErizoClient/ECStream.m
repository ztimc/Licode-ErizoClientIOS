//
//  ErizoClientIOS
//
//  Copyright (c) 2015 Alvaro Gil (zevarito@gmail.com).
//
//  MIT License, see LICENSE file for details.
//

@import WebRTC;
#import "ECStream.h"

@implementation ECStream

@synthesize signalingChannel = _signalingChannel;

# pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
        _streamAttributes = @{};
        _streamOptions = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                        kStreamOptionVideo: @TRUE,
                                                                        kStreamOptionAudio: @TRUE,
                                                                        kStreamOptionData: @TRUE
                           }];
    }
    return self;
}

- (instancetype)initLocalStream {
    self = [self initLocalStreamVideoConstraints:nil audioConstraints:nil];
    return self;
}

- (instancetype)initLocalStreamWithOptions:(NSDictionary *)options
                                attributes:(NSDictionary *)attributes {
    if (self = [self initLocalStreamWithOptions:options
                                     attributes:attributes
                               videoConstraints:nil
                               audioConstraints:nil]) {
    }
    return self;
}

- (instancetype)initLocalStreamWithOptions:(NSDictionary *)options
                                attributes:(NSDictionary *)attributes
                          videoConstraints:(RTCMediaConstraints *)videoConstraints
                          audioConstraints:(RTCMediaConstraints *)audioConstraints {
    if (self = [self init]) {
        RTCDefaultVideoDecoderFactory *decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
        RTCDefaultVideoEncoderFactory *encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
        _peerFactory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:encoderFactory
                                                             decoderFactory:decoderFactory];

        _defaultVideoConstraints = videoConstraints;
        _defaultAudioConstraints = audioConstraints;
        _isLocal = YES;
        if (options) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:_streamOptions];
            for (NSString *key in options) {
                [tempDict setValue:[options valueForKey:key] forKey:key];
            }
            _streamOptions = [NSMutableDictionary dictionaryWithDictionary:tempDict];
        }
        if (attributes) {
            [self setAttributes:attributes];
        }
        [self createLocalStream];
    }
    return self;
}

- (instancetype)initLocalStreamVideoConstraints:(RTCMediaConstraints *)videoConstraints
                               audioConstraints:(RTCMediaConstraints *)audioConstraints {
    if (self = [self initLocalStreamWithOptions:nil
                                     attributes:nil
                               videoConstraints:videoConstraints
                               audioConstraints:audioConstraints]) {
    }
    return self;
}

- (instancetype)initWithStreamId:(NSString *)streamId
                      attributes:(NSDictionary *)attributes
                signalingChannel:(ECSignalingChannel *)signalingChannel {
    if (self = [self init]) {
        _streamId = streamId;
        _isLocal = NO;
        _streamAttributes = attributes;
        _dirtyAttributes = NO;
        self.signalingChannel = signalingChannel;
    }
    return self;
}

# pragma mark - Public Methods

- (void)setSignalingChannel:(ECSignalingChannel *)signalingChannel {
    if (signalingChannel) {
        _signalingChannel = signalingChannel;
        if (_dirtyAttributes) {
            [self setAttributes:_streamAttributes];
        }
    }
}

- (ECSignalingChannel *)signalingChannel {
    return _signalingChannel;
}

- (RTCMediaStream *)createLocalStream {
    _usingFrontCamera = true;
    _mediaStream = [_peerFactory mediaStreamWithStreamId:@"LCMSv0"];

    if ([(NSNumber *)[_streamOptions objectForKey:kStreamOptionVideo] boolValue])
        [self generateVideoTracks];
    
    if ([(NSNumber *)[_streamOptions objectForKey:kStreamOptionAudio] boolValue])
        [self generateAudioTracks];

    return _mediaStream;
}

- (void)generateVideoTracks {
    [self removeVideoTracks];

    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
    if (localVideoTrack) {
        [_mediaStream addVideoTrack:localVideoTrack];
    } else {
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE
        L_ERROR(@"Could not add video track!");
#else
        L_WARNING(@"Simulator doesn't have access to camera, not adding video track.");
#endif
    }
}

- (void)generateAudioTracks {
    [self removeAudioTracks];

    RTCAudioTrack *localAudioTrack = [self createLocalAudioTrack];
    if (localAudioTrack) {
        [_mediaStream addAudioTrack:localAudioTrack];
    } else {
        L_ERROR(@"Could not add audio track!");
    }
}

- (NSDictionary *)getAttributes {
	if(!self.streamAttributes) {
        return @{};
	}
    return self.streamAttributes;
}

- (void)setAttributes:(NSDictionary *)attributes {
    _streamAttributes = attributes;

    if (!self.isLocal) {
        _dirtyAttributes = NO;
        return;
    } else if (!self.signalingChannel) {
        _dirtyAttributes = YES;
        return;
    }

    ECUpdateAttributeMessage *message = [[ECUpdateAttributeMessage alloc]
                                         initWithStreamId:self.streamId
                                         withAttribute:self.streamAttributes];
    [self.signalingChannel updateStreamAttributes:message];
    _dirtyAttributes = NO;
}


- (BOOL)hasAudio {
	return (self.mediaStream.audioTracks.count > 0);
}

- (BOOL)hasVideo {
	return (self.mediaStream.videoTracks.count > 0);
}

- (BOOL)hasData {
	return [[NSString stringWithFormat:@"%@", [_streamOptions valueForKey:kStreamOptionData]]
            boolValue];
}

- (void)mute {
    for (RTCAudioTrack *audioTrack in _mediaStream.audioTracks) {
        audioTrack.isEnabled = NO;
    }
}

- (void)unmute {
    for (RTCAudioTrack *audioTrack in _mediaStream.audioTracks) {
        audioTrack.isEnabled = YES;
    }
}

- (BOOL)sendData:(NSDictionary *)data {
    if (![(NSNumber *)[_streamOptions objectForKey:kStreamOptionData] boolValue]) {
        L_WARNING(@"Trying to send data on a non enabled data stream.");
        return NO;
    }

    if (!self.isLocal) {
        L_WARNING(@"Cannot send data from a non-local stream.");
        return NO;
    }

    if (!data || !self.signalingChannel) {
        L_WARNING(@"Cannot send data, either you pass nil data or signaling channel is not available.");
        return NO;
    }
    ECDataStreamMessage *message = [[ECDataStreamMessage alloc] initWithStreamId:self.streamId
                                                                        withData:data];
    [self.signalingChannel sendDataStream:message];
    return YES;
}

- (void)dealloc {
    [self removeAudioTracks];
    [self removeVideoTracks];
    _mediaStream = nil;
}

# pragma mark - Private Instance Methods

- (RTCVideoTrack *)createLocalVideoTrack {
    RTCVideoSource *source = [_peerFactory videoSource];
    
    _capturer = [[RTCCameraVideoCapturer alloc] initWithDelegate:source];
    [self startCapture];
    return [_peerFactory videoTrackWithSource:source trackId:kLicodeVideoLabel];
}

- (RTCAudioTrack *)createLocalAudioTrack {
    RTCAudioSource *audioSource = [_peerFactory audioSourceWithConstraints:_defaultAudioConstraints];
    RTCAudioTrack *audioTrack = [_peerFactory audioTrackWithSource:audioSource trackId:kLicodeAudioLabel];
    return audioTrack;
}

- (void)removeAudioTracks {
    if (!_mediaStream) return;

    for (RTCAudioTrack *localAudioTrack in _mediaStream.audioTracks) {
        [_mediaStream removeAudioTrack:localAudioTrack];
    }
}

- (void)removeVideoTracks {
    if (!_mediaStream) return;

    for (RTCVideoTrack *localVideoTrack in _mediaStream.videoTracks) {
        [_mediaStream removeVideoTrack:localVideoTrack];
    }
}

- (void)startCapture {
    AVCaptureDevicePosition position =
    _usingFrontCamera ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    AVCaptureDevice *device = [self findDeviceForPosition:position];
    AVCaptureDeviceFormat *format = [self selectFormatForDevice:device];
    
    if (format == nil) {
        RTCLogError(@"No valid formats for device %@", device);
        NSAssert(NO, @"");
        
        return;
    }
    
    //NSInteger fps = [self selectFpsForFormat:format];
    NSInteger fps = 25;

     [_capturer startCaptureWithDevice:device format:format fps:fps];
}

- (void)stopCapture {
    [_capturer stopCapture];
}

- (void)switchCamera {
    _usingFrontCamera = !_usingFrontCamera;
    [self startCapture];
}

#pragma mark - Private

- (AVCaptureDevice *)findDeviceForPosition:(AVCaptureDevicePosition)position {
    NSArray<AVCaptureDevice *> *captureDevices = [RTCCameraVideoCapturer captureDevices];
    for (AVCaptureDevice *device in captureDevices) {
        if (device.position == position) {
            return device;
        }
    }
    return captureDevices[0];
}

- (AVCaptureDeviceFormat *)selectFormatForDevice:(AVCaptureDevice *)device {
    NSArray<AVCaptureDeviceFormat *> *formats =
    [RTCCameraVideoCapturer supportedFormatsForDevice:device];
    int targetWidth = 208;
    int targetHeight = 351;
    AVCaptureDeviceFormat *selectedFormat = nil;
    int currentDiff = INT_MAX;
    
    for (AVCaptureDeviceFormat *format in formats) {
        CMVideoDimensions dimension = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
        FourCharCode pixelFormat = CMFormatDescriptionGetMediaSubType(format.formatDescription);
        int diff = abs(targetWidth - dimension.width) + abs(targetHeight - dimension.height);
        if (diff < currentDiff) {
            selectedFormat = format;
            currentDiff = diff;
        } else if (diff == currentDiff && pixelFormat == [_capturer preferredOutputPixelFormat]) {
            selectedFormat = format;
        }
    }
    
    return selectedFormat;
}

- (NSInteger)selectFpsForFormat:(AVCaptureDeviceFormat *)format {
    Float64 maxFramerate = 0;
    for (AVFrameRateRange *fpsRange in format.videoSupportedFrameRateRanges) {
        maxFramerate = fmax(maxFramerate, fpsRange.maxFrameRate);
    }
    return maxFramerate;
}


@end
