//
//  SHBNewProductSignUpViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 상세 > 가입 > 약관 > 가입입력 > 세금우대 > 가입확인
 */

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBNewProductSignUpViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 스마트신규에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSmartNewData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;


//보이스오버 상품단계 표시
@property (nonatomic, retain) NSString *stepNumber;


/**
 확인/취소 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomBackView;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
//- (IBAction)cancelBtnAction:(SHBButton *)sender;
@end
