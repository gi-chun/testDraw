//
//  SHBAccountNickNameListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBAccountNickNameListCell : UITableViewCell
{
    id target;
	SEL openBtnSelector;
	SEL inquiryBtnSelector;
	SEL deleteBtnSelector;
    
    int row;
    
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;
@property (nonatomic, assign) SEL inquiryBtnSelector;
@property (nonatomic, assign) SEL deleteBtnSelector;

@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountNoLabel;
@property (nonatomic, retain) IBOutlet UILabel *nickNameLabel;

@end
