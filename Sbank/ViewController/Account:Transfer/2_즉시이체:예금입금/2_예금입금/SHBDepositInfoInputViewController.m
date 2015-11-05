//
//  SHBDepositInfoInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBDepositInfoInputViewController.h"
#import "SHBDepositComfirmViewController.h"
#import "SHBUtility.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBDepositCompleteViewController.h"
#import "SHBSmartTransferInfoViewController.h"

@interface SHBDepositInfoInputViewController ()
{
    int serviceType;
    NSString *encriptedPW;
}

@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSMutableDictionary *smartTransferDic;

- (BOOL)validationCheck;
@end

@implementation SHBDepositInfoInputViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize inAccInfoDic;
@synthesize encriptedPW;

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
        case 112300:    // 입금
        {
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";

            serviceType = 2;
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2031" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                         @"출금계좌번호" :  strOutAccNo,
                                         @"출금계좌비밀번호" : encriptedPW,
                                         @"입금은행코드" : @"88",
                                         @"입금계좌번호" : strInAccNo,
                                         @"이체금액" : strAmount,
                                         @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                         }] autorelease];
            [self.service start];
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
    if (self.service.serviceId == SMART_ICHE_PUSH_YN) {
        
        NSDictionary *dataDic = nil;
        
        for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
            
            if ([dic[@"상품코드"] isEqualToString:@"230011831"]) {
                
                dataDic = dic;
                
                break;
            }
        }
        
        if (!dataDic) {
            
            SHBSmartTransferInfoViewController *viewController = [[[SHBSmartTransferInfoViewController alloc] initWithNibName:@"SHBSmartTransferInfoViewController" bundle:nil] autorelease];
            
            [self.navigationController pushFadeViewController:viewController];
            
            return NO;
        }
        
        self.smartTransferDic = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  @"고객번호" : AppInfo.customerNo,
                                  @"적금계좌번호" : [dataDic[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]
                                  }];
        
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5082" viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
        
        return NO;
    }
    
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E5082"]) {
        
        // 스마트이체
        
        if ([aDataSet[@"상태구분"] isEqualToString:@"1"] ||
            ([aDataSet[@"적금계좌번호"] length] > 0 && [aDataSet[@"푸쉬계좌번호"] length] > 0)) {
            
            NSString *acc = [aDataSet[@"푸쉬계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *inAcc = [aDataSet[@"적금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
                
                NSDictionary *tmpDic = @{
                                         @"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
                                         @"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
                                         @"은행코드" : [dic objectForKey:@"은행코드"],
                                         @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
                                         @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                         @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
                                         @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
                                         };
                
                NSString *oldAcc = [tmpDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *newAcc = [tmpDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if ([acc isEqualToString:oldAcc] || [acc isEqualToString:newAcc]) {
                    
                    self.outAccInfoDic = tmpDic;
                    
                    [_btnAccountNo setTitle:tmpDic[@"2"] forState:UIControlStateNormal];
                    
                    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
                    _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
                    _lblBalance.hidden = YES;
                }
                
                if ([inAcc isEqualToString:oldAcc] || [inAcc isEqualToString:newAcc]) {
                    
                    if ([newAcc isEqualToString:inAcc]) {
                        
                        [_lblInAccNo setText:tmpDic[@"출금계좌번호"]];
                    }
                    else {
                        
                        [_lblInAccNo setText:tmpDic[@"구출금계좌번호"]];
                    }
                    
                    [_lblInAccName initFrame:_lblInAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
                    [_lblInAccName setCaptionText:tmpDic[@"1"]];
                }
            }
            
            SInt64 money = 0;
            
            if ([aDataSet[@"이체방식설정"] isEqualToString:@"1"] && [aDataSet[@"이체금액설정구분"] isEqualToString:@"1"]) {
                
                // 소득이체방식, 비율 설정
                
                SInt64 trxMoney = [[_smartTransferDic[@"TRXMONEY"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
                CGFloat rate = [aDataSet[@"이체비율"] floatValue] / 100.f;
                
                money = trxMoney * rate;
            }
            else {
                
                money = [[aDataSet[@"이체금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
            }
            
            if (money < 1000) {
                
                money = 1000;
            }
            
            [_txtInAmount setText:[SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", money]]];
            [_lblKorMoney setText:[NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]]];
            
            _txtInAmount.strLableFormat = @"입력된 금액은 %@ 원입니다";
            _txtInAmount.strNoDataLable = @"입력된 금액이 없습니다";
        }
        else {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"현재 S뱅크 스마트이체 설정이 해제된 상태입니다.\n스마트이체 설정을 진행해 주세요."];
            
            [self.navigationController fadePopToRootViewController];
            
            return NO;
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
            long long remainPaymentMoney = 0;
            long long transferMoney = 0;
            
            // D2031전문에서는 @"지불가능잔액->originalValue"가 없다. 그냥 @"지불가능잔액"을 사용하자.
            remainPaymentMoney = [aDataSet[@"지불가능잔액"] longLongValue];
            transferMoney = [aDataSet[@"이체금액->originalValue"] longLongValue];
            
            if (remainPaymentMoney < transferMoney)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"입금하려는 금액이 출금가능잔액을 초과합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }
            
            AppInfo.commonDic = @{
            @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"수취인성명", @"입금금액"],
            @"제목" : @"예금입금",
            @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
            @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
            @"출금계좌번호" : _btnAccountNo.titleLabel.text,
            @"입금은행" : @"신한은행",
            @"입금계좌번호" : _lblInAccNo.text,
            @"수취인성명" : aDataSet[@"입금계좌성명"],
            @"입금금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"이체금액"]],
            @"계좌명" : _lblInAccName.caption1.text,
            @"전문번호" : AppInfo.serviceCode,
            };
            
            if (self.isPushAndScheme) {
                
                if ([self.data[@"serviceid"] isEqualToString:@"lifehabit"]) {
                
                    // 스마트이체
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                    
                    //전자 서명 결과값 받는 옵저버 등록
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
                    
                    //전자 서명 취소를 받는다
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
                    
                    // 전자서명 에러
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
                    
                    AppInfo.eSignNVBarTitle = @"스마트이체";
                    AppInfo.electronicSignString = @"";
                    
                    for (int i = 1; i < [AppInfo.commonDic[@"SignDataList"] count]; i ++) {
                        
                        NSString *strFieldName = AppInfo.commonDic[@"SignDataList"][i];
                        
                        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                                    i,
                                                    strFieldName,
                                                    AppInfo.commonDic[strFieldName]]];
                    }
                    
                    AppInfo.electronicSignCode = @"E5086";
                    AppInfo.electronicSignTitle = @"스마트이체(금리우대)";
                    
                    self.service = nil;
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5086" viewController:self] autorelease];
                    
                    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                     @"출금계좌번호" : [AppInfo.commonDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                                     @"입금계좌번호" : [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                                     @"스마트이체여부" : @"1",
                                                                                     @"푸쉬발송일련번호" : [SHBUtility nilToString:self.data[@"msgid"]],
                                                                                     }] autorelease];
                    self.service.requestData = aDataSet;
                    [self.service start];
                    
                    return NO;
                }
            }
            
            SHBDepositComfirmViewController *nextViewController = [[[SHBDepositComfirmViewController alloc] initWithNibName:@"SHBDepositComfirmViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark - eSign Noti

- (void)getElectronicSignResult:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SHBDepositCompleteViewController *nextViewController = [[[SHBDepositCompleteViewController alloc] initWithNibName:@"SHBDepositCompleteViewController" bundle:nil] autorelease];
    nextViewController.data = @{ @"isSmartTransfer" : @"YES" };
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopViewController];
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
	
	if (textField == _txtInAmount )
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
            
            _lblBalance.hidden = YES;
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
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.btnAccountNo);
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
    NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if([strOutAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"출금계좌를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
	if ([[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]
        || [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
    {
        strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
        goto ShowAlert;
    }
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
	if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 15 )
	{
        strAlertMessage = @"‘입금금액’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
    
	if([_txtInAmount.text isEqualToString:@"0"])
	{
        strAlertMessage = @"‘입금금액’은 0원을 입력하실 수 없습니다.";
        goto ShowAlert;
	}
    
	if ([_lblInAccName.caption1.text hasPrefix:@"Mint(민트) 정기예금"] && [[_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] < 1000000)
    {
        strAlertMessage = @"Mint(민트) 정기예금의 추가입금액은 100만원 이상입니다.";
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

#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic	// 푸쉬로 왔으면
{
	[super executeWithDic:mDic];
    
	if (mDic) {
        self.data = (NSDictionary *)mDic;
	}
}

#pragma mark - 

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

    self.title = @"즉시이체/예금입금";
    self.strBackButtonTitle = @"예금입금 1단계";
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    if (self.isPushAndScheme) {
        
        if ([self.data[@"serviceid"] isEqualToString:@"lifehabit"]) {
        
            // 스마트이체
            
            [self setTitle:@"스마트 이체"];
            self.strBackButtonTitle = @"스마트 이체";
            
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예금입금" maxStep:2 focusStepNumber:1] autorelease]];
            
            // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
            AppInfo.isNeedBackWhenError = YES;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"SEND_SEQ" : [SHBUtility nilToString:self.data[@"msgid"]]
                                      }];
            
            self.service = nil;
            self.service = [[[SHBAccountService alloc] initWithServiceId:SMART_ICHE_PUSH_YN  viewController:self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
            return;
        }
    }
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예금입금" maxStep:3 focusStepNumber:1] autorelease]];
    
    _lblInAccNo.text = self.inAccInfoDic[@"계좌번호"];
    
    [_lblInAccName initFrame:_lblInAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblInAccName setCaptionText:self.inAccInfoDic[@"계좌명"]];
    
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
    
    _txtInAmount.strLableFormat = @"입력된 금액은 %@ 원입니다";
    _txtInAmount.strNoDataLable = @"입력된 금액이 없습니다";
    
    [self inputAlert];
}

- (void)inputAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                    message:@"자동이체를 통해 불입되는 계좌는 본 입금거래와 상관없이 자동이체 스케쥴에 따른 입금이 되오니 반드시 중복입금 여부를 확인 하시기 바랍니다."
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        _lblBalance.hidden = YES;
        _lblKorMoney.text = @"";
        _txtInAmount.text = @"";

        NSArray * accountArray = [self outAccountList];
        
        if([accountArray count] != 0)
        {
            self.outAccInfoDic = accountArray[0];
            [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
            
            // 출금계좌가 변경되면 암호 초기화
            _txtAccountPW.text = @"";
        }
        else
        {
            [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
            _btnAccountNo.enabled = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.encriptedPW = nil;
    self.smartTransferDic = nil;

    [_btnAccountNo release];
    [_lblBalance release];
    [_txtAccountPW release];
    [_lblInAccNo release];
    [_lblInAccName release];
    [_txtInAmount release];
    [_lblKorMoney release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnAccountNo:nil];
    [self setLblBalance:nil];
    [self setTxtAccountPW:nil];
    [self setLblInAccNo:nil];
    [self setLblInAccName:nil];
    [self setTxtInAmount:nil];
    [self setLblKorMoney:nil];

    [super viewDidUnload];
}

@end
