//
//  SHBSecretCardViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 22..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBSecretCardViewController.h"
#import "SHBSecureService.h"
#import "Encryption.h"

@interface SHBSecretCardViewController ()
{
    NSString *encryptedKeyChar, *encryptedKeynum1, *encryptedKeynum2;
    int mediaType;
    int baseTouchTextField;
    float textFieldYpos;
}
- (void)scrollMainView:(float)posY;
@end

@implementation SHBSecretCardViewController

@synthesize frontLabel;
@synthesize frontNumberLabel;
@synthesize backLabel;
@synthesize backNumberLabel;
@synthesize pwTextField;
@synthesize frontNumTextField;
@synthesize backNumTextField;
@synthesize targetViewController;
@synthesize mark1ImageView;
@synthesize mark2ImageView;
@synthesize indexCurrentField;
@synthesize selfPosY;
@synthesize okButton;
@synthesize cancelButton;
@synthesize nextSVC;

- (void) dealloc
{
    [nextSVC release];
    [mark2ImageView release];
    [mark1ImageView release];
    frontLabel = nil; [frontLabel release];
    frontNumberLabel = nil; [frontNumberLabel release];
    backLabel = nil; [backLabel release];
    backNumberLabel = nil; [backNumberLabel release];
    pwTextField = nil; [pwTextField release];
    frontNumTextField = nil; [frontNumTextField release];
    backNumTextField = nil; [backNumTextField release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[_bottomView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selfPosY = -1;
    }
    return self;
}

- (void)adjuestView
{
    UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
    [self.pwTextField addGestureRecognizer:tapGesture1];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontTexttapGestureEvent:)] autorelease];
    [self.frontNumTextField addGestureRecognizer:tapGesture2];
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapGesture3 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTexttapGestureEvent:)] autorelease];
    [self.backNumTextField addGestureRecognizer:tapGesture3];
    tapGesture3.numberOfTapsRequired = 1;
    tapGesture3.numberOfTouchesRequired = 1;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height)];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self navigationViewHidden];
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        if (self.targetViewController.contentScrollView.frame.origin.y > 80.0f)
//        {
//            [self.targetViewController.contentScrollView setFrame:CGRectMake(self.targetViewController.contentScrollView.frame.origin.x, self.targetViewController.contentScrollView.frame.origin.y - 20, self.targetViewController.contentScrollView.frame.size.width, self.targetViewController.contentScrollView.frame.size.height + 20)];
//        }
//    }
    //장차법 대응
    
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    //{
        //4월말 올릴버젼에 테스트 후 주석 풀어야 함
        [self performSelector:@selector(adjuestView) withObject:nil afterDelay:0.1];
    //}
    
    NSLog(@"pv Y:%f",self.targetViewController.contentScrollView.frame.origin.y);
    NSLog(@"selfPosY:%i",self.selfPosY);
    
    startTextFieldTag = 10;
    endTextFieldTag = 12;
    
    UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
    [self.pwTextField addGestureRecognizer:tapGesture1];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontTexttapGestureEvent:)] autorelease];
    [self.frontNumTextField addGestureRecognizer:tapGesture2];
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapGesture3 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTexttapGestureEvent:)] autorelease];
    [self.backNumTextField addGestureRecognizer:tapGesture3];
    tapGesture3.numberOfTapsRequired = 1;
    tapGesture3.numberOfTouchesRequired = 1;
    
    //이체비밀번호
    [pwTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:targetViewController maximum:8];
    
    //앞의 두자리 보안카드
    [frontNumTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:targetViewController maximum:2];
    
    //뒤의 두자리 보안카드
    [backNumTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:targetViewController maximum:2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSecureCardNumber) name:@"changeSecureCard" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setMediaCode:(int)code previousData:(SHBDataSet *)aDataSet
{
    
    if (code == 1) {
        frontLabel.text = @"세자리 중";
        backLabel.text = @"세자리 중";
        mark1ImageView.hidden = YES;
        mark2ImageView.hidden = YES;
        [backNumTextField setFrame:CGRectMake(mark2ImageView.frame.origin.x + 2, backNumTextField.frame.origin.y, backNumTextField.bounds.size.width, backNumTextField.bounds.size.height)];
        
    } else {
        frontLabel.text = @"네자리 중";
        backLabel.text = @"네자리 중";
        
        
    }
    Encryption *decryptor = [[Encryption alloc] init];
    //frontNumberLabel.text = AppInfo.secretChar1;
    //backNumberLabel.text = AppInfo.secretChar2;
    frontNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar1];
    backNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar2];
    mediaType = code;
    [decryptor release];
    
    self.frontNumberLabel.accessibilityLabel = [NSString stringWithFormat:@"%@앞두자리 %@",frontLabel.text,frontNumberLabel.text];
    self.frontNumTextField.accessibilityLabel = [NSString stringWithFormat:@"%@앞두자리 %@ 입력",frontLabel.text,frontNumberLabel.text];
    self.backNumberLabel.accessibilityLabel = [NSString stringWithFormat:@"%@뒤두자리 %@",backLabel.text,backNumberLabel.text];
    self.backNumTextField.accessibilityLabel = [NSString stringWithFormat:@"%@뒤두자리 %@ 입력",backLabel.text,backNumberLabel.text];
}

