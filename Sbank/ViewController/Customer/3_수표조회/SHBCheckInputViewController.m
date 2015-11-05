//
//  SHBCheckInputViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCheckInputViewController.h"
#import "SHBCheckDetailViewController.h"
#import "SHBCustomerService.h"
#import "SHBAccidentPopupView.h"
#import "SHBCheckHelpInfoView.h"

@interface SHBCheckInputViewController ()
{
    int serviceType;
}
@property (retain, nonatomic) NSMutableArray *checkList; // 수표종류
@end

@implementation SHBCheckInputViewController

- (void)setCheckList
{
    // 수표
    NSArray *nameArray;
    NSArray *checkAmountArray;
    NSArray *codeArray;
    
    nameArray = @[ @"10만원권(13)", @"30만원권(14)", @"50만원권(15)", @"100만원권(16)", @"일반수표(19)" ];
    checkAmountArray = @[ @"100,000", @"300,000", @"500,000", @"1,000,000", @"0" ];
    codeArray = @[ @"13", @"14", @"15", @"16", @"19" ];
    
    for (int i = 0; i < [nameArray count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[nameArray objectAtIndex:i] forKey:@"1"];
        [dic setObject:[checkAmountArray objectAtIndex:i] forKey:@"2"];
        [dic setObject:[codeArray objectAtIndex:i] forKey:@"code"];
        
        [_checkList addObject:dic];
    }

}

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
            // 은행선택
        case 10:
        {
            serviceType = 0;
            
            _btnSelectBank.selected = YES;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"발행은행" options:AppInfo.codeList.bankList CellNib:@"SHBBankListPopupCell" CellH:32 CellDispCnt:9 CellOptCnt:1];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
            // 도움말
        case 20:
        {
            //팝업뷰 오픈
//            SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"도움말" subView2:_viewHelpView];       // 임시 수정
//            [popupView showInView:self.navigationController.view animated:YES];
//            [popupView release];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBCheckHelpInfoView"
                                                           owner:self options:nil];
            SHBCheckHelpInfoView *viewController = (SHBCheckHelpInfoView *)array[0];
            
            SHBAccidentPopupView *popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"도움말"
                                                                             SubViewHeight:216
                                                                            setContentView:viewController] autorelease];
            
            [popupView showInView:self.navigationController.view animated:YES];

        }
            break;
            
            // 수표조회
        case 30:
        {
            serviceType = 1;
            
            if ([_checkList count] == 0)
            {
                [_checkList removeAllObjects];
                
                // 수표
                NSArray *nameArray;
                NSArray *checkAmountArray;
                NSArray *codeArray;
                
                nameArray = @[ @"10만원권(13)", @"30만원권(14)", @"50만원권(15)", @"100만원권(16)", @"일반수표(19)" ];
                checkAmountArray = @[ @"100,000", @"300,000", @"500,000", @"1,000,000", @"0" ];
                codeArray = @[ @"13", @"14", @"15", @"16", @"19" ];

                for (int i = 0; i < [nameArray count]; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    
                    [dic setObject:[nameArray objectAtIndex:i] forKey:@"1"];
                    [dic setObject:[checkAmountArray objectAtIndex:i] forKey:@"2"];
                    [dic setObject:[codeArray objectAtIndex:i] forKey:@"code"];
                    
                    [_checkList addObject:dic];
                }
            }
                
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"수표종류"
                                                                           options:_checkList
                                                                           CellNib:@"SHBFundListCell"
                                                                             CellH:32
                                                                       CellDispCnt:5
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];

        }
            break;
            
            // 확인
        case 40:
        {
            // 수표번호 체크
            if ([_txtInCheckNo.text length] == 0 || [_txtInCheckNo.text length] != 8) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"수표번호 8자리를 입력하여 주십시오."];
                return;
            }
            
            // 발행점 지로코드
            if ([_txtInGiroCode.text length] == 0 || ([_txtInGiroCode.text length] < 6 || [_txtInGiroCode.text length] > 7) ) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"발행점 지로코드를 6~7자 입력하여 주십시오."];
                return;
            }

            // 발행일
            if (![_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"]) {
                if ([_txtInDate.textField.text length] == 0 || [_txtInDate.textField.text length] != 10) {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"발행일을 입력하여 주십시오."];
                    return;
                }
            }
            
            // 수표금액
            if ([_txtInCheckAmount.text length] == 0 || [_txtInCheckAmount.text isEqualToString:@"0"]) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"수표금액을 입력하여 주십시오."];
                return;
            }

            serviceType = 4;
            int execCode;

            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"수표번호" : _txtInCheckNo.text,
                                    @"발행지로코드" : _txtInGiroCode.text,
