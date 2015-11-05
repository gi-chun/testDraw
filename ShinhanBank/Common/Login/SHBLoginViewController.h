//
//  SHBLoginViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 17..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBLoginViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>{
	IBOutlet UIScrollView	*_scrollView;
	IBOutlet UIView			*_infoView;
	IBOutlet UIView			*_descView;
	
	IBOutlet UILabel		*_descLabel1;
	IBOutlet UILabel		*_descLabel2;
	IBOutlet UILabel		*_descLabel3;
	IBOutlet UILabel		*_descLabel4;
	
	NSString	*encriptedPassword;
	
	BOOL isRequestInsPush;
}

@property (nonatomic, retain) NSString *encriptedPassword;

@property (nonatomic, retain) IBOutlet SHBTextField *idTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *pwTextField;

@property (nonatomic, retain) IBOutlet UIButton *idLoginButton;

- (void)scrollMainView:(float)posY;


// 로그인.
- (IBAction)login:(id)sender;
//- (IBAction) closeNormalPad:(id)sender;

// nFilter 관련.
//- (IBAction)showKeypadForNum;
//- (IBAction)showKeypad;

/**
 공인인증서 로그인: 인증서 관리 화면으로 이동.
 
 @param sender 버튼.
 */
- (IBAction)goCertManage:(id)sender;

/**
 공인인증센터 화면으로 이동.
 
 @param sender 버튼.
 */
- (IBAction)goCertCenter:(id)sender;


// 회원가입
- (IBAction)joinMember:(id)sender;


@end
