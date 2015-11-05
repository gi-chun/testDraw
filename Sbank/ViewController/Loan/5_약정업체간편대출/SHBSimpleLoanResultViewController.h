//
//  SHBSimpleLoanResultViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

/**
 대출 - 약정업체 간편대출
 신청결과 조회 화면
 */

@interface SHBSimpleLoanResultViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName;
@property (retain, nonatomic) IBOutlet UIView *hiddenView;

@end
