//
//  Chat_Topic_Study.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/24.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "Chat_Topic_Study.h"
#import "JSMessagesViewController.h"
#import "MolurenHistoryDetailViewController.h"
#import "MolurenHistoryNavigController.h"
#import "ConfirmView.h"

@interface Chat_Topic_Study () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage* ChatterPortrait;

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *messageType;//Incoming:YES;Outgoing:NO;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) NSMutableArray *timestamps;

@property (strong, nonatomic) UIButton *chatBreakBtn;
@property (strong, nonatomic) UILabel *typingLabel;

@property (nonatomic,strong) UIAlertView *backToMainViewAlert;

@property (strong, nonatomic) NSTimer *getMsgs;
@property (strong, nonatomic) NSTimer *getTypingStatus;

@property (nonatomic,strong) UIImageView *gifImageView;//色子动画用
@property (nonatomic) NSInteger x;

@property (strong, nonatomic) UIButton *PowerButton;

@property (nonatomic) BOOL *bSendIphoneUserMsgPrefix;

@property (nonatomic) BOOL *bFirstReceiveMsg;

@end

@implementation Chat_Topic_Study

#pragma mark - View life cycle

- (void)loadView
{
    [super loadView];
    
    self.delegate = self;
    self.dataSource = self;
    
    // Set color pattern here ?
    [[TdTopic Instance] SetCurrentTopic:Topic_Study];
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"页面将要进入前台");
    [super viewWillAppear:animated];
    //开启定时器
    [_getMsgs setFireDate:[NSDate distantPast]];
    //[_getTypingStatus setFireDate:[NSDate distantPast]];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"页面消失，进入后台不显示该页面");
    [super viewDidDisappear:animated];
    //关闭定时器
    [_getMsgs setFireDate:[NSDate distantFuture]];
    //[_getTypingStatus setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up view title
    UIView *navTitle = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/2-90, 10, 180, 30)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"校园";
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(Color_TopicStudy_Pattern);
    titleLabel.frame = CGRectMake(0, 0, 180, 30);
    
    [navTitle addSubview:titleLabel];
    
    self.navigationItem.titleView = navTitle;
    
    [self.view addSubview:navTitle];
    
    // Set up right bar button
    UIImage *PowerButtonBgImage = [UIImage imageNamed:@"Topic_PowerButton_Off"];
    
    _PowerButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-150, 24, 30, 30)];
    [_PowerButton setBackgroundImage:PowerButtonBgImage forState:UIControlStateNormal];
    [_PowerButton addTarget:self action:@selector(onPowerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:_PowerButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // Set up left bar button
    UIImage *LeftBarButtonImage = [UIImage imageNamed:@"Button_Home_CoffeeRoom"];
    
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:LeftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(onReturnButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ui operation

-(void)backToMainView{
    /*if(self.sharedConfig.isConnected){
     _backToMainViewAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前会话没有断开，返回将会丢失当前会话，确定要返回并断开会话吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
     // optional - add more buttons:
     [_backToMainViewAlert addButtonWithTitle:@"取消"];
     [_backToMainViewAlert show];
     }else{
     self.retrieveToken;
     [self.navigationController popViewControllerAnimated:NO];
     [self.tabBarController.tabBar setHidden:NO];
     }*/
    [self.navigationController popViewControllerAnimated:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
    }
    else if (buttonIndex == 1){
        if(self.bConnected){
            [self disconnect];
            
            self.bConnected = false;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

-(void)gotoHistoryDetailView{
    NSArray *sidArray = [self.sharedConfig.hisDB findWithSid:10000];
    if([sidArray count]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"陌路人" message:@"目前没有历史记录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        
        MolurenHistoryDetailViewController *molurenHistoryViewController = [[MolurenHistoryDetailViewController alloc] initWithSid:[sidArray objectAtIndex:[sidArray count]-1]];
        
        MolurenHistoryNavigController *HistoryNavigController = [[MolurenHistoryNavigController alloc] initWithRootViewController:molurenHistoryViewController];
        
        //        MolurenHistoryDetailViewController *molurenHistoryViewController = [[MolurenHistoryDetailViewController alloc] init];
        //        [self.navigationController pushViewController:molurenHistoryViewController animated:YES];
        
        
        //        DYNavigationController *navigationController = self.navigationController;
        //         navigationController.viewControllerStack = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        //
        //         [navigationController SetupHistoryViews];
        //
        //         //[navigationController initWithRootViewController1:molurenHistoryViewController];
        //
        //         //[self.navigationController pushViewController:molurenHistoryViewController animated:YES];
        //
        //         [navigationController pushViewController:molurenHistoryViewController];
        //         [navigationController viewWillAppear:YES];
        
        // Model view
        molurenHistoryViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:HistoryNavigController animated:YES];
    }
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"];
    }
    return nil;
    
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"];
    }
    return nil;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

#pragma mark - Communicating with server

-(void)retrieveToken{
    self.sharedConfig.token=@"";
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:tokenUrl]];
    
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
                                   NSLog(@"更新了token");
                               }
                           }];
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
                                       [self performSelectorOnMainThread:@selector(SessionConnectedCallback) withObject:nil waitUntilDone:YES];
                                   }else{
                                       [self performSelectorOnMainThread:@selector(SessionConnectionExceptionCallback) withObject:nil waitUntilDone:YES];
                                   }
                               }
                           }];
}

