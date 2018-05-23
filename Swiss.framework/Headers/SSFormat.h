//
//  SSFormater.h
//  Swiss
//
//  Created by ztimc on 2018/4/24.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFormat : NSObject


/**
 采样率，如 48000,44100,16000等
 */
@property (nonatomic,assign) NSUInteger sampleRate;

/**
 声道数,stereo(2)或者mono(1)
 */
@property (nonatomic,assign) NSUInteger channel;


@end
