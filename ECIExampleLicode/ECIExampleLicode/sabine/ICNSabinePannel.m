//
//  ICNSabinePannel.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/10/16.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNSabinePannel.h"
#import <SabineSwissSDK/SabineSwissSDK.h>

@implementation ICNSabinePannel {
    UILabel  *textMonitor;
    UISlider *slMonitor;
    
    UILabel  *textGain;
    UISlider *slGain;
    
    UILabel  *textAgc;
    UISwitch *swAgc;
    
    UILabel  *textMix;
    UISwitch *swMix;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textMonitor = [[UILabel alloc] initWithFrame:CGRectZero];
        textGain    = [[UILabel alloc] initWithFrame:CGRectZero];
        textAgc     = [[UILabel alloc] initWithFrame:CGRectZero];
        textMix     = [[UILabel alloc] initWithFrame:CGRectZero];
        
        slMonitor   = [[UISlider alloc] initWithFrame:CGRectZero];
        slGain      = [[UISlider alloc] initWithFrame:CGRectZero];
        swAgc       = [[UISwitch alloc] initWithFrame:CGRectZero];
        swMix       = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [self addSubview:textMonitor];
        [self addSubview:textGain];
        [self addSubview:textAgc];
        [self addSubview:textMix];
        [self addSubview:slMonitor];
        [self addSubview:slGain];
        [self addSubview:swAgc];
        [self addSubview:swMix];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    }
    return self;
}

- (void)layoutSubviews {
    textMonitor.mh_x = 10;
    textMonitor.mh_y = 10;
    textMonitor.mh_width = 100;
    textMonitor.mh_height = 50;
    
    slMonitor.mh_x = 130;
    slMonitor.mh_y = 10;
    slMonitor.mh_width = 200;
    slMonitor.mh_height = 50;
    
    textGain.mh_x = 10;
    textGain.mh_y = 70;
    textGain.mh_width = 100;
    textGain.mh_height = 50;
    
    slGain.mh_x = 130;
    slGain.mh_y = 70;
    slGain.mh_width = 200;
    slGain.mh_height = 50;
    
    textAgc.mh_x = 10;
    textAgc.mh_y = 130;
    textAgc.mh_width = 100;
    textAgc.mh_height = 50;
    
    swAgc.mh_x = 130;
    swAgc.mh_y = 130;
    swAgc.mh_width = 200;
    swAgc.mh_height = 50;
    
    textMix.mh_x = 10;
    textMix.mh_y = 190;
    textMix.mh_width = 100;
    textMix.mh_height = 50;
    
    swMix.mh_x = 130;
    swMix.mh_y = 190;
    swMix.mh_width = 200;
    swMix.mh_height = 50;
    
    [textMonitor setText:@"监听"];
    [textGain setText:@"增益"];
    [textAgc setText:@"自动增益"];
    [textMix setText:@"混音"];
    
    [slMonitor addTarget:self action:@selector(monitorSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [slGain addTarget:self action:@selector(gainSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [swAgc addTarget:self action:@selector(onAgcSwitch:) forControlEvents:UIControlEventValueChanged];
    [swMix addTarget:self action:@selector(onMixSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [slMonitor setMaximumValue:100];
    [slMonitor setMinimumValue:0];
    
    [slGain setMaximumValue:100];
    [slGain setMinimumValue:0];
    
}


- (void)monitorSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int val = (int)slider.value;
    [[SWDeviceManager sharedInstance] setMonito:val];
    NSString *str = [[NSString alloc] initWithFormat:@"监听: =%d" ,val];
    [textMonitor setText:str];
}

- (void)gainSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int val = (int)slider.value;
    [[SWDeviceManager sharedInstance] setMicEffect:val];
    NSString *str = [[NSString alloc] initWithFormat:@"增益: %d",val];
    [textGain setText:str];
}

-(void)onAgcSwitch:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    if (switcher.isOn) {
        [[SWDeviceManager sharedInstance] setAgc:SWSAGCSwitch_ON];
    }else {
        [[SWDeviceManager sharedInstance] setAgc:SWSAGCSwitch_OFF];
    }
   
}

-(void)onMixSwitch:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    if (switcher.isOn) {
        [[SWDeviceManager sharedInstance] setMusicMix:SWSMusicMixSwitch_ON];
    }else {
        [[SWDeviceManager sharedInstance] setMusicMix:SWSMusicMixSwitch_OFF];
    }
}

@end
