//
//  LanuchViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "LanuchViewController.h"

@interface LanuchViewController()

@property (nonatomic,strong) SharedSingleConfig *sharedConfig;

@end

@implementation LanuchViewController

- (void)loadView
{
    [super loadView];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feature"]];
    [self.view addSubview:background];
    
    
    //添加程序名
    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"陌路人";
    appNameLabel.font = [UIFont systemFontOfSize:28];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor blueColor];
    appNameLabel.frame = CGRectMake(MainScreenWidth/2-120/2, 80, 120, 80);
    [self.view addSubview:appNameLabel];
    
    UILabel *signTextLabel = [[UILabel alloc] init];
    signTextLabel.text = @"人生何处不相逢，相逢何必曾相识";
    signTextLabel.font = [UIFont systemFontOfSize:12];
    signTextLabel.textAlignment = NSTextAlignmentCenter;
    signTextLabel.textColor = [UIColor whiteColor];
    signTextLabel.frame = CGRectMake(MainScreenWidth/2-220/2, 140, 220, 25);
    
    [self.view addSubview:signTextLabel];
    
    // 添加版本标识
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"版本v1.0";
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.frame = CGRectMake(MainScreenWidth/2-120/2, MainScreenHeight-60, 120, 25);
    
    [self.view addSubview:versionLabel];
}// 自定义启动页面，兵显示应用的版本号


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.httpAsynchronousRequest;
    self.retrieveToken;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)httpAsynchronousRequest{
    
    if(!self.sharedConfig.isConnected && [self isViewLoaded] && [self.view window] != nil){
        NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:statisticsUrl]];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
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
                                   }
                               }];
    }
    
    
}

-(void)retrieveToken{
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


@end
