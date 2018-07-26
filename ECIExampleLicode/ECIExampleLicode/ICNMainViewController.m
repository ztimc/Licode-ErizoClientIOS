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
#import "ICNRoomView.h"
#import "ICNConferenceView.h"

@interface ICNMainViewController ()

@end

@implementation ICNMainViewController
{
    NSString *roomName;
    NSString *userName;
    
    UIButton *jionButton;
    UIImageView *mainIcon;
    ICNEditText *nameEditText;
    ICNEditText *roomEditText;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    

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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    
    if(size.height > size.width){
        jionButton.frame = CGRectMake((size.width / 2) - (jionButton.mh_width / 2),
                                           size.height - 220 - 80,
                                           138 * 2,
                                           40);
        CGRect nameFrame = jionButton.frame;
        nameFrame.origin.y = jionButton.frame.origin.y - 20 - jionButton.frame.size.height;
        nameEditText.frame = nameFrame;
        CGRect roomFrame = jionButton.frame;
        roomFrame.origin.y = nameFrame.origin.y - 20 - jionButton.frame.size.height;
        roomEditText.frame = roomFrame;
        mainIcon.mh_x = (size.width / 2) - (mainIcon.mh_width / 2);
        mainIcon.mh_y = 106;
    }else{
        jionButton.frame = CGRectMake((size.width / 2) - (jionButton.mh_width / 2),
                                      size.height - 100,
                                      138 * 2,
                                      40);
        CGRect nameFrame = jionButton.frame;
        nameFrame.origin.y = jionButton.frame.origin.y - 20 - jionButton.frame.size.height;
        nameEditText.frame = nameFrame;
        CGRect roomFrame = jionButton.frame;
        roomFrame.origin.y = nameFrame.origin.y - 20 - jionButton.frame.size.height;
        roomEditText.frame = roomFrame;
        mainIcon.mh_x = (size.width / 2) - (mainIcon.mh_width / 2);
        mainIcon.mh_y = 50;
    }
    
}

-(void)setUIViewBackgound:(UIView *)uiview name:(NSString *)name {
    
    UIGraphicsBeginImageContext(uiview.frame.size);
    [[UIImage imageNamed:name] drawInRect:uiview.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    uiview.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)initView {
    
    jionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    jionButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds),
                              self.view.bounds.size.height - 220 - 80,
                              138 * 2,
                              40);
    
    if(self.view.mh_width > self.view.mh_height){
        jionButton.mh_y = self.view.mh_height - 100;
    }
    
    jionButton.mh_centerX = CGRectGetMidX(self.view.bounds);
    
    UIColor *color = RGBHexAlpha(0x6AECFF, 1);
    [jionButton setTitle:@"加入会议" forState:UIControlStateNormal];
    [jionButton.layer setMasksToBounds:YES];
    [jionButton.layer setCornerRadius:20];
    [jionButton setBackgroundColor:color];
    [jionButton addTarget:self action:@selector(onJionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jionButton];
    
    CGRect nameFrame = jionButton.frame;
    nameFrame.origin.y = jionButton.frame.origin.y - 20 - jionButton.frame.size.height;
    nameEditText = [[ICNEditText alloc] initWithIcon:[UIImage imageNamed:@"EditText-Name-Icon"] text:@"名字" keyboardType:UIKeyboardTypeDefault frame:nameFrame];
    [nameEditText setOnTextChange:^(NSString *text) {
        self->userName = text;
    }];
    [self.view addSubview:nameEditText];
    
    CGRect roomFrame = jionButton.frame;
    roomFrame.origin.y = nameFrame.origin.y - 20 - jionButton.frame.size.height;
    
    roomEditText = [[ICNEditText alloc] initWithIcon:[UIImage imageNamed:@"EditText-Room-Icon"] text:@"房间" keyboardType:UIKeyboardTypeNumberPad frame:roomFrame];
    [roomEditText setOnTextChange:^(NSString *text) {
        self->roomName = text;
    }];
    [self.view addSubview:roomEditText];
    
    mainIcon= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home-Icon"]];
    mainIcon.mh_x = CGRectGetMidX(self.view.bounds) - (mainIcon.mh_width / 2);
    mainIcon.mh_y = 106;
    
    if(self.view.mh_width > self.view.mh_height){
       mainIcon.mh_y = 50;
    }
    
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}



///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (roomEditText.frame.origin.y + roomEditText.frame.size.height+50) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}


- (void) keyboardWillHide:(NSNotification *)notify {
    
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}



@end
