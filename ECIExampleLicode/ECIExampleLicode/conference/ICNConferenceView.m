//
//  ICNConferenceView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNConferenceView.h"
#import "ICNSurroundButton.h"
#import "ICNLocalVideoView.h"
#import "ICNRemoteVideoView.h"
#import "ICNConferenceAudioView.h"

@implementation ICNConferenceView {
    NSMutableArray<ECStream *>              *streams;
    NSMutableArray<id<ICNConferenceVideo>>  *_videoViews;
    NSMutableArray<ICNConferenceAudioView*> *_audioViews;
    
    UILabel     *_roomText;
    
    UIButton    *_hangupImage;
    UIImageView *_backgroudView;
    UIImageView *_backgroudIcon;
    ICNSurroundButton *_cameraSwichImage;
    ICNSurroundButton *_muteCtlImage;
    ICNSurroundButton *_cammerCtlImage;
    ICNSurroundButton *_speakerCtlImage;
    
    ECStream *_localStream;
    ICNLocalVideoView *_localVideoView;
    id<ICNConferenceVideo>_currentVideo;
}

- (instancetype)initWithLocalStream:(ECStream *)stream
                              frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        streams = [[NSMutableArray alloc] init];
        _videoViews = [[NSMutableArray alloc] init];
        _audioViews = [[NSMutableArray alloc] init];
        
        [streams addObject:stream];
        _localStream = stream;
        ICNLocalVideoView *locaVideolView = [[ICNLocalVideoView alloc] initWithStream:stream frame:frame];
        [_videoViews addObject:locaVideolView];
        _currentVideo = locaVideolView;
        _localVideoView = locaVideolView;
        
        ICNConferenceAudioView *localAudioView = [[ICNConferenceAudioView alloc] initWithStream:stream frame:CGRectZero];
        [localAudioView showMute:NO];
        [_audioViews addObject:localAudioView];
        
        _backgroudView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroudIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Background-Icon"]];
        
        _roomText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 16)];
        
        _hangupImage      = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        
        _cameraSwichImage = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _muteCtlImage     = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _cammerCtlImage   = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _speakerCtlImage  = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];;
        
        [self _setButtonInfo:_muteCtlImage
                       text:@"静音"
              selectedImage:[UIImage imageNamed: @"Mic-Mute-Selected-Icon"] normalImage:[UIImage imageNamed: @"Mic-Mute-Normal-Icon"]];
        [self _setButtonInfo:_cammerCtlImage
                       text:@"摄像头"
              selectedImage:[UIImage imageNamed: @"Camera-Selected-Icon"]
                normalImage:[UIImage imageNamed: @"Camera-Normal-Icon"]];
        [self _setButtonInfo:_speakerCtlImage
                       text:@"扬声器"
              selectedImage:[UIImage imageNamed: @"Speaker-Selected-Icon"]
                normalImage:[UIImage imageNamed: @"Speaker-Normal-Icon"]];
        [self _setButtonInfo:_cameraSwichImage
                        text:@"切换"
               selectedImage:[UIImage imageNamed: @"Camera-Filp-Icon"]
                 normalImage:[UIImage imageNamed: @"Camera-Filp-Icon"]];
       
        
        [_backgroudView setImage:[UIImage imageNamed: @"Main-Background"]];
        
        
        
        [_hangupImage setImage:[UIImage imageNamed: @"Hungup-Icon"] forState:UIControlStateNormal];
        
        [_cameraSwichImage addGestureRecognizer:[self _createGesture:@selector(_didTriple:)]];
        [_muteCtlImage addGestureRecognizer:[self _createGesture:@selector(_didTriple:)]];
        [_cammerCtlImage addGestureRecognizer:[self _createGesture:@selector(_didTriple:)]];
        [_hangupImage addGestureRecognizer:[self _createGesture:@selector(_didTriple:)]];
        [_speakerCtlImage addGestureRecognizer:[self _createGesture:@selector(_didTriple:)]];
        
        _roomText.font = [UIFont systemFontOfSize:14];
        _roomText.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        _roomText.layer.shadowOpacity = 1.0f;
        _roomText.layer.shadowOffset = CGSizeMake(1, 1);
        _roomText.layer.shadowRadius = 0.5F;
        _roomText.textColor = [UIColor whiteColor];
        
        NSString *roomName = _localStream.getAttributes[@"roomName"];
        _roomText.text = [NSString stringWithFormat:@"房间号:%@", roomName];
        
        [_cammerCtlImage setSelected:_localVideoView.enableVideo];
        [_muteCtlImage setSelected:!_localStream.mediaStream.audioTracks[0].isEnabled];
        
        [self addSubview:_backgroudView];
        [self addSubview:_backgroudIcon];
        [self addSubview:locaVideolView];
        [self addSubview:localAudioView];
        [self addSubview:_roomText];
        [self addSubview:_cameraSwichImage];
        [self addSubview:_muteCtlImage];
        [self addSubview:_cammerCtlImage];
        [self addSubview:_speakerCtlImage];
        [self addSubview:_hangupImage];
        
        if([self isEarphoneConnected] || [self isHeadsetPluggedIn]){
            
            [_speakerCtlImage setHidden:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
        
    }
    
    return self;
}




