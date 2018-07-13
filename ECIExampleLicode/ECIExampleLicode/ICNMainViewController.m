//
//  ICNMainViewController.m
//  ECIExampleLicode
//
//  Created by ztimc on 2018/5/23.
//  Copyright © 2018年 Alvaro Gil. All rights reserved.
//

#import "ICNMainViewController.h"
#import "Nuve.h"
#import "ICNEditText.h"
#import "MultiConferenceViewController.h"


@interface ICNMainViewController ()

@end

@implementation ICNMainViewController
{
    NSString *roomName;
    NSString *userName;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIViewBackgound:self.view name:@"Main-Background"];
    
    
    [self initView];
    
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

- (void)initView {
    UIButton *jionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    jionButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 138,
                              self.view.bounds.size.height - 220 - 40,
                              138 * 2,
                              40);
    UIColor *color = RGBHexAlpha(0x6AECFF, 1);
    [jionButton setTitle:@"加入会议" forState:UIControlStateNormal];
    [jionButton.layer setMasksToBounds:YES];
    [jionButton.layer setCornerRadius:20];
    [jionButton setBackgroundColor:color];
    [jionButton addTarget:self action:@selector(onJionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jionButton];
    
    CGRect nameFrame = jionButton.frame;
    nameFrame.origin.y = jionButton.frame.origin.y - 20 - jionButton.frame.size.height;
    ICNEditText *nameEditText = [[ICNEditText alloc] initWithIcon:[UIImage imageNamed:@"EditText-Name-Icon"] text:@"名字" frame:nameFrame];
    [nameEditText setOnTextChange:^(NSString *text) {
        self->userName = text;
    }];
    [self.view addSubview:nameEditText];
    
    CGRect roomFrame = jionButton.frame;
    roomFrame.origin.y = nameFrame.origin.y - 20 - jionButton.frame.size.height;
    ICNEditText *roomEditText = [[ICNEditText alloc] initWithIcon:[UIImage imageNamed:@"EditText-Room-Icon"] text:@"房间" frame:roomFrame];
    [roomEditText setOnTextChange:^(NSString *text) {
        self->roomName = text;
    }];
    [self.view addSubview:roomEditText];
    
    UIImageView *mainIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home-Icon"]];
    CGRect mainFame = mainIcon.frame;
    mainFame.origin.x = CGRectGetMidX(self.view.bounds) - (mainFame.size.width / 2);
    mainFame.origin.y = 84;
    mainIcon.frame = mainFame;
    [self.view addSubview:mainIcon];
  
}

- (void)onJionButtonClick:(UIButton *)buttion {
    [self.view endEditing:YES];
    if(roomName == nil || [roomName isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"房间号写错了" message:@"不能不写哦" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if(userName == nil || [userName isEqualToString:@""]){
        int value = (arc4random() % 100) + 1;
        userName =  [[NSString alloc] initWithFormat:@"sabine %d",value];
    }
    
    UIAlertController *uiAlertController = [[UIAlertController alloc] init];
    UIAlertAction *audioAction = [UIAlertAction actionWithTitle:@"音频会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MultiConferenceViewController *vc = [[MultiConferenceViewController alloc]initWithMode:Audio roomName:self->roomName userName:self->userName];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:vc animated:NO completion:nil];
    }];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         MultiConferenceViewController *vc = [[MultiConferenceViewController alloc]initWithMode:Video roomName:self->roomName userName:self->userName];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:vc animated:NO completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [uiAlertController addAction:audioAction];
    [uiAlertController addAction:videoAction];
    [uiAlertController addAction:cancelAction];
    [self presentViewController:uiAlertController animated:YES completion:nil];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void)demo2{
    
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
