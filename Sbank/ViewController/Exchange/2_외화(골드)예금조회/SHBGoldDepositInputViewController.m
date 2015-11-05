//
//  SHBGoldDepositInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 8..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGoldDepositInputViewController.h"
#import "SHBGoldDepositConfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBExchangeService.h"

#define GOLD_186 186 // 신한골드리슈금적립
#define GOLD_187 187 // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 188 // 달러&골드테크통장

@interface SHBGoldDepositInputViewController ()
{
    int serviceType;
    int accType;
    NSString *encriptedPW;
    NSString *strRate;
    UIView *contentsView;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *strRate;
@property (retain, nonatomic) IBOutlet UIView *contentsView;
- (BOOL)validationCheck;
@end

@implementation SHBGoldDepositInputViewController
@synthesize outAccInfoDic;
@synthesize inAccInfoDic;
@synthesize encriptedPW;
@synthesize strRate;
@synthesize contentsView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch (sender.tag) {
        case 112100:{ // 출금계좌선택
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray;
            
            if(accType == 188){
                tableDataArray = self.inAccInfoDic[@"외환출금계좌리스트"];
            }else{
                tableDataArray = [self outAccountList];
            }
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:accType == 188 ? @"외화출금가능 계좌가 없습니다." : @"원화출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:accType == 188 ? @"외화출금계좌" : @"원화출금계좌"
                                                                          options:tableDataArray
                                                                          CellNib:accType == 188 ? @"SHBAccidentBankBookInfoCell" : @"SHBAccountListPopupCell"
                                                                            CellH:accType == 188 ? 69 : 50
                                                                      CellDispCnt:5
                                                                       CellOptCnt:accType == 188 ? 3: 2];
            
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112200:{ // 잔액조회
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
            
            if(accType == 188){
                _lblBalance.hidden = NO;
                return;
            }
            
            serviceType = 1;
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
        }
            break;
        case 112300:{ // 골드
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
            _inMoneyView.hidden = YES;
            _inGoldView.hidden = NO;
            
            _txtInAmount.text = @"";
            _txtInAmount.enabled = NO;
            _txtInGold1.text = @"0";
            _txtInGold2.text = @"0";
            _txtInGold1.enabled = YES;
            _txtInGold2.enabled = YES;
            
        }
            break;
        case 112301:{ // 원화
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
            
            if(accType != 188){
                _inMoneyView.hidden = NO;
                _inGoldView.hidden = YES;
                _txtInAmount.enabled = YES;
                _txtInGold1.enabled = NO;
                _txtInGold2.enabled = NO;
            }
            _txtInAmount.text = @"";
            _txtInGold1.text = @"0";
            _txtInGold2.text = @"0";
        }
            break;
        case 112900:{ //확인
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
            
            serviceType = 2;
            
            switch (accType) {
                case GOLD_186:{
                    NSString *strBankGubun = self.outAccInfoDic[@"은행구분"];
                    if([strBankGubun isEqualToString:@"6"]) strBankGubun = @"3";
                    
                    NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7031" viewController:self] autorelease];
                    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                         @"원화출금계좌번호" :  strOutAccNo,
                                                                                         @"원화출금계좌비밀번호" : encriptedPW,
                                                                                         @"원화출금계좌은행구분" : strBankGubun,
                                                                                         @"통화코드" : self.inAccInfoDic[@"통화코드"],
                                                                                         @"계좌번호" : strInAccNo,
                                                                                         }] autorelease];
                    
                    if(_btnSelector1.isSelected){ // 골드선택
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtInGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtInGold2.text];
                        
                        self.service.requestData[@"입금기준"] = @"1";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"외화합계"] = strAmount;
                        self.service.requestData[@"원화합계"] = @"";
                    }else{
                        NSString *strAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        
                        self.service.requestData[@"입금기준"] = @"2";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"외화합계"] = @"";
                        self.service.requestData[@"원화합계"] = strAmount;
                    }
                    [self.service start];
                }
                    break;
                case GOLD_187:{
                    NSString *strBankGubun = self.outAccInfoDic[@"은행구분"];
                    if([strBankGubun isEqualToString:@"6"]) strBankGubun = @"3";

                    NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7140" viewController:self] autorelease];
                    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                         @"거래점용계좌번호" : strOutAccNo,
                                                                                         @"거래점용은행구분" : strBankGubun,
                                                                                         @"원화연동계좌번호" :  strOutAccNo,
                                                                                         @"원화연동비밀번호" : encriptedPW,
                                                                                         @"원화연동계좌은행구분" : strBankGubun,
                                                                                         @"통화코드" : self.inAccInfoDic[@"통화코드"],
                                                                                         @"계좌번호" : strInAccNo,
                                                                                         }] autorelease];
                    
                    if(_btnSelector1.isSelected){ // 골드선택
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtInGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtInGold2.text];
                        
                        self.service.requestData[@"입금기준"] = @"1";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"포지션"] = strAmount;
                        self.service.requestData[@"외화합계"] = strAmount;
                        self.service.requestData[@"원화합계"] = @"";
                    }else{
                        NSString *strAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        
                        self.service.requestData[@"입금기준"] = @"2";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"포지션"] = @"";
                        self.service.requestData[@"외화합계"] = @"";
                        self.service.requestData[@"원화합계"] = strAmount;
                    }
                    [self.service start];
                }
                    break;
                case GOLD_188:{
                    NSString *strBankGubun = [self.outAccInfoDic[@"신계좌변환여부"] isEqualToString:@"1"] ? @"1" : self.outAccInfoDic[@"은행구분"];
                    if([strBankGubun isEqualToString:@"6"]) strBankGubun = @"3";

                    NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7440" viewController:self] autorelease];
                    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                         @"거래점용계좌번호" : strOutAccNo,
                                                                                         @"거래점용은행구분" : strBankGubun,
                                                                                         @"외화연동계좌번호" :  strOutAccNo,
                                                                                         @"외화연동비밀번호" : encriptedPW,
                                                                                         @"외화연동계좌은행구분" : strBankGubun,
                                                                                         @"통화코드" : self.inAccInfoDic[@"통화코드"],
                                                                                         @"계좌번호" : strInAccNo,
                                                                                         }] autorelease];
                    
                    if(_btnSelector1.isSelected){ // 골드선택
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtInGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtInGold2.text];
                        
                        self.service.requestData[@"입금기준"] = @"1";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"포지션"] = strAmount;
                        self.service.requestData[@"외화합계"] = strAmount;
                        self.service.requestData[@"외화연동금액"] = strAmount;
                        self.service.requestData[@"달러대체"] = @"";
                    }else{
                        NSString *strAmount = [NSString stringWithFormat:@"%@.%@", [_txtInGold1.text stringByReplacingOccurrencesOfString:@"," withString:@""], _txtInGold2.text];
                        
                        self.service.requestData[@"입금기준"] = @"2";
                        self.service.requestData[@"입금량"] = strAmount;
                        self.service.requestData[@"포지션"] = @"";
                        self.service.requestData[@"외화합계"] = @"";
                        self.service.requestData[@"외화연동금액"] = @"";
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
                case GOLD_186:{
                    AppInfo.commonDic = @{
                                          @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"골드리슈계좌번호", @"적립량(g)", @"적용가격", @"원화출금계좌번호", @"인출 원화금액"],
                                          @"제목" : @"골드적립",
                                          @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                          @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                          @"골드리슈계좌번호" : aDataSet[@"계좌번호"],
                                          @"적립량(g)" : aDataSet[@"포지션"],
                                          @"적용가격" : aDataSet[@"고객환율"],
                                          @"원화출금계좌번호" : aDataSet[@"원화출금계좌번호"],
                                          @"인출 원화금액" : aDataSet[@"원화합계"],
                                          @"통화" : self.inAccInfoDic[@"통화코드"],
                                          @"AccType" : @"186",
                                          @"수신전문" : aDataSet,
                                          @"전문번호" : AppInfo.serviceCode,
                                          };
                }
                    break;
                case GOLD_187:{
                    AppInfo.commonDic = @{
                                          @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"원화출금계좌번호", @"골드리슈계좌번호", @"원화계좌 고객명", @"골드리슈계좌 고객명", @"거래가격", @"통화", @"원화금액", @"입금량(g)"],
                                          @"제목" : @"골드입금",
                                          @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                          @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                          @"원화출금계좌번호" : aDataSet[@"원화연동계좌번호"],
                                          @"골드리슈계좌번호" : aDataSet[@"계좌번호"],
                                          @"원화계좌 고객명" : aDataSet[@"원화연동계좌고객명"],
                                          @"골드리슈계좌 고객명" : aDataSet[@"고객명"],
                                          @"거래가격" : aDataSet[@"고객환율"],
                                          @"통화" : aDataSet[@"통화"],
                                          @"원화금액" : aDataSet[@"원화합계"],
                                          @"입금량(g)" : aDataSet[@"포지션"],
                                          @"골드상품명" : self.inAccInfoDic[@"_계좌이름"],
                                          @"AccType" : @"187",
                                          @"수신전문" : aDataSet,
                                          @"전문번호" : AppInfo.serviceCode,
                                          };
                }
                    break;
                case GOLD_188:{
                    AppInfo.commonDic = @{
                                          @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"외화출금계좌번호", @"골드리슈계좌번호", @"외화계좌 고객명", @"골드리슈계좌 고객명", @"거래가격", @"통화", @"외화출금액(USD)", @"입금량(g)"],
                                          @"제목" : @"골드입금",
                                          @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                          @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                          @"외화출금계좌번호" : aDataSet[@"외화연동계좌번호"],
                                          @"골드리슈계좌번호" : aDataSet[@"계좌번호"],
                                          @"외화계좌 고객명" : aDataSet[@"외화연동계좌고객명"],
                                          @"골드리슈계좌 고객명" : aDataSet[@"고객명"],
                                          @"거래가격" : aDataSet[@"고객환율"],
                                          @"통화" : aDataSet[@"통화"],
                                          @"외화출금액(USD)" : aDataSet[@"달러대체"],
                                          @"입금량(g)" : aDataSet[@"포지션"],
                                          @"골드상품명" : self.inAccInfoDic[@"_계좌이름"],
                                          @"AccType" : @"188",
                                          @"수신전문" : aDataSet,
                                          @"전문번호" : AppInfo.serviceCode,
                                          };
                }
                    break;
                    
                default:
                    break;
            }
            
            SHBGoldDepositConfirmViewController *nextViewController = [[[SHBGoldDepositConfirmViewController alloc] initWithNibName:@"SHBGoldDepositConfirmViewController" bundle:nil] autorelease];
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
                if([dic[@"통화CODE"] isEqualToString:self.inAccInfoDic[@"통화코드"]]){
                    self.strRate = dic[@"전신환매도우대환율"];
                    _lblCurrencyCode.text = [NSString stringWithFormat:@"%@ (우대환율:%@)", self.inAccInfoDic[@"통화코드"], strRate];
                    break;
                }
            }
        }
            break;
        case 8:
        {
            self.strRate = aDataSet[@"매도우대율"];
            _lblCurrencyCode.text = [NSString stringWithFormat:@"%@ (우대환율:%@ USD)", self.inAccInfoDic[@"통화코드"], strRate];
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
	
	if (textField == _txtInAmount || textField == _txtInGold1)
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

	if (textField == _txtInGold2)
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
    self.outAccInfoDic = self.dataList[anIndex];
    [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];

    if(accType == 188){
        _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@", self.outAccInfoDic[@"3"]];
    }
    
    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
    _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
    
    // 출금계좌가 변경되면 암호 초기화
    _txtAccountPW.text = @"";
    
    _lblBalance.hidden = YES;
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
//    NSString *strInAccNo = [_lblInAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if([strOutAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"출금계좌를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
//	if ([[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]
//        || [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
//    {
//        strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
//        goto ShowAlert;
//    }
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = [NSString stringWithFormat:@"‘%@’는 4자리를 입력해 주십시오.", accType == GOLD_188 ? @"외화출금계좌비밀번호" : @"원화계좌비밀번호"] ;
        goto ShowAlert;
    }
    
    if(_btnSelector1.isSelected){
        if(_txtInGold1.text == nil && _txtInGold2.text == nil)
        {
            strAlertMessage = @"‘입금량’의 입력값이 유효하지 않습니다.";
            goto ShowAlert;
        }
        if([_txtInGold1.text length] == 0) _txtInGold1.text = @"0";
        if([_txtInGold2.text length] == 0) _txtInGold2.text = @"0";
        
        if([_txtInGold1.text isEqualToString:@"0"] && [_txtInGold2.text isEqualToString:@"0"])
        {
            strAlertMessage = @"‘입금량’은 0g을 입력하실 수 없습니다.";
            goto ShowAlert;
        }
    }else{
        if(accType == 188){
            if(_txtInGold1.text == nil && _txtInGold2.text == nil)
            {
                strAlertMessage = @"‘입금금액’의 입력값이 유효하지 않습니다.";
                goto ShowAlert;
            }
            if([_txtInGold1.text length] == 0) _txtInGold1.text = @"0";
            if([_txtInGold2.text length] == 0) _txtInGold2.text = @"0";
            
            if([_txtInGold1.text isEqualToString:@"0"] && [_txtInGold2.text isEqualToString:@"0"])
            {
                strAlertMessage = @"‘입금금액’은 0 USD를 입력하실 수 없습니다.";
                goto ShowAlert;
            }
        }else{
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
    
    accType = [[inAccInfoDic[@"계좌번호"] substringToIndex:3] intValue];
    
    switch (accType) {
        case GOLD_186:{
            self.title = @"골드적립";
            self.strBackButtonTitle = @"골드적립 1단계";
            [_btnComfirm setTitle:@"적립" forState:UIControlStateNormal];
            
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드적립 정보입력" maxStep:4 focusStepNumber:2] autorelease]];
        }
            break;
        case GOLD_187:{
            self.title = @"골드입금";
            self.strBackButtonTitle = @"골드입금 1단계";
            
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 정보입력" maxStep:4 focusStepNumber:2] autorelease]];
            
            serviceType = 7;
            
            NSString *strCurDate = [SHBUtility getCurrentDate];
            
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"F1405" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"조회구분" : @"1", @"고시일자09" : strCurDate}] autorelease];
            [self.service start];
        }
            break;
        case GOLD_188:{
            self.title = @"골드입금";
            self.strBackButtonTitle = @"골드입금 1단계";
            
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"골드입금 정보입력" maxStep:4 focusStepNumber:2] autorelease]];

            contentsView.frame = CGRectMake(0, 0, 317, 296);
            
            _lblAccNoCaption.text = [NSString stringWithFormat:@"외화출금\n계좌번호"];
            _lblAccNameCaption.text = [NSString stringWithFormat:@"외화출금\n비밀번호"];
            [_btnSelector2 setTitle:@"달러(USD)" forState:UIControlStateNormal];
            _lblDescript.text = @"(입금기준이 달러: USD 환산금액, 골드: gram)";
            
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
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    _lblInAccNo.text = self.inAccInfoDic[@"_계좌번호"];
    
    [_lblInAccName initFrame:_lblInAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblInAccName setCaptionText:self.inAccInfoDic[@"_계좌이름"]];
    
    _lblCurrencyCode.text = self.inAccInfoDic[@"통화코드"];
    
    NSArray *accountArray;
    
    if(accType == 188){
        accountArray = self.inAccInfoDic[@"외환출금계좌리스트"];
    }else{
        accountArray = [self outAccountList];
    }
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        if(accType == 188){
            _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@", self.outAccInfoDic[@"3"]];
        }
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
    }
    else
    {
        [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        _btnAccountNo.enabled = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
//        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        _lblBalance.hidden = YES;
        _txtInAmount.text = @"0";
        _txtInGold1.text = @"0";
        _txtInGold2.text = @"0";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag =  112300;
        [self buttonTouchUpInside:btn];
        
        NSArray *accountArray;
        
        if(accType == 188){
            accountArray = self.inAccInfoDic[@"외환출금계좌리스트"];
        }else{
            accountArray = [self outAccountList];
        }
        
        if([accountArray count] != 0)
        {
            self.outAccInfoDic = accountArray[0];
            [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
            if(accType == 188){
                _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@", self.outAccInfoDic[@"3"]];
            }
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
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
    self.encriptedPW = nil;
    
    [_btnAccountNo release];
    [_lblBalance release];
    [_txtAccountPW release];
    [_lblInAccNo release];
    [_lblInAccName release];
    [_txtInAmount release];
    
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
    
    [super viewDidUnload];
}

@end