# pragma mark - configrue ui

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSInteger leftMargin = 10;
    
    _roomText.mh_x = leftMargin;
    _roomText.mh_y = 18;
    
    _backgroudView.frame = CGRectMake(0, 0, self.mh_width, self.mh_height);
    
    
    for(int i = 0; i < _audioViews.count; i++) {
        ICNConferenceAudioView *audioView = _audioViews[i];
        audioView.mh_x = 12
        + (50 * i);
        audioView.mh_y = 45;
    }
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        
        _muteCtlImage.mh_x = 14;
        _muteCtlImage.mh_y = self.bounds.size.height
        - _muteCtlImage.bounds.size.height
        - 30;
        
        _cammerCtlImage.mh_x = _muteCtlImage.mh_x
        + _muteCtlImage.mh_width
        + 14;
        
        _cammerCtlImage.mh_y = self.bounds.size.height
        - _muteCtlImage.bounds.size.height
        - 30;
        
        _hangupImage.mh_centerX = self.bounds.size.width / 2;
        _hangupImage.mh_y       = self.bounds.size.height
        - _hangupImage.mh_height
        - 10;
        
        _cameraSwichImage.mh_x = self.mh_width - _cameraSwichImage.mh_width - 14;
        _cameraSwichImage.mh_y = self.bounds.size.height
        - _cameraSwichImage.bounds.size.height
        - 30;
        
        _speakerCtlImage.mh_x =  _cameraSwichImage.mh_x
        - _cameraSwichImage.mh_width
        - 14;
        
        _speakerCtlImage.mh_y = self.bounds.size.height
        - _speakerCtlImage.mh_height
        - 30;
        
      
        
        _backgroudIcon.mh_centerX = CGRectGetMidX(self.bounds);
        _backgroudIcon.mh_y = 180;
        
        
        if(_currentVideo.isLocal){
            _currentVideo.getView.frame = self.bounds;
        }else{
            ICNRemoteVideoView *remoteVideoVeiw = (ICNRemoteVideoView*)_currentVideo;
            remoteVideoVeiw.frame = self.bounds;
            remoteVideoVeiw.videoView.frame = self.bounds;
        }
        [_currentVideo showBigStyle];
        
        int index = 0;
        for (int i = 0; i < _videoViews.count; i++) {
            // jump current
            if(!_videoViews[i].enableVideo){
                _videoViews[i].getView.hidden = YES;
                continue;
            }else{
                _videoViews[i].getView.hidden = NO;
            }
            
            if(_currentVideo != _videoViews[i]){
                [_videoViews[i] showSmallStyle];
                UIView *videoView = [_videoViews[i] getView];
                CGRect videoFrame = CGRectMake(
                                        self.bounds.size.width - 12 - 90,
                                        (self.bounds.size.height - 90) - (90 * (index + 1))- (index * 12),
                                        90,
                                        90);
                if(_videoViews[i].isLocal){
                    videoView.frame = videoFrame;
                }else{
                    ICNRemoteVideoView *remoteVideoVeiw = (ICNRemoteVideoView*)videoView;
                    remoteVideoVeiw.frame = videoFrame;
                    remoteVideoVeiw.videoView.mh_width = videoFrame.size.width;
                    remoteVideoVeiw.videoView.mh_height = videoFrame.size.height;
                }
                index++;
            }
        }
    }else if(interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight){
        
        _hangupImage.mh_x = self.mh_width - _hangupImage.mh_width - 30;
    
        _hangupImage.mh_centerY       = CGRectGetMidY(self.bounds);
        
        _cameraSwichImage.mh_centerX = _hangupImage.mh_centerX;
        _cameraSwichImage.mh_y = 10;
        
        _speakerCtlImage.mh_centerX = _hangupImage.mh_centerX;
        _speakerCtlImage.mh_y = _hangupImage.mh_y - 80;
        
        _muteCtlImage.mh_centerX = _hangupImage.mh_centerX;
        _muteCtlImage.mh_centerY = self.mh_height - _speakerCtlImage.mh_width - 10;
        
       
        _cammerCtlImage.mh_centerX = _hangupImage.mh_centerX;
        _cammerCtlImage.mh_y = _hangupImage.mh_y + 80;

        
        _backgroudIcon.mh_centerX = CGRectGetMidX(self.bounds);
        _backgroudIcon.mh_y = CGRectGetMidY(self.bounds);
        
        
        if(_currentVideo.isLocal){
            _currentVideo.getView.frame = self.bounds;
        }else{
            ICNRemoteVideoView *remoteVideoVeiw = (ICNRemoteVideoView*)_currentVideo;
            remoteVideoVeiw.frame = self.bounds;
            remoteVideoVeiw.videoView.frame = self.bounds;
        }
        [_currentVideo showBigStyle];
        
        int index = 0;
        for (int i = 0; i < _videoViews.count; i++) {
            // jump current
            if(!_videoViews[i].enableVideo){
                _videoViews[i].getView.hidden = YES;
                continue;
            }else{
                _videoViews[i].getView.hidden = NO;
            }
            
            if(_currentVideo != _videoViews[i]){
                [_videoViews[i] showSmallStyle];
                UIView *videoView = [_videoViews[i] getView];
                CGRect videoFrame = CGRectMake(((index + 1) * 10)
                                               +(90 * index),
                                               self.mh_height
                                               - 90
                                               - 12,
                                               90,
                                               90);
                if(_videoViews[i].isLocal){
                    videoView.frame = videoFrame;
                }else{
                    ICNRemoteVideoView *remoteVideoVeiw = (ICNRemoteVideoView*)videoView;
                    remoteVideoVeiw.frame = videoFrame;
                    remoteVideoVeiw.videoView.mh_width = videoFrame.size.width;
                    remoteVideoVeiw.videoView.mh_height = videoFrame.size.height;
                }
                index++;
            }
        }
        
    }
}

