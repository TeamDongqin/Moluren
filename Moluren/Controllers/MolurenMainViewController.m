#import "MolurenMainViewController.h"
#import "MolurenChatViewController.h"
#import "MolurenChatViewControllerTest.h"
#import "BaseViewController.h"
#import "Chat_Topic_Life.h"
#import "Chat_Topic_Motion.h"
#import "Chat_Topic_Movie.h"
#import "Chat_Topic_Music.h"
#import "Chat_Topic_Study.h"
#import "Chat_Topic_Work.h"
#import "HomeBgImage.h"

@interface MolurenMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton * EnterTopic;

@property (strong, nonatomic) UILabel *onlineCountLabel;

@property (strong, nonatomic) UILabel *chattingCountLabel;

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicatorView;

@property (strong, nonatomic) NSTimer *getOnlineStatus;

- (IBAction)EnterTopic:(id)sender;

@end

@implementation MolurenMainViewController

#pragma mark - View life cycle

- (void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    //页面将要进入前台，开启定时器
    
    //开启定时器
    [_getOnlineStatus setFireDate:[NSDate distantPast]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //页面消失，进入后台不显示该页面，关闭定时器
    
    //关闭定时器
    [_getOnlineStatus setFireDate:[NSDate distantFuture]];
    
    //显示navigationController
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    //[super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize view
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    // Set home background image
//    UIImageView* HomeBgImageView = (UIImageView*)[self.view viewWithTag:2001];
//    [HomeBgImageView setImage:[[HomeBgImage Instance] GetHomeBgImage]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[HomeBgImage Instance] GetHomeBgImage]];
    
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
    
    self.navigationItem.rightBarButtonItem=barbtn;
    
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
    
    
    _activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]
                              initWithFrame:CGRectMake(160,MainScreenHeight/2-15,30,30)];
    _activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.hidesWhenStopped = YES;
    //[self.activityIndicatorView stopAnimating ];//停止
    [self.view addSubview:_activityIndicatorView];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //循环刷新在线人数和聊天人数
    self.updateServerStatus;
    //[NSThread detachNewThreadSelector:@selector(httpAsynchronousRequest) toTarget:self withObject:nil];
    _getOnlineStatus = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(httpAsynchronousRequest) userInfo:nil repeats:YES];
    //self.updateServerStatus;
    //[NSThread detachNewThreadSelector:@selector(updateServerStatus) toTarget:self withObject:nil];
    if([super.self.sharedConfig.token isEqualToString:@""]){
        self.retrieveToken;
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Ui operation

- (IBAction)EnterTopic:(id)sender {
    UIButton* button = (UIButton*)sender;
    // Enter specific topic according to button id
    switch (button.tag) {
        case 1001:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicStudy_Pattern)];
                
                Chat_Topic_Study *chatViewController = [[Chat_Topic_Study alloc] init];
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
        case 1002:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                Chat_Topic_Life *chatViewController = [[Chat_Topic_Life alloc] init];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicLife_Pattern)];
                
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
        case 1003:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicWork_Pattern)];
                
                Chat_Topic_Work *chatViewController = [[Chat_Topic_Work alloc] init];
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
        case 1004:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicMusic_Pattern)];
                
                Chat_Topic_Music *chatViewController = [[Chat_Topic_Music alloc] init];
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
        case 1005:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicMotion_Pattern)];
                
                Chat_Topic_Motion *chatViewController = [[Chat_Topic_Motion alloc] init];
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
        case 1006:
            {
                [self.tabBarController.tabBar setHidden:YES];
                
                // Back to home button
                UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                                      style:UIBarButtonItemStyleBordered
                                                                                     target:nil
                                                                                     action:nil];
                
                [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
                
                [self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicMovie_Pattern)];
                
                Chat_Topic_Movie *chatViewController = [[Chat_Topic_Movie alloc] init];
                [self.navigationController pushViewController:chatViewController animated:YES];
            }
            break;
            
        default:
            break;
    }
}

-(void)OnBackButtonClicked{
    NSLog(@"clickButtonAtIndex:%d",1);
}

-(void)gotoChatingView{
    [self.tabBarController.tabBar setHidden:YES];
    
    // Back to home button
    UIBarButtonItem *BackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"陌路人"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:nil
                                                                         action:nil];
    
    [[self navigationItem] setBackBarButtonItem:BackBarButtonItem];
    
    //[self.navigationController.navigationBar setTintColor:UIColorFromRGB(Color_TopicWork_Pattern)];
    
    MolurenChatViewController *molurenChatViewController = [[MolurenChatViewController alloc] init];
    [self.navigationController pushViewController:molurenChatViewController animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //根据被点击按钮的索引处理点击事件
    
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if(buttonIndex==0){
        NSLog(@"重新获取token");
        self.retrieveToken;
        
    }else{
        
    }
}

- (void)retrieveToken {
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:tokenUrl]];
    
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

-(void)updateServerStatus{
    //if(self.sharedConfig.synchronousServerStatus){
    [self.onlineCountLabel setText:[NSString stringWithFormat: @"%d", self.sharedConfig.onlineNumber]];
    [self.chattingCountLabel setText:[NSString stringWithFormat: @"%d", self.sharedConfig.chattingNumber]];
    //}
    
    /*[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateServerStatus) userInfo:nil repeats:YES];
     [[NSRunLoop currentRunLoop] run];*/
    
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
@end
