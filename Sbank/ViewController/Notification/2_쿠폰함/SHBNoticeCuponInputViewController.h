//
//  SHBNoticeCuponInputViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 14..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBNoticeCuponInputViewController : SHBBaseViewController <SHBTextFieldDelegate, UITextFieldDelegate>

{
    NSString *name_5022;
    NSString *nameCode_5022;
    NSString *name_5024;
    NSString *nameCode_5024;
    NSString *sumpercent_1;
    NSString *sumpercent_2;
    NSString *month;

}


@property (nonatomic, retain) NSMutableArray *marrAccounts;		// 출금계좌 배열
@property (nonatomic, retain) NSMutableDictionary *selectedAccount;	// 선택된 출금계좌
@property (nonatomic, retain) IBOutlet UIView *contentsView;                     // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UIView *view1;                            // 계약기간 입력 뷰
@property (nonatomic, retain) IBOutlet UIView *view2;                            // 계약기간, 회전주기 입력 뷰
@property (nonatomic, retain) IBOutlet UIView *view3;                            // 상품 및 금리조회 버튼 뷰
@property (nonatomic, retain) IBOutlet UILabel *label1;                          // 우대금리유효기간
@property (nonatomic, retain) IBOutlet SHBTextField *textField1;                 // 신규금액(숫자) 텍스트 필드
@property (nonatomic, retain) IBOutlet UILabel *label2;                          // 신규금액(한글)
@property (nonatomic, retain) IBOutlet SHBTextField *textField2;                 // 계약기간 텍스트 필드
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection1; // 계약기간 라디오 버튼
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection2; // 회전주기 라디오 버튼
@property (nonatomic, retain) NSMutableDictionary *selectCouponDic;              // 선택한 쿠폰 데이타
@property (nonatomic, assign) BOOL isTypeB;                                      // view1 or view2 뷰 표시 여부 플래그 (NO:view1, YES:view2) - 중요!!
                                                                                 // view1 = Type A (신한그린애너지, Mint(온라인전용) 정기예금 금리우대 쿠폰)
                                                                                 // view2 = Type B (Tops회전, U드림회전 정기예끔 금리우대 쿠폰)





- (IBAction)buttonDidPush:(id)sender;                                            // 버튼 선택 액션 이벤트


@end
