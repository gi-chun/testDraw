//
//  SHBDepositCompleteViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBDepositCompleteViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
