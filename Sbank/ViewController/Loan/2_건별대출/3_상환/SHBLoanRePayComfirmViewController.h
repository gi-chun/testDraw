//
//  SHBLoanRePayComfirmViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanRePayComfirmViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@end
