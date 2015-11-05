//
//  SHBSimpleLoanSIDViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 대출 - 약정업체 간편대출
 주민등록번호 확인 화면
 */

@protocol SHBSimpleLoanSIDDelegate <NSObject>

- (void)simpleLoanSIDCancel;

@end

@interface SHBSimpleLoanSIDViewController : SHBBaseViewController

@property (assign, nonatomic) id<SHBSimpleLoanSIDDelegate> delegate;

@end
