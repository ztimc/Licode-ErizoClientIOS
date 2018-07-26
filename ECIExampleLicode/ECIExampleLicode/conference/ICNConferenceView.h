//
//  ICNConferenceView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECStream.h"

@protocol ICNConferenceViewDelegete <NSObject>

- (void)onSwitchCamera;

- (void)onMutuCtlClick:(BOOL)mutu;

- (void)onCameraCtlClick:(BOOL)close;

- (void)onHangUpClick;

- (void)onSpeakerCtlClick:(BOOL)speaker;

@end


@interface ICNConferenceView : UIView

@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) id<ICNConferenceViewDelegete> delegete;

- (instancetype)initWithLocalStream:(ECStream*)stream
                              frame:(CGRect)frame;

- (void)jionByStream:(ECStream *)stream;

- (void)leaveByStream:(ECStream *)stream;

- (void)onAudioMuteFromStream:(ECStream *)stream
                    mute:(BOOL)mute;

- (void)onVideoCloseFromStream:(ECStream *)stream
                    close:(BOOL)close;



@end
