//
//  ViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "MolurenMainViewController.h"
#import "MolurenChatViewController.h"
#import "MolurenChatViewControllerTest.h"
#import "BaseViewController.h"
//#import "PXAlertView+Customization.h"

@interface MolurenMainViewController ()
@property (weak, nonatomic) IBOutlet UIButton * EnterTopic;

@property (strong, nonatomic) UILabel *onlineCountLabel;

@property (strong, nonatomic) UILabel *chattingCountLabel;

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicatorView;

@property (strong, nonatomic) NSTimer *getOnlineStatus;

- (IBAction)EnterTopic:(id)sender;

@end

@implementation MolurenMainViewController

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)setup{
    
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    
    /*UIImageView *navTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    UIImage *navTitleBackgroundImage = [[UIImage imageNamed:@"title_bar"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(22,30,22,30)];
    navTitle.image = navTitleBackgroundImage;
    navTitle.userInteractionEnabled = YES;
    
    //添加标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(MainScreenWidth/2-100, 24, 200, 20);*/
    
    //[navTitle addSubview:titleLabel];
    //[self.view addSubview:navTitle];
    
    //_onlineNumber = 0;
    //_chattingNumber = 0;
    //self.sharedConfig.synchronousServerStatus  = YES;
    
    /*
    // 添加在线人数标题label
    UILabel *onlineLabel = [[UILabel alloc] init];
    onlineLabel.text = @"在线人数:";
    onlineLabel.font = [UIFont systemFontOfSize:12];
    onlineLabel.textAlignment = NSTextAlignmentCenter;
    onlineLabel.textColor = [UIColor whiteColor];
    onlineLabel.frame = CGRectMake(MainScreenWidth*3/7, 35, 52, 15);
    
    [self.view addSubview:onlineLabel];
    
    // 添加在线人数计数label
    _onlineCountLabel = [[UILabel alloc] init];
    _onlineCountLabel.text = [NSString stringWithFormat: @"%d", 0];
    _onlineCountLabel.font = [UIFont systemFontOfSize:12];
    _onlineCountLabel.textAlignment = NSTextAlignmentCenter;
    _onlineCountLabel.textColor = [UIColor whiteColor];
    _onlineCountLabel.frame = CGRectMake(MainScreenWidth*3/7+52, 35, 30, 15);
    
    [self.view addSubview:_onlineCountLabel];
    
    //添加聊天人数标题label
    UILabel *chattingLabel = [[UILabel alloc] init];
    chattingLabel.text = @"聊天人数:";
    chattingLabel.font = [UIFont systemFontOfSize:12];
    chattingLabel.textAlignment = NSTextAlignmentCenter;
    chattingLabel.textColor = [UIColor whiteColor];
    chattingLabel.frame = CGRectMake(MainScreenWidth*3/7+82, 35, 52, 15);
    
    [self.view addSubview:chattingLabel];
    
    //添加聊天人数计数label
    _chattingCountLabel = [[UILabel alloc] init];
    _chattingCountLabel.text = [NSString stringWithFormat: @"%d", 0];
    _chattingCountLabel.font = [UIFont systemFontOfSize:12];
    _chattingCountLabel.textAlignment = NSTextAlignmentCenter;
    _chattingCountLabel.textColor = [UIColor whiteColor];
    _chattingCountLabel.frame = CGRectMake(MainScreenWidth*3/7+134, 35, 30, 15);
    
    [self.view addSubview:_chattingCountLabel];
    */
    
    
    // 设置背景图片
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SkynightBG5"]];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 17)];
    UIImage *searchimage=[UIImage imageNamed:@"shape_white"];
    imageView.image =  searchimage;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 46, 17);
    [view addSubview:imageView];
    _onlineCountLabel = [[UILabel alloc] init];
    _onlineCountLabel.text = [NSString stringWithFormat: @"%d", 0];
    _onlineCountLabel.font = [UIFont systemFontOfSize:12];
    _onlineCountLabel.textAlignment = NSTextAlignmentCenter;
    _onlineCountLabel.textColor = [UIColor whiteColor];
    _onlineCountLabel.frame = CGRectMake(16, 0, 30, 17);
    [view addSubview:_onlineCountLabel];

    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithCustomView:view];
    
    //barbtn.image=searchimage;
    
    self.navigationItem.rightBarButtonItem=barbtn;
    
    
    /*self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:onlineImageView];*/
    
