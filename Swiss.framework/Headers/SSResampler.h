//
//  SSResampler.h
//  Swiss
//
//  Created by ztimc on 2018/4/23.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSResampler : NSObject


/**
 初始化，使用前必须前调用

 @param srcSapleRate 原采样率
 @param desSampleRate 目标采样率
 @param channel 声道数
 */
- (void)create:(int)srcSapleRate :(int)desSampleRate :(int)channel;

/**
 重采样

 @param outPcm 采样之后的数据,这块内存由调用者管理
 @param inPCM 原始pcm
 @param len 原始pcm的长度
 @return 重采样之后的长度
 */
- (int)reSample: (uint8_t *)inPCM :(int)len :(uint8_t *)outPcm;


/**
 使用完毕后一定要调用该方法，否则内存泄露!
 */
- (void)close;

@end
