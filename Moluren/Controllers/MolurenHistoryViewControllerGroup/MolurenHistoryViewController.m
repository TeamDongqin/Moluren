//
//  MolurenHistoryViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-11-6.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "MolurenHistoryViewController.h"
#import "SharedSingleConfig.h"
#import "MolurenHistoryDetailViewController.h"

@interface MolurenHistoryViewController ()

@property (nonatomic,strong) SharedSingleConfig *sharedConfig;

@end

@implementation MolurenHistoryViewController


- (void) loadView {
    [super loadView];
}


#pragma mark - Initialization
- (void)setup
{
    //self.title = @"历史记录";
    hisDB = [[ChatHistoryDB alloc] init];
    
    /*if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }*/
    
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2-100, 24, 200, 20)];
    usernameLabel.text=@"历史记录";
    //usernameLabel.adjustsFontSizeToFitWidth=YES;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.font = [UIFont systemFontOfSize:18];
    usernameLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = usernameLabel;
    
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
    titleLabel.frame = CGRectMake(MainScreenWidth/2-100, 24, 200, 20);
    
    [navTitle addSubview:titleLabel];
    [self.view addSubview:navTitle];*/
    
    CGSize size = self.view.frame.size;
    
    CGRect tableFrame = CGRectMake(0.0f, 0, size.width, size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    NSLog(@"初始化完毕聊天历史主界面");
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
        [self.tableView deselectRowAtIndexPath:selected animated:animated];
    //_hisData = [NSMutableArray arrayWithArray:[hisDB findWithTid:nil limit:10000]];
    //_hisData = [NSMutableArray arrayWithArray:[hisDB getChatSummary]];
    _hisData = [NSMutableArray arrayWithArray:[hisDB findWithSid:10000]];
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_hisData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"HistoryCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    NSString *sid = [_hisData objectAtIndex:indexPath.row];
    //cell.textLabel.text = [his.msg stringByAppendingString:his.msgtype==@"IN"?@"(接收)":@"(发送)"];
    cell.textLabel.text = [NSString stringWithFormat:@"会话-%@",sid];
    //cell.detailTextLabel.text = his.date;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sid = [_hisData objectAtIndex:indexPath.row];
    [self.tabBarController.tabBar setHidden:YES];
    MolurenHistoryDetailViewController *controller = [[MolurenHistoryDetailViewController alloc] initWithSid:sid];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/// 左右滑动所显示的文字
- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
/// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果是删除事件，则删除该条记录
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *sid = [_hisData objectAtIndex:indexPath.row];
        [hisDB deleteMsgWithSId:sid];
        [_hisData removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
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

- (void)dealloc
{
    self.tableView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

@end