//    //添加开始连接Button
//    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    connectBtn.titleLabel.textColor = [UIColor whiteColor];
//    connectBtn.titleLabel.font = [UIFont fontWithName:@"Regular" size:20];
//    //[connectBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
//    UIImage *connectBtnBackgroundImage = [[UIImage imageNamed:@"ChatButton + 开始连接"]
//                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0,24,0,24)];
//    [connectBtn setBackgroundImage:connectBtnBackgroundImage
//                          forState:UIControlStateNormal];
//    connectBtn.frame = CGRectMake(30, MainScreenHeight/2-15, 92, 27);
//    [connectBtn addTarget:self action:@selector(onConnectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:connectBtn];
//    
//    //添加 正在为你寻找你的另一个"ta" Label
//    UILabel *hintsLabel = [[UILabel alloc] init];
//    hintsLabel.text = @"正在为你寻找你的另一个\"ta\"";
//    hintsLabel.font = [UIFont systemFontOfSize:12];
//    hintsLabel.textAlignment = NSTextAlignmentCenter;
//    hintsLabel.textColor = [UIColor blackColor];
//    hintsLabel.frame = CGRectMake(connectBtn.frame.origin.x+connectBtn.frame.size.width+3, MainScreenHeight/2-15, 160, 27);
//    
//    [self.view addSubview:hintsLabel];
    
    
    _activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]
                              initWithFrame:CGRectMake(160,MainScreenHeight/2-15,30,30)];
    _activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.hidesWhenStopped = YES;
    //[self.activityIndicatorView stopAnimating ];//停止
    [self.view addSubview:_activityIndicatorView];
    
    
}

- (void)loadView
{
    [super loadView];
    
}

