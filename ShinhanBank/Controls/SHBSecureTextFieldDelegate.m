//
//  SHBSecureTextFieldDelegate.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 24..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBSecureTextFieldDelegate.h"

/*--------------------------------------------------------------------------------------
 엔필터 헤더파일 임포트
 ---------------------------------------------------------------------------------------*/
#import "NFilterNum.h"
#import "NFilterChar.h"
//#import "KNTestor.h"
#import "EccEncryptor.h"

@interface SHBSecureTextFieldDelegate ()
{
    NFilterChar *vcChar;
    NFilterNum *vcNum;
    int vcFlag;
    int orientionFlag;
    BOOL isFirstForceRotate;
}
- (void)forceRotate;
- (void)loadPublicKeyForNFilter;
@end

@implementation SHBSecureTextFieldDelegate


@synthesize preBtnEnable;
@synthesize nextBtnEnable;
@synthesize parentTextField;
@synthesize delegate;
@synthesize targetViewController;

-(void)dealloc
{
	vcChar = nil; [vcChar release];
    vcNum = nil; [vcNum release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    
    self = [super init];
    if (self)
    {
        
        // Drawing code
        
    }
    return self;
}



#pragma mark - 퍼블릭 메서드

+ (id)secureDelegate
{
    
    return [[[SHBSecureTextFieldDelegate alloc] init] autorelease];
}

- (void)forceRotate
{
    //[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIDeviceOrientationPortrait];
    NSLog(@"forceRotate:%i",self.targetViewController.interfaceOrientation);
    AppInfo.isForceRotate = YES;
    
    //[[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(360 * M_PI / 180);
    [AppDelegate.navigationController.view setTransform:transfrom];
    
    if (AppInfo.isiPhoneFive)
    {
        [AppDelegate.navigationController.view setFrame:CGRectMake(0,20,320,548)];
    } else
    {
        [AppDelegate.navigationController.view setFrame:CGRectMake(0,20,320,460)];
    }
    
}

- (void) forcerotateViewSet
{
    
    AppInfo.isForceRotate = NO;
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(0 * M_PI / 180);
    [AppDelegate.navigationController.view setTransform:transfrom];
    
    if (AppInfo.isiPhoneFive)
    {
        [AppDelegate.navigationController.view setFrame:CGRectMake(0,20,320,548)];
    } else
    {
        [AppDelegate.navigationController.view setFrame:CGRectMake(0,20,320,460)];
    }
}

- (void) rotateViewSet
{
    
    orientionFlag = self.targetViewController.interfaceOrientation;
    
    if (vcFlag == 1 && !AppInfo.isSecurityKeyClose)
    { //숫자
        
        
        if (self.targetViewController.interfaceOrientation != UIInterfaceOrientationMaskPortrait)
        {
            
            if ((AppInfo.beforeRotateDirect == 3 && orientionFlag == 4) || (AppInfo.beforeRotateDirect == 4 && orientionFlag == 3))
            {
                
                [vcNum setRotateToInterfaceOrientation:UIInterfaceOrientationMaskPortrait parentView:self.targetViewController.view];
            } else
            {
                [vcNum setRotateToInterfaceOrientation:self.targetViewController.interfaceOrientation parentView:self.targetViewController.view];
            }
            
        }
        
        
    } else if (vcFlag == 2 && !AppInfo.isSecurityKeyClose)
    {
        
        //문자
        
        if (self.targetViewController.interfaceOrientation != UIInterfaceOrientationMaskPortrait)
        {
            
            if ((AppInfo.beforeRotateDirect == 3 && orientionFlag == 4) || (AppInfo.beforeRotateDirect == 4 && orientionFlag == 3))
            {
                
                [vcNum setRotateToInterfaceOrientation:UIInterfaceOrientationMaskPortrait parentView:self.targetViewController.view];
                
            } else
            {
                [vcChar setRotateToInterfaceOrientation:self.targetViewController.interfaceOrientation parentView:self.targetViewController.view];
            }
            
        }
        
    } else {
        
        [self closeKeyPad];
    }
}

- (void) closeKeyPad{
    
	if (vcFlag == 1){
        
        [vcNum closeNFilter];
        
        vcNum = nil;
        vcFlag = nil;
	}else{
        
        [vcChar closeNFilter];
        vcChar = nil;
        vcFlag = nil;
	}
    
}

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next
{
    
    self.preBtnEnable = prev;
    self.nextBtnEnable = next;
    
    if (vcFlag == 1)
    {
        vcNum.preBtn.enabled = self.preBtnEnable;
        vcNum.nextBtn.enabled = self.nextBtnEnable;
        
        vcNum.preBtnLandscape.enabled = self.preBtnEnable;
        vcNum.nextBtnLandscape.enabled = self.nextBtnEnable;
        
        if (!self.preBtnEnable)
        {
            vcNum.preBtn.alpha = 0.7;
            vcNum.preBtnLandscape.alpha = 0.7;
        }
        if (!self.nextBtnEnable)
        {
            vcNum.nextBtn.alpha = 0.7;
            vcNum.nextBtnLandscape.alpha = 0.7;
        }
    } else
    {
        vcChar.preBtn.enabled = self.preBtnEnable;
        vcChar.nextBtn.enabled = self.nextBtnEnable;
        
        vcChar.preBtnLandscape.enabled = self.preBtnEnable;
        vcChar.nextBtnLandscape.enabled = self.nextBtnEnable;
        
        if (!self.preBtnEnable)
        {
            vcChar.preBtn.alpha = 0.7;
            vcChar.preBtnLandscape.alpha = 0.7;
        }
        if (!self.nextBtnEnable)
        {
            vcChar.nextBtn.alpha = 0.7;
            vcChar.nextBtnLandscape.alpha = 0.7;
        }
    }
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.parentTextField resignFirstResponder];
    AppInfo.isSecurityKeyClose = NO;
    self.parentTextField.text = nil;
    int leftCapWidth;
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_focus.png")];
    float imageWidth = tmpImage.size.width;
    
    if (parentTextField.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (parentTextField.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        //leftCapWidth = ((parentTextField.bounds.size.width / 2) - 1);
        leftCapWidth = 3;
    }
    
    [parentTextField setBackground:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //NSLog(@"textFieldDidBeginEditing");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"loginClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateViewSet) name:@"rotateView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forcerotateViewSet) name:@"forcerotateView" object:nil];
    //[self rotateViewSet];
    
	//if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.delegate respondsToSelector:@selector(secureTextFieldDidBeginEditing:)])
    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(secureTextFieldDidBeginEditing:)])
    {
        [self.delegate secureTextFieldDidBeginEditing:parentTextField];
        
    }
    
}