-(void)disconnect{
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:disconnectUrl]];
    
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
                                   BOOL disconnect = [resultDict objectForKey:@"disconnect"];
                                   NSLog(@"disconnect=%@",disconnect?@"YES":@"NO");
                                   if(disconnect){
                                       self.sharedConfig.isConnected = NO;
                                       //self.sharedConfig.synchronousServerStatus  = YES;
                                       [self.sharedConfig updateSessionId];
                                       [self performSelectorOnMainThread:@selector(SessionDisconnectedCallback) withObject:nil waitUntilDone:YES];
                                   }
                               }
                           }];
}

-(void)receiveMessageRequest{
    
    self.sharedConfig.isReceivingMsg = YES;
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:receiveUrl]];
    
    NSString *post=[@"_connected_=true&_h_=1&_token_id_=" stringByAppendingString:self.sharedConfig.token];
    
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
                                   NSLog(@"接收消息http请求异常");
                                   if(error.code==-1001){
                                       self.sharedConfig.httpRequestTimeoutTimes+=1;
                                       NSLog([NSString stringWithFormat:@"http请求超时,连续第%d次",self.sharedConfig.httpRequestTimeoutTimes]);
                                   }
                                   self.sharedConfig.isReceivingMsg = NO;
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%d", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   self.sharedConfig.httpRequestTimeoutTimes = 0;
                                   
                                   //NSDictionary *resultDict = [data objectFromJSONData];
                                   NSError *error;
                                   NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   NSDictionary *hb = [resultDict objectForKey:@"hb"];
                                   //NSLog(@"hb=%@",hb);
                                   NSArray *msgArray = [hb objectForKey:@"msgs"];
                                   NSDictionary *status = [hb objectForKey:@"s"];
                                   NSString *connectedStatus = [status objectForKey:@"s"];
                                   if([connectedStatus isEqualToString:@"disconnected"]){
                                       NSLog(@"当前连接已断开");
                                       self.sharedConfig.isConnected = NO;
                                       [self.sharedConfig updateSessionId];
                                       /*[self performSelectorOnMainThread:@selector(sendDisconectedMessage) withObject:nil waitUntilDone:YES];*/
                                       if(self.sharedConfig.autoConnect){
                                           [self performSelectorOnMainThread:@selector(connectToNewSession) withObject:nil waitUntilDone:YES];
                                       }else{
                                           [self performSelectorOnMainThread:@selector(SessionDisconnectedCallback) withObject:nil waitUntilDone:YES];
                                       }
                                   }
                                   if(msgArray!=nil){
                                       for(NSDictionary *msg in msgArray){
                                           NSString *receivedMsg = [msg objectForKey:@"c"];
                                           NSLog(@"接收到消息:%@",receivedMsg);
                                           //[self.sharedConfig.readMsgArray addObject:receivedMsg];
                                           //[self.sharedConfig.readMsgTimestamps addObject:[NSDate date]];
                                           //self.sharedConfig.readMsgCount = self.sharedConfig.readMsgCount + 1;
                                           //NSMutableDictionary *dictMutable = [[NSMutableDictionary alloc]initWithObjectsAndKeys:receivedMsg,@"msg",[NSDate date],@"date", nil];
                                           NSLog(@"readMsgCount=%d",self.sharedConfig.readMsgCount);
                                           
                                           //                                           if([receivedMsg hasPrefix:@"[ios]"]){
                                           //                                               if([self.sharedConfig.fromDeveceType isEqualToString:@"unknown"]){
                                           //                                                   self.sharedConfig.fromDeveceType = @"ios";
                                           //                                               }
                                           //                                               receivedMsg = [receivedMsg stringByReplacingOccurrencesOfString:@"[ios]" withString:@""];
                                           //                                           }
                                           
                                           // Logic on judging whether ios device
                                           if((_bFirstReceiveMsg == YES) && [receivedMsg containsString: IosDevice_Prefix]){
                                               if([self.sharedConfig.fromDeveceType isEqualToString:@"unknown"]){
                                                   self.sharedConfig.fromDeveceType = @"ios";
                                               }
                                               
                                               _bFirstReceiveMsg = NO;
                                           }
                                           
                                           
                                           if([receivedMsg hasPrefix:@"[ios][摇色子:"]){
                                               receivedMsg = [receivedMsg stringByReplacingOccurrencesOfString:@"[ios][摇色子:" withString:@""];
                                               receivedMsg = [receivedMsg stringByReplacingOccurrencesOfString:@"]" withString:@""];
                                               NSInteger diceValue  = [receivedMsg intValue];
                                               if(diceValue>6 || diceValue<1){
                                                   //接收到错误的摇色子信息,忽略
                                               }else{
                                                   self.sharedConfig.receivedMsg = receivedMsg;
                                                   [self performSelectorOnMainThread:@selector(PlayReceivedDice) withObject:nil waitUntilDone:YES];
                                               }
                                           }
                                           else{
                                               self.sharedConfig.receivedMsg = receivedMsg;
                                               [self performSelectorOnMainThread:@selector(addReceiveMessageToUI) withObject:nil waitUntilDone:YES];
                                           }
                                       }
                                   }
                                   self.sharedConfig.isReceivingMsg = NO;
                               }
                           }];
}

