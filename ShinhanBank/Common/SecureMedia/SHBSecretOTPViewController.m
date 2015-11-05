//
//  SHBSecretOTPViewController.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 10. 28..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBSecretOTPViewController.h"
#import "SHBSecureService.h"

@interface SHBSecretOTPViewController ()
{
    NSString *encryptedKeyChar, *encryptedOTPNum;
    int mediaType;
    float textFieldYpos;
    int baseTouchTextField;
}
- (void)scrollMainView:(float)posY;
@end

@implementation SHBSecretOTPViewController

@synthesize pwTextField;
@synthesize otpTextField;
@synthesize targetViewController;
@synthesize indexCurrentField;
@synthesize selfPosY;
@synthesize okButton;
@synthesize cancelButton;
@synthesize nextSVC;

- (void) dealloc
{
    [nextSVC release];
    pwTextField = nil; [pwTextField release];
    otpTextField = nil; [otpTextField release];
    [_bottomView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)adjuestView
{
    // release 처리
    UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
    [self.pwTextField addGestureRecognizer:tapGesture1];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.numberOfTouchesRequired = 1;
    
    // release 처리
    UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otpTexttapGestureEvent:)] autorelease];
    [self.otpTextField addGestureRecognizer:tapGesture2];
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.numberOfTouchesRequired = 1;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    startTextFieldTag = 10;
    endTextFieldTag = 11;
    
    [self navigationViewHidden];
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        if (self.targetViewController.contentScrollView.frame.origin.y > 80.0f)
//        {
//            [self.targetViewController.contentScrollView setFrame:CGRectMake(self.targetViewController.contentScrollView.frame.origin.x, self.targetViewController.contentScrollView.frame.origin.y - 20, self.targetViewController.contentScrollView.frame.size.width, self.targetViewController.contentScrollView.frame.size.height + 20)];
//        }
//    }
    
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    //{
        //4월말 올릴버젼에 테스트 후 주석 풀어야 함
        [self performSelector:@selector(adjuestView) withObject:nil afterDelay:0.1];
        
    //}
    
    // release 처리
    UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
    [self.pwTextField addGestureRecognizer:tapGesture1];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.numberOfTouchesRequired = 1;
    
    // release 처리
    UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otpTexttapGestureEvent:)] autorelease];
    [self.otpTextField addGestureRecognizer:tapGesture2];
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.numberOfTouchesRequired = 1;
    
    //이체비밀번호
    [pwTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:targetViewController maximum:8];
    
    //otp
    [otpTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:targetViewController maximum:6];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmSecretOTPNumber {
    
    NSString *msg;
    if(pwTextField.text == nil || [pwTextField.text length] < 6 || [pwTextField.text length] > 8)
	{
        
        msg = @"이체비밀번호는 6~8자리로\n입력해야 합니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
	}
    
    if(otpTextField.text == nil || [otpTextField.text length] != 6)
	{
		
		msg = @"[OTP번호 확인] - 입력값이 유효하지 않습니다.(6자리입력)";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
		
	}
    
    if ([self.nextSVC length] == 0 || self.nextSVC == nil)
    {
        self.nextSVC = @"";
    }
    
    // release 처리
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"OTP카드암호" : encryptedOTPNum,
                                @"이체비밀번호" : encryptedKeyChar,
                                @"prevProtocol" : @"C2099",
                                @"NEXT_SVC_CODE" : self.nextSVC,
                                }] autorelease];
    self.service = nil;
    self.service = [[[SHBSecureService alloc] initWithServiceId:SECURE_OTP viewController:self] autorelease];
    
    self.service.previousData = forwardData;
    
    [self.service start];
    
    pwTextField.text = @"";
    otpTextField.text = @"";
}

- (IBAction) cancelSecretMedia
{
    [self.delegate cancelSecretMedia];
}

- (void) returnResult:(OFDataSet *)resultData {
    
    BOOL isConfirm;
    
    if (AppInfo.errorType != nil) { //에러발생시
        isConfirm = NO;
        pwTextField.text = @"";
        otpTextField.text = @"";
        
    } else {
        isConfirm = YES;
    }
    
    if (isConfirm == YES) { //매체정보 확인일때만 델리게이트로 넘겨준다.
        [self.delegate confirmSecretMedia:resultData result:isConfirm media:5];
    }
    
}

