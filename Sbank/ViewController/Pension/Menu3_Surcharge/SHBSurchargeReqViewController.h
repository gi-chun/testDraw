//
//  SHBSurchargeReqViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 19..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"            // list popup view
#import "SHBSecureTextField.h"          // secureTextField
#import "SHBTextField.h"                // SHBTextField


@interface SHBSurchargeReqViewController : SHBBaseViewController <SHBListPopupViewDelegate, SHBSecureDelegate, UITextFieldDelegate, SHBTextFieldDelegate>
{
    IBOutlet UIButton           *buttonAccount;         // 계좌선택 버튼
    
    IBOutlet UILabel        *labelSubTitle;             // 서브 타이틀
    IBOutlet UILabel        *labelAccount1;             // 계좌번호
    IBOutlet UILabel        *labelAmountString;         // 금액한글표시
    IBOutlet UILabel        *labelAmountLeft;           // 출금 가능 금액
    
    IBOutlet SHBSecureTextField     *textFieldPassword;     // 출금계좌비밀번호
    IBOutlet SHBTextField           *textFieldAmount;       // 이체금액
    
    // 선택된 계좌정보
    NSMutableDictionary     *dicAccountDic;
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

// 비밀번호
@property (nonatomic, retain) NSString                  *encriptedPW;

- (IBAction)buttonDidPush:(id)sender;


@end