-(void)SessionConnectedCallback
{
    // Update power button state
    self.bConnected = true;
    self.bFirstReceiveMsg = YES;
    
    // Update power button image
    UIImage *PowerButtonBgImage = [UIImage imageNamed:@"TopicStudy_PowerButton_On"];
    
    [_PowerButton setBackgroundImage:PowerButtonBgImage forState:UIControlStateNormal];
    
    // Set iphone user message prefix
    [self SetIphoneUserMessagePrefix];
}

-(void)SessionDisconnectedCallback{
    // Clear current chat contents
    [self ClearTableView];
    
    // Update power button state
    self.bConnected = false;
    
    // Update power button image
    UIImage *PowerButtonBgImage = [UIImage imageNamed:@"Topic_PowerButton_Off"];
    
    [_PowerButton setBackgroundImage:PowerButtonBgImage forState:UIControlStateNormal];
    
    [self ShowNotification];
    
    //[self sendDisconectedMessage:@"对方已经断开连接，请重新连接 [ Beta ]"];
}

-(void) SessionConnectionExceptionCallback{
    // Clear current chat contents
    [self ClearTableView];
    
    // Update power button state
    self.bConnected = false;
    
    // Update power button image
    UIImage *PowerButtonBgImage = [UIImage imageNamed:@"Topic_PowerButton_Off"];
    
    [_PowerButton setBackgroundImage:PowerButtonBgImage forState:UIControlStateNormal];
    
    
    [self sendDisconectedMessage:@"抱歉，您已被服务器暂时屏蔽， 请稍后再试"];
}

