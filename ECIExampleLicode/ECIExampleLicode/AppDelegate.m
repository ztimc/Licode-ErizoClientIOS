//
//  AppDelegate.m
//  ECIExampleLicode
//
//  Created by Alvaro Gil on 9/4/15.
//  Copyright (c) 2015 Alvaro Gil. All rights reserved.
//

@import WebRTC;
#import "AppDelegate.h"
#import "ErizoClient.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <SabineSwissSDK/SabineSwissSDK.h>
#import "ICNSabineDeviceConfigure.h"
#import "Wav.h"

@interface AppDelegate ()<SabineDeviceDelegate,SWDeviceManagerAudioStreamDelegate>

@property(nonatomic, strong) UISlider *volumeSlider;
@property(nonatomic, strong) MPVolumeView *volumeView;
@property(nonatomic, assign) BOOL isSabine;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize library
    [ErizoClient sharedInstance];
    [self initSwiss];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SWDeviceManager sharedInstance] connect:^(BOOL success) {
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initSwiss{
    [[SWDeviceManager sharedInstance] connect:^(BOOL success) {
        
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(staticChange:) name:SWSccessoryConnectStateChangeNotification object:nil];
    [[SWSDKManager sharedInstance] registerSabineSwissSDK];
    
    [[RTCAudioSession sharedInstance] setSabineDelete:self];
}

-(void)staticChange:(NSNotification * )noti{
    _isSabine = [[noti object] boolValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance]setActive:YES error:nil];
        [[AppDelegate sharedDelegate] setVolume:90];
        ICNSabineDeviceConfigure * deviceConfigrue = [[ICNSabineDeviceConfigure alloc] init];
        [deviceConfigrue configure];
    });
    
}

- (BOOL)hasDevice {
    return _isSabine;
}

- (BOOL)SabineDeviceState {
    return _isSabine;
}

- (void)SabineDeviceStopRecording {
    [[SWDeviceManager sharedInstance] stopRecord];
}

- (void)sabineDeviceStartRecording {
    [[SWDeviceManager sharedInstance] startRecordWithDelegate:self];
}

- (void)readPCMBytesWithCircular:(STCircularPCMBufferModel *)circular andPcm:(Byte *)pcm pcmByteSize:(SInt32)pcmSize {
    
    
    [[RTCAudioSession sharedInstance] pushSabineData:(UInt8 *)pcm length:pcmSize];
}

/**
 获取音量大小
 
 @return 返回值
 */
-(float)getVolume{
    //    在app刚刚初始化的时候使用MPVolumeView获取音量大小可能为0，因此使用[[AVAudioSession sharedInstance]outputVolume]，使用AVAudioSession需要导入头文件#import <AVFoundation/AVFoundation.h>
    return self.volumeSlider.value > 0 ? self.volumeSlider.value : [[AVAudioSession sharedInstance]outputVolume];
}


/**
 设置音量大小
 
 @param value 范围0~100
 */
- (void)setVolume:(float)value {
    
    self.volumeSlider = [self volumeSlider];
    self.volumeView.showsVolumeSlider = YES; // 需要设置 showsVolumeSlider 为 YES
    // 下面两句代码是关键
    [self.volumeSlider setValue:value animated:NO];
    [self.volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.volumeView sizeToFit];
}

/**
 获取MPVolumeView
 
 @return MPVolumeView
 */
- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 100, 100)];
        //下面两行代码都会使音量界面重新显示
        //        [_volumeView setHidden:YES];
        //        [_volumeView removeFromSuperview];
        [self.window addSubview:_volumeView];
    }
    return _volumeView;
}

/**
 获取MPVolumeView上面的滑条
 
 @return UISlider
 */
- (UISlider *)volumeSlider {
    UISlider* volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            break;
        }
    }
    return volumeSlider;
}

@end
