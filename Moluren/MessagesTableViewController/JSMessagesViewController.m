//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "MolurenHistoryDetailViewController.h"
#import "CurrentHistoryPage.h"

#import "HistoryViewController.h"

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>
{
    double animationDuration;
    CGRect keyboardRect;
}


- (void)setup;


@end



@implementation JSMessagesViewController

#pragma mark - JSMessageViewController Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moback"]];
    //[self.view addSubview:background];
    //self.view.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:233/255.0f alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, TITLE_BAR_HEIGHT, size.width, size.height - TITLE_BAR_HEIGHT - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = NO;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideKeyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    //[self.view addGestureRecognizer:tapGestureRecognizer];
    [self.tableView addGestureRecognizer:tap];
	[self.view addSubview:self.tableView]; 

//  LS03
//	UIButton* mediaButton = nil;
//	if (kAllowsMedia)
//	{
//		// set up the image and button frame
//		UIImage* image = [UIImage imageNamed:@"PhotoIcon"];
//		CGRect frame = CGRectMake(4, 0, image.size.width, image.size.height);
//		CGFloat yHeight = (INPUT_HEIGHT - frame.size.height) / 2.0f;
//		frame.origin.y = yHeight;
//		
//		// make the button
//		mediaButton = [[UIButton alloc] initWithFrame:frame];
//		[mediaButton setBackgroundImage:image forState:UIControlStateNormal];
//		
//		// button action
//		[mediaButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
//	}
	
    /*CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    
    self.inputToolBarView.textView.placeHolder = @"说点什么呢？";
    self.inputToolBarView.hidden = YES;*/
    //[self.inputToolBarView.textView addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
//    LS03
//    UIButton *sendButton = [self sendButton];
//    sendButton.enabled = NO;
//    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
//    [sendButton addTarget:self
//                   action:@selector(sendPressed:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [self.inputToolBarView setSendButton:sendButton];
//    [self.view addSubview:self.inputToolBarView];

//  LS03
//	if (kAllowsMedia)
//	{
//		// adjust the size of the send button to balance out more with the camera button on the other side.
//		CGRect frame = self.inputToolBarView.sendButton.frame;
//		frame.size.width -= 16;
//		frame.origin.x += 16;
//		self.inputToolBarView.sendButton.frame = frame;
//		
//		// add the camera button
//		[self.inputToolBarView addSubview:mediaButton];
//        
//		// move the tet view over
//		frame = self.inputToolBarView.textView.frame;
//		frame.origin.x += mediaButton.frame.size.width + mediaButton.frame.origin.x;
//		frame.size.width -= mediaButton.frame.size.width + mediaButton.frame.origin.x;
//		frame.size.width += 16;		// from the send button adjustment above
//		self.inputToolBarView.textView.frame = frame;
//	}
	
    //[self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    
    
    // LS03
    CGFloat inputViewHeight;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        inputViewHeight = 45.0f;
    }
    else{
        inputViewHeight = 40.0f;
    }
    self.messageToolView = [[ZBMessageInputView alloc]initWithFrame:CGRectMake(0.0f,
                                                                               self.view.frame.size.height - inputViewHeight,self.view.frame.size.width,inputViewHeight)];
    self.messageToolView.delegate = self;
    [self.view addSubview:self.messageToolView];
    self.messageToolView.autoresizesSubviews = YES;
    
    [self shareShareMeun];
}

- (void)shareShareMeun
{
    if (!self.shareMenuView)
    {
        self.shareMenuView = [[ZBMessageShareMenuView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                     CGRectGetHeight(self.view.frame),
                                                                                     CGRectGetWidth(self.view.frame), 196) ];
        [self.view addSubview:self.shareMenuView];
        self.shareMenuView.delegate = self;
        
        
        
        ZBMessageShareMenuItem *sharePicItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_pic_ios7"]
                                                                                                title:@"历史记录"];
        ZBMessageShareMenuItem *shareVideoItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_video_ios7"]
                                                                                                  title:@"拍摄"];
        ZBMessageShareMenuItem *shareLocItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_location_ios7"]
                                                                                                title:@"位置"];
        ZBMessageShareMenuItem *shareVoipItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_videovoip"]
                                                                                                 title:@"视频聊天"];
        ZBMessageShareMenuItem *shareDiceItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_dice_ios7"]
                                                                                                 title:@"摇色子"];
        self.shareMenuView.shareMenuItems = [NSArray arrayWithObjects:sharePicItem,shareVideoItem,shareLocItem,shareVoipItem, shareDiceItem,nil];
        [self.shareMenuView reloadData];
        
    }
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedConfig = [SharedSingleConfig getSharedSingleConfig];
    [self setup];
    
    animationDuration = 0.25;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

