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
#import "ICNConferenceView.h"
#import "UIView+Toast.h"

/*
static NSString *roomId = @"59de889a35189661b58017a1";
static NSString *roomName = @"IOS Demo APP";
static NSString *kDefaultUserName = @"ErizoIOS";
 */
#import "SwissPanel.h"

@interface MultiConferenceViewController () <UITextFieldDelegate,
                                             RTCEAGLVideoViewDelegate,
                                             RTCAudioSessionDelegate,
                                             ECRoomStatsDelegate,
                                             ICNConferenceViewDelegete>

@property(nonatomic,strong) NSString *roomName;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,assign) ChatMode mode;

@end

@implementation MultiConferenceViewController {
    ECStream *_localStream;
    ECRoom *_remoteRoom;
    
    ICNSettingModel *_settingMode;
    
    ICNConferenceView *_conferenceView;
    
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

- (void)loadView{
    _settingMode = [[ICNSettingModel alloc] init];
    
    [self initview];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSabineError:)
                                                 name:kSwissDidDisconnectNotification object:nil];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AppDelegate sharedDelegate] setVolume:100];
    ICNSabineDeviceConfigure * deviceConfigrue = [[ICNSabineDeviceConfigure alloc] init];
    [deviceConfigrue configure];
    RTCSetMinDebugLogLevel(RTCLoggingSeverityInfo);
    
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
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initview {
    // Initialize a stream and access local stream
    NSNumber *vidoeBitrate = [_settingMode currentMaxVideoBitrateSettingFromStore];
    NSNumber *audioBitrate = [_settingMode currentMaxAudioBitrateSettingFromStore];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{
        kStreamOptionMaxAudioBW: audioBitrate,
        kStreamOptionMaxVideoBW: vidoeBitrate,}];
    
    _localStream = [[ECStream alloc]
                   initLocalStreamWithOptions:options
                   attributes:@{@"name":@"localStream",
                                @"actualName":@"_userName",
                                @"roomName":self.roomName}];
    
    
    _localStream.mediaStream.videoTracks[0].isEnabled = self.mode == Video;
    
    _conferenceView = [[ICNConferenceView alloc] initWithLocalStream:_localStream frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_conferenceView setDelegete:self];
    self.view = _conferenceView;
    
    if ([_localStream hasVideo]) {
        [_conferenceView setCaptureSession:[_localStream capturer].captureSession];
    }
    
}

# pragma mark - ECRoomDelegate

- (void)room:(ECRoom *)room didError:(ECRoomErrorStatus)status reason:(NSString *)reason {
}

- (void)room:(ECRoom *)room didConnect:(NSDictionary *)roomMetadata {

    NSDictionary *attributes = @{
						   @"name": _roomName,
						   @"actualName": _userName,
                    @"audio":@(_localStream.mediaStream.audioTracks[0].isEnabled),
                    @"video":@(_localStream.mediaStream.videoTracks[0].isEnabled)
						   };

    [_localStream setAttributes:attributes];
    
	
	// We get connected and ready to publish, so publish.
    [_remoteRoom publish:_localStream];

    // Subscribe all streams available in the room.
    for (ECStream *stream in _remoteRoom.remoteStreams) {
        [_remoteRoom subscribe:stream];
    }
    [self _dismissLoading];
    [self _showConnectSuccess];
}

- (void)room:(ECRoom *)room didPublishStream:(ECStream *)stream {

}

- (void)room:(ECRoom *)room didSubscribeStream:(ECStream *)stream {
    
    NSDictionary *data = @{@"videoClose":
                               @(!_localStream.mediaStream.videoTracks[0].isEnabled),
                           @"audioMute":
                               @(!_localStream.mediaStream.audioTracks[0].isEnabled)
                           };
    [_localStream sendData:data];
    
    [_conferenceView jionByStream:stream];
}