#pragma mark - Chatting with other user

-(void)sendDisconectedMessage:(NSString *)msg{
    
    [self.chatBreakBtn setEnabled:NO];
    
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:msg forKey:@"Text"]];
    [self.messageType addObject:@"IN"];
    
    [self.timestamps addObject:[NSDate date]];
    
    [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishReceive];
}

-(void)receiveMessage{
    NSLog(@"isConnected=%@,isReceivingMsg=%@",self.sharedConfig.isConnected?@"YES":@"NO",self.sharedConfig.isReceivingMsg?@"YES":@"NO");
    if(self.sharedConfig.isConnected && !self.sharedConfig.isReceivingMsg){
        if(self.sharedConfig.httpRequestTimeoutTimes>5 && self.sharedConfig.httpRequestTimeoutTimes%6==0){
            self.tdAlertView = [[TdAlertView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Notification_TdAlertView_Height)];
            
            [self.view addSubview:self.tdAlertView];
            
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 self.tdAlertView.frame = CGRectMake(0, Page_History_Navigation_Height, Device_Width, Notification_TdAlertView_Height);
                             } completion:^(BOOL finish){
                                 [UIView animateWithDuration:0.5
                                                       delay:1
                                                     options:UIViewAnimationOptionTransitionCrossDissolve
                                                  animations:^{
                                                      self.tdAlertView.frame = CGRectMake(0, 0, Device_Width, Notification_TdAlertView_Height);
                                                  } completion:^(BOOL finish){
                                                      [self.tdAlertView removeFromSuperview];
                                                  }];
                             }];
        }
        NSLog(@"开始进行http请求获取消息");
        self.receiveMessageRequest;
    }
    /*[NSTimer scheduledTimerWithTimeInterval:1.0
     target:self
     selector:@selector(receiveMessage)
     userInfo:nil
     repeats:NO];*/
    //_getMsgs = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(receiveMessage) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop]addTimer:_getMsgs forMode:NSDefaultRunLoopMode];
    //[[NSRunLoop currentRunLoop] run];
}

-(void)getTypingStatusRequest{
    
    if(self.sharedConfig.isConnected){
        
        //self.sharedConfig.isReceivingMsg = YES;
        
        NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:typingUrl]];
        
        NSString *post=[@"_token_id_=" stringByAppendingString:self.sharedConfig.token];
        
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
                                       NSLog(@"接收消息http请求异常");
                                       //self.sharedConfig.isReceivingMsg = NO;
                                   }else{
                                       
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       
                                       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       
                                       NSLog(@"HttpResponseCode:%d", responseCode);
                                       NSLog(@"HttpResponseBody %@",responseString);
                                       
                                       //NSDictionary *resultDict = [data objectFromJSONData];
                                       NSError *error;
                                       NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                                       BOOL typing = [resultDict objectForKey:@"typing"];
//                                       
//                                       if(typing){
//                                           NSLog(@"对方正在输入");
//                                           [self performSelectorOnMainThread:@selector(showTypingStatus) withObject:nil waitUntilDone:YES];
//                                       }
                                   }
                               }];
    }
    /*_getTypingStatus = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(getTypingStatusRequest:) userInfo:nil repeats:NO];
     [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(getTypingStatusRequest) userInfo:nil repeats:YES];
     //[[NSRunLoop currentRunLoop]addTimer:_getTypingStatus forMode:NSDefaultRunLoopMode];
     [[NSRunLoop currentRunLoop] run];*/
}

