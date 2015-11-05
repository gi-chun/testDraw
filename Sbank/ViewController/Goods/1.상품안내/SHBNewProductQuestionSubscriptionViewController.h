//
//  SHBNewProductQuestionSubscriptionViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 가입 > 약관 > 주택공급정책 활용을 위한 자료조사표
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBMonthField.h"
#import "SHBSelectBox.h"

@interface SHBNewProductQuestionSubscriptionViewController : SHBBaseViewController <SHBTextFieldDelegate, UITextFieldDelegate, SHBListPopupViewDelegate, SHBMonthFieldDelegate, SHBSelectBoxDelegate>

@property (nonatomic, retain) NSMutableDictionary *mdicPushInfo;	// 푸쉬데이터

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

/**
 우편번호 왼쪽
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfZipCodeLeft;

/**
 우편번호 오른쪽
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfZipCodeRight;

/**
 희망주택형
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbHopeHouseType;

/**
 희망주택면적
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbHopeHouseSize;

/**
 희망입주시기
 */
//@property (retain, nonatomic) IBOutlet SHBTextField *tfHopeTime;
@property (retain, nonatomic) IBOutlet SHBMonthField *mfHopeTime;


/**
 직업
 */
//@property (retain, nonatomic) IBOutlet SHBSelectBox *sbJob;

/**
 주거구분
 */
//@property (retain, nonatomic) IBOutlet SHBSelectBox *sbLivingSort;

/**
 주거종류
 */
//@property (retain, nonatomic) IBOutlet SHBSelectBox *sbLivingType;

/**
 라디오버튼 : 기혼
 */
//@property (retain, nonatomic) IBOutlet UIButton *btnMarried;

/**
 라디오버튼 : 미혼
 */
//@property (retain, nonatomic) IBOutlet UIButton *btnSingle;

@property (retain, nonatomic) IBOutlet UIImageView *ivInfoBox;

/**
 우편번호 검색
 */
- (IBAction)zipCodeSearchAction:(SHBButton *)sender;

/**
 결혼여부 : 기혼/미혼
 */
- (IBAction)maritalStatusRadioBtnAction:(UIButton *)sender;

/**
 확인버튼
 */
- (IBAction)confirmBtnAction:(SHBButton *)sender;

/**
 취소버튼
 */
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
