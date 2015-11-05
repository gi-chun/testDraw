//
//  SHBGiroTaxAccountInputViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 18..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"


@interface SHBGiroTaxAccountInputViewController : SHBBaseViewController <UITextFieldDelegate, SHBListPopupViewDelegate, SHBSecureDelegate>
{
    IBOutlet UIScrollView       *scrollView1;
    IBOutlet UIView             *viewRealView;
    
    IBOutlet UIButton           *buttonAccount;         // 계좌선택 버튼
    
    IBOutlet UILabel        *label1;        // 지로번호
    IBOutlet UILabel        *label2;        // 전자납부번호
    IBOutlet UILabel        *label3;        // 청구기관명
    IBOutlet UILabel        *label4;        // 고객조회번호
    IBOutlet UILabel        *label5;        // 납부자명
    IBOutlet UILabel        *label6;        // 납부금액
    IBOutlet UILabel        *label7;        // 고지형태
    IBOutlet UILabel        *label8;        // 부과연월
    IBOutlet UILabel        *label9;        // 납부기한
    IBOutlet UILabel        *label10;       // 출금가능 잔액 label
    
    IBOutlet SHBSecureTextField     *textFieldPassword;         // 계좌비밀번호 textField
    IBOutlet SHBTextField           *textFieldPhoneNumber;      // 전화번호 textField
    
    // 선택된 계좌정보 dictionary
    NSMutableDictionary     *dicAccountDic;
    
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

// 이체 가능 계좌 list
@property (nonatomic, retain) NSMutableArray            *arrayCanTransferAccountList;

// 비밀번호
@property (nonatomic, retain) NSString                  *encriptedPW;

- (IBAction)buttonDidPush:(id)sender;

@end