- (void)room:(ECRoom *)room didUnSubscribeStream:(ECStream *)stream {
    [_conferenceView leaveByStream:stream];
}

- (void)room:(ECRoom *)room didAddedStream:(ECStream *)stream {
    // We subscribe to all streams added.

    [_remoteRoom subscribe:stream];
}

- (void)room:(ECRoom *)room didRemovedStream:(ECStream *)stream {
    [_conferenceView leaveByStream:stream];
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
        self->_localStream = nil;
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
    
    NSNumber *audio = [data objectForKey:@"audioMute"];
    NSNumber *video = [data objectForKey:@"videoClose"];
    if(audio){
        [_conferenceView onAudioMuteFromStream:stream mute:audio.boolValue];
    }
    if(video){
        [_conferenceView onVideoCloseFromStream:stream close:video.boolValue];
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
    
    // Initialize room (without token!)
    
    RTCDefaultVideoDecoderFactory *decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
    RTCDefaultVideoEncoderFactory *encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
    RTCPeerConnectionFactory *_peerFactory = [[RTCPeerConnectionFactory alloc]
                                              initWithEncoderFactory:encoderFactory
                                              decoderFactory:decoderFactory];
    _remoteRoom = [[ECRoom alloc] initWithDelegate:self
                                   andPeerFactory:_peerFactory];
    [_remoteRoom setStatsDelegate:self];
    
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
                              username:@"user"
                                  role:@"presenter"
                            completion:^(BOOL success, NSString *token) {
                                if (success) {
                                    [self->_remoteRoom connectWithEncodedToken:token];
                                    self->_localStream.signalingChannel = self->_remoteRoom.signalingChannel;
                                    [self _showLoading];
                                } else {
                                    [self _handleConnectError:@"创建房间失败"];
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
    for (ECStream *stream in _remoteRoom.remoteStreams) {
       [_conferenceView leaveByStream:stream];
    }
    [_remoteRoom leave];
    _remoteRoom = nil;
    _conferenceView.captureSession = nil;
    [_localStream.capturer stopCapture];
    [self dismissViewControllerAnimated:YES completion:nil];
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

# pragma mark connect handler

- (void)_handleConnectError:(NSString*)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"服务器连接失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Nuve sharedInstance] createToken:self->_roomName
                                  roomType:RoomTypeMCU
                                  username:@"user"
                                      role:@"presenter"
                                completion:^(BOOL success, NSString *token) {
                                    if (success) {
                                        [self->_remoteRoom connectWithEncodedToken:token];
                                        self->_localStream.signalingChannel = self->_remoteRoom.signalingChannel;
                                        [self _showLoading];
                                    } else {
                                        [self _handleConnectError:@"创建房间失败"];
                                    }
                                }];
    }];
    
    UIAlertAction *exit = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self leave];
    }];
    
    [alert addAction:retry];
    [alert addAction:exit];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_showLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToastActivity:CSToastPositionCenter];
    });

}

- (void)_dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hideToastActivity];
    });
}

- (void)_showConnectSuccess {
    [self.view makeToast:@"连接成功"
                duration:1
                position:CSToastPositionCenter];
}

# pragma mark - roomViewDelegete

- (void)onCameraCtlClick:(BOOL)close {
    
    _localStream.mediaStream.videoTracks[0].isEnabled = close;
    
    NSDictionary *data = @{@"videoClose": @(close)};
    
    [_localStream sendData:data];
}

- (void)onHangUpClick {
    [self leave];
}

- (void)onMutuCtlClick:(BOOL)mutu {
    if(mutu){
        [_localStream mute];
    }else{
        [_localStream unmute];
    }
    
    NSDictionary *data = @{@"audioMute": @(mutu)};
    
    [_localStream sendData:data];
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
    [_localStream switchCamera];
}


# pragma mark - status bar hide

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (void)onSabineError:(NSNotification *)notify {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"蓝牙断开了" message:@"请重新进入房间" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self leave];
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