- (BOOL) onParse: (OFDataSet*) aDataSet string: (NSData*) aContent
{
    
    [self returnResult:aDataSet];
    return NO;
}


- (void) pwTexttapGestureEvent:(UITapGestureRecognizer *) sender
{
    
    CGPoint myLocation;
    BOOL isSetYPos;
    
    if (self.selfPosY >= 0)
    {
        isSetYPos = YES;
        myLocation = CGPointMake(0, self.selfPosY);
    } else
    {
        isSetYPos = NO;
        myLocation = [sender locationInView:self.targetViewController.view];
    }
    
    float rectY = 0;
    if (AppInfo.isiPhoneFive)
    {
        if (isSetYPos)
        {
            rectY = 456 - 280;
        } else
        {
            rectY = 504 - 280;
        }
        
    } else
    {
        if (isSetYPos)
        {
            rectY = 366 - 280;
        } else
        {
            rectY = 416 - 280;
        }
        
    }
    
    //recty 범위안에 있으면 키패드를 올리지 않는다.
    if (rectY >= myLocation.y && myLocation.y >= 0)
    {
        
    } else
    {
        //scrollY 값만큼 스크롤한다
        float scrollY;
        if (isSetYPos)
        {
            if (myLocation.y < 0) myLocation.y = -(myLocation.y);
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                scrollY = (myLocation.y - (rectY - 20));
            }else
            {
                scrollY = (myLocation.y - rectY);
            }
            
        } else
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                scrollY = (myLocation.y - (rectY - 20)) - (self.pwTextField.frame.size.height / 2);
            }else
            {
                scrollY = (myLocation.y - rectY) - (self.pwTextField.frame.size.height / 2);
            }
            
        }
        
        
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        textFieldYpos = scrollY;
    }
    baseTouchTextField = 10;
    [pwTextField becomeFirstResponder];
    indexCurrentField = 10;
    
    [self.pwTextField enableAccButtons:NO Next:YES];
    
    if (_prevTF) {
        
        [self.pwTextField enableAccButtons:YES Next:YES];
    }
}

- (void) otpTexttapGestureEvent:(UITapGestureRecognizer *) sender
{
    
    CGPoint myLocation;
    BOOL isSetYPos;
    
    if (self.selfPosY >= 0)
    {
        isSetYPos = YES;
        myLocation = CGPointMake(0, (self.selfPosY + 85));
    } else
    {
        isSetYPos = NO;
        myLocation = [sender locationInView:self.targetViewController.view];
    }
    
    float rectY = 0;
    if (AppInfo.isiPhoneFive)
    {
        
        rectY = 504 - 260;
        
    } else
    {
        
        rectY = 416 - 260;
    }
    
    //recty 범위안에 있으면 키패드를 올리지 않는다.
    if (rectY >= myLocation.y && myLocation.y >= 0)
    {
        
    } else
    {
        //scrollY 값만큼 스크롤한다
        float scrollY;
        if (isSetYPos)
        {
            if (myLocation.y < 0) myLocation.y = -(myLocation.y);
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                scrollY = (myLocation.y - (rectY - 20));
            }else
            {
                scrollY = (myLocation.y - rectY);
            }
            
            if (scrollY < 0) scrollY = -(scrollY);
            
        } else
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                scrollY = (myLocation.y - (rectY - 20)) - (self.pwTextField.frame.size.height / 2);
            }else
            {
                scrollY = (myLocation.y - rectY) - (self.pwTextField.frame.size.height / 2);
            }
            
        }
        
        
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        textFieldYpos = scrollY;
    }
    baseTouchTextField = 11;
    [self.otpTextField becomeFirstResponder];
    indexCurrentField = 11;
    
    [self.otpTextField enableAccButtons:YES Next:NO];
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    
    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, textFieldYpos)];
    //textFieldYpos = 0;
    
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    if (textField.tag == 10) {
        encryptedKeyChar = [[NSString alloc] initWithFormat:@"<E2K_CHAR=%@>",value];
    } else if (textField.tag == 11) {
        encryptedOTPNum = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",value];
    } else {
        
    }
    