- (void)dealloc{
    self.messageToolView = nil;
    
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.messageToolView = nil;
    
//    self.faceView = nil;
//    self.shareMenuView = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillHide:(NSNotification *)notification{
    
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self messageViewAnimationWithMessageRect:CGRectMake(0, 0, 0, 0)
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardChange:(NSNotification *)notification{
    NSLog(@"-----%d---%d",[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y,CGRectGetHeight(self.view.frame));
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:0.25
                                         andState:ZBMessageViewStateShowNone];
    }
}

#pragma end

#pragma mark - MessageView animation
- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(ZBMessageViewState)state{
    
    [UIView animateWithDuration:duration animations:^{
       
        self.messageToolView.frame = CGRectMake(0.0f,MainScreenHeight-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect),MainScreenWidth,CGRectGetHeight(inputViewRect));
        
        
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,self.tableView.frame.origin.y,self.tableView.frame.size.width,MainScreenHeight-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect));
        
        
        NSLog(@"0,%f,%f,%f",MainScreenHeight-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect),MainScreenWidth,CGRectGetHeight(inputViewRect));
        
        //add by liuyouzhang
        /*CGFloat horizontalPadding = 8;
        
        // 垂直间隔
        CGFloat verticalPadding = 5;
        
        // 按钮长,宽
        CGFloat buttonSize = [ZBMessageInputView textViewLineHeight];
        
        self.messageToolView.messageInputTextView.frame = CGRectMake(horizontalPadding + buttonSize +5.0f,
                                                     3.0f,
                                                     self.view.frame.size.width- buttonSize -2*horizontalPadding- 10.0f,
                                                     buttonSize);*/
        
        switch (state) {
            case ZBMessageViewStateShowFace:
            {
//                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
//                
//                self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowNone:
            {
//                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
                
                  self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowShare:
            {
                self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                //self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
            }
                break;
                
            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma end

#pragma mark - ZBMessageInputView Delegate
- (void)didSelectedMultipleMediaAction:(BOOL)changed{
    
    if (changed)
    {
        [self messageViewAnimationWithMessageRect:self.shareMenuView.frame
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowShare];
    }
    else{
        [self messageViewAnimationWithMessageRect:keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
    
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(ZBMessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(ZBMessageTextView *)messageInputTextView
{
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
    
    if (!self.previousTextViewContentHeight)
    {
        self.previousTextViewContentHeight = messageInputTextView.contentSize.height;
    }
}

- (void)inputTextViewDidChange:(ZBMessageTextView *)messageInputTextView
{
    CGFloat maxHeight = [ZBMessageInputView maxHeight];
    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.01f
                         animations:^{
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                     inputViewFrame.origin.y - changeInHeight,
                                                                     inputViewFrame.size.width,
                                                                     inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}
/*
 * 发送信息
 */
- (void)didSendTextAction:(ZBMessageTextView *)messageInputTextView{
    
    ZBMessage *message = [[ZBMessage alloc]initWithText:messageInputTextView.text sender:nil timestamp:[NSDate date]];
    [self sendMessage:message];
    
    [self.delegate sendPressed:nil
                      withText:messageInputTextView.text];
    
    [messageInputTextView setText:nil];
    [self inputTextViewDidChange:messageInputTextView];
}

- (void)sendMessage:(ZBMessage *)message{
}

#pragma mark - ZBMessageShareMenuView Delegate
- (void)didSelecteShareMenuItem:(ZBMessageShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    if(index == 0)
    {
        [self.tabBarController.tabBar setHidden:YES];
        [self.delegate gotoHistoryDetailView];
        
    }
    else if(index == 1)
    {
        
    }
    else if(index == 4)
    {
        //ZBMessage *message = [[ZBMessage alloc]initWithText:@"摇色子" sender:nil timestamp:[NSDate date]];
        //[self sendMessage:message];
        
        [self.delegate sendDicePressed];
        
        //[messageInputTextView setText:nil];
        //[self inputTextViewDidChange:messageInputTextView];
    }
    else
    {
        
    }
}
#pragma end

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self scrollToBottomAnimated:NO];
//    
//    
//    _originalTableViewContentInset = self.tableView.contentInset;
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillShowKeyboard:)
//												 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillHideKeyboard:)
//												 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.inputToolBarView resignFirstResponder];
//    [self setEditing:NO animated:YES];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

#pragma mark - View rotation
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

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.messageToolView.messageInputTextView.text trimWhitespace]];
}


- (void)cameraAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cameraPressed:)]){
        [self.delegate cameraPressed:sender];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType = [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    JSBubbleMessageCell *cell= (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
                                                     mediaType:mediaType
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(cell && mediaType==JSBubbleMediaTypeImage && indexPath.row==[self getTotalRowCount]-1){
        NSLog(@"----%d----------%d---------------",indexPath.row,[self getTotalRowCount]-1);
        [cell.bubbleView startDiceAction];
    }
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                //[cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                //[self loadAvatarImageForOutgoingMessage:indexPath];
                [cell setAvatarImage:[UIImage imageWithData: self.sharedConfig.customerAvaterImgData]];
                break;
        }
    }
    
	if (kAllowsMedia)
		[cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
    
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    //[cell setBackgroundColor:tableView.backgroundColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)loadAvatarImageForOutgoingMessage:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(startImageread:) toTarget:self withObject:indexPath];
}

-(void)startImageread:(NSIndexPath *)indexPath
{
    NSString *aPath3=[NSString stringWithFormat:@"/Documents/%@",self.sharedConfig.customerAvaterImg];
    UIImage *avaterImg = [[UIImage alloc]initWithContentsOfFile:aPath3];
    NSDictionary *cellimage = [NSDictionary dictionaryWithObjectsAndKeys:
                               indexPath, @"indexPath",
                               avaterImg,@"image",
                               nil];
    [self performSelectorOnMainThread:@selector(_setOCellImage:) withObject:cellimage waitUntilDone:YES];
}

- (void)_setOCellImage:( id )celldata
{
    UIImage *newimage = [celldata objectForKey:@"image"];//从参数celldata里面拿出来图片
    NSIndexPath *indexPath = [celldata objectForKey:@"indexPath"];
    [self.tableView cellForRowAtIndexPath:indexPath].imageView.image = newimage;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }else{
        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
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
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

-(void)tapToHideKeyboard:(UITapGestureRecognizer*)tap
{
    //[self.inputToolBarView.textView resignFirstResponder];
    [self.messageToolView.messageInputTextView resignFirstResponder];
}

- (void)finishSend
{
    [self.messageToolView.messageInputTextView setText:nil];
    [self textViewDidChange:self.messageToolView.messageInputTextView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)finishReceive
{
    //[self.inputToolBarView.textView setText:nil];
    //[self textViewDidChange:self.inputToolBarView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
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


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}


#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        if(self.messageToolView.messageInputTextView.text.length>0){
        
        //[textView resignFirstResponder];
        [self.delegate sendPressed:nil
                          withText:[self.messageToolView.messageInputTextView.text trimWhitespace]];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    //self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.messageToolView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.messageToolView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - self.messageToolView.frame.origin.y - inputViewFrame.size.height;
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.messageToolView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageToolView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.messageToolView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.messageToolView.frame = inputViewFrame;
}

#pragma mark - DYNavigationController Delegate

//- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
//{
//    CGRect inputViewFrame = self.inputToolBarView.frame;
//    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
//    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
//    self.inputToolBarView.frame = inputViewFrame;
//    
//    
//}

@end