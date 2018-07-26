//
//  ICNViewCallView.h
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/23.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/RTCCameraPreviewView.h>
#import "ICNVideoViewDelegete.h"
#import "ECStream.h"
#import "ECPlayerView.h"
#import "ICNStatsView.h"
#import "SwissPanel.h"

@interface ICNViewCallView : UIView 

@property(nonatomic, strong,readonly) id<ICNVideoViewDelegete> current;


@property(nonatomic,readonly) NSMutableArray<ICNVideoViewDelegete> *videoViews;
@property(nonatomic,readonly) UIScrollView *videoScrollView;
@property(nonatomic,strong) ICNStatsView *statsView;
@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,readonly) SwissPanel *swissPanel;

- (void)watchStream:(ECStream *)stream;

- (void)removeStreamById:(NSString *)streamId;

@end