//ios7 + xcode5 대응
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (AppInfo.selectedCertificate == nil && AppInfo.isLogin == LoginTypeIDPW)
    {
        if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(secureTextFieldDidBeginEditing:)])
        {
            [self.delegate secureTextFieldDidBeginEditing:parentTextField];
            return NO;
        }
    }
    
    if (!AppInfo.isNfilterPK)
    {
        if (![AppInfo loadPublicKeyForNFilter])
        {
            [self.targetViewController.contentScrollView setContentOffset:CGPointZero animated:YES];
            return NO;
        }
    }
    
    [self textFieldDidBeginEditing:textField];
    if (self.parentTextField.keyboardType == 0)
    {
        [self showKeypadForNum];
    }else
    {
        [self showKeypad];
    }
    //[self textFieldDidBeginEditing:textField];
    return NO;
}

#pragma mark - nFilter

/*--------------------------------------------------------------------------------------
 엔필터 '이전' 버튼 눌렀을 때 발생하는 콜백함수
 ---------------------------------------------------------------------------------------*/
//- (void)onPrevNFilter:(NSString*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
- (void)onPrevNFilter:(NSData*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
{
    
    int leftCapWidth;
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
    float imageWidth = tmpImage.size.width;
    
    if (parentTextField.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (parentTextField.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        //leftCapWidth = ((parentTextField.bounds.size.width / 2) - 1);
        leftCapWidth = 3;
    }
    
    [parentTextField setBackground:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
//    NSLog(@"이전버튼 눌림");
//    NSLog(@"태그: %@", pTagName);
//    NSLog(@"평문: %@", pPlainText);
//    NSLog(@"암호: %@", pEncText);
    //if (pPlainText == nil) pPlainText = @"";
    if (pEncText == nil) pEncText = @"";
    
    //보안지적사항 수정
//    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(onPreviousClick:encText:)])
//    {
//        [self.delegate onPreviousClick:pPlainText encText:pEncText];
//    }
    
    //EccEncryptor *ec = [EccEncryptor sharedInstance];
    //NSString *vudansqhrghghk = [ec makeDecNoPadWithSeedkey:pPlainText];
    
//    NSLog(@"복호화된 평문 %@", vudansqhrghghk);
    
    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(onPreviousClick:encText:)])
    {
        //[self.delegate onPreviousClick:pPlainText encText:pEncText];
        [self.delegate onPreviousClick:pPlainText encText:pEncText];
    }
    
    AppInfo.isSecurityKeyClose = YES;
    vcChar = nil;[vcChar release];
    vcNum = nil;[vcNum release];
    vcFlag = nil;
    if (orientionFlag == 3 || orientionFlag == 4)
    {
        
        //[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIDeviceOrientationPortrait];
        //[UIApplication sharedApplication].us;
        [self forceRotate];
    }
    
}

/*--------------------------------------------------------------------------------------
 엔필터 '다음' 버튼 눌렀을 때 발생하는 콜백함수
 ---------------------------------------------------------------------------------------*/
//- (void)onNextNFilter:(NSString*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
- (void)onNextNFilter:(NSData*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
{
    
    int leftCapWidth;
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
    float imageWidth = tmpImage.size.width;
    
    if (parentTextField.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (parentTextField.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        //leftCapWidth = ((parentTextField.bounds.size.width / 2) - 1);
        leftCapWidth = 3;
    }
    
    [parentTextField setBackground:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
    
//    NSLog(@"다음버튼 눌림");
//    NSLog(@"태그: %@", pTagName);
//    NSLog(@"평문: %@", pPlainText);
//    NSLog(@"암호: %@", pEncText);
    //if (pPlainText == nil) pPlainText = @"";
    if (pEncText == nil) pEncText = @"";
    
    //보안지적사항 수정
//    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(onNextClick:encText:)])
//    {
//        [self.delegate onNextClick:pPlainText encText:pEncText];
//    }
    //EccEncryptor *ec = [EccEncryptor sharedInstance];
    //NSString *vudansqhrghghk = [ec makeDecNoPadWithSeedkey:pPlainText];
    
//    NSLog(@"복호화된 평문 %@", vudansqhrghghk);
    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(onNextClick:encText:)])
    {
        [self.delegate onNextClick:pPlainText encText:pEncText];
    }
    
    AppInfo.isSecurityKeyClose = YES;
    vcChar = nil;[vcChar release];
    vcNum = nil;[vcNum release];
    vcFlag = nil;
    /*
     if (orientionFlag == 3 || orientionFlag == 4)
     {
     
     [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIDeviceOrientationPortrait];
     
     }
     */
}

/*--------------------------------------------------------------------------------------
 엔필터 '키' 버튼 눌렀을 때 발생하는 콜백함수
 ---------------------------------------------------------------------------------------*/
//- (void)onPressNFilter:(NSString*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
- (void)onPressNFilter:(NSData*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
{
//    NSLog(@"엔필터 키눌림");
//    NSLog(@"태그: %@", pTagName);
//    NSLog(@"평문: %@", pPlainText);
//    NSLog(@"암호: %@", pEncText);
    
    //보안지적사항 수정
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *eky = [ec genKey:AppInfo.nfilterPK];
    NSData *plainData = [pPlainText AES256DecryptWithKey:eky];
    NSString *tg70display = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"복호화된 평문 %@", plainText);
    
    //self.parentTextField.text = pPlainText;
    
    self.parentTextField.text = tg70display;
    //if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.delegate respondsToSelector:@selector(onPressSecureKeypad:encText:)])
    if(parentTextField.defaultDelegate.delegate && [parentTextField.defaultDelegate.targetViewController respondsToSelector:@selector(onPressSecureKeypad:encText:)])
    {
        [self.delegate onPressSecureKeypad:pPlainText encText:pEncText];
    }
    
    
}

/*--------------------------------------------------------------------------------------
 엔필터 '닫기' 버튼 눌렀을 때 발생하는 콜백함수
 ---------------------------------------------------------------------------------------*/
//- (void)onCloseNFilter:(NSString*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
- (void)onCloseNFilter:(NSData*)pPlainText encText:(NSString*)pEncText tagName:(NSString*)pTagName
{
//    NSLog(@"엔필터 닫힘");
//    NSLog(@"태그: %@", pTagName);
//    NSLog(@"평문: %@", pPlainText);
//    NSLog(@"암호: %@", pEncText);
    
    
    int leftCapWidth;
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
    float imageWidth = tmpImage.size.width;
    
    if (parentTextField.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (parentTextField.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        //leftCapWidth = ((parentTextField.bounds.size.width / 2) - 1);
        leftCapWidth = 3;
    }
    
    [parentTextField setBackground:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
    
    AppInfo.isSecurityKeyPad = NO; //가로모드 지원 여부 결정
    AppInfo.isSecurityKeyClose = YES;
    
    //[self.delegate textField:parentTextField didEncriptedVaule:pEncText];
    [self.delegate textField:parentTextField didEncriptedData:pPlainText didEncriptedVaule:pEncText];
    
    vcChar = nil;[vcChar release];
    vcNum = nil;[vcNum release];
    vcFlag = nil;
    
    if (orientionFlag == 3 || orientionFlag == 4)
    {
        
        //[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIDeviceOrientationPortrait];
        [self forceRotate];
        
    }
    
}

/*--------------------------------------------------------------------------------------
 엔필터 숫자키패드 띄우는 메소드
 ---------------------------------------------------------------------------------------*/
- (IBAction)showKeypadForNum
{
    vcNum = nil;
    vcFlag = 1;
//    if (!AppInfo.isNfilterPK)
//    {
//        [AppInfo loadPublicKeyForNFilter];
//        
//        //[self loadPublicKeyForNFilter];
//    }
    
    parentTextField.text = @"";
    
    
    [self.parentTextField resignFirstResponder];
	//Debug(@"SHOW NUM KEYPAD!!");
    
    vcNum = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
    //vcNum = [NFilterNum shared];
    //vcNum.preBtnEnabled = self.preBtnEnable;
    //vcNum.nextBtnEnabled = self.nextBtnEnable;
    /*
     #if DEBUG
     Debug(@"put num nfilterPK:%@",AppInfo.nfilterPK);
     #endif
     */
    //Debug(@"put num nfilterPK:%@",AppInfo.nfilterPK);
    [vcNum setServerPublickey:AppInfo.nfilterPK];    // nFilter 공개키 설정.
    [vcNum setCallbackMethod:self
               methodOnClose:@selector(onCloseNFilter:encText:tagName:)
                methodOnPrev:@selector(onPrevNFilter:encText:tagName:)
                methodOnNext:@selector(onNextNFilter:encText:tagName:)
               methodOnPress:@selector(onPressNFilter:encText:tagName:)];
    
    [vcNum setLengthWithTagName:@"encdata1" length:parentTextField.maximum webView:nil ];
    [vcNum setDescription:@"PASSWORD"];
    [vcNum setSupportTextFiled:YES];
    [vcNum setSupport4inch:YES];
    [vcNum setSupportBackgroundEvent:NO];
    [vcNum setSupportLandscape:YES];
    
    
    if (!AppInfo.isForceRotate && [[UIDevice currentDevice] orientation] == UIInterfaceOrientationMaskPortrait)
    {
        [vcNum setRotateToInterfaceOrientation:self.targetViewController.interfaceOrientation parentView:self.targetViewController.view];
    }else
    {
        [vcNum setRotateToInterfaceOrientation:UIInterfaceOrientationPortrait parentView:self.targetViewController.view];
    }
    
    
    
    AppInfo.isSecurityKeyPad = YES; //가로모드 지원 여부 결정
	AppInfo.isSecurityKeyClose = NO;
    
    vcNum.preBtn.enabled = self.preBtnEnable;
    vcNum.nextBtn.enabled = self.nextBtnEnable;
    
    if (!self.preBtnEnable)
    {
        
        vcNum.preBtn.alpha = 0.7;
        vcNum.preBtnLandscape.alpha = 0.7;
    }
    if (!self.nextBtnEnable)
    {
        vcNum.nextBtn.alpha = 0.7;
        vcNum.nextBtnLandscape.alpha = 0.7;
    }
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        vcNum.preBtn.hidden = YES;
        vcNum.nextBtn.hidden = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, vcNum.doneBtn);
        
    }
}

/*--------------------------------------------------------------------------------------
 엔필터 문자키패드 띄우는 메소드
 ---------------------------------------------------------------------------------------*/
- (IBAction)showKeypad
{
    vcChar = nil;
    vcFlag = 2;
//    if (!AppInfo.isNfilterPK)
//    {
//        [AppInfo loadPublicKeyForNFilter];
//        
//        //[self loadPublicKeyForNFilter];
//    }
    parentTextField.text = @"";
    
    //    [UIView animateWithDuration:0.3f animations:^(void) {
    //
    //        [targetViewController.view setFrame:CGRectMake(targetViewController.view.frame.origin.x, targetViewController.view.frame.origin.y - 100, targetViewController.view.frame.size.width, targetViewController.view.frame.size.height)];
    //
    //    }];
    [self.parentTextField resignFirstResponder];
    
    /*
     NSLog(@"SHOW CHR KEYPAD!!");
     #if DEBUG
     NSLog(@"put chr nfilterPK:%@",AppInfo.nfilterPK);
     #endif
     */
    //NSLog(@"put chr nfilterPK:%@",AppInfo.nfilterPK);
    vcChar = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
    //vcChar = [NFilterChar shared];
    [vcChar setServerPublickey:AppInfo.nfilterPK];    // nFilter 공개키 설정.
    [vcChar setCallbackMethod:self
                methodOnClose:@selector(onCloseNFilter:encText:tagName:)
                 methodOnPrev:@selector(onPrevNFilter:encText:tagName:)
                 methodOnNext:@selector(onNextNFilter:encText:tagName:)
                methodOnPress:@selector(onPressNFilter:encText:tagName:)];
    [vcChar setDescription:@"PASSWORD"];
    
    [vcChar setLengthWithTagName:@"encdata2" length:parentTextField.maximum webView:nil ];
    [vcChar setSecurityField:YES];
    [vcChar setSupportCapslock:NO];
    [vcChar setSupport4inch:YES];
    [vcChar setSupportBackgroundEvent:NO];
    [vcChar setSupport4inch:YES];
    [vcChar setSupportLandscape:YES];
    
    
    if (!AppInfo.isForceRotate && [[UIDevice currentDevice] orientation] == UIInterfaceOrientationMaskPortrait)
    {
        [vcChar setRotateToInterfaceOrientation:self.targetViewController.interfaceOrientation parentView:self.targetViewController.view];
    } else
    {
        [vcChar setRotateToInterfaceOrientation:UIInterfaceOrientationPortrait parentView:self.targetViewController.view];
    }
    
    
    AppInfo.isSecurityKeyPad = YES; //가로모드 지원 여부 결정
    AppInfo.isSecurityKeyClose = NO;
    vcChar.preBtn.enabled = self.preBtnEnable;
    vcChar.nextBtn.enabled = self.nextBtnEnable;
    
    if (!self.preBtnEnable)
    {
        vcChar.preBtn.alpha = 0.7;
        vcChar.preBtnLandscape.alpha = 0.7;
    }
    if (!self.nextBtnEnable)
    {
        vcChar.nextBtn.alpha = 0.7;
        vcChar.nextBtnLandscape.alpha = 0.7;
    }
    //[vcChar clearField];
    //[vcChar enableAccButtons:preBtnEnable Next:NextBtnEnable];
    
    Debug(@"certProcessType:%i",AppInfo.certProcessType);
    //로그인 화면이라면...
    if (AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeCopyPC || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign || (AppInfo.certProcessType == CertProcessTypeInFotterLogin && !AppInfo.isLoginView) || AppInfo.certProcessType == CertProcessTypeSign || AppInfo.certProcessType ==CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure || AppInfo.certProcessType == CertProcessTypeIssueLogin)
    {
        vcChar.preBtn.hidden = YES;
        vcChar.nextBtn.hidden = YES;
        
        //vcChar.preBtnLandscape.hidden = YES;
        //vcChar.nextBtnLandscape.hidden = YES;
        
        vcChar.closeBtn.hidden = NO;
        //vcChar.closeBtnLandscape.hidden = NO;
        //[vcChar.doneBtn setTitle:@"로그인" forState:UIControlStateNormal];
        [vcChar.closeBtn setTitle:@"닫기" forState:UIControlStateNormal];
        //[vcChar.closeBtnLandscape setTitle:@"닫기" forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"loginClose" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forcerotateViewSet) name:@"forcerotateView" object:nil];
    }
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        //vcNum.preBtn.hidden = YES;
        //vcNum.nextBtn.hidden = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, vcChar.doneBtn);
    }
}

- (void) loginClose
{
    
    int leftCapWidth;
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:BundlePath(@"textfeld_nor.png")];
    float imageWidth = tmpImage.size.width;
    
    if (parentTextField.bounds.size.width == imageWidth) { //이미지 사이즈와 버튼 사이가 같을 경우 변경 없다
        leftCapWidth = 0;
        
    } else if (parentTextField.bounds.size.width > tmpImage.size.width) { //버튼 사이즈가 이미지 사이즈보다 클때
        leftCapWidth = ((imageWidth / 2) - 1);
        
    }  else { //버튼 사이즈가 이미지 사이즈보다  작을때
        
        //leftCapWidth = ((parentTextField.bounds.size.width / 2) - 1);
        leftCapWidth = 3;
    }
    
    [parentTextField setBackground:[tmpImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0]];
    //parentTextField.text = @"";
    
    AppInfo.isSecurityKeyClose = YES;
    
    if (orientionFlag == 3 || orientionFlag == 4)
    {
        
        //[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIDeviceOrientationPortrait];
        [self forceRotate];
        
    }
    vcNum = nil; [vcNum release];
    vcChar = nil; [vcChar release];
    vcFlag = nil;
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        vcChar.preBtn.hidden = YES;
        vcChar.nextBtn.hidden = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, vcNum.doneBtn);
    }
}


