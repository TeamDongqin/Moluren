//
//  MainTabViewController.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "MolurenSettingViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingTableViewCell1.h"
#import "SettingTableViewCell2.h"

#define AVATAR_VIEW_HEIGHT 120
#define AVATAR_IMG_HEIGHT 100
#define ORIGINAL_MAX_WIDTH 640.0f

@interface MolurenSettingViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (strong, nonatomic) UITableView *tableView;


@end
@implementation MolurenSettingViewController

- (void)loadView
{
    [super loadView];
}

-(void)setup{
    //self.title = @"设置";
    
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2-100, 24, 200, 20)];
    usernameLabel.text=@"设置";
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
    
    CGRect tableFrame = CGRectMake(0.0f, AVATAR_VIEW_HEIGHT, size.width, size.height -AVATAR_VIEW_HEIGHT);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = YES;
    self.tableView.scrollEnabled =NO;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    //self.portraitImageView.frame = CGRectMake(0.0f, 0, 40, 40);
    [self.view addSubview:self.portraitImageView];
    [self loadPortrait];
    
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;//去除分割线
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"SettingTableViewData" ofType:@"plist"];
    self.UserViewCellDic = [[NSDictionary alloc]initWithContentsOfFile:plistpath];
    self.listGroupname = [self.UserViewCellDic allKeys];
    self.listGroupname = [self.listGroupname sortedArrayUsingSelector:@selector(compare:)];//排序}
}

- (void)loadPortrait {
    if([self.sharedConfig.customerAvaterImg isEqualToString:@""] || self.sharedConfig.customerAvaterImg==nil){
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
//        NSURL *portraitUrl = [NSURL URLWithString:@"http://photo.l99.com/bigger/31/1363231021567_5zu910.jpg"];
//        UIImage *protraitImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:portraitUrl]];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            self.portraitImageView.image = protraitImg;
//        });
//    });
        self.portraitImageView.image = [UIImage imageNamed:@"Portrait_Self"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),self.sharedConfig.customerAvaterImg];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.portraitImageView.image = [[UIImage alloc]initWithContentsOfFile:aPath3];
        });
    });
    }
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        NSData *data = nil;
        NSString *imagetype =@"";
        if (UIImagePNGRepresentation(editedImage) == nil) {
            
            data = UIImageJPEGRepresentation(editedImage, 1);
            imagetype = @"jpg";
            
        } else {
            
            data = UIImagePNGRepresentation(editedImage);
            imagetype = @"png";
            
        }
        NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),defaultAvaterName,imagetype];
        self.sharedConfig.customerAvaterImg = [NSString stringWithFormat:@"%@.%@",NSHomeDirectory(),defaultAvaterName,imagetype];
        self.sharedConfig.customerAvaterImgData = data;
        //删除已存在的头像
        if(!self.sharedConfig.customerAvaterImg==nil && ![self.sharedConfig.customerAvaterImg isEqualToString:@""])
        {
            NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), self.sharedConfig.customerAvaterImg];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            [fileManager removeItemAtPath:imageDir error:nil];
        }
        [data writeToFile:aPath atomically:YES];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = AVATAR_IMG_HEIGHT; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, [self.navigationController navigationBar].frame.size.height+20+(AVATAR_VIEW_HEIGHT-AVATAR_IMG_HEIGHT)/2, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(6, 6);
        _portraitImageView.layer.shadowOpacity = 0.8;
        _portraitImageView.layer.shadowRadius = 4.0;
        _portraitImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    //return [self.listGroupname count];
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section//Section头名字设为空
{
    NSString *groupName = @" ";
    return groupName;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"聊天设置", @"聊天设置");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 3;
    /*NSString *groupName = [self.listGroupname objectAtIndex:section];
    NSArray *listitem = [self.UserViewCellDic objectForKey:groupName];
    return [listitem count];*/
    return 1;
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (!cell) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 cell.selectionStyle = UITableViewCellSelectionStyleGray;
 }
 
 //cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
 return cell;
 }*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{/*
  FirstViewController *firstViewController = [[FirstViewController alloc] initWithStyle:UITableViewStylePlain];
  [firstViewController setHidesBottomBarWhenPushed:(BOOL)([indexPath row] % 2)];
  [self.navigationController pushViewController:firstViewController animated:YES];*/
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Settings_Reconnect"];
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] init];
    
    //UISwitch *autoConnectSwitch = (UISwitch *)[cell viewWithTag:100];
    //[autoConnectSwitch setOn:true animated:YES];
    
    //[autoConnectSwitch setOn:true animated:YES];
    
    UILabel *Label = (UILabel *)[cell viewWithTag:101];
    Label.text = @"断开自动重启";
    
    //[cell.autoReconnectSwitch setOn:true animated:YES];
    
    //cell.textLabel.text = Label.text;
    
    return cell;
     */
    
    static NSString *UserViewCellIdentifier1 = @"SettingTableViewCell1";
    static NSString *UserViewCellIdentifier2 = @"SettingTableViewCell2";
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *groupName = [self.listGroupname objectAtIndex:section];
    NSArray *listitem = [self.UserViewCellDic objectForKey:groupName];
    NSDictionary *rowDict = [listitem objectAtIndex:row];
    if (0 == section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserViewCellIdentifier2];
        if(cell==nil){
            cell = [[SettingTableViewCell2 alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:UserViewCellIdentifier2];
            UINib *nib = [UINib nibWithNibName:@"SettingTableViewCell2" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:UserViewCellIdentifier2];
        }
        //cell.name.text = [rowDict objectForKey:@"name"];
        NSString *imagePath = [rowDict objectForKey:@"image"];
        //imagePath = [imagePath stringByAppendingString:@".png"];
        //cell.userviewcell2image.image = [UIImage imageNamed:imagePath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//最后的箭头
        //画线
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 79, 320, 1)];
        UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 80)];
        UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(317, 0, 3, 80)];
        view.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:1];
        leftview.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:1];
        rightview.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:1];
        //[cell.contentView addSubview:view];
        //[cell.contentView addSubview:leftview];
        //[cell.contentView addSubview:rightview];
        cell.textLabel.text= @"断开自动重连";
        
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.on = self.sharedConfig.autoConnect;
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserViewCellIdentifier1];
        if(cell==nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:UserViewCellIdentifier1];
            UINib *nib = [UINib nibWithNibName:@"SettingTableViewCell1" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:UserViewCellIdentifier1];
        }
        //cell.userviewcellname.text = [rowDict objectForKey:@"name"];
        NSString *imagePath = [rowDict objectForKey:@"image"];
        //imagePath = [imagePath stringByAppendingString:@".png"];
        //cell.userviewcellicon.image = [UIImage imageNamed:imagePath];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//最后的箭头
        //画线
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
        UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 40)];
        UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(317, 0, 3, 40)];
        view.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:1];
        //alpha是透明度
        leftview.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:0.3];
        rightview.backgroundColor = [UIColor colorWithRed:43/255.0f green:43/255.0f blue:233/255.0f alpha:1];
        //[cell.contentView addSubview:view];
        //[cell.contentView addSubview:leftview];
        //[cell.contentView addSubview:rightview];
        cell.textLabel.text= @"陌路人 V1.0";
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38.0;
}

-(void)updateSwitchAtIndexPath:(id)sender {
    
    
    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn])
    {
        //
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MolurenAutoConnect"];
        self.sharedConfig.autoConnect = YES;
    }
    else
    {
        //do something
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MolurenAutoConnect"];
        self.sharedConfig.autoConnect = NO;
        
    }
}


@end
