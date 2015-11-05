//
//  SHBLoanCommonInterestPayComfirmViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCommonInterestPayComfirmViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;

@end