- (void)loadPublicKeyForNFilter
{
    #ifdef DEVELOPER_MODE
    [LPStopwatch start:@"nFilter 퍼블릭키 로드"];
    #endif
    NSString *nfilterPKURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, NFILTER_PK_URL];
    
    NSURL *theURL = [NSURL URLWithString:nfilterPKURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    
    NSString *httpBody = @"";
    [request setHTTPMethod:OFHTTPMethodPOST];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
    [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
    
    [HTTPClient requestBlockED:request obj:self];
}

- (void)client: (OFHTTPClient *) aClient didReceiveData:(NSData *)data
{
    
    // 데이터를 수신하지 못했을 경우...
    if (nil == data)
    {
        
        Debug(@"\n------------------------------------------------------------------\
              \nnfilterPK 값얻기 실패\
              \n------------------------------------------------------------------");
        
        AppInfo.isNfilterPK = NO;
        
        NSString *msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:40000 title:@"" message:msg];
        
        
        return;
    }
    
    NSError *error = nil;
    TBXML *tbxml = [[TBXML newTBXMLWithXMLData:data error:&error] autorelease];
    
    if (tbxml.rootXMLElement)
        AppInfo.nfilterPK = [TBXML textForElement:tbxml.rootXMLElement->firstChild];
    
    if (AppInfo.nfilterPK == nil || [AppInfo.nfilterPK length] == 0)
    {
        Debug(@"\n------------------------------------------------------------------\
              \nnfilterPK 값얻기 실패\
              \n------------------------------------------------------------------");
        
        AppInfo.isNfilterPK = NO;
        
        NSString *msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:40000 title:@"" message:msg];
        
        
        return;
    }
    AppInfo.isNfilterPK = YES;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Debug(@"\n------------------------------------------------------------------\
          \nnfilterPK 값:%@\
          \n------------------------------------------------------------------", AppInfo.nfilterPK);
    
    //NSLog(@"nfilterPK 길이:%i",[AppInfo.nfilterPK length]);
    // 스탑와치 중지.
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"nFilter 퍼블릭키 로드"];
    #endif
    if (vcFlag == 1)
    {
        //[self showKeypadForNum];
        [vcNum setServerPublickey:AppInfo.nfilterPK];    // nFilter 공개키 설정.
    }else if (vcFlag == 2)
    {
        //[self showKeypad];
        [vcChar setServerPublickey:AppInfo.nfilterPK];
    }
}

#pragma mark - 얼럿뷰 델리게이트
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 40000)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
    }
}
@end
