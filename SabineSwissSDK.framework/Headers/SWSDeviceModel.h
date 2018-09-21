//
//  SWSDeviceModel.h
//  SabineBTSDK
//
//  Created by dszhangyu on 2018/5/9.
//  Copyright © 2018年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWDeviceManager.h"


@interface SWSDeviceModel : NSObject

@property (nonatomic, copy) NSString * SWS_manufactureID;// 生产商
@property (nonatomic, copy) NSString * SWS_licensedID;// 授权商
@property (nonatomic, copy) NSString * SWS_firmwareVersion;// 硬件版本
@property (nonatomic , copy)NSString * SWS_hardwareVersion;//固件版本
@property (nonatomic ,copy)NSString * SWS_codecVersion;//编码器版本
@property (nonatomic , copy)NSString * SWS_DeviceName;//设备名称
@property (nonatomic , assign)SWSHardwardType SWS_HardwardType;// 设备枚举
@property (nonatomic , copy)NSString * SWS_Protocol;//固件协议

@end
