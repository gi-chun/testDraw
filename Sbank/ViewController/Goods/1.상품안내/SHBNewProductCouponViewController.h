//
//  SHBViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 8. 25..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBTextField.h"


@interface SHBNewProductCouponViewController : SHBBaseViewController<SHBTextFieldDelegate>

{
    NSString *ollehAcc;
    UILabel *acc;
}

- (IBAction)okButton:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *acc;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInCoupon;

@end
