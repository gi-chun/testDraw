//
//  SHBFundAccountLIstCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBFundAccountListCell : UITableViewCell
{
    id target;
	SEL openBtnSelector;
	SEL leftBtnSelector;
	SEL centerBtnSelector;
	SEL rightBtnSelector;
    
    int row;

}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;
@property (nonatomic, assign) SEL leftBtnSelector;
@property (nonatomic, assign) SEL centerBtnSelector;
@property (nonatomic, assign) SEL rightBtnSelector;

@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnCenter;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *accountLabel;
@property (retain, nonatomic) IBOutlet UILabel *rateLabel;
@property (retain, nonatomic) IBOutlet UILabel *moneyLabel;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
