//
//  ICNConferenceAudioView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/25.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNConferenceAudioView.h"
#import "ICNSurroundButton.h"

@implementation ICNConferenceAudioView{
    ICNSurroundButton *_avatar;
    UIImageView *_stateView;
    
}

- (instancetype)initWithStream:(ECStream *)stream
                         frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        _stream = stream;
        _avatar = [[ICNSurroundButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _stateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Aduio-Mute-Icon"]];
        
        NSString * name = stream.getAttributes[@"actualName"];
        [_avatar setTitle:name forState:UIControlStateNormal];
        [_avatar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_avatar setTitleColor:RGBHexAlpha(0x6FD8FF, 1) forState:UIControlStateSelected];
        [_avatar setImage:[UIImage imageNamed:@"Avatar-Icon"] forState:UIControlStateNormal];
        [_avatar setImage:[UIImage imageNamed:@"Avatar-Icon"] forState:UIControlStateSelected];
        
        [self addSubview:_avatar];
        [self addSubview:_stateView];
    }
    
    return self;
}

- (void)showMute:(BOOL)enable{
    _stateView.hidden = !enable;
}

- (void)layoutSubviews{
    _stateView.mh_x = _avatar.mh_width
    -_stateView.mh_width
    - 6;
    
    _stateView.mh_y = _avatar.imageView.mh_height
    - _stateView.mh_height
    + 4;
}

@end
