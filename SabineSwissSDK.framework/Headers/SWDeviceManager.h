//
//  SWDeviceManager.h
//  SabineBTSDK
//
//  Created by dszhangyu on 2018/5/8.
//  Copyright © 2018年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SWSDeviceModel;
/*!
 * 蓝牙协议连接状态发生变化的通知，连接发生改变如果正在录音需要停止录音
 */
FOUNDATION_EXPORT NSString * const SWSccessoryConnectStateChangeNotification;

/*
 *一键录音
 */
FOUNDATION_EXPORT NSString * const SWSButtonPressedNotification;
/*
 *电量等级
 */
FOUNDATION_EXPORT NSString * const SWSPowerLevelNotification;

/**
 设备类型
 
 - SWSHardwardTypeDefault: 手机麦克风
 - SWSHardwardTypeAlayaSilver: alaya普通版
 - SWSHardwardTypeAlayaPro: alaya专业版
 - SWSHardwardTypeSMIC: smic
 - SWSHardwardTypeMike: mike
 - SWSHardwardTypeSOLO: solo
 */
typedef NS_ENUM(NSUInteger, SWSHardwardType) {
    SWSHardwardTypeDefault = 0,
    SWSHardwardTypeAlayaSilver,
    SWSHardwardTypeAlayaPro,
    SWSHardwardTypeSMIC,
    SWSHardwardTypeMike,
    SWSHardwardTypeSOLO,
};

/**
 降噪等级
 
 - SWS_AnsLevel_OFF: 关闭
 - SWS_AnsLevel_Low: 低
 - SWS_AnsLevel_Medium: 中
 - SWS_AnsLevel_Hight: 高
 */
typedef NS_ENUM(NSUInteger, SWSAnsLevel) {
    SWS_AnsLevel_OFF,
    SWS_AnsLevel_Low,
    SWS_AnsLevel_Medium,
    SWS_AnsLevel_Hight,
};

/**
 混音开关
 
 - SWSMusicMixSwitch_OFF: 关闭混音
 - SWSMusicMixSwitch_ON: 开启混音
 */
typedef NS_ENUM(NSUInteger, SWSMusicMixSwitch) {
    SWSMusicMixSwitch_OFF,
    SWSMusicMixSwitch_ON,
};

/**
 自动增益开关
 
 - SWSAGCSwitch_OFF: 关闭自动增益
 - SWSAGCSwitch_ON: 打开自动增益
 */
typedef NS_ENUM(NSUInteger, SWSAGCSwitch) {
    SWSAGCSwitch_OFF,
    SWSAGCSwitch_ON,
};

/**
 呼吸灯状态,录音过程有效
 
 - SWSLight_Static_Close: 关闭
 - SWSLight_Static_Twinkle: 闪烁
 - SWSLight_Static_Breath: 呼吸
 */
typedef NS_ENUM(NSUInteger, SWSLight_Static) {
    SWSLight_Static_Close = 1,
    SWSLight_Static_Twinkle,
    SWSLight_Static_Breath,
};

//-------------------SOLO设备有效---------------//
/**
 solo场景枚举
 
 - SOLO_Defautl_Surround_OFF: 默认场景 麦克风听湿录湿, 所听即所得
 - SOLO_Defautl_Surround_ON: 默认场景 麦克风听湿录湿, 所听即所得
 - SOLO_Dry_Sound_Surround_OFF: 干音场景 麦克风听干录干, 听伴奏录的无伴奏
 - SOLO_Dry_Sound_Surround_ON: 干音场景 麦克风听干录干 , 听原唱录的无伴奏
 - SOLO_Sing_Along_With_Surround_OFF: 跟唱场景 麦克风听湿录湿, 听伴奏录伴奏
 - SOLO_Sing_Along_With_Surround_ON: 跟唱场景 麦克风听湿录湿, 听原唱录伴奏
 - SOLO_Cantata_Surround_OFF: 清唱场景 麦克风听湿录湿, 听伴奏录的无伴奏
 - SOLO_Cantata_Surround_ON: 清唱场景 麦克风听湿录湿, 听原唱录的无伴奏
 - SOLO_Rollback_Surround:SOLO播放的时候要开启（原唱模式开启）
 */
typedef NS_ENUM(NSUInteger, SOLO_Devocal_Surround) {
    SOLO_Defautl_Surround_OFF,
    SOLO_Defautl_Surround_ON,
    SOLO_Dry_Sound_Surround_OFF,
    SOLO_Dry_Sound_Surround_ON,
    SOLO_Sing_Along_With_Surround_OFF,
    SOLO_Sing_Along_With_Surround_ON,
    SOLO_Cantata_Surround_OFF,
    SOLO_Cantata_Surround_ON,
    SOLO_Rollback_Surround,
};

/**
 设置响指开关
 
 - SOLO_Snap_Auto_Devocal_NO: 响指检测关
 - SOLO_Snap_Auto_Devocal_YES: 响指检测开
 */
