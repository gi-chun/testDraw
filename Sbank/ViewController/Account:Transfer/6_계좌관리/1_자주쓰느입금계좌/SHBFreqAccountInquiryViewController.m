//
//  SHBFreqAccountInquiryViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqAccountInquiryViewController.h"
#import "SHBAccountService.h"
#import "SHBFreqAccountInquiryCompleteViewController.h"

@interface SHBFreqAccountInquiryViewController ()
{
    int serviceType;
}

@end

@implementation SHBFreqAccountInquiryViewController
@synthesize service;
@synthesize outAccInfoDic;

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지

    if(_txtInAccountNo.text == nil || [_txtInAccountNo.text length] == 0 || [_txtInAccountNo.text length] > 16)
	{
        strAlertMessage = @"입금계좌번호를 정확하게 입력하십시오.";
        goto ShowAlert;
	}

	if(_txtInNickName.text == nil || [_txtInNickName.text length] == 0 || [_txtInNickName.text length] > 24 )
	{
        strAlertMessage = @"'입금계좌별명'을 입력하십시오.";
        goto ShowAlert;
	}
    
    if([_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"43501001190"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401162030"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401199090"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401093320"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401197940"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"38301000178"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401198298"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"36101100263"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"36101102088"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"36101103459"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"31801093322"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"30601236928"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"34401197933"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"36107101326"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100018666254"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100007460611"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014301031"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100001298169"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014159385"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100002114914"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014199383"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014283415"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014868899"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100016904551"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100011897988"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100013946245"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"100014159378"]] ||
	   [_txtInAccountNo.text isEqualToString:[NSString stringWithFormat:@"150000497880"]] )
	{
        strAlertMessage = @"증권사계좌번호는 등록할 수 없습니다.";
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

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
            // 은행선택
        case 10:
        {
            serviceType = 0;

            _btnSelectBank.selected = YES;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"은행목록" options:AppInfo.codeList.bankList CellNib:@"SHBBankListPopupCell" CellH:32 CellDispCnt:9 CellOptCnt:1];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;

            // 최근입금 계좌
        case 20:
        {
            
            serviceType = 1;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2520" viewController: self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }
            break;

            // 확인
        case 30:
        {
            if (![self validationCheck]) {
                return;
            }
            
            int processFlag;
            NSString *strBankName = _btnSelectBank.titleLabel.text;
            NSString *strInAccNo = _txtInAccountNo.text;
            
            if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구조흥은행"])
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
            
            serviceType = 2;

            NSArray *tmpArray = [self outAccountList];
            NSString *strAccount = @"";

            for(NSDictionary *dic in tmpArray)
            {
                if([dic[@"출금계좌번호"] characterAtIndex:0] == '1' )
                {
                    strAccount = [dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    break;
                }
            }
            
            NSLog(@"strAccount =====%@",strAccount);
       
            // 02126 수정 , 2013.11.04 정과장요청 삭제(민원사항 관련)
          //  if ([AppInfo.userInfo[@"최종출금계좌"] length] > 0)
          //  {
          //      strAccount = AppInfo.userInfo[@"최종출금계좌"];
          //  }
            
            if([strAccount isEqualToString:@""])
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
            
            // 서버알럿이 뜨는것을 막고 업무단에서 알럿을 보여주고자 할때
            AppInfo.isBolckServerErrorDisplay = YES;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                    @"입금계좌번호" : _txtInAccountNo.text,
                                    @"입금계좌메모" : _txtInNickName.text,
                                    @"출금계좌번호" : strAccount,
                                    }];
            
            NSString *execCode = @"";
            
            // 은행 구분
            switch (processFlag)
            {
                    // 타행
                case 2:
                    execCode = @"C2233";
                    break;
                    // 가상계좌
                case 3:
                    execCode = @"C2235";
                    // 0216 수정
//                    aDataSet[@"출금계좌번호"] = _txtInAccountNo.text;
                    break;
                    // 당행
                default:
                    execCode = @"C2231";
                    break;
            }
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:execCode viewController: self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];

        }
            break;
            
            // 취소버튼
        case 40:
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
            
            break;
        case 1:
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
            
        case 2:
        case 3:
        {
            NSLog(@"aDataset : %@", aDataSet);
            
            SHBFreqAccountInquiryCompleteViewController *detailViewController = [[SHBFreqAccountInquiryCompleteViewController alloc] initWithNibName:@"SHBFreqAccountInquiryCompleteViewController" bundle:nil];
            
            AppInfo.commonDic = @{
            @"입금은행" : _btnSelectBank.titleLabel.text,
            @"입금계좌" : _txtInAccountNo.text,
            @"계좌별명" : _txtInNickName.text,
            };
            
            //            [self.navigationController pushViewController:detailViewController animated:YES];
            [self.navigationController pushFadeViewController:detailViewController];
            [detailViewController release];
        }
            break;
            
        default:
            break;
    }
    
    return NO;
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
	
	if (textField == _txtInNickName)
    {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()-_=+{}|[]\\;:\'\"<>?,./`~";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		//한글 12자 제한(영문 24자)
		if (dataLength + dataLength2 > 26)
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
		if (dataLength + dataLength2 > 16)
        {
			return NO;
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_txtInNickName.text != nil && [_txtInNickName.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 24 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘입금계좌별명’은  한글 12자, 영숫자 24자 이상을 입력할 수 없습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtInNickName.text = [SHBUtility substring:_txtInNickName.text ToMultiByteLength:24];
	}
}

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch (serviceType) {
        case 0:
        {
            _btnSelectBank.selected = NO;
            [_btnSelectBank setTitle:AppInfo.codeList.bankList[anIndex][@"1"] forState:UIControlStateNormal];
            
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 1:
        {
            [_btnSelectBank setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            
            _txtInNickName.text = @"";//self.dataList[anIndex][@"2"];
            _txtInAccountNo.text = self.dataList[anIndex][@"3"];

            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
            
        default:
            break;
    }
}

- (void)listPopupViewDidCancel
{
    switch (serviceType) {
        case 0:
        {
            _btnSelectBank.selected = NO;
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 1:
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
            
        default:
            break;
    }
}

- (void)getNotiServerError
{
    
    //[self.accountInfo[@"계좌명"] rangeOfString:@"신한 월복리 적금"].location != NSNotFound
    if([AppInfo.serverErrorMessage rangeOfString:@"이미 등록된 계좌"].location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:AppInfo.serverErrorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    
    NSString *strMessage = [NSString stringWithFormat:@"%@", @"[계좌등록 오류] 계좌번호 확인바랍니다.\n\n타행 사정 또는 계좌특성으로 인해 수취인 조회가 불가한 계좌입니다.\n해당 계좌번호가 정확한지 다시 한 번 확인하여 주시기 바랍니다.\n\n해당계좌번호가 정확하며, 자주쓰는 입금계좌로 등록하시겠습니까?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:strMessage
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:@"취소", nil];
    
    alert.tag = 10101;
    [alert show];
    [alert release];
}








#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    switch ([alertView tag])
    {
        case 10101:
        {
            if (buttonIndex == 0)
            {
              serviceType = 3;
            
              NSString *strBankName = _btnSelectBank.titleLabel.text;
            
              SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                    @"입금계좌번호" : _txtInAccountNo.text,
                                    @"입금계좌메모" : _txtInNickName.text,
                                    }];
            
              self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2237" viewController: self] autorelease];
              self.service.requestData = aDataSet;
              [self.service start];
            }
          
        }
            break;
        default:
            break;
    }
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
    // Do any additional setup after loading the view from its nib.
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;

    self.title = @"계좌관리";
    self.strBackButtonTitle = @"자주쓰는입금계좌 입력";
    
    _txtInNickName.accDelegate = self;
    _txtInAccountNo.accDelegate = self;
    
    _txtInAccountNo.strLableFormat = @"입력된 입금계좌는 %@ 입니다";
    _txtInAccountNo.strNoDataLable = @"입력된 입금계좌가 없습니다";

    _txtInNickName.strLableFormat = @"입력된 계좌별명은 %@ 입니다";
    _txtInNickName.strNoDataLable = @"입력된 계좌별명이 없습니다. 한글 12자리, 영문24자리 이내 입력";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 서버 에러 발생시
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotiServerError) name:@"notiServerError" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [_btnSelectBank release];
    [_btnAccountNo release];
    [_btnOk release];
    [_btnCancel release];
    [_txtInAccountNo release];
    [_txtInNickName release];
    
    [super dealloc];
}

@end
