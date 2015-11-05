//
//  SHBCelebrationTransferInfoInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCelebrationTransferInfoInputViewController.h"
#import "SHBCelebrationTransferComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util
#import "SHBIdentity2ViewController.h" // 추가인증
#import "SHBDeviceRegistServiceViewController.h" // 추가인증

@interface SHBCelebrationTransferInfoInputViewController () <SHBIdentity2Delegate>
{
    int serviceType;
    NSString *encriptedPW;
    NSString *encriptedInAccNo;
    NSString *encriptedAmount;
    
    
    int processFlag;
    int cmsFlag;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *encriptedInAccNo;
@property (retain, nonatomic) NSString *encriptedAmount;




- (BOOL)securityCenterCheck;
- (BOOL)validationCheck;

@end

@implementation SHBCelebrationTransferInfoInputViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize encriptedInAccNo;
@synthesize encriptedAmount;


- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
        case 112100:    // 출금계좌번호
        {
            serviceType = 0;
            
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountList];
            
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
        case 112300:    // 경조문구
        {
            serviceType = 2;

            if([AppInfo.codeList.celebrationCode count] == 0)
            {
                
                _btnSelectCelebration.selected = YES;
                
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"CODE" viewController:self] autorelease];
                self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"codeKey" : @"event_code"}] autorelease];
                [self.service start];
            }
            else
            {
                self.dataList = (NSArray *)AppInfo.codeList.celebrationCode;
                
                SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"통장에 표시할 문구" options:AppInfo.codeList.celebrationCode CellNib:@"SHBCelebrationCell" CellH:54 CellDispCnt:6 CellOptCnt:1];
                [popupView setDelegate:self];
                [popupView showInView:self.navigationController.view animated:YES];
                [popupView release];
            }
        }
            break;
        case 112500:    // 확인
        {
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
            
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            //이체금액
            self.encriptedAmount = [NSString stringWithFormat:@"<E2K_CHAR=%@>", [AppInfo encNfilterData:_txtInAmount.text]];
            
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2021" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                    @"출금계좌번호" : strOutAccNo,
                                    @"출금계좌비밀번호" : self.encriptedPW,
                                    @"입금은행" : @"88",
                                    @"경조코드" : _btnSelectCelebration.titleLabel.text,
                                    @"입금계좌번호" : strInAccNo,
                                    @"이체금액" : strInAmount,
                                    @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                    @"입금계좌통장메모" : _txtRecvMemo.text,
                                    @"출금계좌통장메모" : _txtSendMemo.text,
                                    @"_ExtE2E123_입금계좌번호" : self.encriptedInAccNo,
                                    @"_ExtE2E123_이체금액" : self.encriptedAmount,
                                    @"_IP_ACC_GBN_" :@"ST",
                                    @"_AMT_GBN_" : @"ST",
                                    @"_IP_ACC_IDX_" : @""
                                    }];
            
            self.service.requestData = aDataSet;
            
            serviceType = 3;
            
            [self.service start];
            [aDataSet release];
        }
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
                                    @"추가이체 건수" : @"",
                                    @"추가_입금은행코드" : @"",
                                    @"추가_입금은행명" : @"",
                                    @"추가_입금계좌번호" : @"",
                                    @"추가_입금계좌성명" : @"",
                                    @"추가_이체금액" : @"",
                                    @"계좌번호_상품코드" : @"",
                                    @"거래금액" : [NSString stringWithFormat:@"%lld", inAmount],
                                    @"서비스코드" : @"D2023",
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
                        
                        [viewController executeWithTitle:@"기타이체" Step:0 StepCnt:0 NextControllerName:nil];
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
    SHBCelebrationTransferComfirmViewController *nextViewController = [[[SHBCelebrationTransferComfirmViewController alloc] initWithNibName:@"SHBCelebrationTransferComfirmViewController" bundle:nil] autorelease];
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
    
    else if (btn.tag == 888)  // 입금계좌번호
    {
        [_txtInAccountNo becomeFirstResponder];
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
            for(NSDictionary *dic in aDataSet[@"data"])
            {
                [AppInfo.codeList.celebrationCode addObject:@{
                 @"1" : dic[@"hashtable"][@"value"],
                 @"2" : dic[@"hashtable"][@"code"],
                 }];
            }

            self.dataList = (NSArray *)AppInfo.codeList.celebrationCode;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"통장에 표시할 문구" options:AppInfo.codeList.celebrationCode CellNib:@"SHBCelebrationCell" CellH:54 CellDispCnt:6 CellOptCnt:1];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 3:
        {
            long long remainPaymentMoney = 0;
            long long transferMoney = 0;
            
            remainPaymentMoney = [aDataSet[@"지불가능잔액"] longLongValue];
            transferMoney = [aDataSet[@"이체금액->originalValue"] longLongValue];
            
            if (remainPaymentMoney < transferMoney)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"이체하려는 금액이 출금가능잔액을 초과합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }
            
            AppInfo.commonDic = @{
            @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"수취인성명", @"이체금액", @"경조문구", @"받는통장메모", @"내통장메모", @"중복이체여부"],
            @"제목" : @"경조금이체",
            @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
            @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
            @"출금계좌번호" : _btnAccountNo.titleLabel.text, // ([aDataSet[@"구출금계좌번호"] length] > 0) ? aDataSet[@"구출금계좌번호"] : aDataSet[@"출금계좌번호"],
            @"입금은행" : [AppInfo.codeList bankNameFromCode:aDataSet[@"입금은행코드"]],
            @"입금계좌번호" : _txtInAccountNo.text, // ([aDataSet[@"구입금계좌번호"] length] > 0) ? aDataSet[@"구입금계좌번호"] : aDataSet[@"입금계좌번호"],
            @"수취인성명" : aDataSet[@"입금계좌성명"],
            @"이체금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"이체금액"]],
            @"경조문구" : aDataSet[@"경조코드"],
            @"받는통장메모" : aDataSet[@"입금계좌통장메모"],
            @"내통장메모" : aDataSet[@"출금계좌통장메모"],
            @"수수료" : @"0원",
            @"중복이체여부" : ([aDataSet[@"중복여부"] isEqualToString:@"1"]) ? @"중복이체승인함" : @"해당없음",
            @"입금자성명" : aDataSet[@"출금계좌성명"],
            @"전문번호" : AppInfo.serviceCode,
            };
            
            if ([aDataSet[@"중복여부"] isEqualToString:@"1"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"중복이체 여부를 확인바랍니다."
                                                                message:@"당일 동일한 계좌, 동일한 금액의 이체거래가 있습니다. 이체 내용이 정확한지 다시 한 번 확인하여 주시기 바랍니다. \n이체거래를 계속하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오",nil];
                alert.tag = 9000;
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }
            
            if (![self securityCenterCheck]) return NO;
            
            [self viewControllerDidSelectDataWithDic:nil];
        }
            break;
        case 4:
        {
            for(NSDictionary *dic in aDataSet[@"data"])
            {
                [AppInfo.codeList.celebrationCode addObject:@{
                 @"1" : dic[@"hashtable"][@"value"],
                 @"2" : dic[@"hashtable"][@"code"],
                 }];
            }
            [_btnSelectCelebration setTitle:AppInfo.codeList.celebrationCode[0][@"1"] forState:UIControlStateNormal];

            _btnSelectCelebration.accessibilityLabel = [NSString stringWithFormat:@"선택된 통장에 표시할 문구는 %@ 입니다", _btnSelectCelebration.titleLabel.text];
            _btnSelectCelebration.accessibilityHint = @"통장에 표시할 문구를 바꾸시려면 이중탭 하십시오";
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtRecvMemo || textField == _txtSendMemo)
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
		//한글 7자 제한(영문 14자)
		if (dataLength + dataLength2 > 16)
        {
			return NO;
		}
	}
	else if (textField == _txtInAccountNo ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 17)
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
		if (dataLength + dataLength2 > 14)
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
                _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
                _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if (textField == _txtInAmount)
    {
        _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
    }
    else if(textField == _txtRecvMemo && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtRecvMemo.text = [SHBUtility substring:_txtRecvMemo.text ToMultiByteLength:14];
	}
    else if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtSendMemo.text = [SHBUtility substring:_txtSendMemo.text ToMultiByteLength:14];
	}
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    
    if (textField.tag == 222000)  // 비밀번호
    {
        
        self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
    }
    
    if (textField.tag == 222002) //입금계좌
    {
        self.encriptedInAccNo = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];

    }

    
    
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}

