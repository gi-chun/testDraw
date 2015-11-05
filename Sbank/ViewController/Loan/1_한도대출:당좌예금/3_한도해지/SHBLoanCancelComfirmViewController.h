//
//  SHBLoanCancelComfirmViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCancelComfirmViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@end