-(void)onConnectButtonClicked{
    
    //已经有token
    if(![self.sharedConfig.token isEqualToString:@""] && self.sharedConfig.token.length>1){
        if(!self.sharedConfig.isConnected){
            [self.activityIndicatorView startAnimating ];//启动
            self.connectToNewSession;
        }else{
            self.gotoChatingView;
        }
        //self.checkIfStopAnimating;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"连接错误,点击确认重新连接." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
    }
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if(buttonIndex==0){
        NSLog(@"重新获取token");
        self.getToken;

    }else{
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏状态栏
    NSLog(@"MolurenMainViewController launched");
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:YES];
    [self setup];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //循环刷新在线人数和聊天人数
    self.updateServerStatus;
    //[NSThread detachNewThreadSelector:@selector(httpAsynchronousRequest) toTarget:self withObject:nil];
    _getOnlineStatus = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(httpAsynchronousRequest) userInfo:nil repeats:YES];
    //self.updateServerStatus;
    //[NSThread detachNewThreadSelector:@selector(updateServerStatus) toTarget:self withObject:nil];
    if([super.self.sharedConfig.token isEqualToString:@""]){
        self.getToken;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateServerStatus{
    //if(self.sharedConfig.synchronousServerStatus){
        [self.onlineCountLabel setText:[NSString stringWithFormat: @"%d", self.sharedConfig.onlineNumber]];
        [self.chattingCountLabel setText:[NSString stringWithFormat: @"%d", self.sharedConfig.chattingNumber]];
    //}
    
    /*[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateServerStatus) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];*/
    
}

-(void)checkIfStopAnimating{
    if(self.sharedConfig.isConnected = YES && self.activityIndicatorView.isAnimating){
        [self.activityIndicatorView stopAnimating ];//停止
        self.gotoChatingView;
    }
    /*[NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkIfStopAnimating)
                                   userInfo:nil
                                    repeats:NO];*/

}

-(void)gotoChatingView{
    [self.tabBarController.tabBar setHidden:YES];
    MolurenChatViewController *molurenChatViewController = [[MolurenChatViewController alloc] init];
    [self.navigationController pushViewController:molurenChatViewController animated:YES];
}

-(void)httpAsynchronousRequest{
    
    if(!self.sharedConfig.isConnected && [self isViewLoaded] && [self.view window] != nil){
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:statisticsUrl]];
    
    //NSString *post=@"postData";
    
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%d", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   //NSDictionary *resultDict = [data objectFromJSONData];
                                   NSError *error;
                                   NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   NSDictionary *sDict = [resultDict objectForKey:@"s"];
                                   NSString *a = [sDict objectForKey:@"a"];
                                   NSString *c = [sDict objectForKey:@"c"];
                                   NSLog(@"在线人数:%@;聊天人数:%@",a,c);
                                   //_onlineNumber = [a intValue];
                                   //_chattingNumber = [c intValue];
                                   self.sharedConfig.onlineNumber = [a intValue];
                                   self.sharedConfig.chattingNumber = [c intValue];
                                   [self performSelectorOnMainThread:@selector(updateServerStatus) withObject:nil waitUntilDone:YES];
                               }
                           }];
        }
    /*_getOnlineStatus = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(httpAsynchronousRequest:) userInfo:nil repeats:YES];*/
    //[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(httpAsynchronousRequest) userInfo:nil repeats:YES];
    //[self.getOnlineStatus fire];
    //[[NSRunLoop currentRunLoop]addTimer:_getOnlineStatus forMode:NSDefaultRunLoopMode];
    //[[NSRunLoop currentRunLoop] run];
    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    //[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    [_getOnlineStatus setFireDate:[NSDate distantPast]];
    
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [_getOnlineStatus setFireDate:[NSDate distantFuture]];
    
    //显示navigationController
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    //[super viewWillDisappear:animated];
}

-(void)connectToNewSession{
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:connectUrl]];
    
    NSString *post=[@"_token_id_" stringByAppendingString:self.sharedConfig.token];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%d", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   //[self.activityIndicatorView stopAnimating ];//停止
                                   
                                   //NSDictionary *resultDict = [data objectFromJSONData];
                                   NSError *error;
                                   NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   BOOL connect = [resultDict objectForKey:@"connect"];
                                   //NSLog(@"connect=%@",connect);
                                   NSLog(@"connect=%@",connect?@"YES":@"NO");
                                   if(connect){
                                       self.sharedConfig.isConnected = YES;
                                       [self performSelectorOnMainThread:@selector(checkIfStopAnimating) withObject:nil waitUntilDone:YES];
                                   }else{
                                       NSLog(@"连接异常");
                                   }
                               }
                           }];
}

-(void)getToken{
    self.sharedConfig.token=@"";
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:tokenUrl]];
    NSLog([baseUrl stringByAppendingString:tokenUrl]);
    
    //NSString *post=@"postData";
    
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%d", error.localizedDescription,error.code);
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%d", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   //NSDictionary *resultDict = [data objectFromJSONData];
                                   NSError *error;
                                   NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   NSString *restoken = [resultDict objectForKey:@"token"];
                                   NSLog(@"token=%@",restoken);
                                   self.sharedConfig.token = restoken;
                               }
                           }];
}

- (IBAction)EnterTopic:(id)sender {
    //已经有token
    if(![self.sharedConfig.token isEqualToString:@""] && self.sharedConfig.token.length>1){
        if(!self.sharedConfig.isConnected){
            [self.activityIndicatorView startAnimating ];//启动
            self.connectToNewSession;
        }else{
            self.gotoChatingView;
        }
        //self.checkIfStopAnimating;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"连接错误,点击确认重新连接." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
    }
}
@end