//                                    @"수표권종구분" : _btnSelectCheck.titleLabel.text,
                                    @"수표금액" : _txtInCheckAmount.text,
                                    }];
            
            if ([AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text] isEqualToString:@"88"] ||  //신한 //구조흥 //구신한
                [AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text] isEqualToString:@"21"] ||
                [AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text] isEqualToString:@"26"] ) {
                
                NSString *tempDate1 = [[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                NSString *tempDate2 = [tempDate1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [aDataSet insertObject:[tempDate2 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                forKey:@"조회일자"
                               atIndex:0];

                if (_txtInDate.textField.text != nil || [_txtInDate.textField.text length] > 0) {
                    NSString *inquiryDate = [_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    [aDataSet insertObject:inquiryDate
                                    forKey:@"발행일"
                                   atIndex:0];
                }

                execCode = EXCHANGE_D5220_SERVICE;
            }
            else {
                [aDataSet insertObject:_txtInDate.textField.text
                                forKey:@"발행일"
                               atIndex:0];
                [aDataSet insertObject:AppInfo.codeList.bankCode[_btnSelectBank.titleLabel.text] forKey:@"은행코드" atIndex:0];
                if([_btnSelectBank.titleLabel.text isEqualToString:@"수협은행"] || [_btnSelectBank.titleLabel.text isEqualToString:@"농협은행"] || [_btnSelectBank.titleLabel.text isEqualToString:@"구)축협"] )
                        [aDataSet insertObject:_txtInVerificationCode.text forKey:@"검증코드" atIndex:0];

                execCode = EXCHANGE_D5230_SERVICE;
            }
            // 수표권종구분
            for (NSDictionary *dic in _checkList) {
                if ([_btnSelectCheck.titleLabel.text isEqualToString:dic[@"1"]]) {
                    [aDataSet insertObject:dic[@"code"]
                                    forKey:@"수표권종구분"
                                   atIndex:0];
                    break;
                }
            }
            
            self.service = nil;
            self.service = [[[SHBCustomerService alloc] initWithServiceId:execCode viewController: self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];

        }
            break;
            
            // 취소
        case 50: {
            [self.navigationController fadePopToRootViewController];
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
            
            break;
        case 1:
        {
        }
            break;
        case 4:
        {
            SHBCheckDetailViewController *nextViewController = [[[SHBCheckDetailViewController alloc] initWithNibName:@"SHBCheckDetailViewController" bundle:nil] autorelease];

            NSString *ContentFlag = @"-2";  //초기값 변경...
            
            if (self.service.serviceId == EXCHANGE_D5230_SERVICE) {    // 타행
                
                if ([aDataSet[@"응답코드"] isEqualToString:@"000"]) {
                    ContentFlag = @"0"; // 정상
                }
                else {
                    ContentFlag = @"-1"; // 응답내용
                }

                [aDataSet insertObject:@"1"
                                forKey:@"당행여부"
                               atIndex:0];
                
            }
            else { // 당행 D5220
                // song2 - 20100213
                int action1 = [aDataSet[@"원장상태"] intValue]; //   원장상태
                int action2 = [aDataSet[@"사고여부"] intValue]; //   사고여부
                
                NSLog(@"action1 = %d, action2 = %d ",action1 , action2);
                
                if (action1 == 0 && action2 == 0)
                    ContentFlag = @"3"; // 사용불가
                else if (action1 == 1 && action2 == 0)
                    ContentFlag = @"0"; // 정상
                else if (action1 == 1 && action2 == 1)
                    ContentFlag = @"1"; // 사고
                else if (action1 == 2 && action2 == 0)
                    ContentFlag = @"2"; // 지급
                else if (action1 == 3 && action2 == 0)
                    ContentFlag = @"3";
                else if (action1 == 4 && action2 == 0)
                    ContentFlag = @"0";
                else if (action1 == 7 && action2 == 0)
                    ContentFlag = @"2";
                else if (action1 == 14 && action2 == 0)
                    ContentFlag = @"3";

                [aDataSet insertObject:@"0"
                                forKey:@"당행여부"
                               atIndex:0];
                
            }

            [aDataSet insertObject:ContentFlag
                            forKey:@"CHECK-CONTENTS"
                           atIndex:0];
            // 발행은행 추가
            [aDataSet insertObject:_btnSelectBank.titleLabel.text
                            forKey:@"발행은행"
                           atIndex:0];
            AppInfo.commonDic = aDataSet;
            
            nextViewController.strMenuTitle = self.strMenuTitle;
            [self.navigationController pushFadeViewController:nextViewController];

        }
            break;
        default:
            break;
    }
    
    return YES;
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
    
    if (textField == _txtInCheckNo ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 8)
        {
			return NO;
		}
	}

    if (textField == _txtInGiroCode ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 7)
        {
			return NO;
		}
	}

    if (textField == _txtInCheckAmount && !_txtInCheckAmount.hidden ) {
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
		} else {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
//                _labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
//                _labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
        }
        
	}

    if (textField == _txtInVerificationCode ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 20)
        {
			return NO;
		}
	}

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
//    if (textField == _txtInGiroCode)
//    {
//        if ([_txtInGiroCode.text length] > 7) {
//            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"발행지점지로코드는 6~7자리까지 입력가능 합니다."];
//            _txtInGiroCode.text = [_txtInGiroCode.text substringToIndex:7];
//        }
//    }

    if (textField == _txtInCheckAmount)
    {
        _labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
//        if ([_txtInCheckAmount.text length] > 13) {
//            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"수표금액은 13자리까지 입력가능 합니다."];
//            
//            _txtInCheckAmount.text = [SHBUtility normalStringTocommaString:[_txtInCheckAmount.text substringToIndex:13]];
//        } else {
//            _txtInCheckAmount.text = [SHBUtility normalStringTocommaString:textField.text] ;
//            _labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
//        }
    }

}

