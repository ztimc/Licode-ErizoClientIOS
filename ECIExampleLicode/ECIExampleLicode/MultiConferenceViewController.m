//
//  MultiConferenceViewController.m
//  ECIExampleLicode
//
//  Created by Alvaro Gil on 9/4/15.
//  Copyright (c) 2015 Alvaro Gil. All rights reserved.
//

#import "MultiConferenceViewController.h"
#import "ECRoom.h"
#import "ECStream.h"
#import "ECPlayerView.h"
#import "LicodeServer.h"
#import "Nuve.h"
#import "ErizoClient.h"
#import <Swiss/Swiss.h>
#import <CoreTelephony/CTCellularData.h>
#import "ICNSettingModel.h"
#import "AppDelegate.h"
#import "ICNSabineDeviceConfigure.h"
#import "ICNRoomView.h"


/*
static NSString *roomId = @"59de889a35189661b58017a1";
static NSString *roomName = @"IOS Demo APP";
static NSString *kDefaultUserName = @"ErizoIOS";
 */

@interface MultiConferenceViewController () <UITextFieldDelegate,
                                             RTCEAGLVideoViewDelegate,
                                             RTCAudioSessionDelegate,
                                             ECRoomStatsDelegate,
                                             ICNRoomViewDelegete>

@property(nonatomic,strong) NSString *roomName;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,assign) ChatMode mode;

@end

@implementation MultiConferenceViewController {
    ECStream *localStream;
    ECRoom *remoteRoom;
    NSMutableArray *playerViews;
    ICNSettingModel *settingMode;
    ICNRoomView *videoView;
}

- (instancetype) initWithMode:(ChatMode)mode
                     roomName:(NSString*)roomName
                     userName:(NSString*)userNmae{
    self = [super init];
    if(self){
        self.roomName = roomName;
        self.userName = userNmae;
        self.mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AppDelegate sharedDelegate] setVolume:100];
    ICNSabineDeviceConfigure * deviceConfigrue = [[ICNSabineDeviceConfigure alloc] init];
    [deviceConfigrue configure];
    RTCSetMinDebugLogLevel(RTCLoggingSeverityError);
	
    // Initialize player views array
    playerViews = [NSMutableArray array];
    settingMode = [[ICNSettingModel alloc] init];
    
    RTCAudioSessionConfiguration *webRTCConfig =
    [RTCAudioSessionConfiguration webRTCConfiguration];
    
    if([[SSSwiss sharedInstance] hasDevice]){
        webRTCConfig.category = AVAudioSessionCategoryPlayback;
        webRTCConfig.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
        webRTCConfig.sampleRate = 44100;
    }else{
        webRTCConfig.category = AVAudioSessionCategoryPlayAndRecord;
        webRTCConfig.categoryOptions = webRTCConfig.categoryOptions |
        AVAudioSessionCategoryOptionDefaultToSpeaker;
        webRTCConfig.sampleRate = 44100;
    }
    webRTCConfig.mode = AVAudioSessionModeDefault;

    webRTCConfig.inputNumberOfChannels = 2;
    webRTCConfig.outputNumberOfChannels = 2;
    [RTCAudioSessionConfiguration setWebRTCConfiguration:webRTCConfig];
    [self configureAudioSession];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self connect];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeLocalStream {
    // Initialize a stream and access local stream
    NSNumber *vidoeBitrate = [settingMode currentMaxVideoBitrateSettingFromStore];
    NSNumber *audioBitrate = [settingMode currentMaxAudioBitrateSettingFromStore];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{
        kStreamOptionMaxAudioBW: audioBitrate,
        kStreamOptionMaxVideoBW: vidoeBitrate,}];
    
    localStream = [[ECStream alloc]
                   initLocalStreamWithOptions:options
                   attributes:@{@"name":@"localStream",
                                @"actualName":_userName,
                                @"roomName":self.roomName}];
    
    localStream.mediaStream.videoTracks[0].isEnabled = _mode == Video;
    videoView = [[ICNRoomView alloc] initWithLocalStream:localStream frame:self.view.bounds];
    [videoView setDelegete:self];
    [self.view addSubview:videoView];
    // Render local stream
    if ([localStream hasVideo]) {
        [videoView setCaptureSession:[localStream capturer].captureSession];
    }
    
}

# pragma mark - ECRoomDelegate

- (void)room:(ECRoom *)room didError:(ECRoomErrorStatus)status reason:(NSString *)reason {
}