- (void)_setButtonInfo:(ICNSurroundButton *)button
                 text:(NSString*)text
        selectedImage:(UIImage*)selectedImage
          normalImage:(UIImage*)normalImage {
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:RGBHexAlpha(0x6FD8FF, 1) forState:UIControlStateSelected];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
}

- (UITapGestureRecognizer *)_createGesture:(SEL)action{
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    tapRecognizer.numberOfTapsRequired = 1;
    return tapRecognizer;
}



- (void)_handVideoView{
    
    bool hasVideo = false;
    for (int i = 0; i < _videoViews.count; i++) {
        hasVideo |= _videoViews[i].enableVideo;
    }
    
    if(hasVideo){
        if(_localVideoView.enableVideo){
            [self swapVideoViewToCurrent:_localVideoView];
        }else{
            for (int i = 0; i < _videoViews.count; i++) {
                if(_videoViews[i].enableVideo){
                    [self swapVideoViewToCurrent:_videoViews[i]];
                    break;
                }
            }
        }
    }
    
    [self setNeedsLayout];
}


- (void)swapVideoViewToCurrent:(id<ICNConferenceVideo>)swapView{
    if(_currentVideo == swapView) return;
    
    //移除手势
    [swapView.getView removeGestureRecognizer:(swapView.getView.gestureRecognizers[0])];
    //添加手势
    UITapGestureRecognizer * gesture = [self _createGesture:@selector(_onVideoClick:)];
    [_currentVideo.getView addGestureRecognizer:gesture];
    
    
    //交换位置，先交换本地管理的地址,再交换view位置
    NSUInteger swapViewIndexByVideos = [_videoViews indexOfObject:swapView];
    NSUInteger currentIndexByVideos = [_videoViews indexOfObject:_currentVideo];
    
    
    [_videoViews exchangeObjectAtIndex:swapViewIndexByVideos withObjectAtIndex:currentIndexByVideos];
    
    
    NSUInteger swapIndex = [self.subviews indexOfObject:swapView.getView];
    NSUInteger currentIndex = [self.subviews indexOfObject:_currentVideo.getView];
    
    [self exchangeSubviewAtIndex:swapIndex withSubviewAtIndex:currentIndex];
    _currentVideo = swapView;
    [self setNeedsLayout];
}