- (IBAction) confirmSecretCardNumber {
    
    NSString *msg;
    if(pwTextField.text == nil || [pwTextField.text length] < 6 || [pwTextField.text length] > 8)
	{
        
        msg = @"이체비밀번호는 6~8자리로\n입력해야 합니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
	}
    
    if(frontNumTextField.text == nil || [frontNumTextField.text length] != 2)
	{
		
		msg = @"보안카드 첫번째 앞 두자리 값을 입력하여 주십시오.(2자리입력)";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"입력오류" message:msg];
		return;
		
	}
    
    if(frontNumTextField.text == nil || [backNumTextField.text length] != 2)
	{
		
		msg = @"보안카드 두번째 뒤 두자리 값을 입력하여 주십시오.(2자리입력)";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"입력오류" message:msg];
		return;
		
	}
    
    if ([self.nextSVC length] == 0 || self.nextSVC == nil)
    {
        self.nextSVC = @"";
    }
    
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                               @"보안카드암호1" : encryptedKeynum1,
                               @"보안카드암호2" : encryptedKeynum2,
                               @"이체비밀번호" : encryptedKeyChar,
                               @"prevProtocol" : @"C2098",
                               @"NEXT_SVC_CODE" : self.nextSVC,
                               }] autorelease];
    self.service = nil;
    self.service = [[[SHBSecureService alloc] initWithServiceId:SECURE_CARD viewController:self] autorelease];
    
    self.service.previousData = forwardData;
    
    [self.service start];
    
    pwTextField.text = @"";
    frontNumTextField.text = @"";
    backNumTextField.text = @"";
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
        frontNumTextField.text = @"";
        backNumTextField.text = @"";
    } else {
        isConfirm = YES;
    }
    //NSLog(@"aDataSet:%@",resultData);
    
    if (isConfirm == YES) { //매체정보 확인일때만 델리게이트로 넘겨준다.
        [self.delegate confirmSecretMedia:resultData result:isConfirm media:(int)mediaType];
    }
    
}

- (BOOL) onGenerate: (NSString*) aString dataSet: (OFDataSet *) aDataSet
{
    
    return YES;
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
    NSLog(@"myLocation.y:%f",myLocation.y);
    NSLog(@"rectY:%f",rectY);
    //recty 범위안에 있으면 키패드를 올리지 않는다.
    if (rectY >= myLocation.y && myLocation.y >= 0)
    {
        textFieldYpos = myLocation.y;
        
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
        
        NSLog(@"scrollY:%f",scrollY);
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        textFieldYpos = scrollY;
    }
    
    [pwTextField becomeFirstResponder];
    indexCurrentField = 10;
    baseTouchTextField = 10;
    
    if (_prevTF) {
        
        [self.pwTextField enableAccButtons:YES Next:YES];
    }
    else {
        
        [self.pwTextField enableAccButtons:NO Next:YES];
    }
}

