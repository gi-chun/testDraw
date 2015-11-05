//
//  SHBAutoTransferAgreeViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAutoTransferAgreeViewController : SHBBaseViewController <UIWebViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *marketingAgreeDic; // 마케팅활용동의, 필수정보동의 웹뷰에서 넘어온 데이터

@property (retain, nonatomic) IBOutlet UIButton *btnAutoTransferAgree;
@property (retain, nonatomic) IBOutlet UIButton *btnAgree;
@property (retain, nonatomic) IBOutlet UIButton *btnNotAgree;
@property (retain, nonatomic) IBOutlet UIView *infoAgreeView;
@property (retain, nonatomic) IBOutlet UIView *buttonView;
//@property (retain, nonatomic) IBOutlet UIWebView *marketingWV;
@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;
@property (retain, nonatomic) IBOutlet UIView *mainView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
