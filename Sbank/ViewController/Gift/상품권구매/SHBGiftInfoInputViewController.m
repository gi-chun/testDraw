//
//  SHBGiftInfoInputViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftInfoInputViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util
#import "SHBIdentity2ViewController.h" // 추가인증
#import "SHBDeviceRegistServiceViewController.h" // 추가인증
#import "SHBUtility.h"
#import "SHBGiftService.h"
#import "SHBAccountService.h"
#import "SHBGiftComfirmViewController.h"

#define TOOLBARVIEW_HEIGHT 40   // 툴바 뷰 높이
#define KEYPAD_HEIGHT 216       // 키패드 높이


@interface SHBGiftInfoInputViewController () <SHBIdentity2Delegate>
{
    int serviceType;
    NSString *encriptedPW;
    NSString *encryptPwd1;
    NSString *encryptPwd2;
    
    int processFlag;
    int cmsFlag;
}

@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *encryptPwd1;
@property (retain, nonatomic) NSString *encryptPwd2;


- (BOOL)securityCenterCheck;
- (BOOL)validationCheck;

@end

@implementation SHBGiftInfoInputViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize encryptPwd1;
@synthesize encryptPwd2;
@synthesize giftType;
//@synthesize giftservice;



- (NSMutableArray *)outAccountListGift
{
    NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    //for (NSMutableDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
    for (NSMutableDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
    {
        if([[dic objectForKey:@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [[dic objectForKey:@"계좌번호"] characterAtIndex:0] == '1' && ![[dic objectForKey:@"상품코드"] isEqualToString:@"110003101"]) //s_more 계좌 제외
        {
            [tableDataArray addObject:@{
                                        @"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
                                        @"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
                                        @"은행코드" : [dic objectForKey:@"은행코드"],
                                        @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
                                        @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                        @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
                                        @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
                                        
                                        }];
        }
    }
    
    return tableDataArray;
}



- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
        case 112100:    // 출금계좌번호
        {
            serviceType = 0;
            
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountListGift];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;

            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112200:    // 잔액조회
        {
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if([strOutAccNo isEqualToString:@"선택하세요."])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금계좌를 선택하여 주십시오."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            if([strOutAccNo isEqualToString:@"출금계좌정보가 없습니다."])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            serviceType = 1;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
        }
            break;
       
        case 112500:    // 확인
        {
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
           
           // NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            

            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                                                            @"거래구분" : @"1",  //판매전조회
                                                                            @"업무유형" : @"1",
                                                                            @"기관코드" : giftType,
                                                                            @"판매금액" : _txtInAmount.text,
                                                                            @"_ExtE2E123_판매금액" : self.encryptPwd1,
                                                                            @"계좌구분" : self.outAccInfoDic[@"은행구분"],
                                                                            @"지급계좌번호" : _btnAccountNo.titleLabel.text,
                                                                            //@"지급계좌번호" : self.outAccInfoDic[@"출금계좌번호"],
                                                                            @"계좌비밀번호" : self.encriptedPW,
                                                                            @"구매자휴대폰" : _txtRecvPhone.text,
                                                                            @"받는분휴대폰" : _txtInPhone.text,
                                                                            @"_ExtE2E123_받는분휴대폰" : self.encryptPwd2,
                                                                            @"구매자성명" : _txtInName.text,
                                                                            @"받는분성명" : _txtRecvName.text,
                                                                            @"전달메세지" : _massegecontentTV.text,
                                                                            @"취소시구매일자" : @"",
                                                                            @"취소시구매승인번호" :@"",
                                                                            @"센터처리번호" :@"",
                                                                            }];
            
            

            serviceType = 3;
            
            self.service = nil;
            self.service = [[[SHBGiftService alloc] initWithServiceId:GIFT_E1710
                                                         viewController:self] autorelease];
            self.service.requestData = aDataSet;
            
            [self.service start];

        }
            break;
            
            
        case 112600:
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}


- (IBAction)toolBarViewButtonDidPush:(id)sender
{
  
 
    switch ([sender tag]) {
            
        case 0:
            // 툴바 뷰 - 이전 버튼
             [_txtRecvPhone becomeFirstResponder];
            break;
        case 1:
            // 툴바 뷰 - 다음 버튼
            break;
        case 2:
            // 툴바 뷰 - 완료 버튼
            [_massegecontentTV resignFirstResponder];
            break;
            
        default:
            break;
    }
    
  
    
    
}


#pragma mark -

