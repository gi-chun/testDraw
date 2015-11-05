//
//  SHBNewProductTaxBreakViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 상세 > 가입 > 약관 > 가입입력 > 세금우대
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBDateField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBSelectBox.h"

@interface SHBNewProductTaxBreakViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate, SHBPopupViewDelegate, SHBSelectBoxDelegate , SHBListPopupViewDelegate>

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

@property (nonatomic, retain) OFDataSet *D4220;		// 세금우대 정보
@property (nonatomic, retain) OFDataSet *D3602;		// 세금우대 안내문구
@property (nonatomic, retain) OFDataSet *D4222;		// 비과세

/**
 세금우대가입총액
 */
@property (nonatomic, retain) UILabel *lblTopRow1Title;
@property (nonatomic, retain) UILabel *lblTopRow1Value;

/**
 세금우대한도잔여
 */
@property (nonatomic, retain) UILabel *lblTopRow2Title;
@property (nonatomic, retain) UILabel *lblTopRow2Value;

/**
 확인/취소 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomBackView;

/**
 세금우대 신청금액
 */
@property (nonatomic, retain) SHBTextField *tfTaxBreakAmount;

/**
 자동이체시작일
 */
//@property (nonatomic, retain) SHBTextField *tfAutoTransStartDate;
@property (nonatomic, retain) SHBDateField *dfAutoTransStartDate;

/**
 자동이체종료일
 */
//@property (nonatomic, retain) SHBTextField *tfAutoTransEndDate;
@property (nonatomic, retain) SHBDateField *dfAutoTransEndDate;



/**
 자동이체금액
 */
@property (nonatomic, retain) SHBTextField *tfAutoTransAmount;


//보이스오버 상품단계 표시
@property (nonatomic, retain) NSString *stepNumber;


/**
 확인버튼 액션
 */
- (IBAction)confirmBtnAction:(SHBButton *)sender;

/**
 취소버튼 액션
 */
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
