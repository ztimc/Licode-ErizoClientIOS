//
//  ICNSabineDeviceConfigure.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/6/12.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSabineDeviceConfigure.h"
#import <SabineSwissSDK/SabineSwissSDK.h>

@implementation ICNSabineDeviceConfigure

- (void)configure{

    
    [[SWDeviceManager sharedInstance] setMusicMix:NO];
    [[SWDeviceManager sharedInstance] setReverber:0];
      [[SWDeviceManager sharedInstance] setAgc:SWSAGCSwitch_OFF];
    
    
    SWSHardwardType model = [[[SWDeviceManager sharedInstance] getDeviceInfo] SWS_HardwardType];
    
    if(model == SWSHardwardTypeSMIC){
        [[SWDeviceManager sharedInstance] setMicEffect:15];
    }else if(model == SWSHardwardTypeAlayaSilver || model == SWSHardwardTypeAlayaPro){
        [[SWDeviceManager sharedInstance] setMonito:80];
        [[SWDeviceManager sharedInstance] setMicEffect:50];
    }
}

@end