- (void) frontTexttapGestureEvent:(UITapGestureRecognizer *) sender
{
    CGPoint myLocation;
    BOOL isSetYPos;
    
    
    if (self.selfPosY >= 0)
    {
        isSetYPos = YES;
        myLocation = CGPointMake(0, (self.selfPosY + 130));
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
    NSLog(@"myLocation.y:%f",myLocation.y);
    NSLog(@"rectY:%f",rectY);
    //recty 범위안에 있으면 키패드를 올리지 않는다.
    if (rectY >= myLocation.y && myLocation.y >= 0)
    {
        textFieldYpos = myLocation.y;
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
        
        NSLog(@"scrollY:%f",scrollY);
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        textFieldYpos = scrollY;
    }
    
    [self.frontNumTextField becomeFirstResponder];
    indexCurrentField = 11;
    baseTouchTextField = 11;
    [self.frontNumTextField enableAccButtons:YES Next:YES];
}

- (void) backTexttapGestureEvent:(UITapGestureRecognizer *) sender
{
    CGPoint myLocation;
    BOOL isSetYPos;
    
    if (self.selfPosY >= 0)
    {
        isSetYPos = YES;
        myLocation = CGPointMake(0, (self.selfPosY + 180));
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
    NSLog(@"myLocation.y:%f",myLocation.y);
    NSLog(@"rectY:%f",rectY);
    //recty 범위안에 있으면 키패드를 올리지 않는다.
    if (rectY >= myLocation.y && myLocation.y >= 0)
    {
        textFieldYpos = myLocation.y;
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
        
        NSLog(@"scrollY:%f",scrollY);
        if (myLocation.y <= 180 )
        {
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY + 24)];
        }else
        {
            [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        }
        
        textFieldYpos = scrollY;
    }
    
    [self.backNumTextField becomeFirstResponder];
    indexCurrentField = 12;
    baseTouchTextField = 12;
    [self.backNumTextField enableAccButtons:YES Next:NO];
}

#pragma mark - SHBSecureDelegate

#pragma mark - Scroll Delegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, textFieldYpos)];
    //textFieldYpos = 0;
    
    //[self scrollMainView:0];
    AppInfo.isLandScapeKeyPadBolck = NO;
    if (textField.tag == 10) {
        encryptedKeyChar = [[NSString alloc] initWithFormat:@"<E2K_CHAR=%@>",value];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UILabel *nv = (UILabel *)[self.view viewWithTag:1234];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nv);
            
        }
    } else if (textField.tag == 11) {
        encryptedKeynum1 = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",value];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.backNumberLabel);
            
        }
    } else if (textField.tag == 12) {
        encryptedKeynum2 = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",value];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.okButton);
            
        }
    } else {
        
    }
    
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
    
    if (textField == self.pwTextField)
    {
        AppInfo.isLandScapeKeyPadBolck = NO;
        UITapGestureRecognizer *tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwTexttapGestureEvent:)] autorelease];
        [self.pwTextField addGestureRecognizer:tapGesture1];
        tapGesture1.numberOfTapsRequired = 1;
        tapGesture1.numberOfTouchesRequired = 1;
        indexCurrentField = 10;
        
        if (_prevTF) {
            
            [self.pwTextField enableAccButtons:YES Next:YES];
        }
        else {
            
            [self.pwTextField enableAccButtons:NO Next:YES];
        }
    }
    
    if (textField == self.frontNumTextField)
    {
        AppInfo.isLandScapeKeyPadBolck = YES;
        UITapGestureRecognizer *tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontTexttapGestureEvent:)] autorelease];
        [self.frontNumTextField addGestureRecognizer:tapGesture2];
        tapGesture2.numberOfTapsRequired = 1;
        tapGesture2.numberOfTouchesRequired = 1;
        indexCurrentField = 11;
        [self.frontNumTextField enableAccButtons:YES Next:YES];
    }
    
    if (textField == self.backNumTextField)
    {
        AppInfo.isLandScapeKeyPadBolck = YES;
        UITapGestureRecognizer *tapGesture3 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTexttapGestureEvent:)] autorelease];
        [self.backNumTextField addGestureRecognizer:tapGesture3];
        tapGesture3.numberOfTapsRequired = 1;
        tapGesture3.numberOfTouchesRequired = 1;
        indexCurrentField = 12;
        [self.backNumTextField enableAccButtons:YES Next:NO];
    }
}