//    if (self.targetViewController.contentScrollView.contentSize.height > self.targetViewController.contentScrollView.frame.size.height) {
//        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0,
//                                                                                  self.targetViewController.contentScrollView.contentSize.height - self.targetViewController.contentScrollView.frame.size.height)
//                                                             animated:YES];
//    }
//    else {
//        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
    
    if (self.targetViewController.contentScrollView.contentSize.height > self.targetViewController.contentScrollView.frame.size.height) {
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            AppInfo.scrollBlock = YES;
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0,
                                                                                      self.targetViewController.contentScrollView.contentSize.height - self.targetViewController.contentScrollView.frame.size.height - 20)
                                                                 animated:YES];
        }else
        {
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0,
                                                                                      self.targetViewController.contentScrollView.contentSize.height - self.targetViewController.contentScrollView.frame.size.height)
                                                                 animated:YES];
        }
    }
    else {
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            AppInfo.scrollBlock = YES;
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, -20) animated:YES];
            
        }else
        {
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"secureMediaKeyPadClose" object:nil];
}

- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField
{
    
    
    //[super secureTextFieldDidBeginEditing:textField];
    if (textField == pwTextField)
    {
        // release 처리
        UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
        [self.pwTextField addGestureRecognizer:tapGesture1];
        tapGesture1.numberOfTapsRequired = 1;
        tapGesture1.numberOfTouchesRequired = 1;
        indexCurrentField = 10;
        [self.pwTextField enableAccButtons:NO Next:YES];
        
        if (_prevTF) {
            
            [self.pwTextField enableAccButtons:YES Next:YES];
        }
    }
    
    if (textField == otpTextField)
    {
        
        // release 처리
        UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otpTexttapGestureEvent:)] autorelease];
        [self.otpTextField addGestureRecognizer:tapGesture2];
        tapGesture2.numberOfTapsRequired = 1;
        tapGesture2.numberOfTouchesRequired = 1;
        indexCurrentField = 11;
        [self.otpTextField enableAccButtons:YES Next:NO];
    }
}
//이전 버튼 클릭
- (void)onPreviousClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    //NSLog(@"previous");
    if (indexCurrentField == 11)
    {
        encryptedOTPNum = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",pEncText];
        [self.otpTextField closeSecureKeyPad];
        [self.pwTextField becomeFirstResponder];
        [self.pwTextField enableAccButtons:NO Next:YES];	// 이전,다음버튼 (비)활성
        
        if (_prevTF) {
            
            [self.pwTextField enableAccButtons:YES Next:YES];
        }
        
        float scrollY = 0;
        if (baseTouchTextField == 10)
        {
            scrollY = textFieldYpos;
        }
        
        if (baseTouchTextField == 11)
        {
            scrollY = textFieldYpos - 15;
        }
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
    }
    else if (_prevTF && indexCurrentField == 10) {
        
        [self.pwTextField closeSecureKeyPad];
        [_prevTF becomeFirstResponder];
    }
}

//다음 버튼 클릭
- (void)onNextClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    //NSLog(@"next");
    if (indexCurrentField == 10)
    {
        encryptedKeyChar = [[NSString alloc] initWithFormat:@"<E2K_CHAR=%@>",pEncText];
        [self.pwTextField closeSecureKeyPad];
        [self.otpTextField becomeFirstResponder];
        [self.otpTextField enableAccButtons:YES Next:NO];
        
        float scrollY = 0;
        if (baseTouchTextField == 10)
        {
            scrollY = textFieldYpos + 20;
        }
        
        if (baseTouchTextField == 11)
        {
            scrollY = textFieldYpos;
        }
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
    }
}
//
//- (void)didGetToMaxmum
//{
//    // 필요하면 구현...
//    NSLog(@"showSecureKeyPad");
//}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"subview didRotateFromInterfaceOrientation:%i",fromInterfaceOrientation);
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"rotateView" object:nil];
}

- (void)scrollMainView:(float)posY{
	//animation set
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self.targetViewController.contentScrollView];
	
	//scroll set
	[self.targetViewController.contentScrollView setFrame:CGRectMake(0, 44 + posY, self.targetViewController.contentScrollView.frame.size.width, self.targetViewController.contentScrollView.frame.size.height)];
	
	//animation run
	[UIView commitAnimations];
	
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다. sample
- (void) getElectronicSignCancel
{
    
    self.pwTextField.text = @"";
    self.otpTextField.text = @"";
    
}

- (void)viewDidUnload {
    [self setBottomView:nil];
    [super viewDidUnload];
}
@end
