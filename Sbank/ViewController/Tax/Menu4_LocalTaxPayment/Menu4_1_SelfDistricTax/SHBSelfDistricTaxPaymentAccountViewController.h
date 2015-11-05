//
//  SHBSelfDistricTaxPaymentAccountViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 1..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"                // 계좌리스트 팝업
#import "SHBSecureTextField.h"


@interface SHBSelfDistricTaxPaymentAccountViewController : SHBBaseViewController <SHBListPopupViewDelegate, SHBSecureDelegate>
{
    IBOutlet UIScrollView       *scrollView;        // scrollView
    IBOutlet UIView             *viewRealView;      // 실제 view
    
    IBOutlet UIButton           *buttonAccount;         // 계좌선택 버튼
    
    IBOutlet UILabel            *labelRemainAmount;         // 계좌잔액
    IBOutlet UILabel            *labelAmount;               // 납부금액
    
    IBOutlet SHBSecureTextField *secureTextField1;          // 계좌비밀번호
}

// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;
// 선택된 계좌정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicAccountDic;

// 비밀번호
@property (nonatomic, retain) NSString                  *encriptedPW;



- (IBAction)buttonDidPush:(id)sender;

@end
