//
//  SHBAccountFundListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBAccountFundListCell : UITableViewCell
{
	id target;
	SEL pSelector;
    int row;
}
    
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL pSelector;
@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *accountName;
@property (retain, nonatomic) IBOutlet UILabel *accountNo;
@property (retain, nonatomic) IBOutlet UILabel *rate;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnCenter;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