- (void)_didTriple:(UITapGestureRecognizer *)recognizer {
    if(!_delegete) return;
    
    if(recognizer.view == _cameraSwichImage){
        
        [_delegete onSwitchCamera];
        
    }else if(recognizer.view == _muteCtlImage){
        
        BOOL mute = !_muteCtlImage.isSelected;
        [_muteCtlImage setSelected:mute];
        [_delegete onMutuCtlClick:mute];
        _localStream.mediaStream.audioTracks[0].isEnabled = !mute;
    }else if(recognizer.view == _cammerCtlImage){
        
        BOOL videoEnable = !_cammerCtlImage.isSelected;
        [_cammerCtlImage setSelected:videoEnable];
        
        [_delegete onCameraCtlClick:!videoEnable];
        _localStream.mediaStream.videoTracks[0].isEnabled = videoEnable;
        
        [self _handVideoView];
    }else if(recognizer.view == _hangupImage){
        
        [_delegete onHangUpClick];
        
    }else if(recognizer.view == _speakerCtlImage){
        
        BOOL selected = !_speakerCtlImage.selected;
        [_speakerCtlImage setSelected:selected];
        [_delegete onSpeakerCtlClick:selected];
        
    }
}

- (void)_onVideoClick:(UITapGestureRecognizer *)recognizer {
    [self swapVideoViewToCurrent:(id<ICNConferenceVideo>)recognizer.view];
}

# pragma mark - stream operator
- (void)jionByStream:(ECStream *)stream {
    BOOL hasVideo = NO;
    for(int i = 0; i < _videoViews.count; i++){
        hasVideo |= _videoViews[i].enableVideo;
    }
    
    [streams addObject:stream];
    
    ICNConferenceAudioView *audioView = [[ICNConferenceAudioView alloc] initWithStream:stream frame:CGRectZero];
    [audioView showMute:NO];
        
    ICNRemoteVideoView *videoView = [[ICNRemoteVideoView alloc] initWithLiveStream:stream frame:CGRectMake(0, 0, 90, 90)];
    [videoView showSmallStyle];

    [_audioViews addObject:audioView];
    [_videoViews addObject:videoView];
    
    [self insertSubview:audioView aboveSubview:_currentVideo.getView];
    [self insertSubview:videoView aboveSubview:_currentVideo.getView];
    
    
    UITapGestureRecognizer *gestrue = [self _createGesture:@selector(_onVideoClick:)];
    [videoView addGestureRecognizer:gestrue];
    
    if(!hasVideo){
        [self swapVideoViewToCurrent:videoView];
    }
    
    [self setNeedsLayout];
}

