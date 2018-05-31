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
    //用于网络权限处理
    [self demo2];
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

-(void)demo2{
    //访问百度首页
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:@"http://m.baidu.com"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //response ： 响应：服务器的响应
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //error：链接错误的信息
        NSLog(@"网络响应：response：%@",response);
        
    }
                                    ];
    
    //5.执行任务
    [dataTask resume];
}



@end
