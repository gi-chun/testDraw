//
//  SHBLoanCommonInterestPayCompleteViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCommonInterestPayCompleteViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
