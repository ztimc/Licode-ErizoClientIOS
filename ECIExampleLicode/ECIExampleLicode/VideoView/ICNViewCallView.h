//
//  ICNViewCallView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/23.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/RTCCameraPreviewView.h>
#import "ICNVideoView.h"
#import "ECStream.h"
#import "ECPlayerView.h"

@interface ICNViewCallView : UIView

@property(nonatomic, strong,readonly) id<ICNVideoView> current;
@property(nonatomic, assign,readonly) NSInteger currentPosition;

@property(nonatomic,readonly) NSMutableArray<ICNVideoView> *videoViews;
@property(nonatomic,readonly) UIScrollView *videoScrollView;
@property(nonatomic, strong) AVCaptureSession *captureSession;


- (void)watchStream:(ECStream *)stream;

- (void)removeStreamById:(NSString *)streamId;

@end
