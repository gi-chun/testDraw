//
//  SHBLoanCancelCompleteViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//




#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCancelCompleteViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@property (nonatomic, retain) NSDictionary *L1241;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
