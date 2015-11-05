//
//  SHBGiroTaxInputNoViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBPopupView.h"
#import "SHBListPopupView.h"
#import "SHBMonthField.h"


@interface SHBGiroTaxInputNoViewController : SHBBaseViewController <SHBTextFieldDelegate, SHBMonthFieldDelegate, SHBListPopupViewDelegate, SHBSecureDelegate, SHBPopupViewDelegate>
{
    IBOutlet UIScrollView       *scrollView;
    IBOutlet UIView             *viewRealView;
    IBOutlet UIView             *viewAmountConfirmView;         // 금액 검증번호
    IBOutlet UIView             *viewMovedView;                 // 금액 검증번호 유무로 이동되는 view
    
    IBOutlet UIView             *viewHelpView;     // 도움말 view1
    IBOutlet UIView             *viewSearchView;    // 지로번호로 찾기 view
    
    IBOutlet UIButton           *buttonAccount;         // 계좌선택 버튼
    
    SHBPopupView                *giroNumberSearchPopupView;     // 지로번호조회 popupView
    
    IBOutlet UILabel        *labelResult1;              // 검색된 이용기관지로번호
    IBOutlet UILabel        *labelResult2;              // 검색된 수납기관명
    
    
    IBOutlet SHBTextField           *textFieldInputGiro;    // 지로검색의 textField
    IBOutlet UIButton               *buttonSelect;          // 선택
    IBOutlet SHBTextField           *textFieldAmount;       // 납부금액
    IBOutlet SHBTextField           *textFieldSearchNumber; // 고객조회번호
    IBOutlet SHBTextField           *textFieldVerificationNumber;   // 금액검증번호
    IBOutlet SHBSecureTextField     *textFieldPassword;     // 출금계좌비밀번호
    IBOutlet SHBTextField           *textFieldName;         // 납부자명
    IBOutlet SHBTextField           *textFieldPhoneNumber;  // 전화번호
    
    IBOutlet SHBMonthField	*monthField1;
    
    IBOutlet UILabel        *labelGiroNumber;           // 지로번호
    IBOutlet UILabel        *labelCompanyName;          // 납부기관명
    IBOutlet UILabel        *labelAmountString;         // 금액한글표시
    IBOutlet UILabel        *labelSearchORConfirm;      // 고객조회번호, 납부자확인번호
    IBOutlet UILabel        *labelSearchNumberPosition; // 고객조회번호 입력 순서 label
    IBOutlet UILabel        *labelAmountLeft;           // 출금가능잔액
    
    // 선택된 계좌정보
    NSMutableDictionary     *dicAccountDic;
    
    NSString                *strGiroKind;               // 지로 종류
    
}

// 비밀번호
@property (nonatomic, retain) NSString      *encriptedPW;

- (IBAction)buttonDidPush:(id)sender;

@end
