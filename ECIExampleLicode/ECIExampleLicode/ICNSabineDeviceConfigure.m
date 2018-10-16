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
   
    [[SWDeviceManager sharedInstance] setReverber:0];
   
    [[SWDeviceManager sharedInstance] setAgc:SWSAGCSwitch_OFF];
    
    
    SWSHardwardType model = [[[SWDeviceManager sharedInstance] getDeviceInfo] SWS_HardwardType];
    [[SWDeviceManager sharedInstance] setMusicMix:SWSMusicMixSwitch_OFF];
    
    if(model == SWSHardwardTypeSMIC){
        [[SWDeviceManager sharedInstance] setMicEffect:15];
        [[SWDeviceManager sharedInstance] setMonito:60];
    }else if(model == SWSHardwardTypeAlayaSilver || model == SWSHardwardTypeAlayaPro){
        [[SWDeviceManager sharedInstance] setMonito:80];
        [[SWDeviceManager sharedInstance] setMicEffect:50];
    }
}

@end
