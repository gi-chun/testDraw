//
//  SHBGiftInfoInputViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBGiftService.h"
#import "SHBListPopupView.h"
#import "SHBSecureTextField.h"
#import "SHBTextField.h"
#import "SHBMobileCertificateService.h" // 추가인증


@interface SHBGiftInfoInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate,UITextViewDelegate>

{
    //SHBAccountService *service;
    //SHBGiftService *giftservice;
    NSDictionary *outAccInfoDic;
    NSString *giftType;
}

//@property (nonatomic, retain) SHBAccountService *service;
//@property (nonatomic, retain) SHBGiftService *giftservice;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (nonatomic, retain) NSString *giftType;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;  //출금계좌번호

@property (retain, nonatomic) IBOutlet UILabel *lblBalance;  // 출금가능금액
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;  // 구매제한 문구

@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW; //계좌비밀번호
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtInAmount;    //구매금액

@property (retain, nonatomic) IBOutlet SHBTextField *txtInName;     //보내는분
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvName;    //받는분

@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtInPhone;    //받는분휴대폰
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvPhone;    //보내는분휴대폰
@property (retain, nonatomic) IBOutlet SHBTextField *txtInText;    //전달내용
@property (retain, nonatomic) IBOutlet UITextView *massegecontentTV;  //전달 내용 텍스트뷰
@property (nonatomic, retain) IBOutlet UIView *toolBarView;                         // 툴바 뷰
@property (retain, nonatomic) IBOutlet UIButton *prevBtn;
@property (retain, nonatomic) IBOutlet UILabel *emartInfoLabel;
@property (retain, nonatomic) IBOutlet UIView *bottomInputView;

@property (nonatomic, retain) SHBMobileCertificateService *securityCenterService; // 추가인증
@property (nonatomic, retain) OFDataSet *securityCenterDataSet; // 추가인증
@property (retain, nonatomic) IBOutlet UIView *mainView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;


@end
