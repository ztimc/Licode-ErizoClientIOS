//
//  SWSDKManager.h
//  SabineBTSDK
//
//  Created by dszhangyu on 2018/5/14.
//  Copyright © 2018年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWSDKManager : NSObject

#pragma mark - 调试开关

+ (instancetype)sharedInstance;


/*!
 * 设置调试log开关, 默认是关闭的
 */
- (void)setSabineLog:(BOOL)isOn;


/**
 调试开关是否开启

 @return 返回YES表明已开启
 */
- (BOOL)isSabineLogOn;

/**
 注册sabineSDK
 */
-(BOOL)registerSabineSwissSDK;




@end