//이전 버튼 클릭
- (void)onPreviousClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    //NSLog(@"previous");
    BOOL isMoveBlock = NO;
    float scrollY = 0;
    if (indexCurrentField == 12 && isMoveBlock == NO)
    {
        encryptedKeynum2 = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",pEncText];
        [self.backNumTextField closeSecureKeyPad];
        //키패드 이동 //
        NSLog(@"textFieldYpos:%f",textFieldYpos);

        
        CGRect textFieldRect = [self.frontNumTextField convertRect:self.frontNumTextField.bounds toView:self.targetViewController.contentScrollView];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            scrollY = textFieldRect.origin.y;
        }else
        {
            scrollY = textFieldRect.origin.y;
        }
        
        NSLog(@"scrollY:%f",scrollY);
        
        float rectY = 0;
        if (AppInfo.isiPhoneFive)
        {
            rectY = 504 - 260;
            
        } else
        {
            
            rectY = 416 - 260;
        }
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 190)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
            }
            
        }else
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 170)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
            }
            
        }
        ///////////
        isMoveBlock = YES;
        AppInfo.isLandScapeKeyPadBolck = YES;
        [self.frontNumTextField becomeFirstResponder];
        [self.frontNumTextField enableAccButtons:YES Next:YES];	// 이전,다음버튼 (비)활성
    }
    if (indexCurrentField == 11 && isMoveBlock == NO)
    {
        encryptedKeynum1 = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",pEncText];
        [self.frontNumTextField closeSecureKeyPad];
        
        //키패드 이동 //
        NSLog(@"textFieldYpos:%f",textFieldYpos);
        [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY)];
        

        
        CGRect textFieldRect = [self.pwTextField convertRect:self.pwTextField.bounds toView:self.targetViewController.contentScrollView];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            scrollY = textFieldRect.origin.y;
        }else
        {
            scrollY = textFieldRect.origin.y;
        }
        
        NSLog(@"scrollY:%f",scrollY);
        float rectY = 0;
        if (AppInfo.isiPhoneFive)
        {
            
            
            rectY = 504 - 260;
            
        } else
        {
            
            rectY = 416 - 260;
        }
        
        if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0,-20)];
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0,0)];
            }
        }else
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                if (AppInfo.isiPhoneFive)
                {
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 170)];
                }else
                {
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
                }
                
                
            }else
            {
                if (AppInfo.isiPhoneFive)
                {
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 150)];
                }else
                {
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 61)];
                }
                
            }
            
        }
        
        
//        isMoveBlock = YES;
        AppInfo.isLandScapeKeyPadBolck = NO;
        [self.pwTextField becomeFirstResponder];
        
        if (_prevTF) {
            
            [self.pwTextField enableAccButtons:YES Next:YES];
        }
        else {
            
            [self.pwTextField enableAccButtons:NO Next:YES];	// 이전,다음버튼 (비)활성
        }
    }
    else if (_prevTF && indexCurrentField == 10 && isMoveBlock == NO) {
        
        indexCurrentField = 9;
        
        [self.pwTextField closeSecureKeyPad];
        [_prevTF becomeFirstResponder];
    }
    
}

