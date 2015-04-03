//
//  PersonViewController.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/2.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "PersonViewController.h"
#import "UserInfo.h"

@interface PersonViewController ()

@property (strong, nonatomic) UITableViewCell *firstNameCell;
@property (strong, nonatomic) UITableViewCell *shareCell;
@property (strong, nonatomic) UITableViewCell *shareCell1;

@property (strong, nonatomic) UITextField *firstNameText;

@end

@implementation PersonViewController

#pragma View life cycle

-(void)viewWillAppear:(BOOL)animated{
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(Color_SettingView_Background);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,Device_Width,Device_Height) style:UITableViewStyleGrouped];
    //tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[tableView setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.scrollEnabled = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    // construct first name cell, section 0, row 0
    self.firstNameCell = [[UITableViewCell alloc] init];
    self.firstNameCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.shareCell.textLabel.text = @"个性签名";
    self.shareCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.shareCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.firstNameText = [[UITextField alloc]initWithFrame:CGRectInset(self.firstNameCell.contentView.bounds, 15, 0)];
    
    NSString* string = [[UserInfo Instance] GetUserPersonalSignature];
    if( [string isEqual: @""]){
        self.firstNameText.placeholder = UserPerSignature_Defaul;
    }
    else{
        self.firstNameText.text = string;
    }
    
    self.firstNameText.delegate = self;
    
    [self.firstNameCell addSubview:self.firstNameText];
    
    // construct share cell, section 1, row 00
    self.shareCell = [[UITableViewCell alloc]init];
    self.shareCell.textLabel.text = @"交换名片";
    self.shareCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.shareCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.shareCell1 = [[UITableViewCell alloc]init];
    self.shareCell1.textLabel.text = @"口袋";
    self.shareCell1.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.shareCell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Ui operation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 5, 12, Device_Width * 3 / 5, 40)];
//    label.text = @"个性签名";
//    label.textColor = UIColorFromRGB(0x919191);
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    // Set the data for this cell:
//    UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 20, Device_Width, 40)];
//    [cell addSubview:label];
//    
//    // set the accessory view:
//    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//    
//    [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
//    [cell.contentView.layer setBorderWidth:1.0f];
//    
//    return cell;
    
    UITableViewCell* cell = nil;
    
    switch(indexPath.section)
    {
        case 0:
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    cell = self.firstNameCell;
                }
                break;
                default:
                break;
            }
        }
        break;
        case 1:
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    cell = self.shareCell;
                }
                break;
                default:
                break;
            }
        }
        break;
        case 2:
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    cell = self.shareCell1;
                }
                break;
                default:
                break;
            }
        }
        break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* string = nil;
    
    switch(section)
    {
        case 0:
        {
            string = @"个性签名";
        }
        break;
        case 1:
        {
            string = @"功能";
        }
        break;
        case 2:
        {
            string = @"口袋";
        }
        break;
        default:
        break;
    }
    
    return string;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [[UserInfo Instance] SetUserPersonalSignature:textField.text];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.firstNameText == textField)
    {
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }
    return YES;
}

@end
