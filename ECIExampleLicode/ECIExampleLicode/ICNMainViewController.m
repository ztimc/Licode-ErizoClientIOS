//
//  ICNMainViewController.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/23.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNMainViewController.h"

@interface ICNMainViewController ()

@end

@implementation ICNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIViewBackgound:self.view name:@"Main-Background"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUIViewBackgound:(UIView *)uiview name:(NSString *)name {
    
    UIGraphicsBeginImageContext(uiview.frame.size);
    [[UIImage imageNamed:name] drawInRect:uiview.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    uiview.backgroundColor = [UIColor colorWithPatternImage:image];
}


@end