-(void)showTypingStatus{
    [_typingLabel setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector: @selector(dismissTypingStatus)
                                   userInfo:nil repeats:NO];
}

-(void)dismissTypingStatus{
    [_typingLabel setHidden:YES];
}

-(void)addReceiveMessageToUI/*:(NSMutableDictionary *)dic*/{
    
    //NSLog(@"添加消息到UI msg=%@",[dic objectForKey:@"msg"]);
    NSString *msg = self.sharedConfig.receivedMsg ;//[self.sharedConfig.readMsgArray objectAtIndex:self.sharedConfig.readMsgCount-1];//[dic objectForKey:@"msg"];
    NSDate *d = [NSDate date];//[self.sharedConfig.readMsgTimestamps objectAtIndex:self.sharedConfig.readMsgCount-1];//[dic objectForKey:@"date"];
    if(msg!=@""){
        [self.messageArray addObject:[NSDictionary dictionaryWithObject:msg forKey:@"Text"]];
        [self.messageType addObject:@"IN"];
        [self.timestamps addObject:d];
        
        NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:d];
        [self.sharedConfig insertMsgDataToTable:msg msgtype:@"IN" date:dateString];
        
        [JSMessageSoundEffect playMessageReceivedSound];
        
        [self finishReceive];
        [self scrollToBottomAnimated:YES];
        
    }
    
}

-(BOOL)isFirstSendMsg
{
    //messageArray、messageType
    NSInteger i = 0,j=0;
    for (i=0;i<[_messageType count]-1;i++){
        if([[_messageType objectAtIndex:i] isEqualToString:@"OUT"]){
            j+=1;
            if(j>0){
                return NO;
            }
        }
    }
    return YES;
}

-(void) sendMessageRequest:(NSString *)message{
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:sendUrl]];
    
    NSString *postString=[[[@"_message_=" stringByAppendingString:message] stringByAppendingString:@"&_h_=1&_token_id_=" ] stringByAppendingString:self.sharedConfig.token];
    
    
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp);
    //NSData *postData = [postString dataUsingEncoding: enc allowLossyConversion: YES];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
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
                                   
                                   //NSDictionary *resultDict = [data objectFromJSONData];
                                   /*NSError *error;
                                    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                    NSString *hb = [resultDict objectForKey:@"hb"];
                                    NSLog(@"hb=%@",hb);*/
                               }
                           }];
}

-(void)SetIphoneUserMessagePrefix{
    self.bSendIphoneUserMsgPrefix = true;
    
    [self sendMessageRequest:[[TdUtilities Instance] GetUserSignature:@" 我就是我， 不一样的烟火~  "]];
    
    self.bSendIphoneUserMsgPrefix = false;
}

- (void)sendZBPressed:(UIButton *)sender withText:(NSString *)text
{
    
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:text forKey:@"Text"]];
    [self.messageType addObject:@"OUT"];
    
    NSDate *d = [NSDate date];
    [self.timestamps addObject:d];
    
    
    
    /*
     if((self.messageArray.count - 1) % 2)
     [JSMessageSoundEffect playMessageSentSound];
     else
     [JSMessageSoundEffect playMessageReceivedSound];
     */
    
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
    
    if(!self.sharedConfig.isConnected){
        [self sendDisconectedMessage:@"亲， 您已经不在'校园'啦，'校园'随时欢迎您回来！"];
    }else{
        
        [self sendMessageRequest:text];
        NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:d];
        [self.sharedConfig insertMsgDataToTable:text msgtype:@"OUT" date:dateString];
    }
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:text forKey:@"Text"]];
    [self.messageType addObject:@"OUT"];
    
    NSDate *d = [NSDate date];
    [self.timestamps addObject:d];
    
    
    
    /*
     if((self.messageArray.count - 1) % 2)
     [JSMessageSoundEffect playMessageSentSound];
     else
     [JSMessageSoundEffect playMessageReceivedSound];
     */
    
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
    
    if(!self.sharedConfig.isConnected){
        [self sendDisconectedMessage:@"亲， 您已经不在'校园'啦，'校园'随时欢迎您回来！"];
    }else{
        
        [self sendMessageRequest:text];
        NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:d];
        [self.sharedConfig insertMsgDataToTable:text msgtype:@"OUT" date:dateString];
    }
    [self scrollToBottomAnimated:YES];
}

