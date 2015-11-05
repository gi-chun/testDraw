//
//  SHBNoticeMenuViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBNoticeMenuViewController : SHBBaseViewController<UIWebViewDelegate>
{
    UIButton *btn_menu1;
    UIButton *btn_menu2;
    UIButton *btn_menu3;
    UIButton *btn_menu4;
    UIButton *btn_menu5;
    UIButton *btn_menu6;
    UIButton *btn_menu7; // FAQ조회
    
    NSString *seq; //이벤트 새소식 상세페이지로 이동
    NSString *faq_seq; //이벤트 새소식 상세페이지로 이동
    
    IBOutlet SHBWebView		*webView;
    
    UIPanGestureRecognizer	*panBtnRecognizer;
}

@property (retain, nonatomic) IBOutlet UIButton *btn_menu0; //알림
@property (retain, nonatomic) IBOutlet UIButton *btn_menu1;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu2;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu3;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu4;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu5;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu6;
@property (retain, nonatomic) IBOutlet UIButton *btn_menu7; // FAQ조회
@property (retain, nonatomic) IBOutlet UIButton *btn_menu8; // 스마트명함
@property (retain, nonatomic) IBOutlet UIButton *btn_menu9; // 맞춤거래 설계

@property (retain, nonatomic) IBOutlet UIView *menuView;
@property (retain, nonatomic) IBOutlet UIButton *btnNextMenu;
@property (retain, nonatomic) IBOutlet UIButton *btnNextLeftMenu;

@property (retain, nonatomic) IBOutlet UIButton *dragBtn;
@property (retain, nonatomic) IBOutlet UIButton *closeBtn;

@property (retain, nonatomic) IBOutlet UIImageView *smartLetterNew;
@property (retain, nonatomic) IBOutlet UIImageView *smartCareNew;
@property (retain, nonatomic) IBOutlet UIImageView *couponNew;
@property (retain, nonatomic) IBOutlet UIImageView *lineBG;

@property (retain, nonatomic) IBOutlet UIView *alimBaseView;
@property (retain, nonatomic) IBOutlet UIView *alimView;

- (IBAction)alimPress:(id)sender;
@end
