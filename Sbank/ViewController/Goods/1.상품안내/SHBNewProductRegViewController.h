//
//  SHBNewProductRegViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 상세 > 가입 > 약관 > 가입입력 화면
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBSelectBox.h"

@interface SHBNewProductRegViewController : SHBBaseViewController <SHBSecureDelegate, SHBTextFieldDelegate, UITextFieldDelegate, SHBListPopupViewDelegate, UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate, SHBSelectBoxDelegate>
{
	int valAmount;  //금액 1: 최소   2: 최대   3: 최소, 최대
    NSString *newMoney;
}

@property BOOL isSubscription;	// 청약여부

/**
 계약기간_자유여부 가 1일 경우 사용
 */
@property BOOL exceptionVal;
@property int mini;
@property int max;

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
 적립방식 선택 라디오버튼 (정기적립식, 자유적립식)
 */
@property (nonatomic, retain) NSMutableArray *marrAccumulateRadioBtns;

/**
 계약기간 선택 라디오버튼 배열
 */
@property (nonatomic, retain) NSMutableArray *marrPeriodRadioBtns;
@property (nonatomic, retain) NSString *strProductCode1;	// 정기적립식 상품코드
@property (nonatomic, retain) NSString *strProductCode2;	// 자유적립식 상품코드

/**
 계약기간 (계약기간 자유일때 생성)
 */
@property (nonatomic, retain) SHBTextField *tfPeriod;


/**
 회전주기 선택 라디오버튼 배열
 */
@property (nonatomic, retain) NSMutableArray *marrTurnRadioBtns;

/**
 신규금액
 */
@property (nonatomic, retain) SHBTextField *tfAmount;

/**
 신규계좌 비밀번호
 */
@property (nonatomic, retain) SHBSecureTextField *tfNewPW;

/**
 비밀번호 확인
 */
@property (nonatomic, retain) SHBSecureTextField *tfNewPWConfirm;


/**
 소득금액증명원 발급번호 확인
 */
@property (nonatomic, retain) SHBTextField *tfNum1;
@property (nonatomic, retain) SHBTextField *tfNum2;
@property (nonatomic, retain) SHBTextField *tfNum3;
@property (nonatomic, retain) SHBTextField *tfNum4;



/**
 휴대폰번호 확인
 */
@property (nonatomic, retain) SHBTextField *tfphone1;
@property (nonatomic, retain) SHBTextField *tfphone2;
@property (nonatomic, retain) SHBTextField *tfphone3;

/**
 예금별명
 */
@property (nonatomic, retain) SHBTextField *tfAccountName;

/**
 권유직원번호
 */
@property (nonatomic, retain) SHBTextField *tfEmployee;

/**
 권유직원조회 버튼
 */
@property (nonatomic, retain) SHBButton *btnEmployee;

/**
 쿠폰번호
 */
@property (nonatomic, retain) SHBTextField *tfCoupon;

/**
 출금계좌번호
 */
//@property (nonatomic, retain) SHBTextField *tfOldAccountNum;
@property (nonatomic, retain) SHBSelectBox *sbOldAccountNum;

/**
 출금계좌비밀번호
 */
@property (nonatomic, retain) SHBSecureTextField *tfOldAccountPW;

/**
 권유직원 조회 팝업뷰 > 검색어 텍스트필드
 */
//@property (retain, nonatomic) IBOutlet SHBTextField *tfEmployeeSearchWord;

/**
 우편번호1
 */
@property (nonatomic, retain) SHBTextField *tfZipCode1;

/**
 우편번호2
 */
@property (nonatomic, retain) SHBTextField *tfZipCode2;

/**
 주소
 */
@property (nonatomic, retain) SHBTextField *tfAddress;

/**
 권유직원 조회 팝업뷰
 */
//@property (retain, nonatomic) IBOutlet UIView *employeeView;

/**
 권유직원 조회 팝업뷰의 직원이름 라디오버튼
 */
//@property (retain, nonatomic) IBOutlet UIButton *btnRadioEmployee;

/**
 권유직원 조회 팝업뷰의 지점명 라디오버튼
 */
//@property (retain, nonatomic) IBOutlet UIButton *btnRadioBranch;

/**
 조회된 권유직원목록 테이블뷰
 */
//@property (retain, nonatomic) IBOutlet UITableView *tblEmployees;

/**
 확인/취소 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomView;

/**
 확인버튼 액션
 */
- (IBAction)confirmBtnAction:(UIButton *)sender;

/**
 취소버튼 액션
 */
- (IBAction)cancelBtnAction:(UIButton *)sender;

/**
 적립방식 라디오버튼 (정기적립식, 자유적립식)
 */
- (void)selectedAccumulateRadioBtn:(UIButton *)sender;

/**
 계약기간 라디오버튼 선택되었을 때
 */
- (void)selectedPeriodRadioBtn:(UIButton *)sender;


/**
회전주기 라디오버튼 선택되었을 때
 */
- (void)selectedTurnRadioBtn:(UIButton *)sender;


//보이스오버 상품단계 표시
@property (nonatomic, retain) NSString *stepNumber;	
/**
 권유직원 조회 > 라디오버튼 액션
 */
//- (IBAction)employeeRadioBtn:(UIButton *)sender;

/**
 권유직원 조회 > 조회버튼 액션
 */
//- (IBAction)searchEmployeeBtn:(SHBButton *)sender;

@end