#pragma mark -
#pragma mark Notifications

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch (serviceType) {
        case 0:
        {
            _btnSelectBank.selected = NO;
            [_btnSelectBank setTitle:AppInfo.codeList.bankList[anIndex][@"1"] forState:UIControlStateNormal];
            
            if([_btnSelectBank.titleLabel.text isEqualToString:@"수협은행"] || [_btnSelectBank.titleLabel.text isEqualToString:@"농협은행"] || [_btnSelectBank.titleLabel.text isEqualToString:@"구)축협"] ) {
                _txtInVerificationCode.enabled = YES;
            } else {
                _txtInVerificationCode.enabled = NO;
            }
        }
            break;
        case 1:
        {
            [_btnSelectCheck setTitle:[[_checkList objectAtIndex:anIndex] objectForKey:@"1"]
                       forState:UIControlStateNormal];

            _txtInCheckAmount.text = [[_checkList objectAtIndex:anIndex] objectForKey:@"2"];
            _labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInCheckAmount.text]];

            if ([_btnSelectCheck.titleLabel.text isEqualToString:@"일반수표(19)"]) {
                _txtInCheckAmount.enabled = YES;
            } else {
                _txtInCheckAmount.enabled = NO;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)listPopupViewDidCancel
{
}

#pragma mark - Delegate : SHBDateFieldDelegate
//- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
//{
////	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
////    [dateField setDate:date];
//}
//
//- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date
//{
////	NSLog(@"=====>>>>>>> [11] DatePicker 데이터 변경시");
//    [dateField setDate:date];
//}
//
//- (void)didPrevButtonTouchWithdateField:(SHBDateField*)dateField
//{
////	NSLog(@"=====>>>>>>> [12] DatePicker 이전버튼");
//}
//
//- (void)didNextButtonTouchWithdateField:(SHBDateField*)dateField
//{
////	NSLog(@"=====>>>>>>> [13] DatePicker 다음버튼");
//}

- (void)currentDateField:(SHBDateField *)dateField
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];

//	NSLog(@"=====>>>>>>> [14] 현재 데이트 피커 : 데이트 피커의 위치이동이 필요할시 작성");
    
}


- (void)dealloc {
    _checkList = nil;
    [_btnSelectBank release];
    [_btnSelectCheck release];
    [_btnOk release];
    [_btnCancel release];
    [_txtInCheckNo release];
    [_txtInGiroCode release];
    [_txtInCheckAmount release];
    [_txtInVerificationCode release];
    [_strMenuTitle release];
    [_labelCheckInputTitle release];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.strMenuTitle isEqualToString:@"수표조회"]) {
        self.title = @"수표조회";
        _labelCheckInputTitle.text = @"수표조회";
    } else {
        self.title = @"사고신고 조회";
        _labelCheckInputTitle.text = @"수표 사고신고 조회";
    }
    
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ 메인", self.title];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222003;
    
    _checkList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setCheckList];
    
    // 발행일
//    [_txtInDate setDelegate:self];
    [_txtInDate initFrame:_txtInDate.frame];
    _txtInDate.textField.font = [UIFont systemFontOfSize:14];
    _txtInDate.textField.textAlignment = UITextAlignmentLeft;
    _txtInDate.delegate = self;
    [_txtInDate selectDate:[NSDate date] animated:NO];
    _txtInDate.textField.text = @"";
    
    // 수표번호
    [_txtInCheckNo setAccDelegate:self];
    
    // 발행지점지로코드
    [_txtInGiroCode setAccDelegate:self];
    
    // 수표금액
    [_txtInCheckAmount setAccDelegate:self];
    
    // 검증코드
    [_txtInVerificationCode setAccDelegate:self];
    
    // 비활성화
    _txtInCheckAmount.enabled = NO;
    _txtInVerificationCode.enabled = NO;
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
