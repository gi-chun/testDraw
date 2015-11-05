//
//  SHBSimpleLoanStipulationViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 대출 - 약정업체 간편대출
 약관동의 화면
 */

@interface SHBSimpleLoanStipulationViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet UIButton *agreeBtn; // 예, 동의합니다.
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn1_1; // 1. 필수적 정보 (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn1_2; // 1. 선택적 정보 (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn2; // 2. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn3; // 3. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn4; // 4. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn5; // 5. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn6; // 6. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn7; // 7. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn8; // 8. (동의함, 동의하지 않음)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *collectionBtn9; // 9. (동의함, 동의하지 않음)

- (void)clearViewData;

@end
