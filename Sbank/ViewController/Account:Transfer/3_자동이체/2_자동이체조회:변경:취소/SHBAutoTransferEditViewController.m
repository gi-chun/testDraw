//
//  SHBAutoTransferEditViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferEditViewController.h"
#import "SHBAutoTransferEditComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBAutoTransferEditViewController ()
{
    int serviceType;
    NSString *encriptedPW;
    
    int processFlag;
    int cmsFlag;
    
    NSMutableDictionary *codeDic;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (nonatomic, retain) NSMutableDictionary *codeDic;
- (void)defaultValueSetting;
- (BOOL)validationCheck;
@end

@implementation SHBAutoTransferEditViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize codeDic;

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
        case 112200:    // 변경할항목
        {
            serviceType = 1;
            
            _btnSelectChange.selected = YES;
            
            NSMutableArray *array = nil;
            
            if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
                 [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
                 [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
            {
                array = [NSMutableArray arrayWithArray:@[
                         @{@"1" : @"이체금액", @"2" : @"1"},
                         @{@"1" : @"이체시작일", @"2" : @"3"},
                         @{@"1" : @"이체종료일", @"2" : @"2"},
                         @{@"1" : @"이체주기", @"2" : @"4"},
                         @{@"1" : @"출금계좌", @"2" : @"5"},
                         @{@"1" : @"입금계좌", @"2" : @"6"},
                         @{@"1" : @"휴일이체", @"2" : @"7"},
                         @{@"1" : @"통장표시내용", @"2" : @"9"},
                         ]];
            }
            else
            {
                array = [NSMutableArray arrayWithArray:@[
                         @{@"1" : @"이체종료일", @"2" : @"1"},
                         @{@"1" : @"이체금액", @"2" : @"2"},
                         @{@"1" : @"이체시작일", @"2" : @"3"},
                         ]];
            }
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"변경할 항목"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:5
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 112300:    // 이체주기
        {
            serviceType = 2;
            _btnTransferTerm.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"1개월", @"2" : @"01"},
                                     @{@"1" : @"2개월", @"2" : @"02"},
                                     @{@"1" : @"3개월", @"2" : @"03"},
                                     @{@"1" : @"6개월", @"2" : @"06"},
                                     @{@"1" : @"월요일", @"2" : @"91"},
                                     @{@"1" : @"화요일", @"2" : @"92"},
                                     @{@"1" : @"수요일", @"2" : @"93"},
                                     @{@"1" : @"목요일", @"2" : @"94"},
                                     @{@"1" : @"금요일", @"2" : @"95"},
                                     @{@"1" : @"매일", @"2" : @"99"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"이체주기"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:5
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 112400:    // 휴일이체구분
        {
            serviceType = 3;
            _btnHoliday.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"휴일익일이체", @"2" : @"0"},
                                     @{@"1" : @"휴일전일이체", @"2" : @"1"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"휴일이체구분"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:2
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 112500:    // 확인
        {
            if(![self validationCheck]) return;
            _txtAccountPW.text = @"";
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strBankName = _btnSelectBank.titleLabel.text;
            NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            // 1:당행, 2:타행, 3:가상, 4:평생계좌 구분
            if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구신한은행"] ||
               [strBankName isEqualToString:@"구조흥은행"] )
            {
                if([strInAccNo length] == 11)
                {
                    if([strBankName isEqualToString:@"신한은행"])
                    {
                        if([[strInAccNo substringFromIndex:3] hasPrefix:@"99"])
                        {
                            processFlag = 3;
                        }
                        else
                        {
                            processFlag = 1;
                        }
                    }
                    else
                    {
                        processFlag = 3;
                    }
                }
                else if([strInAccNo length] == 14)
                {
                    if([[strInAccNo substringFromIndex:3] hasPrefix:@"901"] || [strInAccNo hasPrefix:@"562"])
                    {
                        processFlag = 3;
                    }
                    else
                    {
                        processFlag = 1;
                    }
                }
                else
                {
                    processFlag = 1;
                }
                if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
                {
                    processFlag = 4;
                }
            }
            else
            {
                processFlag = 2;
            }
            
            //
            if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
            {
                cmsFlag = 1;
            }
            else
            {
                switch ([strInAccNo length]) {
                    case 11:
                    case 12:
                    {
                        cmsFlag = 1;
                    }
                        break;
                    case 13:
                    {
                        if([[strInAccNo substringFromIndex:3] hasPrefix:@"81"] || [[strInAccNo substringFromIndex:3] hasPrefix:@"82"])
                        {
                            cmsFlag = 2;
                        }
                        else
                        {
                            cmsFlag = 1;
                        }
                    }
                        break;
                    case 14:
                    {
                        if([strInAccNo hasPrefix:@"560"])
                        {
                            cmsFlag = 2;
                        }
                        else if([strInAccNo hasPrefix:@"561"])
                        {
                            if([[strInAccNo substringFromIndex:3] hasPrefix:@"910"])
                            {
                                cmsFlag = 1;
                            }
                            else
                            {
                                cmsFlag = 2;
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
            
            SHBDataSet *aDataSet = nil;
            
            if (processFlag == 3 || processFlag == 4) {     // 가상계좌, 평생계좌
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"제휴가상계좌 자동이체는 변경거래 할 수 없습니다. 등록이나 취소 거래를 하십시오."];
                
                return;
            }
            else
            {
//                aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
//                            @"출금계좌번호" : strOutAccNo,
//                            @"출금계좌비밀번호" : self.encriptedPW,
//                            @"입금은행코드" : self.data[@"입금은행코드"],
//                            @"입금계좌번호" : strInAccNo,
//                            @"이체금액" : strInAmount,
//                            @"이체일자" : self.data[@"이체일자"],
//                            @"변경할이체일자" : [_startDateField.textField.text substringFromIndex:8],
//                            @"이체주기" : codeDic[@"이체주기"],
//                            @"이체시작일자" : [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
//                            @"이체종료일자" : [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
//                            @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
//                            }];

                aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                            @"출금계좌번호" : strOutAccNo,
                            @"출금계좌비밀번호" : self.encriptedPW,
                            @"입금은행코드" : self.data[@"입금은행코드"],
                            @"입금계좌번호" : strInAccNo,
                            @"이체금액" : strInAmount,
                            @"이체일자" : [_startDateField.textField.text substringFromIndex:8],
                            @"변경할이체일자" : @"",
                            @"이체주기" : codeDic[@"이체주기"],
                            @"이체시작일자" : [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"이체종료일자" : [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                            }];
                
                switch (processFlag)
                {
                    case 1: // 당행
                    {
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2221" viewController:self] autorelease];
                    }
                        break;
                    case 2: // 타행
                    {
                        aDataSet[@"이체일자"] = @"";
                        aDataSet[@"변경할이체일자"] = [_startDateField.textField.text substringFromIndex:8];
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2224" viewController:self] autorelease];
                    }
                        break;
                    case 3: // 가상
                    {
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2225" viewController:self] autorelease];
                    }
                        break;
                }
            }
            
            self.service.requestData = aDataSet;
            
            serviceType = 5 + processFlag;
            
            [self.service start];
            [aDataSet release];
        }
            break;
        case 112600:    // 취소
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)closeNormalPad:(id)sender
{
    [super closeNormalPad:sender];
    
    [_txtAccountPW becomeFirstResponder];
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 6: // 당행이체
        case 7: // 타행이체
        case 8: // 가상계좌 이체
        {
            NSMutableDictionary *signInfoDic = [[[NSMutableDictionary alloc] initWithDictionary:
                                                 @{
                                                 @"SignDataList" : @[@"제목", @"거래구분", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"입금계좌예금주", @"이체일", @"이체시작일", @"이체종료일", @"이체금액", @"이체주기", @"휴일이체구분", @"받는통장메모", @"내통장메모"],
                                                 @"제목" : @"자동이체 변경을 신청합니다.",
                                                 @"거래구분" : @"자동이체 변경",
                                                 @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                                 @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                                 @"출금계좌번호" : _btnAccountNo.titleLabel.text,
                                                 @"입금은행" : _btnSelectBank.titleLabel.text,
                                                 @"입금계좌번호" : _txtInAccountNo.text,
                                                 @"입금계좌예금주" : aDataSet[@"입금계좌성명"],
                                                 @"이체일" : [NSString stringWithFormat:@"%@일", [_startDateField.textField.text substringFromIndex:8]],
                                                 @"이체시작일" : _startDateField.textField.text,
                                                 @"이체종료일" : _endDateField.textField.text,
                                                 @"이체금액" : [NSString stringWithFormat:@"%@원", _txtInAmount.text],
                                                 @"이체주기" : _btnTransferTerm.titleLabel.text,
                                                 @"휴일이체구분" : _btnHoliday.titleLabel.text,
                                                 @"받는통장메모" : _txtRecvMemo.text,
                                                 @"내통장메모" : _txtSendMemo.text,
                                                 @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                 @"입금은행코드" : aDataSet[@"입금은행코드"],
                                                 @"휴일이체구분CODE" : codeDic[@"휴일이체구분"],
                                                 @"거래구분CODE" : codeDic[@"변경할항목"],
                                                 @"구이체일" : self.data[@"이체일자"],
                                                 @"이체종류CODE" : self.data[@"이체종류"],
                                                 @"이체주기CODE" : codeDic[@"이체주기"],
                                                 @"전문번호" : AppInfo.serviceCode,
                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                 @"_신계좌번호" : self.outAccInfoDic[@"출금계좌번호"],
                                                 }] autorelease];
            
            AppInfo.commonDic = (NSDictionary *)signInfoDic;
            
            SHBAutoTransferEditComfirmViewController *nextViewController = [[[SHBAutoTransferEditComfirmViewController alloc] initWithNibName:@"SHBAutoTransferEditComfirmViewController" bundle:nil] autorelease];
            nextViewController.data = self.data;
            [self.navigationController pushFadeViewController:nextViewController];
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
    if (alertView.tag == 9999 && buttonIndex == alertView.cancelButtonIndex)
    {
           
        SHBPushInfo *openURLManager = [SHBPushInfo instance];
    
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartfundcenter://"]])
        {
        
            [openURLManager requestOpenURL:@"smartfundcenter://" Parm:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id495878508?mt=8"]];
        }
        
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
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
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

            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
        case 1: // 변경할항목
        {
            _btnSelectChange.selected = NO;
            [_btnSelectChange setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"변경할항목"] = self.dataList[anIndex][@"2"];
            
            _btnSelectChange.accessibilityLabel = [NSString stringWithFormat:@"선택된 변경할항목은 %@ 입니다", _btnSelectChange.titleLabel.text];
            _btnSelectChange.accessibilityHint = @"변경할항목을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectChange);
            
            [self defaultValueSetting];
        }
            break;
        case 2:    // 이체주기
        {
            _btnTransferTerm.selected = NO;
            [_btnTransferTerm setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"이체주기"] = self.dataList[anIndex][@"2"];
            _btnTransferTerm.accessibilityLabel = [NSString stringWithFormat:@"선택된 이체주기는 %@ 입니다", _btnTransferTerm.titleLabel.text];
            _btnTransferTerm.accessibilityHint = @"이체주기를 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferTerm);
        }
            break;
        case 3:    // 휴일이체구분
        {
            _btnHoliday.selected = NO;
            [_btnHoliday setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"휴일이체구분"] = self.dataList[anIndex][@"2"];
            _btnHoliday.accessibilityLabel = [NSString stringWithFormat:@"선택된 휴일이체구분은 %@ 입니다", _btnHoliday.titleLabel.text];
            _btnHoliday.accessibilityHint = @"휴일이체구분을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnHoliday);
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
        case 1:    // 변경할항목
        {
            _btnSelectChange.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectChange);
        }
            break;
        case 2:    // 이체주기
        {
            _btnTransferTerm.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferTerm);
        }
            break;
        case 3:    // 휴일이체구분
        {
            _btnHoliday.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnHoliday);
        }
            break;
            
        default:
            break;
    }
}

- (void)defaultValueSetting
{
    _btnAccountNo.enabled = NO;
    _txtInAccountNo.enabled = NO;
    _txtInAmount.enabled = NO;
    _btnTransferTerm.enabled = NO;
    _startDateField.textField.enabled = NO;
    _endDateField.textField.enabled = NO;
    _btnHoliday.enabled = NO;
    _txtRecvMemo.enabled = NO;
    _txtSendMemo.enabled = NO;
    
    NSString *strAccNo = [self.data[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    NSArray *accountArray = [self outAccountList];
    
    for(NSDictionary *dic in accountArray)
    {
        if([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo] ||
           [[dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
        {
            self.outAccInfoDic = dic;
            
            [_btnAccountNo setTitle:dic[@"2"] forState:UIControlStateNormal];
            // 출금계좌가 변경되면 암호 초기화
            if(![dic[@"2"] isEqualToString:_btnAccountNo.titleLabel.text])
            {
                _txtAccountPW.text = @"";
            }
            break;
        }
    }
    
//    [_btnAccountNo setTitle:self.data[@"출금계좌번호"] forState:UIControlStateNormal];
    [_btnSelectBank setTitle:[AppInfo.codeList bankNameFromCode:self.data[@"입금은행코드"]] forState:UIControlStateNormal];
    _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
    _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
    
    _txtInAccountNo.text = self.data[@"_입금계좌번호"];
    _txtInAmount.text = self.data[@"이체금액"];
    _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]];
    [_btnTransferTerm setTitle:self.data[@"이체주기->display"] != nil ? self.data[@"이체주기->display"] : @"1개월" forState:UIControlStateNormal];
    codeDic[@"이체주기"] = self.data[@"이체주기"] != nil ? self.data[@"이체주기"] : @"01";
    _btnTransferTerm.accessibilityLabel = [NSString stringWithFormat:@"선택된 이체주기는 %@ 입니다", _btnTransferTerm.titleLabel.text];
    _btnTransferTerm.accessibilityHint = @"이체주기를 바꾸시려면 이중탭 하십시오";
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    [_startDateField selectDate:[dateFormatter dateFromString:self.data[@"이체시작일자"]] animated:NO];
    
    if(![self.data[@"이체종료일자"] isEqualToString:@""] && self.data[@"이체종료일자"] != nil)
    {
        [_endDateField selectDate:[dateFormatter dateFromString:self.data[@"이체종료일자"]] animated:NO];
    }
    
    [_btnHoliday setTitle:[self.data[@"휴일이체구분"] isEqualToString:@"0"] ? @"휴일익일이체" : @"휴일전일이체" forState:UIControlStateNormal];
    codeDic[@"휴일이체구분"] = self.data[@"휴일이체구분"];
    _btnHoliday.accessibilityLabel = [NSString stringWithFormat:@"선택된 휴일이체구분은 %@ 입니다", _btnHoliday.titleLabel.text];
    _btnHoliday.accessibilityHint = @"휴일이체구분을 바꾸시려면 이중탭 하십시오";
    
    _txtRecvMemo.text = self.data[@"입금계좌통장메모"];
    _txtSendMemo.text = self.data[@"타행수취인명"];

    if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
    {
        switch ([codeDic[@"변경할항목"] intValue]) {
            case 1:
            {
                _txtInAmount.enabled = YES;
            }
                break;
            case 2:
            {
                _endDateField.textField.enabled = YES;
            }
                break;
            case 3:
            {
                _startDateField.textField.enabled = YES;
            }
                break;
            case 4:
            {
                _btnTransferTerm.enabled = YES;
            }
                break;
            case 5:
            {
                _btnAccountNo.enabled = YES;
            }
                break;
            case 6:
            {
                _txtInAccountNo.enabled = YES;
            }
                break;
            case 7:
            {
                _btnHoliday.enabled = YES;
            }
                break;
            case 9:
            {
                _txtRecvMemo.enabled = YES;
                _txtSendMemo.enabled = YES;
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch ([codeDic[@"변경할항목"] intValue]) {
            case 1:
            {
                _endDateField.textField.enabled = YES;
            }
                break;
            case 2:
            {
                _txtInAmount.enabled = YES;
            }
                break;
            case 3:
            {
                _startDateField.textField.enabled = YES;
            }
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
    if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
    {
        switch ([codeDic[@"변경할항목"] intValue]) {
            case 1: // 이체금액
            {
                if([_txtInAmount.text isEqualToString:@"0"])
                {
                    strAlertMessage = @"‘이체금액’은 0원을 입력하실 수 없습니다.";
                    goto ShowAlert;
                }
                
                if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 15 )
                {
                    strAlertMessage = @"‘이체금액’의 입력값이 유효하지 않습니다.";
                    goto ShowAlert;
                }
            }
                break;
            case 2: // 이체종료일
            {
                NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if([startDate intValue] > [endDate intValue])
                {
                    strAlertMessage = @"이체종료일이 이체시작일보다 커야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] == [endDate intValue])
                {
                    strAlertMessage = @"이체시작일자와 이체종료일자를 동일한 날짜로 등록할 수 없습니다.";
                    goto ShowAlert;
                }
            }
                break;
            case 3: // 이체시작일
            {
                NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *minDate = [[SHBUtility dateStringToMonth:0 toDay:1] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if ([strBankName isEqualToString:@"신한은행"] && [startDate intValue] < [minDate intValue])
                {
                    strAlertMessage = @"이체시작일을 현재일자보다 큰 미래일자로 변경하여 주십시오.";
                    goto ShowAlert;
                }
                
                if (![strBankName isEqualToString:@"신한은행"] && [startDate intValue] <= [minDate intValue])
                {
                    strAlertMessage = @"타행 자동이체 시작일은 2영업일 전까지 변경신청하셔야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] > [endDate intValue])
                {
                    strAlertMessage = @"이체종료일이 이체시작일보다 커야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] == [endDate intValue])
                {
                    strAlertMessage = @"이체시작일자와 이체종료일자를 동일한 날짜로 등록할 수 없습니다.";
                    goto ShowAlert;
                }
                
                
            }
                break;
            case 4: // 이체주기
            {
                
            }
                break;
            case 5: // 출금계좌
            {
                if (([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
                    || ([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]))
                {
                    strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
                    goto ShowAlert;
                }
            }
                break;
            case 6: // 입금계좌
            {
                if([strInAccNo length] == 0 ||
                   ([strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 14) ||
                   (![strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 16)){
                    strAlertMessage = @"‘입금계좌’ 입력값이 유효하지 않습니다.";
                    goto ShowAlert;
                }
                
                if([strInAccNo isEqualToString:@"43501001190"] ||
                   [strInAccNo isEqualToString:@"34401162030"] ||
                   [strInAccNo isEqualToString:@"34401199090"] ||
                   [strInAccNo isEqualToString:@"34401093320"] ||
                   [strInAccNo isEqualToString:@"34401197940"] ||
                   [strInAccNo isEqualToString:@"38301000178"] ||
                   [strInAccNo isEqualToString:@"34401198298"] ||
                   [strInAccNo isEqualToString:@"36101100263"] ||
                   [strInAccNo isEqualToString:@"36101102088"] ||
                   [strInAccNo isEqualToString:@"36101103459"] ||
                   [strInAccNo isEqualToString:@"31801093322"] ||
                   [strInAccNo isEqualToString:@"30601236928"] ||
                   [strInAccNo isEqualToString:@"34401197933"] ||
                   [strInAccNo isEqualToString:@"36107101326"] ||
                   [strInAccNo isEqualToString:@"100018666254"] ||
                   [strInAccNo isEqualToString:@"100007460611"] ||
                   [strInAccNo isEqualToString:@"100014301031"] ||
                   [strInAccNo isEqualToString:@"100001298169"] ||
                   [strInAccNo isEqualToString:@"100014159385"] ||
                   [strInAccNo isEqualToString:@"100002114914"] ||
                   [strInAccNo isEqualToString:@"100014199383"] ||
                   [strInAccNo isEqualToString:@"100014283415"] ||
                   [strInAccNo isEqualToString:@"100014868899"] ||
                   [strInAccNo isEqualToString:@"100016904551"] ||
                   [strInAccNo isEqualToString:@"100011897988"] ||
                   [strInAccNo isEqualToString:@"100013946245"] ||
                   [strInAccNo isEqualToString:@"100014159378"] ||
                   [strInAccNo isEqualToString:@"150000497880"] )
                {
                    strAlertMessage = @"증권사계좌는 자동이체등록을 하실 수 없습니다.";
                    goto ShowAlert;
                }
                
                if([strInAccNo length] == 12 && [strBankName isEqualToString:@"신한은행"] &&
                   ([[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] >= 250
                    && [[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] <= 259))
                {
                    strAlertMessage = @"펀드계좌 자동이체는 스마트 펀드센터 앱에서 가능합니다.";
                    goto ShowAlert_fund;
                }
                
                if (([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
                    || ([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]))
                {
                    strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
                    goto ShowAlert;
                }
                
                if([_txtInAccountNo.text isEqualToString:self.data[@"_입금계좌번호"]])
                {
                    strAlertMessage = @"입금계좌를 변경하지 않았습니다.";
                    goto ShowAlert;
                }
            }
                break;
            case 7: // 휴일이체
            {
                
            }
                break;
            case 9: // 통장표시내용
            {
                if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 0 && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] < 5 )
                {
                    strAlertMessage = @"‘받는분 통장표시’ 내용은 한글3자이상 영문숫자 5자이상으로 입력하셔야 합니다.";
                    goto ShowAlert;
                }
                
                if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
                {
                    strAlertMessage = @"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
                    goto ShowAlert;
                }
                
                if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 0 && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] < 5 )
                {
                    strAlertMessage = @"‘보내는분 통장표시’ 내용은 한글3자이상 영문숫자 5자이상으로 입력하셔야 합니다.";
                    goto ShowAlert;
                }
                
                if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
                {
                    strAlertMessage = @"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
                    goto ShowAlert;
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch ([codeDic[@"변경할항목"] intValue]) {
            case 1: // 이체종료일
            {
                NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if([startDate intValue] > [endDate intValue])
                {
                    strAlertMessage = @"이체종료일이 이체시작일보다 커야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] == [endDate intValue])
                {
                    strAlertMessage = @"이체시작일자와 이체종료일자를 동일한 날짜로 등록할 수 없습니다.";
                    goto ShowAlert;
                }
            }
                break;
            case 2: // 이체금액
            {
                if([_txtInAmount.text isEqualToString:@"0"])
                {
                    strAlertMessage = @"‘이체금액’은 0원을 입력하실 수 없습니다.";
                    goto ShowAlert;
                }
                
                if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 15 )
                {
                    strAlertMessage = @"‘이체금액’의 입력값이 유효하지 않습니다.";
                    goto ShowAlert;
                }
            }
                break;
            case 3: // 이체시작일
            {
                NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *minDate = [[SHBUtility dateStringToMonth:0 toDay:1] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if ([strBankName isEqualToString:@"신한은행"] && [startDate intValue] < [minDate intValue])
                {
                    strAlertMessage = @"이체시작일을 현재일자보다 큰 미래일자로 변경하여 주십시오.";
                    goto ShowAlert;
                }
                
                if (![strBankName isEqualToString:@"신한은행"] && [startDate intValue] <= [minDate intValue])
                {
                    strAlertMessage = @"타행 자동이체 시작일은 2영업일 전까지 변경신청하셔야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] > [endDate intValue])
                {
                    strAlertMessage = @"이체종료일이 이체시작일보다 커야 합니다.";
                    goto ShowAlert;
                }
                
                if([startDate intValue] == [endDate intValue])
                {
                    strAlertMessage = @"이체시작일자와 이체종료일자를 동일한 날짜로 등록할 수 없습니다.";
                    goto ShowAlert;
                }
                
                
            }
                break;
                
            default:
                break;
        }
    }
    
ShowAlert_fund:
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:self
												   cancelButtonTitle:@"이동"
												   otherButtonTitles:@"취소",nil] autorelease];
		[alertView show];
        alertView.tag = 9999;
        
		return NO;
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
    
    self.title = @"자동이체";
    self.strBackButtonTitle = @"자동이체 변경 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체 변경" maxStep:3 focusStepNumber:1] autorelease]];
    
    self.contentScrollView.contentSize = CGSizeMake(317, 696);
    contentViewHeight = 696;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222005;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    processFlag = 0;
    cmsFlag = 0;
    
    codeDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
	if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
         [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
	{
        [_btnSelectChange setTitle:@"이체금액" forState:UIControlStateNormal];
        codeDic[@"변경할항목"] = @"1";
    }
    else
    {
        [_btnSelectChange setTitle:@"이체종료일" forState:UIControlStateNormal];
        codeDic[@"변경할항목"] = @"1";
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    // 기간지정 시작
    [_startDateField initFrame:_startDateField.frame];
    [_startDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_startDateField.textField setTextColor:RGB(44, 44, 44)];
    [_startDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_startDateField setDelegate:self];
    [_startDateField setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]]];
//    [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
    _startDateField.textField.enabled = NO;
    
    // 기간지정 종료
    [_endDateField initFrame:_endDateField.frame];
    [_endDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_endDateField.textField setTextColor:RGB(44, 44, 44)];
    [_endDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_endDateField setDelegate:self];
    [_endDateField setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]]];
//    [_endDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
    _endDateField.textField.enabled = NO;

    _txtInAccountNo.strLableFormat = @"입력된 입금계좌는 %@ 입니다";
    _txtInAccountNo.strNoDataLable = @"입력된 입금계좌가 없습니다";
    
    _txtInAmount.strLableFormat = @"입력된 이체금액은 %@ 원입니다";
    _txtInAmount.strNoDataLable = @"입력된 이체금액이 없습니다";
    
    _txtRecvMemo.strLableFormat = @"입력된 받는통장메모는 %@ 입니다";
    _txtRecvMemo.strNoDataLable = @"입력된 받는통장메모가 없습니다. (선택)한글3~7자이내, 영숫자5~14자이내로 입력가능합니다";
    _txtSendMemo.strLableFormat = @"입력된 내통장메모는 %@ 입니다";
    _txtSendMemo.strNoDataLable = @"입력된 내통장메모가 없습니다. (선택)한글3~7자이내, 영숫자5~14자이내로 입력가능합니다";
    
    [self defaultValueSetting];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        if (([self.data[@"입금은행코드"] isEqualToString:@"088"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"021"] ||
             [self.data[@"입금은행코드"] isEqualToString:@"026"] ))
        {
            [_btnSelectChange setTitle:@"이체금액" forState:UIControlStateNormal];
            codeDic[@"변경할항목"] = @"1";
        }
        else
        {
            [_btnSelectChange setTitle:@"이체종료일" forState:UIControlStateNormal];
            codeDic[@"변경할항목"] = @"1";
        }
        
        [self defaultValueSetting];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.encriptedPW = nil;
    
    [codeDic release];
    [_btnAccountNo release];
    [_btnSelectBank release];
    [_lblKorMoney release];
    [_btnTransferTerm release];
    [_btnHoliday release];
    [_txtAccountPW release];
    [_txtInAccountNo release];
    [_txtInAmount release];
    [_txtRecvMemo release];
    [_txtSendMemo release];
    [_startDateField release];
    [_endDateField release];
    [_btnSelectChange release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnAccountNo:nil];
    [self setBtnSelectBank:nil];
    [self setLblKorMoney:nil];
    [self setBtnTransferTerm:nil];
    [self setBtnHoliday:nil];
    [self setTxtAccountPW:nil];
    [self setTxtInAccountNo:nil];
    [self setTxtInAmount:nil];
    [self setTxtRecvMemo:nil];
    [self setTxtSendMemo:nil];
    [self setStartDateField:nil];
    [self setEndDateField:nil];
    [self setBtnSelectChange:nil];
    [super viewDidUnload];
}
@end
