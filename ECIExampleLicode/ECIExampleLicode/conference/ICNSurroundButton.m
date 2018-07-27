//
//  ICNSurroundButton.m
//  SABVideoAndAudioRecord
//
//  Created by dszhangyu on 2018/7/10.
//  Copyright © 2018年 dszhangyu. All rights reserved.
//

#import "ICNSurroundButton.h"

@interface ICNSurroundButton()

@end

@implementation ICNSurroundButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        self.titleLabel.layer.shadowOpacity = 1.0f;
        self.titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
        self.titleLabel.layer.shadowRadius = 0.5F;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.mh_centerX = self.bounds.size.width / 2;
    
    self.titleLabel.frame =
                       CGRectMake(0,
                       self.imageView.mh_height + self.imageView.mh_y + 2,
                       self.bounds.size.width,
                       12);
}




@end