- (void)room:(ECRoom *)room didConnect:(NSDictionary *)roomMetadata {

    NSDictionary *attributes = @{
						   @"name": _roomName,
						   @"actualName": _userName,
                    @"audio":@(localStream.mediaStream.audioTracks[0].isEnabled),
                    @"video":@(localStream.mediaStream.videoTracks[0].isEnabled)
						   };

    [localStream setAttributes:attributes];
    
	
	// We get connected and ready to publish, so publish.
    [remoteRoom publish:localStream];

    // Subscribe all streams available in the room.
    for (ECStream *stream in remoteRoom.remoteStreams) {
        [remoteRoom subscribe:stream];
    }
}

- (void)room:(ECRoom *)room didPublishStream:(ECStream *)stream {

}

- (void)room:(ECRoom *)room didSubscribeStream:(ECStream *)stream {
    [videoView watchStream:stream];
}

- (void)room:(ECRoom *)room didUnSubscribeStream:(ECStream *)stream {
    [videoView removeStreamById:stream.streamId];
}

- (void)room:(ECRoom *)room didAddedStream:(ECStream *)stream {
    // We subscribe to all streams added.

    [remoteRoom subscribe:stream];
}

- (void)room:(ECRoom *)room didRemovedStream:(ECStream *)stream {
    [videoView removeStreamById:stream.streamId];
}

- (void)room:(ECRoom *)room didStartRecordingStream:(ECStream *)stream
                                    withRecordingId:(NSString *)recordingId
                                      recordingDate:(NSDate *)recordingDate {
    // TODO
}

- (void)room:(ECRoom *)room didFailStartRecordingStream:(ECStream *)stream
                                           withErrorMsg:(NSString *)errorMsg {
    // TODO
}

- (void)room:(ECRoom *)room didUnpublishStream:(ECStream *)stream {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->localStream = nil;
    });
}

- (void)room:(ECRoom *)room didChangeStatus:(ECRoomStatus)status {
    switch (status) {
        case ECRoomStatusDisconnected:
            
            break;
        default:
            break;
    }
}

- (void)room:(ECRoom *)room didReceiveData:(NSDictionary *)data fromStream:(ECStream *)stream {
	L_INFO(@"received data stream %@ %@\n", stream.streamId, data);
    
    NSNumber *audio = [data objectForKey:@"audioSate"];
    NSNumber *video = [data objectForKey:@"videoSate"];
    if(audio){
        [videoView notifyRemoteAudioSateChange:stream ennable:audio.boolValue];
    }
    if(video){
        [videoView notifyRemoteVideoSateChange:stream ennable:video.boolValue];
    }
}

- (void)room:(ECRoom *)room didUpdateAttributesOfStream:(ECStream *)stream {
	L_INFO(@"updated attributes stream %@ %@\n", stream.streamId, stream.streamAttributes);
}

# pragma mark - RTCEAGLVideoViewDelegate

- (void)videoView:(RTCEAGLVideoView*)videoView didChangeVideoSize:(CGSize)size {
	L_INFO(@"Change %p %f %f", videoView, size.width, size.height);
}



# pragma mark - UI Actions

-(void)connect {
    if (!localStream) {
        [self initializeLocalStream];
    }
    
    // Initialize room (without token!)
    
    RTCDefaultVideoDecoderFactory *decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
    RTCDefaultVideoEncoderFactory *encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
    RTCPeerConnectionFactory *_peerFactory = [[RTCPeerConnectionFactory alloc]
                                              initWithEncoderFactory:encoderFactory
                                              decoderFactory:decoderFactory];
    remoteRoom = [[ECRoom alloc] initWithDelegate:self
                                   andPeerFactory:_peerFactory];
    [remoteRoom setStatsDelegate:self];
    
    /*
     
     Method 1: Chotis example:
     =========================
     
     Obtains a token from official Licode demo servers.
     This method is useful if you don't have a custom Licode deployment and
     want to try it. Keep in mind that many times demo servers are down or
     with self-signed or expired certificates.
     You might need to update room ID on LicodeServer.m file.
     
     [[LicodeServer sharedInstance] obtainMultiVideoConferenceToken:username
     completion:^(BOOL result, NSString *token) {
     if (result) {
     // Connect with the Room
     [remoteRoom connectWithEncodedToken:token];
     } else {
     [self showCallConnectViews:YES updateStatusMessage:@"Token fetch failed"];
     }
     }];
     
     Method 2: Connect with Nuve directly without middle server API:
     ===============================================================
     
     The following methods are recommended if you already have your own
     Licode deployment. Check Nuve.h for sub-API details.
     
     
     Method 2.1: Create token for the first room name/type available with the posibility
     to create one if not exists.
     */
    
    
    /*[[Nuve sharedInstance] createTokenForTheFirstAvailableRoom:nil
     roomType:RoomTypeMCU
     username:username
     create:YES
     completion:^(BOOL success, NSString *token) {
     if (success) {
     [remoteRoom connectWithEncodedToken:token];
     } else {
     [self showCallConnectViews:YES
     updateStatusMessage:@"Error!"];
     }
     }];*/
    
    [[Nuve sharedInstance] createToken:_roomName
                              roomType:RoomTypeMCU
                              username:_userName
                                  role:@"presenter"
                            completion:^(BOOL success, NSString *token) {
                                if (success) {
                                    [self->remoteRoom connectWithEncodedToken:token];
                                    self->localStream.signalingChannel = self->remoteRoom.signalingChannel;
                                } else {
                                    NSLog(@"error createToken");
                                }
                            }];
    
    
    
    /* Method 2.2: Create a token for a given room id.
     
     [[Nuve sharedInstance] createTokenForRoomId:roomId
     username:username
     role:kLicodePresenterRole
     completion:^(BOOL success, NSString *token) {
     if (success) {
     [remoteRoom connectWithEncodedToken:token];
     } else {
     [self showCallConnectViews:YES
     updateStatusMessage:@"Error!"];
     }
     }];*/
    /*
     Method 2.3: Create a Room and then create a Token.
     
     [[Nuve sharedInstance] createRoomAndCreateToken:roomName
     roomType:RoomTypeMCU
     username:username
     completion:^(BOOL success, NSString *token) {
     if (success) {
     [remoteRoom connectWithEncodedToken:token];
     } else {
     [self showCallConnectViews:YES
     updateStatusMessage:@"Error!"];
     }
     }];
     */

}

