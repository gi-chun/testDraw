//
//  SHBLoanStipulationView.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define kRowHeight		35

#import <UIKit/UIKit.h>
#import "SHBButton.h"
#import "SHBLoanStipulationViewController.h"

@interface SHBLoanStipulationView : UIView

@property (nonatomic, assign) SHBLoanStipulationViewController *parentViewController;
@property (nonatomic, retain) NSString *strLoan;

@end
