//
//  ICNLocalVideoView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ICNConferenceVideo.h>
#import <WebRTC/RTCCameraPreviewView.h>

@interface ICNLocalVideoView : RTCCameraPreviewView<ICNConferenceVideo>

- (instancetype)initWithStream:(ECStream *)stream
                         frame:(CGRect)frame;

@end
