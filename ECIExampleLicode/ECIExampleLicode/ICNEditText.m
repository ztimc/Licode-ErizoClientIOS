//
//  ICNEditText.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/7/12.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNEditText.h"

@implementation ICNEditText{
    UIImageView *iconView;
    UITextField *textView;
    OnTextFieldChangeCallback callback;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self setBackgroundColor:RGBHexAlpha(0xFFFFFF, 0.3)];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EditText-Name-Icon"]];
        textView = [[UITextField alloc] initWithFrame:CGRectZero];
        textView.placeholder = @"text";
        textView.textColor   = [UIColor whiteColor];
        textView.borderStyle = UITextBorderStyleNone;
        textView.keyboardType = UIKeyboardTypeNumberPad;
        [textView addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:iconView];
        [self addSubview:textView];
    }
    return self;
}

- (instancetype)initWithIcon:(UIImage *)image
                        text:(NSString *)text
                keyboardType:(UIKeyboardType)keyboardType
                       frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:RGBHexAlpha(0xFFFFFF, 0.3)];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        
        iconView = [[UIImageView alloc] initWithImage:image];
        textView = [[UITextField alloc] initWithFrame:CGRectZero];
        textView.placeholder = text;
        textView.textColor   = [UIColor whiteColor];
        textView.borderStyle = UITextBorderStyleNone;
        textView.keyboardType = keyboardType;
        [textView addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:iconView];
        [self addSubview:textView];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    
    CGRect iconFrame = iconView.frame;
    CGFloat frameMidY = CGRectGetMidY(frame);
    iconFrame.origin.x = 8;
    iconFrame.origin.y = frameMidY - (iconFrame.size.height / 2);
    iconView.frame = iconFrame;
    
    CGRect textFrame;
    textFrame.size.height = frame.size.height;
    textFrame.size.width  = frame.size.width - iconFrame.size.width - 4;
    textFrame.origin.x = iconFrame.size.width + 4 + 8;
    textFrame.origin.y = 0;
    textView.frame = textFrame;
}

- (void)setOnTextChange:(OnTextFieldChangeCallback)callback{
    self->callback = callback;
}

- (void)onTextChange:(UITextField *)textField {
    if(callback){
        callback(textField.text);
    }
}

@end