typedef NS_ENUM(NSUInteger, SOLO_Snap_Auto_Devocal) {
    SOLO_Snap_Auto_Devocal_NO,
    SOLO_Snap_Auto_Devocal_YES,
};


@class STCircularPCMBufferModel;
@protocol SWDeviceManagerAudioStreamDelegate <NSObject>
@optional


/**
 读取pcm数据,注意如果要使用缓存池读取数据，每次读取的数据长度应大于3840，缓存池一旦存满，将覆盖最早的数据
 
 @param circular 缓存池
 @param pcm 实时流
 @param pcmSize 大小
 */
- (void)readPCMBytesWithCircular:(STCircularPCMBufferModel *)circular andPcm:(Byte *)pcm pcmByteSize:(SInt32)pcmSize;

@end


@interface SWDeviceManager : NSObject
/*!
 * 与蓝牙录音协议的连接状态, 收到SWSccessoryConnectStateChangeNotification 通知, 则表明该变量发生变化
 */
@property (nonatomic, assign, readonly) BOOL isConnect;

@property (nonatomic, assign) BOOL skipAudioStream;//控制流是否输出（Yes为抛弃帧数据）

@property (nonatomic, assign, readonly) BOOL isOutputStreamReady;//   初始化完成判断是否可以发送蓝牙数据流



@property (nonatomic, weak) id <SWDeviceManagerAudioStreamDelegate> delegate;


#pragma mark - 初始化

/**
 初始化单例
 
 @return 返回对象
 */
+ (instancetype)sharedInstance;

/**
 获取SDK版本号

 @return 版本号
 */
+(NSString *)getVersion;

/**
 连接是否成功
 
 @param connect YES表示连接成功
 */
-(void)connect:(void(^)(BOOL success))connect;


/*!
 * 断开蓝牙协议
 */
- (void)disConnect;


/**
 获取设备信息model
 
 @return 返回设备信息model
 */
-(SWSDeviceModel * )getDeviceInfo;


#pragma mark - 设置参数
/**
 设置监听, 此方法对左右声道都有效
 @param value 取值范围0 ~ 100
 */
-(void)setMonito:(NSInteger)value;

/**
 设置降噪等级
 
 @param value 参见枚举SWSAnsLevel
 */
-(void)setAns:(SWSAnsLevel)value;

/**
 设置混音开关
 
 @param value 参见枚举SWSMusicMixSwitch
 */
-(void)setMusicMix:(SWSMusicMixSwitch)value;

/**
 设置混响
 
 @param value 取值范围0~100
 */
-(void)setReverber:(NSInteger)value;

/**
 设置自动增益开关
 
 @param value 参见枚举SWSAGCSwitch
 */
-(void)setAgc:(SWSAGCSwitch)value;


/**
 设置增益值，此方法对左右声道都有效
 
 @param value 取值范围 0 ~ 100
 */
-(void)setMicEffect:(NSInteger)value;

/**
 设置呼吸灯状态
 
 @param value 参见枚举SWSLight_Static
 */
-(void)setLightState:(SWSLight_Static)value;

#pragma mark - 录音开启、关闭
/*!
 * 开始录音
 * @return YES 表示成功, NO 表示失败(可能是蓝牙未连接)
 */
- (BOOL)startRecord;

/**
 开始录音
 
 @param delegate 设置代理接收录音数据
 @return YES 表示成功, NO 表示失败(可能是蓝牙未连接)
 */
- (BOOL)startRecordWithDelegate:(id <SWDeviceManagerAudioStreamDelegate>)delegate;

/**
开始录音

 @param startJitter YES开启防抖动开关
 @param delegate 设置代理接收录音数据
 @return YES 表示成功, NO 表示失败(可能是蓝牙未连接)
 */
-(BOOL)startRecordWithJitter:(BOOL)startJitter andDelegate:(id<SWDeviceManagerAudioStreamDelegate>)delegate;

/*!
 * 结束获取数据
 * @reture YES 表示成功, NO 表示失败(可能是蓝牙未连接);
 */
- (BOOL)stopRecord;

#pragma mark - SWSHardwardTypeSOLO参数
/**
 设置SWSHardwardTypeSOLO的场景参数
 
 @param value 参见枚举SOLO_Devocal_Surround
 */
-(void)setRecordMode:(SOLO_Devocal_Surround)value;

/**
 设置响指检测
 
 @param value 参见枚举：SOLO_Snap_Auto_Devocal
 */
-(void)setSnapDevocal:(SOLO_Snap_Auto_Devocal)value;

/**
 升级开始
 
 @param filePath 升级包路径
 @param complete 返回的code码
 @param completeProgress 升级进度这里是指写入附件蓝牙的进度
 */
-(void)upgradeStartWithFilePath:(NSString *)filePath complete:(void(^)(NSInteger code))complete andProgress:(void(^)(float progress))completeProgress;


/**
 结束升级，这个方法必须在upgradeStartWithFilePath方法回调code等于SUCCESS的时候或者completeProgress等于1的时候才能调用
 */
-(void)upgradeEnd;

@end
