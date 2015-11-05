//
//  SHBAccountListCell.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBAttentionLabel.h"

@interface SHBAccountListCell : UITableViewCell
{
	id target;
	SEL pSelector;
    int row;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL pSelector;
@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIImageView *imgDetail;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *accountName;
@property (retain, nonatomic) IBOutlet UILabel *accountNo;
@property (retain, nonatomic) IBOutlet UILabel *rate;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UILabel *balanceCaption;
@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnCenter;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *expiryDate;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
