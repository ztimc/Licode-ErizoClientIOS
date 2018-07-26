//
//  ICNRemoteVideoView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNRemoteVideoView.h"

@implementation ICNRemoteVideoView{
    UILabel *_nameText;
}

- (instancetype)initWithLiveStream:(ECStream *)liveStream
                             frame:(CGRect)frame{
    self = [super initWithLiveStream:liveStream frame:frame];
    
    if(self){
         NSString *name = self.stream.getAttributes[@"actualName"];
        
        _nameText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,frame.size.width - 8, 15)];
        _nameText.text = name;
        _nameText.font = [UIFont systemFontOfSize:13];
        _nameText.textColor = [UIColor whiteColor];
        _nameText.layer.shadowColor = RGBHexAlpha(0x000000, 0.5).CGColor;
        _nameText.layer.shadowOpacity = 1.0f;
        _nameText.layer.shadowOffset = CGSizeMake(1, 1);
        _nameText.layer.shadowRadius = 0.5F;
        _nameText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameText];
    }
    
    return self;
}

- (void)layoutSubviews{
    _nameText.mh_width = self.bounds.size.width;
    _nameText.mh_centerX = CGRectGetMidX(self.bounds);
    
    _nameText.mh_y = self.bounds.size.height
    - _nameText.mh_height
    - 4;
}

# pragma mark - ICNConferenceVideo

- (UIView *)getView{
    return self;
}

- (ECStream *)getStream{
    return self.stream;
}

- (BOOL)isLocal{
    return NO;
}

- (void)showBigStyle{
    [_nameText setHidden:YES];
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
}

- (void)showSmallStyle{
    [_nameText setHidden:NO];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] CGColor];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (BOOL)enableVideo{
    NSNumber *video = self.stream.getAttributes[@"video"];
    if(video){
        return video.boolValue;
    }
    return NO;
}

@end
