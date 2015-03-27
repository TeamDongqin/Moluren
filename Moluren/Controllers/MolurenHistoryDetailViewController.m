//
//  MolurenHistoryDetailViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-11-23.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "MolurenHistoryDetailViewController.h"
#import "ChatHistoryEntity.h"
#import "JSBubbleMessageCell.h"

@interface MolurenHistoryDetailViewController ()

@property (nonatomic, strong) NSString *sid;

@property (strong, nonatomic) UIButton *ReturnButton;
@property (strong, nonatomic) UIButton *DeleteButton;

@end

@implementation MolurenHistoryDetailViewController


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

#pragma mark - Initialization
- (void)setup
{
    hisDB = [[ChatHistoryDB alloc] init];
    
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
    
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,size.width,Page_History_Header)];
    self.titleView.text = [NSString stringWithFormat:@"历史记录-%d",self.sid];
    self.titleView.textAlignment = NSTextAlignmentCenter;
    self.titleView.backgroundColor = UIColorFromRGB(0xD87A7A);
    
    [self.view addSubview:self.titleView];
    
    CGRect tableFrame = CGRectMake(0.0f, Page_History_Header, size.width, size.height - Page_History_Header);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
    
    [self.view addSubview:self.tableView];
    
    UIImage *ReturnButtonImage = [UIImage imageNamed:@"Button_Return"];
    
    _ReturnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 24, 60, 20)];
    [_ReturnButton setBackgroundImage:ReturnButtonImage forState:UIControlStateNormal];
    [_ReturnButton addTarget:self action:@selector(onReturnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.ReturnButton];
}

-(void)onReturnButtonClick{
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizerRight];
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizerLeft];
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
        //如果需要自定义历史记录view的左右滑动切换效果,那么就在这里进行动画设置
        //molurenHistoryDetailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        /*CATransition *animation = [CATransition animation];
        [animation setDuration:8.0f];
        [animation setType:@"cube"];
        [animation setSubtype:@"fromRight"];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[molurenHistoryDetailViewController.view layer] addAnimation:animation forKey:@"kTransitionAnimation"];*/
        
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.8;
        //1 立方体旋转效果
        /*transition.type = @"cube";
        transition.subtype = @"fromRight";*/
        //2 翻页效果 不用设置subtype
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.view.window.layer addAnimation:transition forKey:@"kTransitionAnimation"];
        
        [self presentModalViewController:molurenHistoryDetailViewController animated:NO];
        //[self presentModalViewController:molurenHistoryDetailViewController animated:YES];
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        //执行程序
        //self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.8;
        //1 立方体旋转效果
        /*transition.type = @"cube";
        transition.subtype = @"fromLeft";*/
        //2 翻页效果 不用设置subtype
        //transition.type = @"pageUnCurl";
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromLeft;
        
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.window.layer addAnimation:transition forKey:@"kTransitionAnimation"];
        
        [self dismissModalViewControllerAnimated:NO];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
        [self.tableView deselectRowAtIndexPath:selected animated:animated];*/
    _hisData = [NSMutableArray arrayWithArray:[hisDB findWithSidForDetail:self.sid limit:10000]];
    [self.tableView reloadData];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self scrollToBottomAnimated:YES];
}

- (void) viewWillDisAppear:(BOOL)animated {
    
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_hisData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType = [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];*/
    
    ChatHistoryEntity *his = [_hisData objectAtIndex:indexPath.row];
    JSBubbleMessageType type;
    if([his.msgtype isEqualToString:@"IN"]){
        type = JSBubbleMessageTypeIncoming;
    }else{
        type = JSBubbleMessageTypeOutgoing;
    }
    JSBubbleMessageStyle bubbleStyle = JSBubbleMessageStyleFlat;
    JSAvatarStyle avatarStyle = JSAvatarStyleSquare;
    JSBubbleMediaType mediaType = JSBubbleMediaTypeText;
    
    BOOL hasTimestamp = YES;
    BOOL hasAvatar = YES;
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone mediaType:mediaType
                                                  hasTimestamp:hasTimestamp
                                                messageType:0
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp){
        //将时间字符串转化为NSDate
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        //dateFormatter通过setTimeZone来设置正确的时区
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
        NSDate *date=[dateFormatter dateFromString:his.date];
        [cell setTimestamp:date];
    }
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
                [cell setAvatarImage:[UIImage imageNamed:@"Portrait_TopicLife"]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                [cell setAvatarImage:[UIImage imageNamed:@"Portrait_Self"]];
                //[cell setAvatarImage:[UIImage imageWithData: self.sharedConfig.customerAvaterImgData]];
                break;
        }
    }
    
    [cell setMessage:his.msg];
    [cell setBackgroundColor:tableView.backgroundColor];
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatHistoryEntity *his = [_hisData objectAtIndex:indexPath.row];
    //if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
        return [JSBubbleMessageCell neededHeightForText:his.msg
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    /*}else{
        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }*/
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }*/
    return YES;
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }*/
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
