//
//  SHBBancasuranceListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBBancasuranceListCell : UITableViewCell
{
	id target;
	SEL pSelector;
    int row;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL pSelector;
@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *bacName;
@property (retain, nonatomic) IBOutlet UILabel *bacNo;
@property (retain, nonatomic) IBOutlet UILabel *insuranceName;
@property (retain, nonatomic) IBOutlet UILabel *contractDate;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
