//
//  ICNStatsView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/30.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNStatsView.h"

@implementation ICNStatsView{
    UILabel *_audioStatsLable;
    UILabel *_videoStatsLable;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _audioStatsLable =  [[UILabel alloc] initWithFrame:CGRectZero];
        _videoStatsLable =  [[UILabel alloc] initWithFrame:CGRectZero];
        _audioStatsLable.textColor = [UIColor greenColor];
        _videoStatsLable.textColor = [UIColor greenColor];
        [self addSubview:_audioStatsLable];
        [self addSubview:_videoStatsLable];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    }
    return self;
}

- (void)layoutSubviews{
    CGRect frame = self.bounds;
    CGRect audioFrame = CGRectMake(20, 0, frame.size.width-40, frame.size.height / 2);
    CGRect videoFrame = CGRectMake(20, frame.size.height / 2, frame.size.width - 40, frame.size.height / 2);
    _audioStatsLable.frame = audioFrame;
    _videoStatsLable.frame = videoFrame;
}

- (void)setStats:(NSString *)mediaType
            kbps:(long)kbps{
    
    if([mediaType caseInsensitiveCompare:@"video"] == NSOrderedSame){
        dispatch_async(dispatch_get_main_queue(), ^{
            _videoStatsLable.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"video kbps is %ld kbps",kbps]];
        });
        
    }else if([mediaType caseInsensitiveCompare:@"audio"] == NSOrderedSame){
        dispatch_async(dispatch_get_main_queue(), ^{
            _audioStatsLable.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"audio kbps is %ld kbps",kbps]];
        });
        
    }
}

@end
