//
//  SHBGoldPaymentInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldPaymentInputViewController.h"
#import "SHBGoldPaymentConfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBExchangeService.h"

#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"
#import "SHBScrollLabel.h"

#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldPaymentInputViewController ()<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    NSDictionary *inAccInfoDic;
    int serviceType;
    int accType;
    NSString *encriptedPW;
    NSString *strRate;
}
@property (retain, nonatomic) NSDictionary *inAccInfoDic;
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *strRate;

@property (retain, nonatomic) IBOutlet UILabel *lblAccNoCaption;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet UILabel *lblAccNo;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyCode;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;
@property (retain, nonatomic) IBOutlet UILabel *lblDescript;

@property (retain, nonatomic) IBOutlet UIView *moneyView;
@property (retain, nonatomic) IBOutlet SHBTextField *txtAmount;

@property (retain, nonatomic) IBOutlet UIView *goldView;
@property (retain, nonatomic) IBOutlet SHBTextField *txtGold1;
@property (retain, nonatomic) IBOutlet SHBTextField *txtGold2;
@property (retain, nonatomic) IBOutlet UIButton *btnComfirm;

- (BOOL)validationCheck;

@end

@implementation SHBGoldPaymentInputViewController
@synthesize accountInfo;
@synthesize inAccInfoDic;
@synthesize encriptedPW;
@synthesize strRate;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch (sender.tag) {
        case 112100:{ // 입금계좌선택
            _btnAccountNo.selected = YES;
            
            if ([self.dataList count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:accType == 188 ? @"외화입금가능 계좌가 없습니다." : @"원화입금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:accType == 188 ? @"외화입금계좌" : @"원화입금계좌"
                                                                          options:[NSMutableArray arrayWithArray:self.dataList]
                                                                          CellNib:accType == 188 ? @"SHBAccidentBankBookInfoCell" : @"SHBAccountListPopupCell"
                                                                            CellH:accType == 188 ? 69 : 50
                                                                      CellDispCnt:5
                                                                       CellOptCnt:accType == 188 ? 3: 2];
            
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112300:{ // 골드
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
            _moneyView.hidden = YES;
            _goldView.hidden = NO;
            
            _txtAmount.text = @"";
            _txtAmount.enabled = NO;
            _txtGold1.text = @"0";
            _txtGold2.text = @"0";
            _txtGold1.enabled = YES;
            _txtGold2.enabled = YES;
            
        }
            break;
        case 112301:{ // 원화
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
            
            if(accType != 188){
                _moneyView.hidden = NO;
                _goldView.hidden = YES;
                _txtAmount.enabled = YES;
                _txtGold1.enabled = NO;
                _txtGold2.enabled = NO;
            }
            _txtAmount.text = @"";
            _txtGold1.text = @"0";
            _txtGold2.text = @"0";
        }
            break;
        case 112900:{ //확인
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
            
            serviceType = 2;

            NSString *strInAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strOutAccNo = nil;
           // NSString *strOutAccNo = [_lblAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            switch (accType) {
                case GOLD_187:{
                    NSString *strBankGubun = self.accountInfo[@"은행구분"];
                    if([strBankGubun isEqualToString:@"6"]) strBankGubun = @"3";
                    
                    
                    if ([strBankGubun isEqualToString:@"3"])   // 구계좌 일때 수정요청 와서 수정된 사항임 (D7130일때 )
                    {
                        strOutAccNo = self.accountInfo[@"구계좌번호"]; // 구계좌
                    }
                    else
                    {
                        strOutAccNo = [_lblAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];  // 신계좌
                    }
                                    
                    
                    
                    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7130" viewController:self] autorelease];
                    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                         @"연동입금계좌번호2" : strInAccNo,
                                                                                         @"은행코드2" : inAccInfoDic[@"은행구분"],
                                                                                         @"계좌번호" : strOutAccNo,
                                                                                         @"비밀번호외화" : encriptedPW,
                                                                                         @"은행구분" : strBankGubun,
                                                                                         @"거래점용계좌번호" : strOutAccNo,
                                                                                         @"거래점용은행구분" : strBankGubun,
                                                                                         @"통화코드" : self.accountInfo[@"통화코드"],
                                                                                         }] autorelease];
                    
                    if(_btnSelector1.isSelected){ // 골드선택
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtGold2.text];
                        
                        self.service.requestData[@"출금기준"] = @"1";
                        self.service.requestData[@"출금량"] = strAmount;
                        self.service.requestData[@"POSITION"] = strAmount;
                        self.service.requestData[@"외화합계"] = strAmount;
                        self.service.requestData[@"원화합계"] = @"";
                    }else{
                        NSString *strAmount = [_txtAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        
                        self.service.requestData[@"출금기준"] = @"2";
                        self.service.requestData[@"출금량"] = strAmount;
                        self.service.requestData[@"POSITION"] = @"";
                        self.service.requestData[@"외화합계"] = @"";
                        self.service.requestData[@"원화합계"] = strAmount;
                    }
                    [self.service start];
                }
                    break;
                case GOLD_188:{
                    NSString *strBankGubun = [self.accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? @"1" : self.accountInfo[@"은행구분"];
                    if([strBankGubun isEqualToString:@"6"]) strBankGubun = @"3";

                    NSString *strBankGubun2 = [self.inAccInfoDic[@"신계좌변환여부"] isEqualToString:@"1"] ? @"1" : self.inAccInfoDic[@"은행구분"];
                    if([strBankGubun2 isEqualToString:@"6"]) strBankGubun2 = @"3";
                    
                    
                    
                    
                    
                    
                    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7430" viewController:self] autorelease];
                    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                         @"연동입금계좌번호1" : strInAccNo,
                                                                                         @"은행코드1" : strBankGubun2,
                                                                                         @"계좌번호" : strOutAccNo,
                                                                                         @"비밀번호외화" : encriptedPW,
                                                                                         @"은행구분" : strBankGubun,
                                                                                         @"거래점용계좌번호" : strOutAccNo,
                                                                                         @"거래점용은행구분" : strBankGubun,
                                                                                         @"통화코드" : self.accountInfo[@"통화코드"],
                                                                                         }] autorelease];
                    
                    if(_btnSelector1.isSelected){ // 골드선택
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtGold2.text];
                        
                        self.service.requestData[@"출금기준"] = @"1";
                        self.service.requestData[@"출금량"] = strAmount;
                        self.service.requestData[@"POSITION"] = strAmount;
                        self.service.requestData[@"외화합계"] = strAmount;
                        self.service.requestData[@"달러대체"] = @"";
                    }else{
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtGold2.text];
                        
                        self.service.requestData[@"출금기준"] = @"2";
                        self.service.requestData[@"출금량"] = strAmount;
                        self.service.requestData[@"POSITION"] = @"";
                        self.service.requestData[@"외화합계"] = @"";
                        self.service.requestData[@"달러대체"] = strAmount;
                    }
                    [self.service start];
                }
                    break;
                    
                default:
                    break;
            }
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
        case 1:
        {
            _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@원", aDataSet[@"지불가능잔액"]];
            _lblBalance.hidden = NO;
        }
            break;
        case 2:
        {
            switch (accType) {
                case GOLD_187:{
                    AppInfo.commonDic = @{
                                          @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"골드리슈계좌번호", @"원화입금계좌번호", @"골드리슈계좌 고객명", @"원화계좌 고객명", @"거래가격", @"통화", @"지급량(g)", @"원화 평가금액", @"소득세", @"지방소득세", @"원화 입금금액"],
                                          @"제목" : @"골드출금",
                                          @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                          @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                          @"골드리슈계좌번호" : aDataSet[@"계좌번호"],
                                          @"원화입금계좌번호" : aDataSet[@"연동입금계좌번호2"],
                                          @"골드리슈계좌 고객명" : aDataSet[@"외화예금고객명"],
                                          @"원화계좌 고객명" : aDataSet[@"연동원화고객명"],
                                          @"거래가격" : aDataSet[@"고객환율"],
                                          @"통화" : aDataSet[@"통화코드"],
                                          @"지급량(g)" : aDataSet[@"외화합계"],
                                          @"원화 평가금액" : aDataSet[@"원화합계"],
                                          @"소득세" : aDataSet[@"소득세"],
                                          @"지방소득세" : aDataSet[@"지방소득세"],
                                          @"원화 입금금액" : aDataSet[@"세후지급금액"],
                                          @"골드상품명" : self.accountInfo[@"_계좌이름"],
                                          @"AccType" : @"187",
                                          @"수신전문" : aDataSet,
                                          @"전문번호" : AppInfo.serviceCode,
                                          };
                }
                    break;
                case GOLD_188:{
                    AppInfo.commonDic = @{
                                          @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"골드리슈계좌번호", @"외화입금계좌번호", @"골드리슈계좌 고객명", @"외화계좌 고객명", @"거래가격(USD)", @"통화", @"지급량(g)", @"외화입금액(USD)", @"소득세", @"지방소득세"],
                                          @"제목" : @"골드출금",
                                          @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                          @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                          @"골드리슈계좌번호" : aDataSet[@"계좌번호"],
                                          @"외화입금계좌번호" : aDataSet[@"연동입금계좌번호1"],
                                          @"골드리슈계좌 고객명" : aDataSet[@"외화예금고객명"],
                                          @"외화계좌 고객명" : aDataSet[@"연동외화고객명"],
                                          @"거래가격(USD)" : aDataSet[@"고객환율"],
                                          @"통화" : aDataSet[@"통화코드"],
                                          @"지급량(g)" : aDataSet[@"포지션"],
                                          @"외화입금액(USD)" : aDataSet[@"달러대체"],
                                          @"소득세" : aDataSet[@"소득세"],
                                          @"지방소득세" : aDataSet[@"지방소득세"],
                                          @"골드상품명" : self.accountInfo[@"_계좌이름"],
                                          @"AccType" : @"188",
                                          @"수신전문" : aDataSet,
                                          @"전문번호" : AppInfo.serviceCode,
                                          };
                }
                    break;
                    
                default:
                    break;
            }
            
            SHBGoldPaymentConfirmViewController *nextViewController = [[[SHBGoldPaymentConfirmViewController alloc] initWithNibName:@"SHBGoldPaymentConfirmViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 7:
        {
            for(NSDictionary *dic in [aDataSet arrayWithForKey:@"조회내역"]){
                if([dic[@"통화CODE"] isEqualToString:self.accountInfo[@"통화코드"]]){
                    self.strRate = dic[@"전신환매입우대환율"];
                    _lblCurrencyCode.text = [NSString stringWithFormat:@"%@ (우대환율:%@)", self.accountInfo[@"통화코드"], strRate];
                    break;
                }
            }
        }
            break;
        case 8:
        {
            self.strRate = aDataSet[@"매입우대율"];
            _lblCurrencyCode.text = [NSString stringWithFormat:@"%@ (우대환율:%@)", self.accountInfo[@"통화코드"], strRate];
        }
            break;
            
        default:
            break;
    }
    
    self.service = nil;
    
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
	
	if (textField == _txtAmount || textField == _txtGold1)
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
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
				return NO;
			}
		}
	}
    
	if (textField == _txtGold2)
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
		if (dataLength + dataLength2 > 2)
        {
			return NO;
		}
	}
	
    return YES;
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    _btnAccountNo.selected = NO;
    [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
    self.inAccInfoDic = self.dataList[anIndex];
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
    
    NSString *strAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if([strAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"입금계좌를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
    if(!([_txtAccountPW.text length] >= 4 && [_txtAccountPW.text length] <= 6)){
        strAlertMessage = @"‘골드계좌비밀번호’는 4~6자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
    if(_btnSelector1.isSelected){
        if(_txtGold1.text == nil && _txtGold2.text == nil)
        {
            strAlertMessage = @"‘출금량’의 입력값이 유효하지 않습니다.";
            goto ShowAlert;
        }
        if([_txtGold1.text length] == 0) _txtGold1.text = @"0";
        if([_txtGold2.text length] == 0) _txtGold2.text = @"0";
        
        if([_txtGold1.text isEqualToString:@"0"] && [_txtGold2.text isEqualToString:@"0"])
        {
            strAlertMessage = @"‘출금량’은 0g을 입력하실 수 없습니다.";
            goto ShowAlert;
        }
    }else{
        if(accType == 188){
            if(_txtGold1.text == nil && _txtGold2.text == nil)
            {
                strAlertMessage = @"‘출금금액’의 입력값이 유효하지 않습니다.";
                goto ShowAlert;
            }
            if([_txtGold1.text length] == 0) _txtGold1.text = @"0";
            if([_txtGold2.text length] == 0) _txtGold2.text = @"0";
            
            if([_txtGold1.text isEqualToString:@"0"] && [_txtGold2.text isEqualToString:@"0"])
            {
                strAlertMessage = @"‘출금금액’은 0 USD를 입력하실 수 없습니다.";
                goto ShowAlert;
            }
        }else{
            if(_txtAmount.text == nil || [_txtAmount.text length] == 0 || [_txtAmount.text length] > 15 )
            {
                strAlertMessage = @"‘출금금액’의 입력값이 유효하지 않습니다.";
                goto ShowAlert;
            }
            if([_txtAmount.text isEqualToString:@"0"])
            {
                strAlertMessage = @"‘출금금액’은 0원을 입력하실 수 없습니다.";
                goto ShowAlert;
            }
        }
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
    accType = [[accountInfo[@"계좌번호"] substringToIndex:3] intValue];

    self.title = @"골드출금";
    self.strBackButtonTitle = @"골드출금 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드출금 정보입력" maxStep:4 focusStepNumber:2] autorelease]];
    
    switch (accType) {
        case GOLD_187:{
            serviceType = 7;

            _lblBalance.text = [NSString stringWithFormat:@"* 출금가능그램 : %@ (g)\n* 평가금액 : %@ (원)", self.accountInfo[@"외화잔액"], self.accountInfo[@"평가금액"]];
            
            NSString *strCurDate = [SHBUtility getCurrentDate];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"F1405" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"조회구분" : @"1", @"고시일자09" : strCurDate}] autorelease];
            [self.service start];
        }
            break;
        case GOLD_188:{
            _lblAccNoCaption.text = [NSString stringWithFormat:@"외화입금\n계좌번호"];
            [_btnSelector2 setTitle:@"달러(USD)" forState:UIControlStateNormal];
            _lblDescript.text = @"(출금기준이 달러: USD 환산금액, 골드: gram)";
            _lblBalance.text = [NSString stringWithFormat:@"* 출금가능그램 : %@ (g)\n* 평가금액 : %@ (USD)", self.accountInfo[@"외화잔액"], self.accountInfo[@"평가금액"]];
            
            serviceType = 8;
            
            NSString *strCurDate = [SHBUtility getCurrentDate];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"F1406" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"조회구분" : @"1", @"고시일자1" : strCurDate, @"고시일자2" : strCurDate}] autorelease];
            [self.service start];
        }
            break;
            
        default:
            break;
    }
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222003;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
    
    _lblAccNo.text = self.accountInfo[@"_계좌번호"];
    
    [_lblAccName initFrame:_lblAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblAccName setCaptionText:self.accountInfo[@"_계좌이름"]];
    
    _lblCurrencyCode.text = self.accountInfo[@"통화코드"];
    
    if(accType == 188){
        self.dataList = self.accountInfo[@"외환입금계좌리스트"];
        if([self.dataList count] != 0)
        {
            [_btnAccountNo setTitle:self.dataList[0][@"2"] forState:UIControlStateNormal];
            self.inAccInfoDic = self.dataList[0];
        }
        else
        {
            [_btnAccountNo setTitle:@"외화입금계좌정보가 없습니다." forState:UIControlStateNormal];
            _btnAccountNo.enabled = NO;
        }
    }
    else if (accType == 187) {
        
        NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        
        for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
        {
            NSInteger account = [[dic[@"계좌번호"] substringToIndex:3] integerValue];
            
            if (160 > account) {
                
                [tableDataArray addObject:@{
                                            @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                                            @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                            @"은행코드" : [dic objectForKey:@"은행코드"],
                                            @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
                                            @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                            @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
                                            @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
                                            }];
            }
        }
        
        self.dataList = (NSArray *)tableDataArray;
        
        if([self.dataList count] != 0)
        {
            [_btnAccountNo setTitle:self.dataList[0][@"2"] forState:UIControlStateNormal];
            self.inAccInfoDic = self.dataList[0];
        }
        else
        {
            [_btnAccountNo setTitle:@"원화입금계좌정보가 없습니다." forState:UIControlStateNormal];
            _btnAccountNo.enabled = NO;
        }
    }
    else{
        NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        
        for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
        {
            if([dic[@"입금가능여부"] isEqualToString:@"1"]) // 정상교과장의 요청으로 예금종류 1 인 경우에서 바뀜(2013.04.03)
            {
                [tableDataArray addObject:@{
                                            @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                                            @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                            @"은행코드" : [dic objectForKey:@"은행코드"],
                                            @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
                                            @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                            @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
                                            @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
                                            }];
            }
        }
        
        self.dataList = (NSArray *)tableDataArray;
        
        if([self.dataList count] != 0)
        {
            [_btnAccountNo setTitle:self.dataList[0][@"2"] forState:UIControlStateNormal];
            self.inAccInfoDic = self.dataList[0];
        }
        else
        {
            [_btnAccountNo setTitle:@"원화입금계좌정보가 없습니다." forState:UIControlStateNormal];
            _btnAccountNo.enabled = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        _txtAmount.text = @"0";
        _txtGold1.text = @"0";
        _txtGold2.text = @"0";

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag =  112300;
        [self buttonTouchUpInside:btn];
        
        if([self.dataList count] != 0)
        {
            [_btnAccountNo setTitle:self.dataList[0][@"2"] forState:UIControlStateNormal];
            self.inAccInfoDic = self.dataList[0];
        }
        else
        {
            if(accType == 188){
                [_btnAccountNo setTitle:@"외화입금계좌정보가 없습니다." forState:UIControlStateNormal];
                _btnAccountNo.enabled = NO;
            }else{
                [_btnAccountNo setTitle:@"원화입금계좌정보가 없습니다." forState:UIControlStateNormal];
                _btnAccountNo.enabled = NO;
            }
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
    self.encriptedPW = nil;
    
    [_btnAccountNo release];
    [_lblBalance release];
    [_txtAccountPW release];
    [_lblAccNo release];
    [_lblAccName release];
    [_txtAmount release];
    [_txtGold1 release];
    [_txtGold2 release];
    
    [super dealloc];
}
@end
