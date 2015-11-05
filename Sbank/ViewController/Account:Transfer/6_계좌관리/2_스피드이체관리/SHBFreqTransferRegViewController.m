//
//  SHBFreqTransferRegViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqTransferRegViewController.h"
#import "SHBFreqTransferRegComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util

@interface SHBFreqTransferRegViewController ()
{
    int serviceType;

    int processFlag;
    int cmsFlag;
}
- (BOOL)validationCheck;
@end

@implementation SHBFreqTransferRegViewController
@synthesize nType;  // 0 : 등록, 1 : 변경, 9 : 등록(이체화면에서 올경우)
@synthesize service;
@synthesize outAccInfoDic;

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
        case 112300:    // 입금은행
        {
            serviceType = 2;
            
            _btnSelectBank.selected = YES;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"은행목록" options:AppInfo.codeList.bankList CellNib:@"SHBBankListPopupCell" CellH:32 CellDispCnt:9 CellOptCnt:1];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112400:    // 본인계좌
        {
            serviceType = 3;
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            //for(NSDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
            for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
            {
                if([dic[@"입금가능여부"] isEqualToString:@"1"]) // 정상교과장의 요청으로 예금종류 1 인 경우에서 바뀜(2013.04.03)
                {
                    [tableDataArray addObject:@{
                     @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                     @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"]
                     }];
                }
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"본인계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112401:    // 최근입금계좌
        {
            serviceType = 4;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2520" viewController: self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }
            break;
        case 112402:    // 자주쓰는계좌
        {
            serviceType = 5;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2210" viewController: self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }
            break;
        case 112500:    // 확인, 변경
        {
            if(![self validationCheck]) return;
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strBankName = _btnSelectBank.titleLabel.text;
            NSString *strInAmount = _txtInAmount.text;
            NSString *transAmount = nil;
            
            if([strBankName isEqualToString:@"신한은행"])
            {
                serviceType = 6;
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2281" viewController: self] autorelease];
                
                SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{@"입금은행코드" : @"88", @"입금계좌번호" : strInAccNo}];
                self.service.requestData = aDataSet;
                [self.service start];
                [aDataSet release];
            }
            else
            {
                serviceType = 7;
                
                if ([strInAmount isEqualToString:@"0"])
                {
                    transAmount = @"1";
                }
                
                else
                {
                    transAmount = strInAmount;
                }
                
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2282" viewController: self] autorelease];
                SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                        //@"주민번호" : AppInfo.ssn,
                                        //@"주민번호" : [AppInfo getPersonalPK],
                                        @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                        @"출금계좌번호" : strOutAccNo,
                                        @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                        @"입금계좌번호" : strInAccNo,
                                        @"이체금액" : transAmount}];
                self.service.requestData = aDataSet;
                [self.service start];
                [aDataSet release];
            }
            
        }
            break;
        case 112600:    // 취소, 삭제
        {
            if(nType == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"삭제 후 해당정보는 복원되지 않습니다. 삭제하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오",nil];
                alert.tag = 100;
                [alert show];
                [alert release];
            }
            else
            {
                [self.navigationController fadePopViewController];
            }
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            self.dataList = [aDataSet arrayWithForKey:@"최근입금계좌"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"최근 이용하신 입금계좌가 존재하지 않습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : [AppInfo.codeList bankNameFromCode:dic[@"최근입금은행코드"]],
                 @"2" : dic[@"최근입금계좌성명"],
                 @"3" : dic[@"최근입금계좌번호"],
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"최근입금계좌" options:tableDataArray CellNib:@"SHBRecentAccountCell" CellH:60 CellDispCnt:5 CellOptCnt:3];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 5:
        {
            self.dataList = [aDataSet arrayWithForKey:@"입금계좌"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"등록되어 있는 자주쓰는 입금계좌가 존재하지 않습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : [AppInfo.codeList bankNameFromCode:dic[@"입금은행코드"]],
                 @"2" : dic[@"입금계좌성명"],
                 @"3" : dic[@"입금계좌번호"],
                 @"4" : [NSString stringWithFormat:@"별명 : %@", dic[@"nick_name"]],
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"자주쓰는계좌" options:tableDataArray CellNib:@"SHBFrequentAccountCell" CellH:86 CellDispCnt:3 CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 6: // 당행 수취인 조회
        {
            NSDictionary *dic = @{
            @"입금계좌별명" : _txtNickName.text,
            @"출금계좌번호" : _btnAccountNo.titleLabel.text,
            @"입금은행" : _btnSelectBank.titleLabel.text,
            @"입금은행코드" : AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text],
            @"입금계좌번호" : _txtInAccountNo.text,
            @"입금자명" : aDataSet[@"수취인"],
            @"이체금액" : _txtInAmount.text,
            @"받는분통장메모" : _txtRecvMemo.text == nil ? @"" : _txtRecvMemo.text,
            @"보내는분통장메모" : _txtSendMemo.text == nil ? @"" : _txtSendMemo.text,
            @"KEY" : nType == 1 ? self.data[@"KEY"] : @"",
            };
            
            SHBFreqTransferRegComfirmViewController *nextViewController = [[[SHBFreqTransferRegComfirmViewController alloc] initWithNibName:@"SHBFreqTransferRegComfirmViewController" bundle:nil] autorelease];
            nextViewController.data = dic;
            nextViewController.nType = nType;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 7: // 타행 수취인 조회
        {
            NSDictionary *dic = @{
            @"입금계좌별명" : _txtNickName.text,
            @"출금계좌번호" : _btnAccountNo.titleLabel.text,
            @"입금은행" : _btnSelectBank.titleLabel.text,
            @"입금은행코드" : AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text],
            @"입금계좌번호" : _txtInAccountNo.text,
            @"입금자명" : aDataSet[@"수취인"],
            @"이체금액" : _txtInAmount.text,
            @"받는분통장메모" : _txtRecvMemo.text == nil ? @"" : _txtRecvMemo.text,
            @"보내는분통장메모" : _txtSendMemo.text == nil ? @"" : _txtSendMemo.text,
            @"KEY" : nType == 1 ? self.data[@"KEY"] : @"",
            };
            
            SHBFreqTransferRegComfirmViewController *nextViewController = [[[SHBFreqTransferRegComfirmViewController alloc] initWithNibName:@"SHBFreqTransferRegComfirmViewController" bundle:nil] autorelease];
            nextViewController.data = dic;
            nextViewController.nType = nType;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 8:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"정상 처리되었습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
            break;
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    switch (alertView.tag) {
        case 100:
        {
            if (buttonIndex == 0)
            {
                serviceType = 8;
                
                self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_DELETE viewController:self] autorelease];
                self.service.previousData = (SHBDataSet *)@{@"KEY" : self.data[@"KEY"]};
                [self.service start];
            }
        }
            break;
            
        default:
        {
            for (UIViewController *viewController in self.navigationController.viewControllers)
            {
                if ([viewController isKindOfClass:NSClassFromString(@"SHBFreqTransferListViewController")])
                {
                    [viewController performSelector:@selector(refresh)];
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
        }
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

	if (textField == _txtNickName)
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
		//한글 10자 제한(영문 20자)
		if (dataLength + dataLength2 > 22)
        {
			return NO;
		}
	}
	else if (textField == _txtRecvMemo || textField == _txtSendMemo)
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
	else if (textField == _txtInAccountNo )
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
    else if(_txtNickName.text != nil && [_txtNickName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 20 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘이체계좌별명’ 내용이 입력한도를 초과했습니다.(한글 10자, 영숫자 20자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtNickName.text = [SHBUtility substring:_txtNickName.text ToMultiByteLength:20];
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
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.btnAccountNo);
        }
            break;
        case 2:
        {
            _btnSelectBank.selected = NO;
            [_btnSelectBank setTitle:AppInfo.codeList.bankList[anIndex][@"1"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 3:
        {
            [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            _txtInAccountNo.text = self.dataList[anIndex][@"2"];

            UIButton *btn = (UIButton *)[self.view viewWithTag:112400];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 4:
        case 5:
        {
            [_btnSelectBank setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            _txtInAccountNo.text = self.dataList[anIndex][@"3"];

            UIButton *btn = (UIButton *)[self.view viewWithTag:serviceType == 4 ? 112401 : 112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
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
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
        case 2:
        {
            _btnSelectBank.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 3:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112400];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 4:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112401];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 5:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;

    if(_txtNickName.text == nil || [_txtNickName.text length] == 0)
    {
        strAlertMessage = @"이체계좌별명을 입력하여 주십시오.";
        goto ShowAlert;
    }
    
	int checkCount = 0;
	for (int i = 0; i < [_txtNickName.text length]; i++) {
		NSInteger ch = [_txtNickName.text characterAtIndex:i];
		/**
		 A~Z : 65 ~ 90
		 a~z : 97 ~ 122
		 0~9 : 48 ~ 57
         ㄱ ~ ㅣ : 12593 ~ 12643
		 가~ 힣(Hangul Syllabales): 44032 ~ 55203
		 **/
		if (!((32 == ch) || (48 <= ch && ch <= 57) || (65 <= ch && ch <=92) || (97 <= ch && ch <= 122) || (44032 <= ch && ch <= 55203) || (12593 <= ch && ch <= 12643))) {
			checkCount++;
			break;
		}
	}
	
	if (checkCount > 0 ) {
        strAlertMessage = @"이체계좌별명은 한글과 영숫자만 입력이 가능합니다.";
        goto ShowAlert;
	}
    
    if([strInAccNo length] == 0 ||
       ([strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 14) ||
       (![strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 16)){
        strAlertMessage = @"‘입금계좌’ 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }
    
//	if([strInAccNo length] == 12 && [strBankName isEqualToString:@"신한은행"] &&
//       ([[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] >= 250
//        && [[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] <= 259))
//	{
//        strAlertMessage = @"펀드계좌는 즉시이체에서 이체하실 수 없습니다.";
//        goto ShowAlert;
//	}
	
	if (([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
        || ([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]))
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"계좌관리";

    if(nType == 1)
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"스피드이체변경" maxStep:2 focusStepNumber:1]autorelease]];
        self.strBackButtonTitle = @"스피드이체 변경 1단계";
        
        [_btnOK setTitle:@"변경" forState:UIControlStateNormal];
        [_btnCancel setTitle:@"삭제" forState:UIControlStateNormal];
        
        _txtNickName.text = self.data[@"입금계좌별명"];
        
        [_btnAccountNo setTitle:self.data[@"출금계좌번호"] forState:UIControlStateNormal];
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";

        [_btnSelectBank setTitle:[AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]] forState:UIControlStateNormal];
        _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
        _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
        
        _txtInAccountNo.text = self.data[@"입금계좌번호"];
        _txtInAmount.text = [SHBUtility normalStringTocommaString:self.data[@"이체금액"]];
        _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]];
        
        _txtRecvMemo.text = self.data[@"받는분통장메모"];
        _txtSendMemo.text = self.data[@"보내는분통장메모"];
    }
    else
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"스피드이체등록" maxStep:2 focusStepNumber:1]autorelease]];
        self.strBackButtonTitle = @"스피드이체 등록 1단계";
        
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
    }
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222004;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_txtNickName release];
    [_btnAccountNo release];
    [_btnSelectBank release];
    [_lblKorMoney release];
    [_txtInAccountNo release];
    [_txtInAmount release];
    [_txtRecvMemo release];
    [_txtSendMemo release];

    [_btnOK release];
    [_btnCancel release];

    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTxtNickName:nil];
    [self setBtnAccountNo:nil];
    [self setBtnSelectBank:nil];
    [self setLblKorMoney:nil];
    [self setTxtInAccountNo:nil];
    [self setTxtInAmount:nil];
    [self setTxtRecvMemo:nil];
    [self setTxtSendMemo:nil];
    
    [self setBtnOK:nil];
    [self setBtnCancel:nil];

    [super viewDidUnload];
}
@end
