//
//  PreviousHistoryPage.m
//  Moluren
//
//  Created by zheng lingshan on 15/1/13.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "PreviousHistoryViewController.h"
#import "PreviousHistoryViewController.h"
#import "NextHistoryViewController.h"
#import "MolurenHistoryDetailViewController.h"
#import "ChatHistoryEntity.h"
#import "JSBubbleMessageCell.h"

#define SummaryViewWidth  MainScreenWidth
#define SummaryViewHeight 120

@interface PreviousHistoryViewController ()

@property (nonatomic,strong) SharedSingleConfig *sharedConfig;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) UIView * summaryView;

@end

@implementation PreviousHistoryViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
    _hisData = [NSMutableArray arrayWithArray:[hisDB findWithSidForDetail:self.sid limit:10000]];
    [self.tableView reloadData];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self scrollToBottomAnimated:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    //[self.tabBarController.tabBar setHidden:NO];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization
- (void)setup {
    UIView *navTitle = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/2-100, 10, 200, 32)];
    //self.navigationItem.titleView = navTitle;
    
    self.delegate = self;
    self.dataSource = self;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, SummaryViewWidth - 2* 20, SummaryViewHeight / 2 - 20)];
    timeLabel.text = @"6 : 50 PM, 周二， 123条记录";
    timeLabel.font = [UIFont systemFontOfSize:18];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor whiteColor];
    
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, SummaryViewHeight / 2, SummaryViewWidth - 2* 20, SummaryViewHeight / 2 - 20)];
    durationLabel.text = @"聊天时间： 10 分钟";
    durationLabel.font = [UIFont systemFontOfSize:18];
    durationLabel.textAlignment = NSTextAlignmentLeft;
    durationLabel.textColor = [UIColor whiteColor];
    
    self.summaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SummaryViewWidth, SummaryViewHeight)];
    //summaryView.backgroundColor = [UIColor whiteColor];
    
    [self.summaryView addSubview:timeLabel];
    [self.summaryView addSubview:durationLabel];
    
    // Add Tableview
    hisDB = [[ChatHistoryDB alloc] init];
    
    //    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2-100, 24, 200, 20)];
    //    usernameLabel.text=@"历史记录";
    //    //usernameLabel.adjustsFontSizeToFitWidth=YES;
    //    usernameLabel.textAlignment = NSTextAlignmentCenter;
    //    usernameLabel.font = [UIFont systemFontOfSize:18];
    //    usernameLabel.textColor = [UIColor whiteColor];
    //    self.navigationItem.titleView = usernameLabel;
    
    [self tableViewSetup];
    
    self.view.backgroundColor = UIColorFromRGB(0x5EBEE7);
    [self.view addSubview:self.summaryView];
    [self.view addSubview:self.tableView];
    
    //[self ShowChatLog];
}

#pragma mark - DYNavigationControllerDelegate

- (UIViewController *)viewControllerToPush {
    UIViewController *anotherDetailViewController = [[UIViewController alloc] init];
    anotherDetailViewController.view.backgroundColor = [UIColor lightGrayColor];
    return anotherDetailViewController;
}

#pragma mark - Chat Log Module : Setup
- (void)ShowChatLog {
    //MolurenHistoryDetailViewController *controller = [self initWithSid:0];
    //[self.navigationController pushViewController:controller animated:YES];
}

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

- (void)tableViewSetup
{
    hisDB = [[ChatHistoryDB alloc] init];
    
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
    CGRect tableFrame = CGRectMake(0.0f, self.summaryView.frame.size.height, MainScreenWidth, size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
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
    JSAvatarStyle avatarStyle = JSAvatarStyleCircle;
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
                [cell setAvatarImage:[UIImage imageNamed:@"default-avatar-in"]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                //[cell setAvatarImage:[UIImage imageNamed:@"default-avatar-out"]];
                [cell setAvatarImage:[UIImage imageWithData: self.sharedConfig.customerAvaterImgData]];
                break;
        }
    }
    
    [cell setMessage:his.msg];
    [cell setBackgroundColor:tableView.backgroundColor];
    return cell;
}


#pragma mark - Chat Log Module : Table view delegate
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

#pragma mark - Chat Log Module : Messages view controller
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
