//
//  ICNRoomView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/13.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECStream.h"



@protocol ICNRoomViewDelegete <NSObject>

- (void)onSwitchCamera;

- (void)onMutuCtlClick:(BOOL)mutu;

- (void)onCameraCtlClick:(BOOL)close;

- (void)onHangUpClick;

- (void)onSpeakerCtlClick:(BOOL)speaker;

@end

@interface ICNRoomView : UIView

@property(nonatomic,strong) id<ICNRoomViewDelegete> delegete;

@property(nonatomic,strong) AVCaptureSession *captureSession;

- (instancetype)initWithLocalStream:(ECStream*)stream
                      frame:(CGRect)frame;

- (void)watchStream:(ECStream *)stream;
- (void)removeStreamById:(NSString *)streamId;

- (void)notifyRemoteAudioSateChange:(ECStream *)stream
                            ennable:(BOOL)enable;
- (void)notifyRemoteVideoSateChange:(ECStream *)stream
                            ennable:(BOOL)enable;

@end
