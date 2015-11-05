//
//  SHB_GoldTech_InputViewcontroller.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 11. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBSelectBox.h"



@interface SHB_GoldTech_InputViewcontroller : SHBBaseViewController <SHBSecureDelegate, SHBTextFieldDelegate, UITextFieldDelegate, SHBListPopupViewDelegate, UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate, SHBSelectBoxDelegate>
{
    int valAmount;  //금액 1: 최소   2: 최대   3: 최소, 최대
    NSDictionary *outAccInfoDic;
    NSDictionary *inAccInfoDic;
    NSMutableDictionary *userItem;
    UIButton *btn_zeroCheck;
}

@property (retain, nonatomic) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) NSDictionary *inAccInfoDic;
@property (retain, nonatomic) UIButton *btn_zeroCheck;
/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;



/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 마지막 약관 동의 체크 여부
 */
@property (getter = isLastAgreeCheck) BOOL lastAgreeCheck;



/**
통화코드
 */
@property (nonatomic, retain) UILabel *lb_code;



/**
 신규금액
 */
@property (nonatomic, retain) SHBTextField *tfAmount;

@property (nonatomic, retain) SHBTextField *tfgoal1;
@property (nonatomic, retain) SHBTextField *tfgoal2;
@property (nonatomic, retain) SHBTextField *tfganger1;
@property (nonatomic, retain) SHBTextField *tfganger2;

/**수익률 일자
 */
@property (nonatomic, retain) SHBTextField *dayGoal;
 
/**수익률 일자
 */
@property (nonatomic, retain) SHBTextField *dayGoalNotic;



/**
그램
 */
@property (nonatomic, retain) SHBTextField *tfAmount_gram;


/**
 신규계좌 비밀번호
 */
@property (nonatomic, retain) SHBSecureTextField *tfNewPW;

/**
 비밀번호 확인
 */
@property (nonatomic, retain) SHBSecureTextField *tfNewPWConfirm;


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