- (BOOL)securityCenterCheck
{
    // (5) <추가인증 여부 체크>
    if (![_securityCenterDataSet[@"C2403_2채널인증여부"] isEqualToString:@"Y"]) { // 추가인증 안한 고객인 경우(C2403_2채널인증여부:Y가 아닐경우)
        
        // (1) <보안매체>
        if (![_securityCenterDataSet[@"점자보안카드사용여부"] isEqualToString:@"Y"] &&
            ![_securityCenterDataSet[@"OTP사용여부"] isEqualToString:@"Y"]) { // 보안카드인 경우(점자보안카드사용여부 == N and OTP사용여부 == N)
            
            long long inAmount = [[_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체금액
            long long checkAmount = [[_securityCenterDataSet[@"이체추가인증기준금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체추가인증기준금액
            
            AppInfo.transferDic = @{
                                    @"추가이체여부" : @"N",
                                    @"입금은행명" : @"신한은행",
                                    @"추가이체건수" : @"",
                                    @"추가_입금은행코드" : @"",
                                    @"추가_입금은행명" : @"",
                                    @"추가_입금계좌번호" : @"",
                                    @"추가_입금계좌성명" : @"",
                                    @"추가_이체금액" : @"",
                                    @"계좌번호_상품코드" : @"",
                                    @"거래금액" : [NSString stringWithFormat:@"%lld", inAmount],
                                    @"서비스코드" : @"E1730",
                                    };
            
            // (2) <금액체크>
            if ([_securityCenterDataSet[@"일누적이체금액"] longLongValue] + inAmount >= checkAmount) { // 이체추가인증기준금액 이상인 경우(해당금액 < 일누적이체금액 + 이체금액)
                
                // (3) <이용기기등록고객>
                if (![_securityCenterDataSet[@"PC지정등록신청여부"] isEqualToString:@"Y"]) { // 미등록인 경우(PC지정등록신청여부:N)
                    
                    // (8) <추가인증 체크>
                    if ([_securityCenterDataSet[@"이체추가인증신청여부"] isEqualToString:@"Y"]) { // 이체추가인증신청여부:Y인 경우
                        
                        // 추가인증 요청
                        SHBIdentity2ViewController *viewController = [[[SHBIdentity2ViewController alloc]initWithNibName:@"SHBIdentity2ViewController" bundle:nil] autorelease];
                        
                        viewController.needsLogin = YES;
                        viewController.delegate = self;
                        viewController.data = [NSDictionary dictionaryWithDictionary:_securityCenterDataSet];
                        viewController.serviceSeq = SERVICE_300_OVER;
                        
                        [self checkLoginBeforePushViewController:viewController animated:YES];
                        
                        [viewController executeWithTitle:@"상품권구매" Step:0 StepCnt:0 NextControllerName:nil];
                        [viewController subTitle:@"추가인증 방법 선택"];
                        
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    SHBGiftComfirmViewController *nextViewController = [[[SHBGiftComfirmViewController alloc] initWithNibName:@"SHBGiftComfirmViewController" bundle:nil] autorelease];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (IBAction)closeNormalPad:(id)sender
{
    UIButton *btn = sender;
    [super closeNormalPad:sender];
    
    if (btn.tag == 999)  // 계좌번호
    {
          [_txtAccountPW becomeFirstResponder];
    }
    
    else if (btn.tag == 1000)  // 구매금액
    {
         [_txtInAmount becomeFirstResponder];
    }

    else if (btn.tag == 1001)  // 받는분 번호
    {
        [_txtInPhone becomeFirstResponder];
    }


  
    
   
}


- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    // 추가인증 정보 조회
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E2114"]) {
        
        self.securityCenterDataSet = aDataSet;
        
        
        // 안심거래서비스 체크
        if ([aDataSet[@"안심거래서비스가입여부"] isEqualToString:@"Y"] && [aDataSet[@"안심거래서비스기기여부"] isEqualToString:@"N"] && [AppInfo.userInfo[@"안심거래서비스사용여부"] isEqualToString:@"Y"])
        {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:9877
                             title:@""
                           message:@"안심거래 서비스 신청 고객님은 등록하신 기기로만 이체 거래가 가능합니다. 안심거래 서비스의 기기 추가등록은 인근 영업점을 방문하시어 1회용 인증번호 수령 후 가능합니다."];
            return NO;
            
        }
        
        
        // 이용기기등록고객 체크
        if ([aDataSet[@"PC지정등록신청여부"] isEqualToString:@"Y"]) {
            
            // 이용기기 체크
            if (![aDataSet[@"PC지정등록MAC여부"] isEqualToString:@"Y"]) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:9876
                                 title:@""
                               message:@"고객님께서는 이용기기 등록 서비스에 가입되어 있습니다. 현재 이용기기를 등록하기 위하여 이용기기 등록 서비스로 이동합니다."];
                return NO;
            }
        }
        
        return NO;
    }
    
    switch (serviceType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@원", aDataSet[@"지불가능잔액"]];
            _lblBalance.hidden = NO;
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            NSString *type;
            if ([giftType isEqualToString:@"EMART"])
            {
                type = @"신세계 상품권";
            }
            else
            {
                type = @"문화 상품권";
            }

            
            AppInfo.commonDic = @{
                                    @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"상품권종류", @"출금계좌번호",@"계좌구분",@"구매금액", @"판매금액", @"캐시백금액", @"받는분성명", @"보내는분성명", @"보내는분휴대폰",@"받는분휴대폰",@"전달메세지",@"기관코드",@"대외거래고유번호",@"계좌비밀번호",@"지급계좌번호"],
                                    @"제목" : @"상품권 구매",
                                    @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                    @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                    @"상품권종류" : type,
                                    @"출금계좌번호" : _btnAccountNo.titleLabel.text,
                                    @"계좌구분" : self.outAccInfoDic[@"은행구분"],
                                    @"구매금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"구매금액"]],
                                    @"판매금액" : _txtInAmount.text,
                                    @"캐시백금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"캐시백금액"]],
                                    @"받는분성명" : aDataSet[@"받는분성명"],
                                    @"보내는분성명" : aDataSet[@"구매자성명"],
                                    @"보내는분휴대폰" : aDataSet[@"구매자휴대폰"],
                                    @"받는분휴대폰" : aDataSet[@"받는분휴대폰"],
                                    @"전달메세지" : aDataSet[@"전달메세지"],
                                    @"기관코드" : giftType,
                                    @"대외거래고유번호" : aDataSet[@"대외거래고유번호"],
                                    @"계좌비밀번호" : self.encriptedPW,
                                    @"지급계좌번호" : self.outAccInfoDic[@"출금계좌번호"],
                                    };

            if (![self securityCenterCheck]) return NO;
            [self viewControllerDidSelectDataWithDic:nil];
            
         
        }
            break;
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    switch ([alertView tag]) {
        case 9000:
        {
            if (buttonIndex == 0) {
                if (![self securityCenterCheck]) return;
                
                [self viewControllerDidSelectDataWithDic:nil];
            }
        }
            break;
        case 9876:
        {
            // 이용기기 등록 메뉴로 이동
            SHBDeviceRegistServiceViewController *viewController = [[[SHBDeviceRegistServiceViewController alloc] initWithNibName:@"SHBDeviceRegistServiceViewController" bundle:nil] autorelease];
            [self.navigationController popToRootWithFadePushViewController:viewController];
            
        }
            break;
        case 9877:
        {
            // 안심거래 알럿 후 메인으로 이동
            [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITextField Delegate




#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
        if (textField == _txtInText) {
            
            [_massegecontentTV performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
        }
        else {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                 self.contentScrollView.contentOffset = CGPointMake(0, textField.superview.frame.origin.y - 26);
            }];
        }
        
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtInName || textField == _txtRecvName)
    {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		//한글 10자 제한(영문20자)
		if (dataLength + dataLength2 > 20)
        {
			return NO;
		}
	}
	else if (textField == _txtInPhone || textField == _txtRecvPhone ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 11)
        {
			return NO;
		}
	}
	else if (textField == _txtInAmount )
    {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 9) //100만원
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
                
               // _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
                
                //_lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if (textField == _txtInName)  //구매금액 가변텍스트
    {
        //_lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
    }
    else if(textField == _txtRecvName && [_txtRecvName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘받는분 성명’ 은 최대 10자까지 입력이 가능합니다. 입력하신 내용을 확인하여 주시기 바랍니다.(한글 10자, 영숫자 20자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtRecvName.text = [SHBUtility substring:_txtRecvName.text ToMultiByteLength:20];
	}
    else if(_txtInName.text != nil && [_txtInName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘보내는분 성명’ 은 최대 10자까지 입력이 가능합니다. 입력하신 내용을 확인하여 주시기 바랍니다.(한글 10자, 영숫자 20자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtInName.text = [SHBUtility substring:_txtInName.text ToMultiByteLength:20];
	}
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
     [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
   
    if (textField.tag == 222000)  // 계좌번호
    {
       
        self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
    }
    
    if (textField.tag == 222001) //판매금액
    {
        self.encryptPwd1 = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
        textField.secureTextEntry=NO;
    }
    
    
    if (textField.tag == 222004) //받는분 휴대폰번호
    {
        self.encryptPwd2 = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
        textField.secureTextEntry=NO;
    }
    
    
    
    
    
    
}

#pragma mark - identity2 Delegate

- (void)identity2ViewControllerCancel
{
    AppInfo.isNeedClearData = YES;
}


#pragma mark - UITextView Delegate Methods

- (void)didCompleteButtonTouch
{
    [super didCompleteButtonTouch];
    
    if ([_massegecontentTV isFirstResponder]) {
        
        [_massegecontentTV resignFirstResponder];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // TextView PlaceHolder 초기화
    if ([textView.text isEqualToString:@"(최대 50자)"]) {
        
        textView.text = @"";
        textView.textColor = RGB(44, 44, 44);
    }
    
    // 스크롤 뷰 사이즈 늘려줌
    CGRect rectTemp = _mainView.frame;
    rectTemp.size.height += KEYPAD_HEIGHT + TOOLBARVIEW_HEIGHT + 10;
    self.contentScrollView.contentSize = rectTemp.size;
    
    // 툴바 추가 및 위치 초기화
    rectTemp = _toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    _toolBarView.frame = rectTemp;
    
    [AppDelegate.window addSubview:_toolBarView];
    
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height - TOOLBARVIEW_HEIGHT - KEYPAD_HEIGHT;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarView.frame = rectTemp;
        
        if ([giftType isEqualToString:@"EMART"]) {
            
            self.contentScrollView.contentOffset = CGPointMake(0, 347);
        }
        else {
            
            self.contentScrollView.contentOffset = CGPointMake(0, 295);
        }
    }];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    // TextView PlaceHolder 초기화
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"(최대 50자)";
        textView.textColor = [UIColor lightGrayColor];
    }
    else {
        
        textView.textColor = RGB(44, 44, 44);
    }
    
    // 스크롤 뷰 사이즈 초기화
    CGRect rectTemp = _toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{

        _toolBarView.frame = rectTemp;
        
        self.contentScrollView.contentSize = CGSizeMake(317, height(_mainView));
        
        contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
   
    } completion:^(BOOL finished){
        
        [_toolBarView removeFromSuperview];
    }];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 입력이 불가능한 특수문자인지 확인
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"$₩€£¥•"] invertedSet];
    BOOL isSpecialCharacters = [text isEqualToString:[[text componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""]];
    
    if (isSpecialCharacters && ![text isEqualToString:@""]) { // 입력 가능한 문자만 입력 가능
        
        return NO;
    }
    
    // 자리수 확인
    NSInteger textLength = [textView.text length] + [text length];
    
    if (textLength > 50) { // 최대 100자리까지 입력제한
        
        return NO;
    }
    
    return YES;
}


#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
            self.outAccInfoDic = self.dataList[anIndex];
            
            [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
            
            // 출금계좌가 변경되면 암호 초기화
            _txtAccountPW.text = @"";
            
            _lblBalance.hidden = YES;
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.btnAccountNo);
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)listPopupViewDidCancel{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
        }
            break;
        case 2:
        {
           
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
   // NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    int inAmount = [[_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue ];
    
    
    if([strOutAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"‘출금계좌’를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
   	
	if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 9 )
	{
        strAlertMessage = @"‘구매금액’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
    
	if([_txtInAmount.text isEqualToString:@"0"])
	{
        strAlertMessage = @"‘구매금액’은 0원을 입력하실 수 없습니다.";
        goto ShowAlert;
	}
    
    
    if ([giftType isEqualToString:@"EMART"])
    {
        if (  10000 > inAmount  ||  inAmount > 1000000) {
            strAlertMessage = @"구매 가능한 금액이 아닙니다. 입력하신 구매금액을 확인하여 주시기 바랍니다.";
            goto ShowAlert;
            
        }
    }
    else
    {
        if (  10000 > inAmount  ||  inAmount > 100000) {
            strAlertMessage = @"구매 가능한 금액이 아닙니다. 입력하신 구매금액을 확인하여 주시기 바랍니다.";
            goto ShowAlert;
            
        }
    }

    
    if(_txtInName.text == nil || [_txtInName.text length] == 0  )
	{
        strAlertMessage = @"보내는분 성명을 입력해 주십시오.";
        goto ShowAlert;
	}

    if(_txtRecvName.text == nil || [_txtRecvName.text length] == 0  )
	{
        strAlertMessage = @"받는분 성명을 입력해 주십시오.";
        goto ShowAlert;
	}
    
    
    if(_txtInPhone.text == nil || [_txtInPhone.text length] == 0 || [_txtInPhone.text length] < 10 )
	{
        strAlertMessage = @"받는분 휴대폰번호를 입력해 주십시오.";
        goto ShowAlert;
	}

    if(_txtRecvPhone.text == nil || [_txtRecvPhone.text length] == 0 || [_txtRecvPhone.text length] < 10 )
	{
        strAlertMessage = @"보내는분 휴대폰번호를 입력해 주십시오.";
        goto ShowAlert;
	}
    
    
    if(_massegecontentTV.text == nil || [_massegecontentTV.text length] == 0 || [_massegecontentTV.text isEqualToString:@"(최대 50자)" ])
	{
        strAlertMessage = @"전달내용을 입력해 주십시요.";
        goto ShowAlert;
	}
   
    
    
	if(_txtRecvName.text != nil && [_txtRecvName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        strAlertMessage = @"‘받는분 성명’ 내용이 입력한도를 초과했습니다.(한글 10자, 영숫자 20자)";
        goto ShowAlert;
	}
    
	if(_txtInName.text != nil && [_txtInName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        strAlertMessage = @"‘보내는분 성명’ 내용이 입력한도를 초과했습니다.(한글 10자, 영숫자 20자)";
        goto ShowAlert;
	}
    
    
    
    NSString *tmpStr = [_massegecontentTV.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    if (!tmpStr) {
        
        strAlertMessage = @"지원하지 않는 문자가 있습니다.\n다시 입력해 주세요.";
        goto ShowAlert;    }

    
ShowAlert:
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:nil
												   cancelButtonTitle:@"확인"
												   otherButtonTitles:nil] autorelease];
		[alertView show];
		return NO;
	}
	
	return YES;
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"모바일 상품권 구매";
    //self.strBackButtonTitle = @"";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"상품권 구매 정보입력" maxStep:3 focusStepNumber:1] autorelease]];
    
    [_prevBtn setEnabled:YES];      //전달메모 툴바 이전 버튼
    
    self.txtInAmount.secureTextEntry=NO;
    self.txtInPhone.secureTextEntry=NO;
    self.giftType = AppInfo.giftType;   // 상품권 종류
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    //구매금액
    [self.txtInAmount showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:7];
    
    //받는분 휴대폰 번호
     [self.txtInPhone showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:11];
    
    processFlag = 0;
    cmsFlag = 0;
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
    }
    else
    {
        [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        _btnAccountNo.enabled = NO;
    }
    
    serviceType = 4;
      
    if ([giftType isEqualToString:@"EMART"]) {
        
        _lblKorMoney.text = @"(구매금액 월100만원으로 제한)";
        
        [_emartInfoLabel setHidden:NO];
        
        FrameReposition(_bottomInputView, 0, 304);
        FrameResize(_mainView, width(_mainView), 588);
        
        self.contentScrollView.contentSize = CGSizeMake(317, 588);
    }
    else {
        
        _lblKorMoney.text = @"(구매금액 1회10만원, 월100만원으로 제한)";
        
        [_emartInfoLabel setHidden:YES];
        
        FrameReposition(_bottomInputView, 0, 252);
        FrameResize(_mainView, width(_mainView), 536);
        
        self.contentScrollView.contentSize = CGSizeMake(317, 536);
    }
    
    contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222006;
    
    _txtInName.text = AppInfo.userInfo[@"고객성명"];
    _txtRecvPhone.text = [AppInfo.userInfo[@"휴대폰번호"]stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        processFlag = 0;
        cmsFlag = 0;
        
        _lblBalance.hidden = YES;
        _lblKorMoney.text = @"";
       
        _txtInAmount.text = @"";
        
        //_txtInName.text = @"";
        _txtRecvName.text = @"";
        
        _txtInPhone.text = @"";
        //_txtRecvPhone.text = @"";
        _txtInText.text = @"";
        _massegecontentTV.text = @"";
        
    }
    
    // 추가인증 정보조회
    self.securityCenterService = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
    [_securityCenterService start];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    self.encriptedPW = nil;
    self.giftType = nil;
    
    [_btnAccountNo release];
    [_lblBalance release];
    [_lblKorMoney release];
    [_txtInAmount release];
    [_txtAccountPW release];
    [_prevBtn release];
    [_txtInName release];
    [_txtRecvName release];
    [_txtInPhone release];
    [_txtRecvPhone release];
    [_txtInText release];
    [_massegecontentTV release];
    
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
    [_emartInfoLabel release];
    [_bottomInputView release];
    [_mainView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnAccountNo:nil];
    [self setLblBalance:nil];
    [self setLblKorMoney:nil];
    [self setTxtInAmount:nil];
    [self setTxtAccountPW:nil];
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
     [self setPrevBtn:nil];
    
    [super viewDidUnload];
    
}
@end
