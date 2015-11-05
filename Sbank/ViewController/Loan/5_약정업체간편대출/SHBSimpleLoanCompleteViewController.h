//
//  SHBSimpleLoanCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 대출 - 약정업체 간편대출
 신청완료 화면
 */

@interface SHBSimpleLoanCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *errorView;
@property (retain, nonatomic) IBOutlet UIView *errorBottomView;
@property (retain, nonatomic) IBOutlet UIImageView *box;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@end
