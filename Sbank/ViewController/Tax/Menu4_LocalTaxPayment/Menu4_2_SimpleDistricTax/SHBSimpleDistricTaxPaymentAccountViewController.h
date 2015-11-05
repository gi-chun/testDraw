//
//  SHBSimpleDistricTaxPaymentAccountViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 6..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"                // 계좌리스트 팝업
#import "SHBSecureTextField.h"

@interface SHBSimpleDistricTaxPaymentAccountViewController : SHBBaseViewController <SHBListPopupViewDelegate, SHBSecureDelegate>
{
    IBOutlet UIButton           *buttonAccount;         // 계좌선택 버튼
    
    IBOutlet UILabel            *labelName;                 // 납부자정보
    IBOutlet UILabel            *labelDate1;                // 납기내납기일
    IBOutlet UILabel            *labelDate2;                // 납기후납기일
    IBOutlet UILabel            *labelRemainAmount;         // 잔액
    IBOutlet UILabel            *labelAmount;               // 납부금액
    
    IBOutlet SHBSecureTextField *secureTextField1;          // 계좌비밀번호
    
    // 선택된 계좌정보 dictionary
    NSMutableDictionary     *dicAccountDic;
}

// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

// 비밀번호
@property (nonatomic, retain) NSString                  *encriptedPW;


- (IBAction)buttonDidPush:(id)sender;

@end
