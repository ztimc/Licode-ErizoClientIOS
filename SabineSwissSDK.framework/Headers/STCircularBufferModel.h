//
//  STCircularBufferModel.h
//  SabineSwissSDK
//
//  Created by dszhangyu on 2018/5/25.
//  Copyright © 2018年 dszhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCircularBufferModel : NSObject
@property (nonatomic, assign, readonly) void *circularBufferRef;
@property (nonatomic, assign, readonly) SInt32 availableReadBytes;

/**
 创建缓存池

 @param byteSize 缓存池大小
 @return 创建结果
 */
- (BOOL)creatCircularBufferWithSize:(SInt32)byteSize;

/**
 初始化缓存池

 @param byteSize 缓存池大小
 @return 缓存池对象
 */
- (instancetype)initWithCircularBufferSize:(SInt32)byteSize;

/**
 重置缓存池
 */
- (void)reset;

/**
 向缓存池添加数据

 @param dataByte 添加的数据流
 @param byteLength 数据长度
 */
- (void)appendWithDataByte:(Byte *)dataByte byteLength:(UInt32)byteLength;

/**
 从缓存池里面读取数据

 @param byteLength 要读取的长度
 @return 读取数据流
 */
- (Byte *)readByteFromCircularWithLength:(SInt32)byteLength;

/**
 从缓存池里面读取数据

 @param availableBytes 读取所有数据
 @return 读取的长度
 */
- (Byte *)tailOfAvailableReadBytes:(SInt32 *)availableBytes;
@end
