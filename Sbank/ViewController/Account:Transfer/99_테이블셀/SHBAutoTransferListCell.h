//
//  SHBAutoTransferListCell.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 13.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBAutoTransferListCell : UITableViewCell
{
	id target;
	SEL pSelector;
    int row;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL pSelector;
@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
@property (retain, nonatomic) IBOutlet UILabel *lblData05;
@property (retain, nonatomic) IBOutlet UIButton *btnOpen;
@property (retain, nonatomic) IBOutlet UIButton *btnLeft;
@property (retain, nonatomic) IBOutlet UIButton *btnCenter;
@property (retain, nonatomic) IBOutlet UIButton *btnRight;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
