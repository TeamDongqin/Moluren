//
//  ConfirmView.m
//  Moluren
//
//  Created by zheng lingshan on 15/4/1.
//  Copyright (c) 2015年 com.teamdongqin. All rights reserved.
//

#import "ConfirmView.h"

@implementation ConfirmView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 1)];
    view4.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self addSubview:view4];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, Device_Width, 64)];
    view1.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self addSubview:view1];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width / 5, 12, Device_Width * 3 / 5, 40)];
    label.text = [[TdTopic Instance] GetCurrentConfirmText];
    label.textColor = UIColorFromRGB(0x919191);
    label.textAlignment = NSTextAlignmentCenter;
    
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual toItem:view1
                                 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual toItem:view1
                                 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    [self addSubview:label];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, Device_Width, 1)];
    view2.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self addSubview:view2];
    
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114, Device_Width, 7)];
    view3.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [self addSubview:view3];
    
    UIButton* ConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 66, Device_Width, 48)];
    ConfirmButton.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [ConfirmButton setTitle:@"离 开" forState:UIControlStateNormal];
    [ConfirmButton setTitleColor:[[TdTopic Instance] GetCurrentColorPattern] forState:UIControlStateNormal];
    [ConfirmButton addTarget:self action:@selector(OnConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ConfirmButton];
    
    UIButton* CancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 121, Device_Width, 48)];
    CancelButton.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [CancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [CancelButton setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:CancelButton];
}

-(void)OnConfirmButtonClick{
    if ([self.ConfirmViewDelegate respondsToSelector:@selector(SendConfirmButtonClickEvent)]){
        [self.ConfirmViewDelegate SendConfirmButtonClickEvent];
    }
}

-(void)OnCancelButtonClick{
    if([self.ConfirmViewDelegate respondsToSelector:@selector(SendCancelButtonClickEvent)]){
        [self.ConfirmViewDelegate SendCancelButtonClickEvent];
    }
}


@end
