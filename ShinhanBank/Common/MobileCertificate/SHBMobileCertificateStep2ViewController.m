//
//  SHBMobileCertificateStep2ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMobileCertificateStep2ViewController.h"
#import "SHBMobileCertificateService.h"

#import "SHBDeviceRegistServiceAddConfirmViewController.h"

@interface SHBMobileCertificateStep2ViewController ()
{
    NSString *tempCertNumber;
    
    NSInteger currentRequest; // 1: 확인,  2: 재전송
}

- (void)requestMobileCert;
- (void)requestMobileCertReSend;

@end

@implementation SHBMobileCertificateStep2ViewController
@synthesize certTextField;
@synthesize subTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)navigationButtonPressed:(id)sender
{
    [super navigationButtonPressed:sender];
    
    if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
    {
        UIButton *btnSender = (UIButton*)sender;
        switch (btnSender.tag)
        {
            case NAVI_CLOSE_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
            case QUICK_HOME_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.subTitleLabel.text = @"own cell phone authentication";
    }
    
	[certTextField setAccDelegate:self];
    
    [self.contentScrollView addSubview:mainView];
    [self.contentScrollView setContentSize:mainView.frame.size];
    contentViewHeight = self.contentScrollView.contentSize.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
	[_nextViewControlName release];
	
    [mainView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [mainView release];
    mainView = nil;
    [super viewDidUnload];
}

#pragma mark - Method

- (void)executeWithTitle:(NSString*)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString*)nextCtrlName Info:(NSDictionary*)infoDic{
	
    if ([aTitle isEqualToString:@"회원가입"])
    {
        self.subTitleLabel.text = @"휴대폰 가입인증";
    }
    
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
    
	mobileDic = [infoDic copy];
	
	if (nextCtrlName) {
		SafeRelease(_nextViewControlName);
		_nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
	
	[self setTitle:aTitle];
	
	// Max 10개까지만 Step 단계표시
	if (stepCnt < 11) {
		UIButton	*stepButtn;
		
		for (int i=stepCnt; i>=1; i --) {
			// step button setting
			stepButtn = (UIButton*)[self.view viewWithTag:i];
			float stepWidth = stepButtn.frame.size.width;
			float stepX = 311 - ((stepWidth+2) * ((stepCnt+1) - i));
			[stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
			[stepButtn setHidden:NO];
			
			if (step >= i){
				stepButtn.selected = YES;
			}else{
				stepButtn.selected = NO;
			}
		}
	}
	
}

- (void)requestMobileCert
{
    currentRequest = 1;
    
    AppInfo.serviceCode = @"MOBILE_CERT";
    
    if (self.serviceSeq == SERVICE_300_OVER)
    {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"거래구분" : @"05",
                                @"인증구분" : @"04",
                                @"서비스코드" : mobileDic[@"serviceCode"],
                                @"고객번호" : AppInfo.customerNo,
                                @"인증번호" : certTextField.text,
                                @"계좌번호_상품코드" : AppInfo.transferDic[@"계좌번호_상품코드"],
                                @"거래금액" : AppInfo.transferDic[@"거래금액"],
                                @"추가이체여부" : AppInfo.transferDic[@"추가이체여부"],
                                @"추가_입금계좌번호" : AppInfo.transferDic[@"추가_입금계좌번호"],
                                }];
        
        
        SendData(SHBTRTypeServiceCode, @"C2409", SERVICE_URL, self, aDataSet);
        
    }else
    {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"구분" : mobileDic[@"separation"],
                                @"인증구분" : @"04",
                                @"서비스코드" : mobileDic[@"serviceCode"],
                                @"고객번호" : AppInfo.customerNo,
                                @"인증번호" : certTextField.text,
                                }];
        
        if (AppInfo.isLogin != 0) {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_VERIFY_URL, self, aDataSet);
        }
        else {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_VERIFY_GUEST_URL, self, aDataSet);
        }
    }
    
}

- (void)requestMobileCertReSend
{
    currentRequest = 2;
    
    AppInfo.serviceCode = @"MOBILE_CERT";
    NSLog(@"abcd:%@",AppInfo.transferDic);
    NSLog(@"efgh:%@",mobileDic);
    if (self.serviceSeq == SERVICE_300_OVER)
    {
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"업무별인증시간" : @"3",
                               @"업무별오류횟수" :@"3",
                               @"추가이체여부" : AppInfo.transferDic[@"추가이체여부"],
                               @"입금은행명" : AppInfo.transferDic[@"입금은행명"],
                               @"추가이체건수" : AppInfo.transferDic[@"추가이체건수"],
                               @"추가_입금은행코드" : AppInfo.transferDic[@"추가_입금은행코드"],
                               @"추가_입금은행명" : AppInfo.transferDic[@"추가_입금은행명"],
                               @"추가_입금계좌번호" : AppInfo.transferDic[@"추가_입금계좌번호"],
                               @"추가_입금계좌성명" : AppInfo.transferDic[@"추가_입금계좌성명"],
                               @"추가_이체금액" : AppInfo.transferDic[@"추가_이체금액"],
                               //@"구분" : [self getCodeValue:2],
                               @"휴대폰번호" : mobileDic[@"phoneNumber"],
                               @"고객번호" : AppInfo.customerNo,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               @"서비스코드" : mobileDic[@"serviceCode"],
                               @"성명" : mobileDic[@"name"],
                               }];
        
        SendData(SHBTRTypeServiceCode, @"E3029", MOBILE_CERT_300OVER_SMSARS_URL, self, dataSet);
