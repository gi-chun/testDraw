//
//  SHBFundTransListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 17..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBFundTransListCell : UITableViewCell
{
    id target;
	SEL openBtnSelector;
    
    int row;
    
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;

@property (nonatomic, retain) IBOutlet UILabel *transDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *transTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *transMoneyLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountMoneyLabel;
@property (nonatomic, retain) IBOutlet UILabel *acountCountLabel;

@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIImageView *imgOpen;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