//다음 버튼 클릭
- (void)onNextClick:(NSString*)pPlainText encText:(NSString*)pEncText
{
    BOOL isMoveBlock = NO;
    float scrollY = 0.0;
    //NSLog(@"next");
    if (indexCurrentField == 10 && isMoveBlock == NO)
    {
        encryptedKeyChar = [[NSString alloc] initWithFormat:@"<E2K_CHAR=%@>",pEncText];
        [self.pwTextField closeSecureKeyPad];
        //키패드 이동 //
        
        NSLog(@"textFieldYpos:%f",textFieldYpos);
        
        CGRect textFieldRect = [self.frontNumTextField convertRect:self.frontNumTextField.bounds toView:self.targetViewController.contentScrollView];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            scrollY = textFieldRect.origin.y;
        }else
        {
            scrollY = textFieldRect.origin.y;
        }
        
        NSLog(@"scrollY:%f",scrollY);
        NSLog(@"selfPosY:%i",self.selfPosY);
        
        float rectY = 0;
        if (AppInfo.isiPhoneFive)
        {
            
            
            rectY = 504 - 260;
            
        } else
        {
            
            rectY = 416 - 260;
        }
        
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 190)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
            }
            
        }else
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 170)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
            }
            
        }
        ///////////
        isMoveBlock = YES;
        AppInfo.isLandScapeKeyPadBolck = YES;
        [self.frontNumTextField becomeFirstResponder];
        [self.frontNumTextField enableAccButtons:YES Next:YES];
        
    }
    
    if (indexCurrentField == 11 && isMoveBlock == NO)
    {
        encryptedKeynum1 = [[NSString alloc] initWithFormat:@"<E2K_NUM=%@>",pEncText];
        [self.frontNumTextField closeSecureKeyPad];
        
        //키패드 이동 //
        NSLog(@"textFieldYpos:%f",textFieldYpos);
        
        CGRect textFieldRect = [self.backNumTextField convertRect:self.backNumTextField.bounds toView:self.targetViewController.contentScrollView];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            scrollY = textFieldRect.origin.y;
        }else
        {
            scrollY = textFieldRect.origin.y;
        }
        
        NSLog(@"scrollY:%f",scrollY);
        float rectY = 0;
        if (AppInfo.isiPhoneFive)
        {
            
            
            rectY = 504 - 260;
            
        } else
        {
            
            rectY = 416 - 260;
        }
        
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 190)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 101)];
            }
        }else
        {
            if (AppInfo.isiPhoneFive)
            {
                if (rectY >= (scrollY + self.selfPosY) && scrollY >= 0)
                {
                    
                }else
                {
                    //[self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
                    [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 170)];
                }
            }else
            {
                [self.targetViewController.contentScrollView setContentOffset:CGPointMake(0, scrollY - 81)];
            }
            
        }
        ////////
        
//        isMoveBlock = YES;
        AppInfo.isLandScapeKeyPadBolck = YES;
        [self.backNumTextField becomeFirstResponder];
        [self.backNumTextField enableAccButtons:YES Next:NO];
    }
}

//- (void)didGetToMaxmum
//{
//    // 필요하면 구현...
//    NSLog(@"showSecureKeyPad");
//}

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

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //노티피케이션을 이용해 내가 선택되었다고 알린다
    //[[NSNotificationCenter  defaultCenter] postNotificationName:@"rotateView" object:nil];
    NSLog(@"subview didRotateFromInterfaceOrientation:%i",fromInterfaceOrientation);
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"rotateView" object:nil];
}


#pragma mark - 전자 서명 노티피케이션 정보를 받는다. sample
- (void)getElectronicSignCancel
{
    
    pwTextField.text = @"";
    frontNumTextField.text = @"";
    backNumTextField.text = @"";
    frontNumberLabel.text = AppInfo.secretChar1;
    backNumberLabel.text = AppInfo.secretChar2;
    
}
- (void)changeSecureCardNumber
{
    Encryption *decryptor = [[Encryption alloc] init];
    //번호변경에 따른 방어코드
    if (![self.frontNumberLabel.text isEqualToString:[decryptor aes128Decrypt:AppInfo.secretChar1]])
    {
        self.frontNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar1];
    }
    
    if (![self.backNumberLabel.text isEqualToString:[decryptor aes128Decrypt:AppInfo.secretChar2]])
    {
        self.backNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar2];
    }
    [decryptor release];
}
- (void)viewDidUnload {
	[self setBottomView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}
@end