- (void)leave{
    for (ECStream *stream in remoteRoom.remoteStreams) {
        [videoView removeStreamById:stream.streamId];
    }
    [remoteRoom leave];
    remoteRoom = nil;
    videoView.captureSession = nil;
    [localStream.capturer stopCapture];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unpublish:(id)sender {
    if (localStream) {
        [remoteRoom unpublish];
    } else {
        [self initializeLocalStream];
        [remoteRoom publish:localStream];
    }
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
	NSDictionary *data = @{
						   @"name": _userName,
						   @"msg": @"my test message in licode chat room"
						   };
	[localStream sendData:data];
	
	NSDictionary *attributes = @{
						   @"name": _userName,
						   @"actualName": _userName,
						   @"type": @"public",
						   };
	[localStream setAttributes:attributes];
}

- (void)closeStream:(id)sender {
    NSString *streamId = [NSString stringWithFormat:@"%ld", (long)((UIButton *)sender).tag];
    for (ECStream *stream in remoteRoom.remoteStreams) {
        if ([stream.streamId isEqualToString:streamId]) {
            [remoteRoom unsubscribe:stream];
        }
    }
}

- (void)configureAudioSession {
    RTCAudioSessionConfiguration *configuration =
    [[RTCAudioSessionConfiguration alloc] init];
    configuration.category = AVAudioSessionCategoryPlayback;
    configuration.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
    configuration.mode = AVAudioSessionModeDefault;
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session lockForConfiguration];
    BOOL hasSucceeded = NO;
    NSError *error = nil;
    if (session.isActive) {
        hasSucceeded = [session setConfiguration:configuration error:&error];
    } else {
        hasSucceeded = [session setConfiguration:configuration
                                          active:YES
                                           error:&error];
    }
    if (!hasSucceeded) {
        RTCLogError(@"Error setting configuration: %@", error.localizedDescription);
    }
    [session unlockForConfiguration];
}

# pragma mark - publish statistic

- (void)room:(ECRoom *)room publishingClient:(ECClient *)publishingClient
                                            mediaType:(NSString *)mediaType
                                            ssrc:(NSString *)ssrc
                                            didPublishingAtKbps:(long)kbps{
}

- (void)room:(ECRoom *)room publishingClient:(ECClient *)publishingClient
                                            mediaType:(NSString *)mediaType
                                            ssrc:(NSString *)ssrc
                                            didReceiveStats:(RTCLegacyStatsReport *)statsReport{
}

# pragma mark - roomViewDelegete

- (void)onCameraCtlClick:(BOOL)close {
    
    localStream.mediaStream.videoTracks[0].isEnabled = close;
    
    NSDictionary *data = @{@"videoSate": @(close)};

    [localStream sendData:data];
}

- (void)onHangUpClick {
    [self leave];
}

- (void)onMutuCtlClick:(BOOL)mutu {
    if(mutu){
        [localStream mute];
    }else{
        [localStream unmute];
    }
    
    NSDictionary *data = @{@"audioSate": @(!mutu)};
    
    [localStream sendData:data];
}

- (void)onSpeakerCtlClick:(BOOL)speaker {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    if(speaker){
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                            error:nil];
    }else{
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                            error:nil];
    }
}

- (void)onSwitchCamera {
    [localStream switchCamera];
}

# pragma mark - status bar hide

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