- (void)sendDicePressed
{
    if([self.sharedConfig.fromDeveceType isEqualToString:@"ios"]){
        
        //隐藏软键盘
        [self.messageToolView.messageInputTextView becomeFirstResponder];
        
        self.x = arc4random() ;
        self.x = abs(self.x)%6;
        NSLog(@"%d",self.x+1);
        //self.gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"dice_%d", x+1]];
        self.willSendImage = [UIImage imageNamed:[NSString stringWithFormat: @"dice_%d", self.x+1]];
        [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
        [self.messageType addObject:@"OUT"];
        [self.timestamps addObject:[NSDate date]];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        
        [self sendMessageRequest:[NSString stringWithFormat:@"[ios][摇色子:%d]",self.x+1]];
        NSDate *d = [NSDate date];
        NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:d];
        [self.sharedConfig insertMsgDataToTable:[NSString stringWithFormat:@"[ios][摇色子:%d]",self.x+1] msgtype:@"OUT" date:dateString];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"陌路人" message:@"对方需要IOS版本才能支持哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)PlayReceivedDice
{
    NSInteger i =[self.sharedConfig.receivedMsg intValue];
    self.willSendImage = [UIImage imageNamed:[NSString stringWithFormat: @"dice_%d", i]];
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
    [self.messageType addObject:@"IN"];
    [self.timestamps addObject:[NSDate date]];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    NSDate *d = [NSDate date];
    NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:d];
    [self.sharedConfig insertMsgDataToTable:[NSString stringWithFormat:@"[ios][摇色子:%d]",i] msgtype:@"IN" date:dateString];
}

-(NSInteger)getTotalRowCount
{
    return [self.messageArray count];
}

-(void)ClearTableView{
    [self.messageType removeAllObjects];
    [self.messageArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Chat style theme

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messageType[indexPath.row] ==@"IN" ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
        NSLog(@"Text");
        return JSBubbleMediaTypeText;
    }else if ([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        NSLog(@"Image");
        return JSBubbleMediaTypeImage;
    }
    
    return -1;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyAlternating;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleSquare;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"Portrait_TopicStudy"];
}

- (UIImage *)UserProfileMenuItem{
    return [UIImage imageNamed:@"TopicStudy_UserProfileMenuItem"];
}

- (UIImage *)DiceMenuItem{
    return [UIImage imageNamed:@"TopicStudy_DiceMenuItem"];
}

- (UIImage *)ChatHistoryMenuItem{
    return [UIImage imageNamed:@"TopicStudy_ChatHistoryMenuItem"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return self.readLocalAvaterImg;
}

-(UIImage *)readLocalAvaterImg
{
    UIImage *avaterImg = nil;
    //if([self.sharedConfig.customerAvaterImg isEqualToString:@""] || self.sharedConfig.customerAvaterImg==nil){
    avaterImg = [UIImage imageNamed:@"Portrait_Self"];
    /*}else{
     NSString *aPath3=[NSString stringWithFormat:@"/Documents/%@",self.sharedConfig.customerAvaterImg];
     avaterImg = [[UIImage alloc]initWithContentsOfFile:aPath3];
     }*/
    return avaterImg;
}

- (void)loadAvatarImageForOutgoingMessage:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(startImageread:) toTarget:self withObject:indexPath];
}


@end