//        SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_URL, self, dataSet);
        
    }else
    {
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"구분" : mobileDic[@"separation"],
                               @"휴대폰번호" : mobileDic[@"phoneNumber"],
                               @"고객번호" : AppInfo.customerNo,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               @"서비스코드" : mobileDic[@"serviceCode"],
                               @"성명" : mobileDic[@"name"],
                               }];
        
        if (AppInfo.isLogin != 0) {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_URL, self, dataSet);
        }
        else {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_GUEST_URL, self, dataSet);
        }
    }
    
}

#pragma mark - HTTP Delegate

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    if (self.serviceSeq != SERVICE_300_OVER)
    {
        if (![dataSet[@"result"] isEqualToString:@"0"]) {
            return;
        }
    }
    
    if (currentRequest == 1) {
        [certTextField setText:@""];
        
        //예적금 해지, SMS, ARS 모두 인증할때
        if (AppInfo.isAllIdenty)
        {
            AppInfo.isSMSIdenty = YES;
            
            if (!AppInfo.isARSIdenty)
            {
                [AppDelegate.navigationController fadePopViewController]; //모바일 스텝2
                [AppDelegate.navigationController fadePopViewController]; //모바일 스텝1
                return;
            }else
            {
                AppInfo.isAllIdentyDone = YES; //Ars  할 필요 없음
            }
            
            
        }
        
        if (_nextViewControlName){
            
            
                // 다음에 열릴 클래스 오픈
                
                SHBBaseViewController *viewController = [[[NSClassFromString(_nextViewControlName) class] alloc] initWithNibName:_nextViewControlName bundle:nil];
                
                viewController.needsLogin = NO;
                [self checkLoginBeforePushViewController:viewController animated:YES];
                [viewController release];
            
            
            
        } else {
            int objectIndex = [[AppDelegate.navigationController viewControllers] count] - 4;
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:objectIndex] viewControllerDidSelectDataWithDic:nil];
            
        }
    }
    else if (currentRequest == 2) {
        [self.certTextField setText:@""];
        
        Debug(@"인증번호 : [ %@ ]", dataSet[@"인증번호"]);

        if (!AppInfo.realServer)
        {
            if (dataSet[@"인증번호"]) {
                [self.certTextField setText:dataSet[@"인증번호"]];
            }
        }
    }
}

#pragma mark - IBActions

- (IBAction)buttonPressed:(UIButton *)sender
{
    [certTextField resignFirstResponder];
    
	if (sender.tag == 110) {
		// 확인버튼
		// 인증번호 체크
		if ([certTextField.text length] < 1 || certTextField.text == nil){
            NSString *msg;
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = @"Please enter the certification number.";
            } else if (AppInfo.LanguageProcessType == JapanLan)
            {
                msg = @"認証番号をご入力ください。";
            } else
            {
                msg = @"인증번호를 입력해 주시기 바랍니다.";
            }
            
            [UIAlertView showAlertLan:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];

			return;
		}
        
		// 인증번호 검증 통신
		[self requestMobileCert];
        
	}
    else if (sender.tag == 120) {
		// 취소버튼
		[self.navigationController fadePopViewController];
        
        if ([_delegate respondsToSelector:@selector(mobileCertificateStep2Back)])
        {
            [_delegate mobileCertificateStep2Back];
        }
		
        if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
        {
            UIButton *btnSender = (UIButton*)sender;
            switch (btnSender.tag)
            {
                case NAVI_CLOSE_BTN_TAG:
                {
                    AppInfo.isAllIdenty = NO;
                    AppInfo.isAllIdentyDone = NO;
                    AppInfo.isSMSIdenty = NO;
                    AppInfo.isARSIdenty = NO;
                }
                    break;
                case QUICK_HOME_TAG:
                {
                    AppInfo.isAllIdenty = NO;
                    AppInfo.isAllIdentyDone = NO;
                    AppInfo.isSMSIdenty = NO;
                    AppInfo.isARSIdenty = NO;
                }
                    break;
            }
        }
	}
    else if (sender.tag == 130) {
		// 인증번호 다시받기
        [self requestMobileCertReSend];
        
        NSString *msg;
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"The certification number is resent to your cell phone, Please enter the number and press the \"Confirm\" button.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"認証番号が再電送されました。認証番号を入力してから進行してください。";
        } else
        {
            msg = @"인증번호가 재발송 되었습니다.\n인증번호 입력 후 진행하여 주시기 바랍니다.";
        }
        
        [UIAlertView showAlertLan:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == certTextField) {
        if ([textField.text length] >= 6 && range.length == 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Delegate : SHBTextFieldAccDelegate

- (void)didCompleteButtonTouch
{
	[certTextField focusSetWithLoss:NO];
	[certTextField resignFirstResponder];
	
}	// 완료버튼

#pragma mark - Delegate : UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[(SHBTextField*)textField focusSetWithLoss:YES];
	[(SHBTextField*)textField enableAccButtons:NO Next:NO];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[certTextField focusSetWithLoss:NO];
	[certTextField resignFirstResponder];
	
	return YES;
}

@end
