//
//  SHBELD_BA17_13_TaxBreakViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 6. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

    
#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBDateField.h"
    
@interface SHBELD_BA17_13_TaxBreakViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>


@property (nonatomic, retain) NSMutableDictionary *mdicPushInfo;	// 푸쉬데이터

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

@property (nonatomic, retain) OFDataSet *D4220;		// 세금우대 정보
@property (nonatomic, retain) OFDataSet *D3602;		// 세금우대 안내문구
@property (nonatomic, retain) OFDataSet *D4222;		// 비과세
@property (nonatomic, retain) OFDataSet *D6115;		// Emaill 값

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

    
    
    
