//
//  SSBeamformer.h
//  Swiss
//
//  Created by ztimc on 2018/4/23.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#include <Foundation/Foundation.h>

@interface SSBeamformer : NSObject

/**
 初始化，使用之前调用

 @param sampleRate 采样率
 @param frameSize 一帧大小
 */
- (void)create:(int)sampleRate :(int)frameSize;


/**
 处理数据

 @param outPcm 输出的pcm数据，由调用者控制
 @param inPCM 输入的pcm
 @param len 输入pcm的长度
 @return 输出pcm的长度
 */
- (int)process: (uint8_t *)inPCM :(int)len :(uint8_t *)outPcm;


/**
 使用完毕后调用，否则内存泄漏
 */
- (void)close;

@end
