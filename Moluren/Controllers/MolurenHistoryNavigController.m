//
//  MolurenHistoryNavigController.m
//  Moluren
//
//  Created by zheng lingshan on 15/3/28.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "MolurenHistoryNavigController.h"
#import "ChatHistoryEntity.h"
#import "JSBubbleMessageCell.h"
#import "MolurenHistoryDetailViewController.h"

@interface MolurenHistoryNavigController()

@property (nonatomic, strong) NSString *sid;

@property (strong, nonatomic) UIButton *ReturnButton;
@property (strong, nonatomic) UIButton *DeleteButton;

@property (strong, nonatomic) UIColor *CurrentColorPattern;

@property  int firstX;
@property  int firstY;

@end

@implementation MolurenHistoryNavigController

#pragma View life cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self styleNavBar];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)styleNavBar {
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UINavigationBar *CustomNavigBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), Page_History_Navigation_Height)];
    
    self.CustomNavigItem = [[UINavigationItem alloc] init];
    
    self.CurrentColorPattern = [[TdTopic Instance] GetCurrentColorPattern];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)/3, 64);
    label.text = @"聊天记录";
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.CurrentColorPattern;
    
    self.CustomNavigItem.titleView = label;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Button_Return_Default"];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    self.CustomNavigItem.leftBarButtonItem = backBarButtonItem;
    
//    UIImage *rightButtonImage = [UIImage imageNamed:@"Button_Return"];
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:nil];
//    
//    newItem.rightBarButtonItem = rightBarButtonItem;
    
    [CustomNavigBar setItems:@[self.CustomNavigItem]];
    [CustomNavigBar setTintColor: self.CurrentColorPattern];
    
    [self.view addSubview:CustomNavigBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizerRight];
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizerLeft];
    
    //[self SetupGesture];
}

#pragma Ui operations
- (void)backTapped:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        NSInteger *preSid =  [self->hisDB findPreSitWithCurrentSid:self.sid];
        if(preSid==-1000){
            NSLog(@"没有更多的历史记录了");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"陌路人" message:@"没有更多的历史记录了!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        MolurenHistoryDetailViewController *molurenHistoryDetailViewController = [[MolurenHistoryDetailViewController alloc] initWithSid:[NSString stringWithFormat: @"%d",preSid]];

        [self pushViewController:molurenHistoryDetailViewController animated:YES];
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        
        [self popViewControllerAnimated:YES];
    }
}

-(void)PushViewController{
    //[self pushViewController:molurenHistoryDetailViewController animated:YES];
}

-(void)PopViewController{
    [self popViewControllerAnimated:YES];
}

-(void)SetupGesture {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)move:(id)sender {
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [[sender view] center].x;
        self.firstY = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(self.firstX+translatedPoint.x, self.firstY);
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = self.firstY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            if (finalX < 0) {
                //finalX = 0;
            } else if (finalX > 768) {
                //finalX = 768;
            }
            
            if (finalY < 0) {
                finalY = 0;
            } else if (finalY > 1024) {
                finalY = 1024;
            }
        } else {
            if (finalX < 0) {
                //finalX = 0;
            } else if (finalX > 1024) {
                //finalX = 768;
            }
            
            if (finalY < 0) {
                finalY = 0;
            } else if (finalY > 768) {
                finalY = 1024;
            }
        }
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}

#pragma Sid management

- (id) init {
    self = [super init];
    if (self) {
        self.sid = nil;
    }
    return self;
}

- (id) initWithSid:(NSString *) sid {
    self = [super init];
    if (self) {
        self.sid = sid;
    }
    return self;
}


@end