#pragma mark - identity2 Delegate

- (void)identity2ViewControllerCancel
{
    AppInfo.isNeedClearData = YES;
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
            _btnSelectCelebration.selected = NO;
            [_btnSelectCelebration setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            
            _btnSelectCelebration.accessibilityLabel = [NSString stringWithFormat:@"선택된 통장에 표시할 문구는 %@ 입니다", _btnSelectCelebration.titleLabel.text];
            _btnSelectCelebration.accessibilityHint = @"통장에 표시할 문구를 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectCelebration);
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
            _btnSelectCelebration.selected = NO;
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
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if([strOutAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"‘출금계좌’를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
    if([strInAccNo length] == 0 || [strInAccNo length] > 14){
        strAlertMessage = @"‘입금계좌’ 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
	if ([[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]
        || [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
    {
        strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
        goto ShowAlert;
    }
    
	if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 15 )
	{
        strAlertMessage = @"‘이체금액’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
    
	if([_txtInAmount.text isEqualToString:@"0"])
	{
        strAlertMessage = @"‘이체금액’은 0원을 입력하실 수 없습니다.";
        goto ShowAlert;
	}
    
//    if([_btnSelectCelebration.titleLabel.text isEqualToString:@"선택하세요."])
//    {
//        strAlertMessage = @"‘통장에 표시할 문구’를 선택하여 주십시오.";
//        goto ShowAlert;
//    }
    
	if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}
    
	if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}
    
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"기타이체";
    self.strBackButtonTitle = @"경조금이체 등록 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"경조금 이체" maxStep:3 focusStepNumber:1] autorelease]];
    
    self.contentScrollView.contentSize = CGSizeMake(317, 425);
    contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222004;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 입금계좌번호
    [self.txtInAccountNo showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:17];
    self.txtInAccountNo.secureTextEntry=NO;
    
    
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
    
    if([AppInfo.codeList.celebrationCode count] == 0)
    {
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"CODE" viewController:self] autorelease];
        self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"codeKey" : @"event_code"}] autorelease];
        [self.service start];
    }
    else
    {
        [_btnSelectCelebration setTitle:AppInfo.codeList.celebrationCode[0][@"1"] forState:UIControlStateNormal];
        
        _btnSelectCelebration.accessibilityLabel = [NSString stringWithFormat:@"선택된 통장에 표시할 문구는 %@ 입니다", _btnSelectCelebration.titleLabel.text];
        _btnSelectCelebration.accessibilityHint = @"통장에 표시할 문구를 바꾸시려면 이중탭 하십시오";
    }
    
    _txtInAmount.strLableFormat = @"입력된 금액은 %@ 원입니다";
    _txtInAmount.strNoDataLable = @"입력된 금액이 없습니다";
    
    _txtRecvMemo.strLableFormat = @"입력된 받는통장메모는 %@ 입니다";
    _txtRecvMemo.strNoDataLable = @"입력된 받는통장메모가 없습니다. (선택)7자이내로 입력가능합니다";
    _txtSendMemo.strLableFormat = @"입력된 내통장메모는 %@ 입니다";
    _txtSendMemo.strNoDataLable = @"입력된 내통장메모가 없습니다. (선택)7자이내로 입력가능합니다";
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
        [_btnSelectCelebration setTitle:AppInfo.codeList.celebrationCode[0][@"1"] forState:UIControlStateNormal];
        _btnSelectCelebration.accessibilityLabel = [NSString stringWithFormat:@"선택된 통장에 표시할 문구는 %@ 입니다", _btnSelectCelebration.titleLabel.text];
        _btnSelectCelebration.accessibilityHint = @"통장에 표시할 문구를 바꾸시려면 이중탭 하십시오";

        _txtInAccountNo.text = @"";
        _txtInAmount.text = @"";
        _txtRecvMemo.text = @"";
        _txtSendMemo.text = @"";
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
    
    [_btnAccountNo release];
    [_btnSelectCelebration release];
    [_lblBalance release];
    [_lblKorMoney release];
    [_txtInAccountNo release];
    [_txtInAmount release];
    [_txtRecvMemo release];
    [_txtSendMemo release];
    [_txtAccountPW release];
    
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnAccountNo:nil];
    [self setBtnSelectCelebration:nil];
    [self setLblBalance:nil];
    [self setLblKorMoney:nil];
    [self setTxtInAccountNo:nil];
    [self setTxtInAmount:nil];
    [self setTxtRecvMemo:nil];
    [self setTxtSendMemo:nil];
    [self setTxtAccountPW:nil];
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
     [super viewDidUnload];
}
@end
