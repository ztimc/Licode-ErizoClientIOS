//
//  STCircularPCMBufferModel.h
//  SabineSwissSDK
//
//  Created by dszhangyu on 2018/5/25.
//  Copyright © 2018年 dszhangyu. All rights reserved.
//

#import "STCircularBufferModel.h"
#import <AVFoundation/AVFoundation.h>
#import "SWDeviceManager.h"


@class STCircularPCMBufferModel;
@protocol STCirculatPCMBufferDelegate <NSObject>
@optional

/*!
 * @discussion circularBuffer 收到数据后的回调方法, 该协议目前已由SWDeviceManager实现, 不必关注
 * @params circularBuff 存储音频数据的buffer
 * @params pcm 接收到的PCM数据
 * @params pcmSize 接收到的PCM数据长度(sizeof(Byte))
 */
- (void)circularBuffer:(STCircularPCMBufferModel *)circularBuff
    hasReceivePCMBytes:(Byte *)pcm
           pcmByteSize:(SInt32)pcmSize;

@end

@interface STCircularPCMBufferModel : STCircularBufferModel

@property (nonatomic , assign)BOOL isStartRecord;

@property (nonatomic, weak) id <STCirculatPCMBufferDelegate> delegate;

/*!
 * @discussion 此方法与代理方法 readPcm:didReceivePCMBytes:pcmByteSize:; 配合使用
 * @params byteLength 需要读取的数据长度(sizeof(Byte)) 一般为1024*2*numOfChannel
 * @return 需要读取的PCM数据, 如果读取的长度大于缓存中的长度则返回NULL
 *
 */
- (Byte *)readPCMByteWithLength:(SInt32)byteLength;



@end

