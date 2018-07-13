//
//  ICNRoomView.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/13.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNRoomView.h"

@implementation ICNRoomView{
    UILabel *nameText;
    UILabel *callTimeText;
    UIImageView *cameraSwichImage;
    UIImageView *muteCtlImage;
    UIImageView *cammerCtlImage;
    UIImageView *hangupImage;
    UIImageView *speakerCtlImage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nameText = [[UILabel alloc] initWithFrame:CGRectZero];
        callTimeText = [[UILabel alloc] initWithFrame:CGRectZero];
       
    }
    return self;
}



@end