- (void)leaveByStream:(ECStream *)stream {
    
    if([stream.streamId isEqualToString:_currentVideo.getStream.streamId]){
        [self swapVideoViewToCurrent:_localVideoView];
    }
    
    for(int i = 0; i < streams.count; i++){
        if([stream.streamId isEqualToString:streams[i].streamId]){
            [streams removeObject:streams[i]];
            break;
        }
    }
    
    for(int i = 0; i < _audioViews.count; i++){
        if([_audioViews[i].stream.streamId isEqualToString:stream.streamId]){
            [_audioViews[i] removeFromSuperview];
            [_audioViews removeObject:_audioViews[i]];
            break;
        }
    }
    
    for(int i = 0; i < _videoViews.count; i++){
        if([_videoViews[i].getStream.streamId isEqualToString:stream.streamId]){
            
            [_videoViews[i].getView removeFromSuperview];
            [_videoViews removeObject:_videoViews[i]];
            break;
        }
    }
    
}

- (void)onAudioMuteFromStream:(ECStream *)stream
                         mute:(BOOL)mute {
    for(int i = 0; i < _audioViews.count; i++){
        if([_audioViews[i].stream.streamId isEqualToString:stream.streamId]){
            [_audioViews[i] showMute:mute];
        }
    }
}

- (void)onVideoCloseFromStream:(ECStream *)stream
                         close:(BOOL)close {
    for(int i = 0; i < _videoViews.count; i++){
        if([_videoViews[i].getStream.streamId isEqualToString:stream.streamId]){
            NSDictionary *dictionary = _videoViews[i].getStream.getAttributes;
            NSMutableDictionary *mutableArray =  [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [mutableArray setValue:@(!close) forKey:@"video"];
            [_videoViews[i].getStream setAttributes:[NSDictionary dictionaryWithDictionary:mutableArray]];
            break;
        }
    }
    if(close){
        if([_currentVideo.getStream.streamId isEqualToString:stream.streamId]){
            if(_localVideoView.enableVideo){
                [self swapVideoViewToCurrent:_localVideoView];
            }else{
                id<ICNConferenceVideo> hasVideoView;
                for (int i = 0; i < _videoViews.count; i++) {
                    if(_videoViews[i].enableVideo){
                        hasVideoView = _videoViews[i];
                        break;
                    }
                }
                if(hasVideoView){
                   [self swapVideoViewToCurrent:hasVideoView];
                }
            }
        }
    }else{
        int hasCout = 0;
        id<ICNConferenceVideo> hasVideoView;
        for (int i = 0; i < _videoViews.count; i++) {
            if(_videoViews[i].enableVideo){
                hasCout++;
                hasVideoView = _videoViews[i];
            }
        }
        if(hasCout == 1){
            [self swapVideoViewToCurrent:hasVideoView];
        }
    }
    
    [self setNeedsLayout];
}

- (BOOL)isEarphoneConnected {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones] || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP]) {
            
            return YES;
        }
    }
    return NO;
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [_speakerCtlImage setHidden:YES];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [_speakerCtlImage setHidden:NO];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}


# pragma mark - property set
- (void)setCaptureSession:(AVCaptureSession *)captureSession{
    for (int i = 0; i < _videoViews.count; i++) {
        if(_videoViews[i].isLocal){
            ICNLocalVideoView *localView = (ICNLocalVideoView*)_videoViews[i];
            [localView setCaptureSession:captureSession];
            return;
        }
    }
}

@end
