//
//  ICNSabineDeviceConfigure.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/6/12.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSabineDeviceConfigure.h"
#import <Swiss/Swiss.h>

@implementation ICNSabineDeviceConfigure

- (void)configure{
    SSDeviceInfo *deviceInfo = [[SSDeviceInfo alloc] init];
    [[SSSwiss sharedInstance] setMusicMix:NO];
    [[SSSwiss sharedInstance] setMonitor:(UInt8)0];
    [[SSSwiss sharedInstance] setReverberaion:(UInt8)0];
    
    DEVICE_NAME name = [deviceInfo getDeviceName];
    
    if(name == S_MIC){
        [[SSSwiss sharedInstance] setAGC:NO];
        [[SSSwiss sharedInstance] setGain:15];
    }else if(name == ALAYA_PRO || name == ALAYA_SILVER){
        [[SSSwiss sharedInstance] setAGC:NO];
        [[SSSwiss sharedInstance] setGain:30];
    }
}

@end
