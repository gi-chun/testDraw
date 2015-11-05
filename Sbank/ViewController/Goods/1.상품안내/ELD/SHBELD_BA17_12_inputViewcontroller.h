//
//  SHBELD_BA17_12_inputViewcontroller.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 5. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBSelectBox.h"

@interface SHBELD_BA17_12_inputViewcontroller : SHBBaseViewController <SHBSecureDelegate, SHBTextFieldDelegate, UITextFieldDelegate, SHBListPopupViewDelegate, UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate, SHBSelectBoxDelegate>
{
	int valAmount;  //금액 1: 최소   2: 최대   3: 최소, 최대
}

@property (nonatomic, retain) NSMutableDictionary *mdicPushInfo;	// 푸쉬데이터

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;


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
 출금계좌번호
 */
//@property (nonatomic, retain) SHBTextField *tfOldAccountNum;
@property (nonatomic, retain) SHBSelectBox *sbOldAccountNum;

/**
 출금계좌비밀번호
 */
@property (nonatomic, retain) SHBSecureTextField *tfOldAccountPW;


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

//보이스오버 상품단계 표시
@property (nonatomic, retain) NSString *stepNumber;


/**
 상태값 초기화
 */
- (void)reset;

@end
