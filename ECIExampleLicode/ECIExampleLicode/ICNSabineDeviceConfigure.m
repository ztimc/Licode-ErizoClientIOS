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
    [[SSSwiss sharedInstance] setReverberaion:(UInt8)0];
    [[SSSwiss sharedInstance] setAGC:NO];
    
    DEVICE_NAME name = [deviceInfo getDeviceName];
    
    if(name == S_MIC){
        [[SSSwiss sharedInstance] setGain:15];
    }else if(name == ALAYA_PRO || name == ALAYA_SILVER){
        [[SSSwiss sharedInstance] setGain:50];
        [[SSSwiss sharedInstance] setMonitor:(UInt8)80];
    }
}

@end
