//
//  SHBNewProductRegTopView.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 상품가입 입력화면 및 세금우대 입력화면의 상단에서 사용하는 뷰
 */

#import <UIKit/UIKit.h>
#import "SHBNewProductRegViewController.h"
#import "SHBNewProductTaxBreakViewController.h"
#import "SHBELD_BA17_12_inputViewcontroller.h"
#import "SHBELD_BA17_13_TaxBreakViewController.h"
#import "SHB_GoldTech_InputViewcontroller.h"


@interface SHBNewProductRegTopView : UIView

@property (nonatomic, assign) SHBNewProductRegViewController *regViewController;
@property (nonatomic, assign) SHBNewProductTaxBreakViewController *taxBreakViewController;
@property (nonatomic, assign) SHBELD_BA17_12_inputViewcontroller *eld_inputViewController;
@property (nonatomic, assign) SHBELD_BA17_13_TaxBreakViewController *eld_taxBreakViewController;
@property (nonatomic, assign) SHB_GoldTech_InputViewcontroller *gold_inputViewController;
- (id)initWithFrame:(CGRect)frame parentViewController:(SHBBaseViewController *)viewController;

@end
