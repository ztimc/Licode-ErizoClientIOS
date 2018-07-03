//
//  SwissPanel.m
//  WebRTCSample
//
//  Created by ztimc on 2018/6/12.
//  Copyright © 2018年 ztimc. All rights reserved.
//

#import "SwissPanel.h"
#import <Swiss/Swiss.h>

@implementation SwissPanel {
    UISlider *_gainSlider;
    UISlider *_monitorSlider;
    UISlider *_reverberationSlider;
    UISwitch *_mixSwitch;
    UISwitch *_agcSwitch;
    UISwitch *_stereoSwitch;
    
    UILabel *_gainTextLable;
    UILabel *_monitorTextLable;
    UILabel *_reverberationTextLable;
    UILabel *_mixTextLable;
    UILabel *_agcTextLable;
    UILabel *_stereoTextLable;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _gainSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _monitorSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _reverberationSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        
        _mixSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        _agcSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        _stereoSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        _gainTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _monitorTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _reverberationTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _mixTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _agcTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _stereoTextLable = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [_gainSlider setMaximumValue:100];
        [_gainSlider setMinimumValue:0];
        [_monitorSlider setMaximumValue:100];
        [_monitorSlider setMinimumValue:0];
        [_reverberationSlider setMaximumValue:100];
        [_reverberationSlider setMinimumValue:0];
        
        [_gainSlider addTarget:self action:@selector(onGainSliderChange:)
                       forControlEvents:UIControlEventValueChanged];
        [_monitorSlider addTarget:self action:@selector(onMonitorSliderChange:)
                       forControlEvents:UIControlEventValueChanged];
        [_reverberationSlider addTarget:self action:@selector(onReverberationSliderChange:)
                       forControlEvents:UIControlEventValueChanged];
        [_mixSwitch addTarget:self action:@selector(onMixSwich:)
                       forControlEvents:UIControlEventValueChanged];
        [_agcSwitch addTarget:self action:@selector(onAgcSwich:)
                       forControlEvents:UIControlEventValueChanged];
        
        [_stereoSwitch addTarget:self action:@selector(onStereoSwich:)
             forControlEvents:UIControlEventValueChanged];
        
        
        [_gainTextLable setText:@"增益"];
        [_monitorTextLable setText:@"监听"];
        [_reverberationTextLable setText:@"混响"];
        [_mixTextLable setText:@"混音"];
        [_agcTextLable setText:@"自动增益"];
        [_stereoTextLable setText:@"声道互换"];
        
        [self addSubview:_gainSlider];
        [self addSubview:_monitorSlider];
        [self addSubview:_reverberationSlider];
        [self addSubview:_mixSwitch];
        [self addSubview:_agcSwitch];
        [self addSubview:_stereoSwitch];
        [self addSubview:_gainTextLable];
        [self addSubview:_monitorTextLable];
        [self addSubview:_reverberationTextLable];
        [self addSubview:_mixTextLable];
        [self addSubview:_agcTextLable];
        [self addSubview:_stereoTextLable];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:.6]];
    }
    return self;
}

- (void)layoutSubviews {
    self.frame = self.bounds;
    
    NSInteger itemHeight          = 50;
    NSInteger lableWidth          = 100;
    NSInteger sliderWidth         = 200;
    NSInteger itemMargin          = 5;
    NSInteger rightElementMargin  = 10;
    NSInteger switchWith          = 80;
    NSInteger framePaadingLeft    = 10;
    NSInteger framePaadingTop     = 10;
    
    _gainTextLable.frame          = CGRectMake(framePaadingLeft,
                                              framePaadingTop,
                                              lableWidth,
                                              itemHeight);
    _gainSlider.frame             = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               framePaadingTop,
                                               sliderWidth,
                                               itemHeight);
    
    _monitorTextLable.frame       = CGRectMake(framePaadingLeft,
                                               itemHeight + itemMargin + framePaadingTop,
                                               lableWidth,
                                               itemHeight);
    
    _monitorSlider.frame          = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               itemHeight + itemMargin + framePaadingTop,
                                               sliderWidth,
                                               itemHeight);
    
    _reverberationTextLable.frame = CGRectMake(framePaadingLeft,
                                               itemHeight * 2 + itemMargin + framePaadingTop,
                                               lableWidth,
                                               itemHeight);
    _reverberationSlider.frame    = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               itemHeight * 2 + itemMargin + framePaadingTop,
                                               sliderWidth,
                                               itemHeight);
    
    _mixTextLable.frame           = CGRectMake(framePaadingLeft,
                                               itemHeight * 3 + itemMargin + framePaadingTop,
                                               lableWidth,
                                               itemHeight);
    _mixSwitch.frame              = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               itemHeight * 3 + itemMargin + framePaadingTop,
                                               switchWith,
                                               itemHeight);
    
    _agcTextLable.frame           = CGRectMake(framePaadingLeft,
                                               itemHeight * 4 + itemMargin + framePaadingTop,
                                               lableWidth,
                                               itemHeight);
    _agcSwitch.frame              = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               itemHeight * 4 + itemMargin + framePaadingTop,
                                               switchWith,
                                               itemHeight);
    
    _stereoTextLable.frame           = CGRectMake(framePaadingLeft,
                                               itemHeight * 5 + itemMargin + framePaadingTop,
                                               lableWidth,
                                               itemHeight);
    
    _stereoSwitch.frame              = CGRectMake(rightElementMargin + lableWidth + framePaadingLeft,
                                               itemHeight * 5 + itemMargin + framePaadingTop,
                                               switchWith,
                                               itemHeight);
}

- (void)onGainSliderChange:(UISlider *)slider {
    [[SSSwiss sharedInstance] setGain:(UInt8)slider.value];
    NSString *text = [[NSString alloc] initWithFormat:@"增益 : %d",(int)slider.value];
    [_gainTextLable setText:text];
}

- (void)onMonitorSliderChange:(UISlider *)slider {
    [[SSSwiss sharedInstance] setMonitor:(UInt8)slider.value];
    NSString *text = [[NSString alloc] initWithFormat:@"监听 : %d",(int)slider.value];
    [_monitorTextLable setText:text];
}

- (void)onReverberationSliderChange:(UISlider *)slider {
    [[SSSwiss sharedInstance] setReverberaion:(UInt8)slider.value];
    NSString *text = [[NSString alloc] initWithFormat:@"混响 : %d",(int)slider.value];
    [_reverberationTextLable setText:text];
}

- (void)onMixSwich:(UISwitch *)switcher{
    [[SSSwiss sharedInstance] setMusicMix:switcher.isOn];
}

- (void)onAgcSwich:(UISwitch *)switcher{
    [[SSSwiss sharedInstance] setAGC:switcher.isOn];
}

- (void)onStereoSwich:(UISwitch *)switcher{
    [[SSSwiss sharedInstance] setSwapStereo:switcher.isOn];
}

@end
