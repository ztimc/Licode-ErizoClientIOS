//
//  SSFirmwareManager.h
//  Swiss
//
//  Created by ztimc on 2018/3/3.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSFirmwareManager : NSObject

+ (instancetype)shareInstance;

- (void)updateFirmware:(NSString *)filePath
        updateProgress:(nullable void (^)(NSProgress *uploadProgress))updateProgressBlock;

- (void)onReceivedFileLength:(NSUInteger)receivedFileLength;

NS_ASSUME_NONNULL_END
@end
