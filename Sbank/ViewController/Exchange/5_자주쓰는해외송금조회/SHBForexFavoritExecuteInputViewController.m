//
//  SHBForexFavoritExecuteInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritExecuteInputViewController.h"
#import "SHBExchangeService.h" // 서비스

#import "SHBForexFavoritExecuteConfirmViewController.h" // 자주쓰는 해외송금 정보확인

#import "SHBListPopupView.h" // list popup
#import "SHBExchangePopupView.h" // list popup

/// list popup tag
enum FAVORIT_LISTPOPUP_TAG {
    FAVORIT_LISTPOPUP_SENDCLASS = 2001,
    FAVORIT_LISTPOPUP_CURRENCY,
    FAVORIT_LISTPOPUP_BANKCOUNTRY,
    FAVORIT_LISTPOPUP_BREAKDOWN,
    FAVORIT_LISTPOPUP_FOREIGNACCOUNTNUMBER,
    FAVORIT_LISTPOPUP_WONACCOUNTNUMBER
};

@interface SHBForexFavoritExecuteInputViewController ()
<SHBListPopupViewDelegate>
{
    BOOL _isOkBtn; // 확인버튼 눌렀는지 여부
    BOOL _isForeign; // 외화계좌 확인 조회 여부
}

@property (retain, nonatomic) NSArray *textFieldList;
@property (retain, nonatomic) NSMutableArray *sendClassList; // 송금구분
@property (retain, nonatomic) NSMutableArray *currencyList; // 통화구분
@property (retain, nonatomic) NSMutableArray *bankCountryList; // 수취은행국가명
@property (retain, nonatomic) NSMutableArray *breakdownList; // 재산반출내역
@property (retain, nonatomic) NSMutableArray *foreignAccountNumberList; // 외화출금 계좌번호
@property (retain, nonatomic) NSMutableArray *wonAccountNumberList; // 원화출금 계좌번호

@property (retain, nonatomic) NSString *encriptedForeignPasswd; // 외화출금계좌 비밀번호
@property (retain, nonatomic) NSString *encriptedWonPasswd; // 원화출금계좌 비밀번호
@property (retain, nonatomic) NSString *encriptedJumin; // 유학생주민등록번호

@property (retain, nonatomic) NSMutableDictionary *selectSendClassDic; // 선택된 송금구분
@property (retain, nonatomic) NSMutableDictionary *selectCurrencyDic; // 선택된 통화구분
@property (retain, nonatomic) NSMutableDictionary *selectBankCountryDic; // 선택된 수취은행국가명
@property (retain, nonatomic) NSMutableDictionary *selectForeignAccountDic; // 선택된 외화출금 계좌번호
@property (retain, nonatomic) NSMutableDictionary *selectWonAccountDic; // 선택된 원화출금 계좌번호

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

/// 버튼 상태 체크
- (BOOL)buttonCheck:(UIButton *)button;

/// 수수료 구하기
- (Float64)getFee;

/// 송금 금액
- (Float64)getTotalMoney;

/// 외화출금 금액
- (Float64)getForeignMoney;

/// 원화인출 금액
- (void)setWonWithDrawal;

/**
 은행타입
 @param type 은행타입
 */
- (NSString *)getBankType:(NSString *)type;

/// F2027 전문
- (void)serviceF2027;

@end

@implementation SHBForexFavoritExecuteInputViewController

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
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    self.strBackButtonTitle = @"자주쓰는 해외송금 1단계";
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    self.textFieldList = @[ _remittance1, _remittance2, _jumin, _foreignWithDrawal1, _foreignWithDrawal2,
                            _foreignPasswd, _wonPasswd, ];
    
    [self setTextFieldTagOrder:_textFieldList];
    
    _isOkBtn = NO;
    _isForeign = NO;
    
    self.sendClassList = [NSMutableArray array];
    self.currencyList = [NSMutableArray array];
    self.bankCountryList = [NSMutableArray array];
    self.breakdownList = [NSMutableArray array];
    self.foreignAccountNumberList = [NSMutableArray array];
    self.wonAccountNumberList = [NSMutableArray array];
    
    // 유학생주민등록번호
    [_jumin showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
    
    // 외화출금계좌 비밀번호
    [_foreignPasswd showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 원화출금계좌 비밀번호
    [_wonPasswd showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 출금계좌번호
    self.wonAccountNumberList = [self outAccountList];
    
    if ([_wonAccountNumberList count] != 0) {
        self.selectWonAccountDic = _wonAccountNumberList[0];
        
        [_wonAccountNumber setTitle:_selectWonAccountDic[@"2"] forState:UIControlStateNormal];
    }
    else if ([_wonAccountNumberList count] == 0) {
        [_wonAccountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
    }
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F0010_SERVICE
                                                   viewController:self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dataSetF3732 = nil;
    self.preDataSet = nil;
    
    self.textFieldList = nil;
    self.sendClassList = nil;
    self.currencyList = nil;
    self.bankCountryList = nil;
    self.breakdownList = nil;
    self.foreignAccountNumberList = nil;
    self.wonAccountNumberList = nil;
    
    self.encriptedForeignPasswd = nil;
    self.encriptedWonPasswd = nil;
    self.encriptedJumin = nil;
    
    self.selectSendClassDic = nil;
    self.selectCurrencyDic = nil;
    self.selectBankCountryDic = nil;
    self.selectForeignAccountDic = nil;
    self.selectWonAccountDic = nil;
    
    [_sendClass release];
    [_currency release];
    [_bankCountry release];
    [_receiptCharge release];
    [_sendCharge release];
    [_breakdown release];
    [_nonSelected release];
    [_foreignAccountNumber release];
    [_wonAccountNumber release];
    [_mainView release];
    [_remittance1 release];
    [_remittance2 release];
    [_jumin release];
    [_foreignWithDrawal1 release];
    [_foreignWithDrawal2 release];
    [_foreignPasswd release];
    [_wonWithDrawal release];
    [_wonPasswd release];
    [_balance release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setSendClass:nil];
    [self setCurrency:nil];
    [self setBankCountry:nil];
    [self setReceiptCharge:nil];
    [self setSendCharge:nil];
    [self setBreakdown:nil];
    [self setNonSelected:nil];
    [self setForeignAccountNumber:nil];
    [self setWonAccountNumber:nil];
    [self setMainView:nil];
    [self setRemittance1:nil];
    [self setRemittance2:nil];
    [self setJumin:nil];
    [self setForeignWithDrawal1:nil];
    [self setForeignWithDrawal2:nil];
    [self setForeignPasswd:nil];
    [self setWonWithDrawal:nil];
    [self setWonPasswd:nil];
    [self setBalance:nil];
	[super viewDidUnload];
}

#pragma mark -

- (void)serverError
{
    [_wonPasswd setText:@""];
    self.encriptedWonPasswd = @"";
    [_foreignPasswd setText:@""];
    self.encriptedForeignPasswd = @"";
}

- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.2lf", number];
    }
    else {
        string = [NSString stringWithFormat:@"%.lf", number];
    }
    
    NSString *str = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumber *num = [NSNumber numberWithDouble:[str doubleValue]];
    
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setAllowsFloats:YES];
    
    NSString *commaString = [numberFormatter stringForObjectValue:num];
    
    if (isPoint) {
        NSRange range = [commaString rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
            commaString = [NSString stringWithFormat:@"%@.00", commaString];
        }
        else {
            if ([commaString length] - 1 == range.location + 1) {
                commaString = [NSString stringWithFormat:@"%@0", commaString];
            }
        }
    }
    
    return commaString;
}

- (BOOL)buttonCheck:(UIButton *)button
{
    if ([button.titleLabel.text length] == 0 ||
        [button.titleLabel.text isEqualToString:@"선택하세요"] ||
        [button.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다."] ||
        [button.titleLabel.text isEqualToString:@"외화출금계좌정보가 없습니다."]) {
        return YES;
    }
    
    return NO;
}

- (Float64)getFee
{
	Float64 fee = 0.f;
    
    NSString *currency = _selectCurrencyDic[@"code"];
    
    if (![_sendCharge isSelected]) {
        return 0.f;
    }
	
	if(currency == nil || [currency isEqualToString:@""]) {
		return 0.f;
	}
	else if([currency isEqualToString:@"USD"]) {
		return 20.f;
	}
	else if([currency isEqualToString:@"JPY"]) {
		fee = [self getTotalMoney];
		
		fee = fee * 0.0005 < 3000.f ? 3000.f : fee * 0.0005;
		
		fee = floor(fee);
		
		return fee;
	}
	else if([currency isEqualToString:@"EUR"]) {
		return 25.f;
	}
	else if([currency isEqualToString:@"GBP"]) {
		return 15.f;
	}
	else if([currency isEqualToString:@"CAD"]) {
		return 25.f;
	}
	else if([currency isEqualToString:@"CHF"]) {
		return 35.f;
	}
	else if([currency isEqualToString:@"HKD"]) {
		return 200.f;
	}
	else if([currency isEqualToString:@"SEK"]) {
		return 150.f;
	}
	else if([currency isEqualToString:@"AUD"]) {
		return 25.f;
	}
	else if([currency isEqualToString:@"DKK"]) {
		return 150.f;
	}
	else if([currency isEqualToString:@"NOK"]) {
		return 150.f;
	}
	else if([currency isEqualToString:@"SGD"]) {
		return 35.f;
	}
	else if([currency isEqualToString:@"NZD"]) {
		return 30.f;
	}
	else if([currency isEqualToString:@"THB"]) {
		NSArray *array = [_dataSetF3732 arrayWithForKey:@"조회내역"];
		
        if ([array count] == 0) {
			return 0.f;
		}
		
        for (NSDictionary *dic in array) {
			if ([dic[@"통화CODE"] isEqualToString:@"THB"]) {
				Float64 rate = [dic[@"대미환산환율"] doubleValue];
				Float64 tmpFee = 20.f / rate;
                
                return tmpFee;
			}
		}
	}
	else if([currency isEqualToString:@"SAR"]) {
		NSArray *array = [_dataSetF3732 arrayWithForKey:@"조회내역"];
		
        if ([array count] == 0) {
			return 0.f;
		}
		
        for (NSDictionary *dic in array) {
            if ([dic[@"통화CODE"] isEqualToString:@"SAR"]) {
				Float64 rate = [dic[@"대미환산환율"] doubleValue];
				Float64 tmpFee = 20.f / rate;
                
				return tmpFee;
			}
		}
	}
	else if([currency isEqualToString:@"KWD"]) {
		NSArray *array = [_dataSetF3732 arrayWithForKey:@"조회내역"];
		
        if ([array count] == 0) {
			return 0.f;
		}
		
        for (NSDictionary *dic in array) {
            if ([dic[@"통화CODE"] isEqualToString:@"KWD"]) {
				Float64 rate = [dic[@"대미환산환율"] doubleValue];
				Float64 tmpFee = 20.f / rate;
                
				return tmpFee;
			}
		}
	}
	
	return 0.f;
}

- (Float64)getTotalMoney
{
    NSString *number1 = [_remittance1.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *number2 = [_remittance2.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
	if ([number1 length] == 0 || [number1 isEqualToString:@"0"]) {
		return [[NSString stringWithFormat:@"0.%@", number2] doubleValue];
	}
	else if ([number2 length] == 0 || [number2 isEqualToString:@"0"]) {
        return [[NSString stringWithFormat:@"%@", number1] doubleValue];
    }
    else {
        return [[NSString stringWithFormat:@"%@.%@", number1, number2] doubleValue];
	}
}

- (Float64)getForeignMoney
{
    NSString *number1 = [_foreignWithDrawal1.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *number2 = [_foreignWithDrawal2.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
	if ([number1 length] == 0 || [number1 isEqualToString:@"0"]) {
		return [[NSString stringWithFormat:@"0.%@", number2] doubleValue];
	}
	else if ([number2 length] == 0 || [number2 isEqualToString:@"0"]) {
        return [[NSString stringWithFormat:@"%@", number1] doubleValue];
    }
    else {
        return [[NSString stringWithFormat:@"%@.%@", number1, number2] doubleValue];
	}
}

- (void)setWonWithDrawal
{
    if ([_sendCharge isSelected]) {
        [_wonWithDrawal setText:[self addComma:[self getTotalMoney] + floor([self getFee] * 100) / 100 - [self getForeignMoney]
                                       isPoint:YES]];
    }
    else {
        [_wonWithDrawal setText:[self addComma:[self getTotalMoney] - [self getForeignMoney]
                                       isPoint:YES]];
    }
}

- (NSString *)getBankType:(NSString *)type
{
	switch ([type integerValue]) {
		case 0:
			return @"없음";
            
		case 1:
			return @"ABA(미국)";
            
		case 2:
			return @"BLZ(독일)";
            
		case 3:
			return @"SORT(영국)";
            
		case 4:
			return @"BSB(호주)";
            
		case 5:
			return @"SWIFT CODE";
            
		case 6:
			return @"CHIPS UID";
            
		case 7:
			return @"TRANSIT NO(캐나다)";
            
		default:
			return @"";
	}
}

- (void)serviceF2027
{
    SHBDataSet *aDataSet = [SHBDataSet dictionary];
    
    if ([_selectWonAccountDic[@"신계좌변환여부"] isEqualToString:@"1"]) {
        [aDataSet insertObject:@"1"
                        forKey:@"원화구은행구분"
                       atIndex:0];
        [aDataSet insertObject:_selectWonAccountDic[@"2"]
                        forKey:@"원화지급계좌번호"
                       atIndex:0];
    }
    else {
        [aDataSet insertObject:_selectWonAccountDic[@"은행코드"]
                        forKey:@"원화구은행구분"
                       atIndex:0];
        [aDataSet insertObject:_selectWonAccountDic[@"2"]
                        forKey:@"원화지급계좌번호"
                       atIndex:0];
    }
    
    [aDataSet insertObject:_encriptedWonPasswd
                    forKey:@"원화비밀번호"
                   atIndex:0];
    
    if (![self buttonCheck:_foreignAccountNumber] && [self getForeignMoney] != 0.f) {
        
        if ([_selectForeignAccountDic[@"신계좌변환여부"] isEqualToString:@"1"]) {
            [aDataSet insertObject:@"1"
                            forKey:@"외화구은행구분"
                           atIndex:0];
            [aDataSet insertObject:_selectForeignAccountDic[@"계좌번호"]
                            forKey:@"외화지급계좌번호"
                           atIndex:0];
        }
        else {
            [aDataSet insertObject:_selectForeignAccountDic[@"은행구분"]
                            forKey:@"외화구은행구분"
                           atIndex:0];
            [aDataSet insertObject:_selectForeignAccountDic[@"구계좌번호"]
                            forKey:@"외화지급계좌번호"
                           atIndex:0];
        }
        
        [aDataSet insertObject:_encriptedForeignPasswd
                        forKey:@"외화비밀번호"
                       atIndex:0];
        [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", [self getForeignMoney]]
                        forKey:@"외화대체금액"
                       atIndex:0];
    }
    
    if ([_sendClass.titleLabel.text isEqualToString:@"유학생송금"]) {
        [aDataSet insertObject:@"1"
                        forKey:@"유학생유무"
                       atIndex:0];
        [aDataSet insertObject:_encriptedJumin
                        forKey:@"유학생주민번호"
                       atIndex:0];
        
        /*
        if (![[AppInfo getPersonalPK] isEqualToString:aDataSet[@"유학생주민번호"]]) {
            [aDataSet insertObject:@"1"
                            forKey:@"대리인여부"
                           atIndex:0];
        }
         */
    }
    else if ([_sendClass.titleLabel.text isEqualToString:@"해외체재비"]) {
        [aDataSet insertObject:@"0"
                        forKey:@"유학생유무"
                       atIndex:0];
        
        /* 유학생주민번호의 경우 서버에서 로그인사용자 주민번호를 전송하도록 수정됨
        [aDataSet insertObject:[AppInfo getPersonalPK]//[NSString stringWithFormat:@"%@%@", _jumin1.text, _jumin2.text]
                        forKey:@"유학생주민번호"
                       atIndex:0];
        
        if (![[AppInfo getPersonalPK] isEqualToString:aDataSet[@"유학생주민번호"]]) {
            [aDataSet insertObject:@"1"
                            forKey:@"대리인여부"
                           atIndex:0];
        }
         */
    }
    
    [aDataSet insertObject:_selectSendClassDic[@"code"]
                    forKey:@"송금사유구분"
                   atIndex:0];
    [aDataSet insertObject:@"1"
                    forKey:@"송금구분"
                   atIndex:0];
    
    
    if ([_sendClass.titleLabel.text isEqualToString:@"재외동포 재산반출"]) {
        [aDataSet insertObject:_breakdown.titleLabel.text
                        forKey:@"송금사유"
                       atIndex:0];
    }
    else {
        [aDataSet insertObject:@""
                        forKey:@"송금사유"
                       atIndex:0];
    }
    
    [aDataSet insertObject:_selectCurrencyDic[@"code"]
                    forKey:@"통화코드"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", [self getTotalMoney]]
                    forKey:@"송금금액"
                   atIndex:0];
    [aDataSet insertObject:[_wonWithDrawal.text stringByReplacingOccurrencesOfString:@"," withString:@""]
                    forKey:@"포지션금액"
                   atIndex:0];
    [aDataSet insertObject:_selectBankCountryDic[@"code"]
                    forKey:@"수취인국가코드"
                   atIndex:0];
    [aDataSet insertObject:[_sendCharge isSelected] ? @"1" : @"0"
                    forKey:@"수수료부담구분"
                   atIndex:0];
    
    if ([_sendCharge isSelected]) {
        [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", floor([self getFee] * 100) / 100]
                        forKey:@"해외수수료금액"
                       atIndex:0];
    }
    
    AppInfo.commonDic = @{
                        EXCHANGE_F2027 : aDataSet,
                        EXCHANGE_F2035 : _preDataSet,
                        };
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F2027_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Button

/// 송금구분
- (IBAction)sendClassBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.sendClassList = [NSMutableArray array];
    
    NSArray *nameArray = @[
                         @"일반송금(개인이전,본인계좌로의 송금제외)", @"신고없는 자본거래(본인계좌로의 송금포함)", @"유학생송금", @"해외체재비", @"외국인소득급여",
                         @"해외이주비", @"재외동포 재산반출", @"대외계정 인출", @"비거주자유원계정 인출",@"해외이주예정자",
                         ];
    
    NSArray *codeArray = @[
                         @"3", @"6", @"2", @"1", @"5",
                         @"10", @"11", @"12", @"13", @"17",
                         ];
    
    for (NSInteger i = 0; i < [nameArray count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    @{
                                    @"1" : nameArray[i],
                                    @"code" : codeArray[i],
                                    }];
        
        [_sendClassList addObject:dic];
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"송금구분"
                                                                   options:_sendClassList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:7
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FAVORIT_LISTPOPUP_SENDCLASS];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 통화구분
- (IBAction)currencyBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.currencyList = [NSMutableArray arrayWithArray:
                         @[
                         @{ @"value" : @"미국달러", @"code" : @"USD", @"1" : @"미국달러(USD)", },
                         @{ @"value" : @"일본엔", @"code" : @"JPY", @"1" : @"일본엔(JPY)", },
                         @{ @"value" : @"유럽연합유로", @"code" : @"EUR", @"1" : @"유럽연합유로(EUR)", },
                         @{ @"value" : @"영국파운드", @"code" : @"GBP", @"1" : @"영국파운드(GBP)", },
                         @{ @"value" : @"캐나다달러", @"code" : @"CAD", @"1" : @"캐나다달러(CAD)", },
                         @{ @"value" : @"스위스프랑", @"code" : @"CHF", @"1" : @"스위스프랑(CHF)", },
                         @{ @"value" : @"홍콩달러", @"code" : @"HKD", @"1" : @"홍콩달러(HKD)", },
                         @{ @"value" : @"스웨덴크로네", @"code" : @"SEK", @"1" : @"스웨덴크로네(SEK)", },
                         @{ @"value" : @"호주달러", @"code" : @"AUD", @"1" : @"호주달러(AUD)", },
                         @{ @"value" : @"덴마크크로네", @"code" : @"DKK", @"1" : @"덴마크크로네(DKK)", },
                         @{ @"value" : @"노르웨이크로네", @"code" : @"NOK", @"1" : @"노르웨이크로네(NOK)", },
                         @{ @"value" : @"싱가폴달러", @"code" : @"SGD", @"1" : @"싱가폴달러(SGD)", },
                         @{ @"value" : @"뉴질랜드달러", @"code" : @"NZD", @"1" : @"뉴질랜드달러(NZD)", },
                         @{ @"value" : @"태국바트", @"code" : @"THB", @"1" : @"태국바트(THB)", },
                         ]];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"환전통화"
                                                                   options:_currencyList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:7
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FAVORIT_LISTPOPUP_CURRENCY];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 수취은행국가명
- (IBAction)bankCountryBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([AppInfo.codeList.nationList count] > 0) {
        self.bankCountryList = AppInfo.codeList.nationList;
        
        SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"수취은행국가명"
                                                                       options:_bankCountryList
                                                                       CellNib:@"SHBExchangePopupCell"
                                                                         CellH:32
                                                                   CellDispCnt:7
                                                                    CellOptCnt:1] autorelease];
        [popupView setDelegate:self];
        [popupView setTag:FAVORIT_LISTPOPUP_BANKCOUNTRY];
        [popupView showInView:self.navigationController.view animated:YES];
    }
    else {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"codeKey" : @"NAT_C",
                                }];
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_CODE_SERVICE
                                                       viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
    
    
}

/// 유학생주민등록번호
- (IBAction)closeNormalPad0:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_jumin becomeFirstResponder];
}

/// 해외수수료부담자
- (IBAction)chargeBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if (sender == _receiptCharge) {
        [_receiptCharge setSelected:YES];
        [_sendCharge setSelected:NO];
    }
    else if (sender == _sendCharge) {
        if ([_sendClass.titleLabel.text isEqualToString:@"대외계정 인출"]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"대외계정 인출은 해외수수료 송금인 부담으로 해외송금거래를 하실 수 없습니다."];
            
            return;
        }
        
        [_receiptCharge setSelected:NO];
        [_sendCharge setSelected:YES];
    }
    
    [self setWonWithDrawal];
}

/// 재산반출내역
- (IBAction)breakdownBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.breakdownList = [NSMutableArray arrayWithArray:
                          @[
                          @{@"1" : @"부동산",},
                          @{@"1" : @"예금",},
                          @{@"1" : @"기타",}
                          ]];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"재산반출내역"
                                                                   options:_breakdownList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:3
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FAVORIT_LISTPOPUP_BREAKDOWN];
    [popupView showInView:self.navigationController.view animated:YES];
}

// 선택안함
- (IBAction)nonSelectedBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.selectForeignAccountDic = [NSMutableDictionary dictionary];
    
    if ([_foreignAccountNumberList count] == 0) {
        [_foreignAccountNumber.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_foreignAccountNumber setTitle:@"외화출금계좌정보가 없습니다." forState:UIControlStateNormal];
    }
    else {
        [_foreignAccountNumber setTitle:@"선택하세요" forState:UIControlStateNormal];
    }
    
    [_foreignWithDrawal1 setText:@"0"];
    [_foreignWithDrawal2 setText:@"0"];
    [_foreignPasswd setText:@""];
    
    if ([_sendClass.titleLabel.text isEqualToString:@"대외계정 인출"]) {
        [_foreignPasswd setEnabled:YES];
        [_foreignWithDrawal1 setEnabled:YES];
        [_foreignWithDrawal2 setEnabled:YES];
    }
    else if ([_sendClass.titleLabel.text isEqualToString:@"비거주자유원계정 인출"]) {
        [_foreignAccountNumber setEnabled:NO];
    }
    else {
        [_foreignPasswd setEnabled:NO];
        [_foreignWithDrawal1 setEnabled:NO];
        [_foreignWithDrawal2 setEnabled:NO];
    }
    
    [self setWonWithDrawal];
}

/// 외화출금계좌번호
- (IBAction)foreignAccountNumberBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"외화출금계좌"
                                                                   options:_foreignAccountNumberList
                                                                   CellNib:@"SHBAccidentBankBookInfoCell"
                                                                     CellH:69
                                                               CellDispCnt:5
                                                                CellOptCnt:3] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FAVORIT_LISTPOPUP_FOREIGNACCOUNTNUMBER];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 외화출금계좌 비밀번호
- (IBAction)closeNormalPad1:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_foreignPasswd becomeFirstResponder];
}

/// 원화출금계좌번호
- (IBAction)wonAccountNumberBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.wonAccountNumberList = [self outAccountList];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
                                                                   options:_wonAccountNumberList
                                                                   CellNib:@"SHBAccountListPopupCell"
                                                                     CellH:50
                                                               CellDispCnt:5
                                                                CellOptCnt:2] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FAVORIT_LISTPOPUP_WONACCOUNTNUMBER];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 원화출금계좌 비밀번호
- (IBAction)closeNormalPad2:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_wonPasswd becomeFirstResponder];
}

/// 잔액조회
- (IBAction)balanceBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([self buttonCheck:_wonAccountNumber]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"원화출금계좌번호를 선택해 주세요."];
        
        return;
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"출금계좌번호" : _wonAccountNumber.titleLabel.text,
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_D2004_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([self buttonCheck:_sendClass]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"송금구분을 선택하여 주십시오."];
        
        return;
    }
    
    if ([self buttonCheck:_currency]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"송금통화를 선택하여 주십시오."];
        
        return;
    }
    
    if ([self getTotalMoney] == 0.f) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"전체송금액을 0이상 입력하여 주십시오."];
        
        return;
    }
    
    if ([self buttonCheck:_bankCountry]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"수취은행국가명을 선택하여 주십시오."];
        
        return;
    }
    
    if ([_sendClass.titleLabel.text isEqualToString:@"유학생송금"]) {
        
        if ([_jumin.text length] != 13) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"주민등록번호 13자리를 입력하여 주십시오."];
            
            return;
        }
    }
    else if ([_sendClass.titleLabel.text isEqualToString:@"일반송금(개인이전,본인계좌로의 송금제외)"]) {
        if([_preDataSet[@"의뢰인정보내용1"] isEqualToString:_preDataSet[@"수취인정보내용1"]]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"의뢰인과 수취인이 동일합니다."];
            
            return;
		}
    }
    else if ([_sendClass.titleLabel.text isEqualToString:@"재외동포 재산반출"]) {
        if ([self buttonCheck:_breakdown]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"재산반출 내역을 선택해 주십시오."];
            
            return;
        }
    }
    else if ([_sendClass.titleLabel.text isEqualToString:@"대외계정 인출"]) {
        if ([self buttonCheck:_foreignAccountNumber]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"외화출금계좌번호를 선택하여 주십시오."];
            
            return;
        }
        else {
            if ([self getForeignMoney] == 0.f) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"외화계좌인출금액을 입력하여 주십시오."];
                
                return;
            }
            
            if ([_foreignPasswd.text length] != 4) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"외화출금계좌비밀번호를 입력하여 주십시오."];
                
                return;
            }
            
        }
        
        if ([self getForeignMoney] > [self getTotalMoney]) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"입력하신 외화계좌 인출금액이 송금예정액보다 큽니다. 외화계좌 인출금액을 확인해주세요."];
            
            return;
        }
        
        if ([self getTotalMoney] - [self getForeignMoney] != 0) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"대외계정 인출은 외화계좌에서 전액 출금하셔야 합니다."];
            
            return;
        }
    }
    
    if (![self buttonCheck:_foreignAccountNumber]) {
        if ([self getForeignMoney] == 0) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"외화계좌인출금액을 입력하여 주십시오."];
            
            return;
        }
        
        if ([_foreignPasswd.text length] != 4) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"외화출금계좌비밀번호를 입력하여 주십시오."];
            
            return;
        }
    }
    
    if ([_wonPasswd.text length] != 4) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"계좌비밀번호를 입력하여 주십시오."];
        
        return;
    }
    
    if ([self getForeignMoney] > [self getTotalMoney]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"입력하신 외화계좌인출금액이 송금예정액보다 큽니다. 외화계좌인출금액을 확인하여 주십시오."];
        
        return;
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"출금계좌번호" : _wonAccountNumber.titleLabel.text,
                           @"출금계좌비밀번호" : _encriptedWonPasswd,
                           }];
    
    _isOkBtn = YES;
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_C2092_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    switch (self.service.serviceId) {
        case EXCHANGE_CODE_SERVICE:
        {
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKeyPath:@"data"]) {
                [dic setObject:dic[@"value"] forKey:@"1"];
            }
        }
            break;
        case EXCHANGE_F0010_SERVICE:
        {
            NSArray *arr = [aDataSet arrayWithForKey:@"외화계좌"];
            
            self.foreignAccountNumberList = [NSMutableArray array];
            
            for (NSMutableDictionary *dic in arr) {
                if ([dic[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"]) {
                    if ([dic[@"상품부기명"] length] > 0) {
                        [dic setObject:dic[@"상품부기명"]
                                forKey:@"1"];
                    }
                    else {
                        [dic setObject:dic[@"과목명"]
                                forKey:@"1"];
                    }
                    
                    if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                        [dic setObject:dic[@"계좌번호"]
                                forKey:@"2"];
                    }
                    else {
                        [dic setObject:dic[@"구계좌번호"]
                                forKey:@"2"];
                    }
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                        [dic[@"계좌번호"] hasPrefix:@"187"] ||
                        [dic[@"계좌번호"] hasPrefix:@"188"]) {
                        [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                                forKey:@"3"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                                forKey:@"3"];
                    }
                    
                    [_foreignAccountNumberList addObject:dic];
                }
            }
        }
            break;
        case EXCHANGE_F2027_SERVICE:
        {
            [aDataSet insertObject:_sendClass.titleLabel.text
                            forKey:@"_송금구분"
                           atIndex:0];
            [aDataSet insertObject:_selectCurrencyDic[@"code"]
                            forKey:@"_송금통화"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", [self getTotalMoney]]
                            forKey:@"_환전금액"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", floor([self getFee] * 100) / 100]
                            forKey:@"_해외수수료"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"수수료금액"]]
                            forKey:@"_수수료금액"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"전신료금액"]]
                            forKey:@"_전신료"
                           atIndex:0];
            [aDataSet insertObject:[self buttonCheck:_foreignAccountNumber] ? @"" : _foreignAccountNumber.titleLabel.text
                            forKey:@"_외화출금계좌번호"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%.2lf", [self getForeignMoney]]
                            forKey:@"_외화계좌인출금액"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@",
                                    [self addComma:[aDataSet[@"고객환율->originalValue"] doubleValue] isPoint:YES]]
                            forKey:@"_적용환율"
                           atIndex:0];
            
            if ([self buttonCheck:_wonAccountNumber]) {
                [aDataSet insertObject:@""
                                forKey:@"_원화출금계좌번호"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:_wonAccountNumber.titleLabel.text
                                forKey:@"_원화출금계좌번호"
                               atIndex:0];
            }
            
            [aDataSet insertObject:_wonWithDrawal.text
                            forKey:@"_원화계좌인출금액"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"원화환산합계"]]
                            forKey:@"_원화인출합계금액"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"의뢰인정보내용1"]
                            forKey:@"_보내시는분성명"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"송금의뢰인전화번호"]
                            forKey:@"_보내시는분전화번호"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"수취인정보내용1"]
                            forKey:@"_성명"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"송금수취인전화번호"]
                            forKey:@"_전화번호"
                           atIndex:0];
            
            if ([_sendClass.titleLabel.text isEqualToString:@"유학생송금"]) {
                if ([_jumin.text length] == 13) {
                    [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", [_jumin.text substringToIndex:6]]
                                    forKey:@"_주민등록번호"
                                   atIndex:0];
                }
                else {
                    [aDataSet insertObject:@""
                                    forKey:@"_주민등록번호"
                                   atIndex:0];
                }
            }
            else {
                [aDataSet insertObject:@""
                                forKey:@"_주민등록번호"
                               atIndex:0];
            }
            
            [aDataSet insertObject:_preDataSet[@"수취인정보내용2"]
                            forKey:@"_주소"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"수취인은행정보1"]
                            forKey:@"_은행명"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"수취인은행정보2"]
                            forKey:@"_지점명"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"수취인은행정보3"]
                            forKey:@"_은행주소"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"수취인계좌번호"]
                            forKey:@"_계좌번호"
                           atIndex:0];
            [aDataSet insertObject:[self getBankType:_preDataSet[@"해외결제전산망_CODE"]]
                            forKey:@"_해외은행구분"
                           atIndex:0];
            [aDataSet insertObject:_preDataSet[@"은행CODE"]
                            forKey:@"_해외은행번호"
                           atIndex:0];
            if ([self buttonCheck:_breakdown]) {
                [aDataSet insertObject:@""
                                forKey:@"_송금사유"
                               atIndex:0];
            } else {
                [aDataSet insertObject:_breakdown.titleLabel.text
                                forKey:@"_송금사유"
                               atIndex:0];
            }
            
            if ([_receiptCharge isSelected]) {
                [aDataSet insertObject:@"수취인"
                                forKey:@"_해외수수료부담자"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:@"송금인"
                                forKey:@"_해외수수료부담자"
                               atIndex:0];
            }
            
            [aDataSet insertObject:_currency.titleLabel.text
                            forKey:@"_통화구분"
                           atIndex:0];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    Debug(@"%@", aDataSet);
    
    switch (self.service.serviceId) {
        case EXCHANGE_CODE_SERVICE:
        {
            self.bankCountryList = [aDataSet arrayWithForKeyPath:@"data"];
            AppInfo.codeList.nationList = [aDataSet arrayWithForKeyPath:@"data"];
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"수취은행국가명"
                                                                           options:_bankCountryList
                                                                           CellNib:@"SHBExchangePopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:7
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView setTag:FAVORIT_LISTPOPUP_BANKCOUNTRY];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case EXCHANGE_F0010_SERVICE:
        {
            if ([_foreignAccountNumberList count] == 0) {
                [_foreignAccountNumber.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [_foreignAccountNumber setTitle:@"외화출금계좌정보가 없습니다." forState:UIControlStateNormal];
            }
        }
            break;
        case EXCHANGE_C2092_SERVICE:
        {
            if (_isOkBtn) {
                if (_isForeign) {
                    [self serviceF2027];
                }
                else {
                    if([_sendClass.titleLabel.text isEqualToString:@"해외이주비"] ||
                       [_sendClass.titleLabel.text isEqualToString:@"해외이주예정자"] ||
                       [_sendClass.titleLabel.text isEqualToString:@"재외동포 재산반출"] ||
                       [_sendClass.titleLabel.text isEqualToString:@"대외계정 인출"] ||
                       [_sendClass.titleLabel.text isEqualToString:@"비거주자자유원계정 인출"]) {
                        
                        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                               @{
                                               @"업무구분" : @"4",
                                               @"검색번호" : @"1",
                                               @"고객번호" : AppInfo.userInfo[@"고객번호"],
                                               @"고객번호FIL" : @"",
                                               }];
                        
                        self.service = nil;
                        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F2024_SERVICE
                                                                       viewController:self] autorelease];
                        self.service.requestData = dataSet;
                        [self.service start];
                    }
                    else
                    {
                        if ([self buttonCheck:_foreignAccountNumber]) {
                            [self serviceF2027];
                        }
                        else {
                            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                                   @{
                                                   @"출금계좌번호" : _foreignAccountNumber.titleLabel.text,
                                                   @"출금계좌비밀번호" : _encriptedForeignPasswd,
                                                   }];
                            
                            _isOkBtn = YES;
                            _isForeign = YES;
                            
                            self.service = nil;
                            self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_C2092_SERVICE
                                                                           viewController:self] autorelease];
                            self.service.requestData = dataSet;
                            [self.service start];
                        }
                    }
                }
            }
        }
            break;
        case EXCHANGE_D2004_SERVICE:
        {
            if ([aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"]) {
                [_balance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", aDataSet[@"지불가능잔액"]]];
            }
        }
            break;
        case EXCHANGE_F2024_SERVICE:
        {
            if ([self buttonCheck:_foreignAccountNumber]) {
                [self serviceF2027];
            }
            else {
                SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                       @{
                                       @"출금계좌번호" : _foreignAccountNumber.titleLabel.text,
                                       @"출금계좌비밀번호" : _encriptedForeignPasswd,
                                       }];
                
                _isOkBtn = YES;
                _isForeign = YES;
                
                self.service = nil;
                self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_C2092_SERVICE
                                                               viewController:self] autorelease];
                self.service.requestData = dataSet;
                [self.service start];
            }
        }
            break;
        case EXCHANGE_F2027_SERVICE:
        {
            [_wonPasswd setText:@""];
            self.encriptedWonPasswd = @"";
            [_foreignPasswd setText:@""];
            self.encriptedForeignPasswd = @"";
            
            SHBForexFavoritExecuteConfirmViewController *viewController = [[[SHBForexFavoritExecuteConfirmViewController alloc] initWithNibName:@"SHBForexFavoritExecuteConfirmViewController" bundle:nil] autorelease];
            [viewController setDetailData:aDataSet];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    if (textField == _foreignPasswd) {
        self.encriptedForeignPasswd = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    }
    else if (textField == _wonPasswd) {
        self.encriptedWonPasswd = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    }
    else if (textField == _jumin) {
        self.encriptedJumin = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    }
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _remittance1 || textField == _foreignWithDrawal1) {
        if ([number length] <= 14) {
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[self addComma:[number doubleValue] isPoint:NO]];
        }
        
        return NO;
    }
    else if (textField == _remittance2 || textField == _foreignWithDrawal2) {
        if ([number length] <= 2) {
            [textField setText:number];
        }
        
        return NO;
    }
    else if (textField == _jumin) {
        if ([number length] <= 13) {
            [textField setText:number];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - SHBTextField

- (void)didPrevButtonTouch
{
    if (self.curTextField == _remittance1 || self.curTextField == _remittance2 ||
        self.curTextField == _foreignWithDrawal1 || self.curTextField == _foreignWithDrawal2) {
        [self setWonWithDrawal];
    }
    
    [super didPrevButtonTouch];
}

- (void)didNextButtonTouch
{
    if (self.curTextField == _remittance1 || self.curTextField == _remittance2 ||
        self.curTextField == _foreignWithDrawal1 || self.curTextField == _foreignWithDrawal2) {
        [self setWonWithDrawal];
    }
    
    [super didNextButtonTouch];
}

- (void)didCompleteButtonTouch
{
	if (self.curTextField == _remittance1 || self.curTextField == _remittance2 ||
        self.curTextField == _foreignWithDrawal1 || self.curTextField == _foreignWithDrawal2) {
        [self setWonWithDrawal];
    }
    
    [super didCompleteButtonTouch];
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch ([listPopView tag]) {
        case FAVORIT_LISTPOPUP_SENDCLASS:
        {
            self.selectSendClassDic = _sendClassList[anIndex];
            
            NSString *name = _selectSendClassDic[@"1"];
            
            [_sendClass setTitle:name forState:UIControlStateNormal];
            _sendClass.accessibilityLabel = name;
            
            [_breakdown setEnabled:NO];
            [_breakdown setTitle:@"선택하세요" forState:UIControlStateNormal];
            
            [_jumin setEnabled:NO];
            [_jumin setText:@""];
            
            [_foreignAccountNumber setEnabled:YES];
            
            if (!_selectForeignAccountDic[@"1"]) {
                if ([_foreignAccountNumberList count] == 0) {
                    [_foreignAccountNumber.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    [_foreignAccountNumber setTitle:@"외화출금계좌정보가 없습니다." forState:UIControlStateNormal];
                }
                else {
                    [_foreignAccountNumber setTitle:@"선택하세요" forState:UIControlStateNormal];
                }
                
                [_foreignPasswd setEnabled:NO];
                [_foreignPasswd setText:@""];
                [_foreignWithDrawal1 setEnabled:NO];
                [_foreignWithDrawal1 setText:@"0"];
                [_foreignWithDrawal2 setEnabled:NO];
                [_foreignWithDrawal2 setText:@"0"];
            }
            else {
                [_foreignPasswd setEnabled:YES];
                [_foreignWithDrawal1 setEnabled:YES];
                [_foreignWithDrawal2 setEnabled:YES];
            }
            
            [_wonPasswd setEnabled:YES];
            [_wonPasswd setText:@""];
            
            [self setWonWithDrawal];
            
            if ([name isEqualToString:@"유학생송금"]) {
                [_jumin setEnabled:YES];
            }
            else if ([name isEqualToString:@"재외동포 재산반출"]) {
                [_breakdown setEnabled:YES];
            }
            else if ([name isEqualToString:@"대외계정 인출"]) {
                [_foreignPasswd setEnabled:YES];
                [_foreignWithDrawal1 setEnabled:YES];
                [_foreignWithDrawal2 setEnabled:YES];
                
                [_wonPasswd setText:@""];
                
                [self chargeBtn:_receiptCharge];
            }
            else if ([name isEqualToString:@"비거주자유원계정 인출"]) {
                [_foreignAccountNumber setEnabled:NO];
                [_foreignPasswd setEnabled:NO];
                [_foreignPasswd setText:@""];
                [_foreignWithDrawal1 setEnabled:NO];
                [_foreignWithDrawal1 setText:@"0"];
                [_foreignWithDrawal2 setEnabled:NO];
                [_foreignWithDrawal2 setText:@"0"];
                
                if ([_foreignAccountNumberList count] == 0) {
                    [_foreignAccountNumber.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    [_foreignAccountNumber setTitle:@"외화출금계좌정보가 없습니다." forState:UIControlStateNormal];
                }
                else {
                    [_foreignAccountNumber setTitle:@"선택하세요" forState:UIControlStateNormal];
                }
                
                [_wonPasswd setEnabled:YES];
            }
            
            [self setTextFieldTagOrder:_textFieldList];
        }
            break;
        case FAVORIT_LISTPOPUP_CURRENCY:
        {
            self.selectCurrencyDic = _currencyList[anIndex];
            
            [_currency setTitle:_selectCurrencyDic[@"1"] forState:UIControlStateNormal];
            _currency.accessibilityLabel = _selectCurrencyDic[@"1"];
            [self setWonWithDrawal];
        }
            break;
        case FAVORIT_LISTPOPUP_BANKCOUNTRY:
        {
            self.selectBankCountryDic = _bankCountryList[anIndex];
            [_bankCountry setTitle:_selectBankCountryDic[@"1"]
                          forState:UIControlStateNormal];
            _bankCountry.accessibilityLabel = _selectBankCountryDic[@"1"];
        }
            break;
        case FAVORIT_LISTPOPUP_BREAKDOWN:
        {
            [_breakdown setTitle:_breakdownList[anIndex][@"1"]
                        forState:UIControlStateNormal];
            _breakdown.accessibilityLabel = _breakdownList[anIndex][@"1"];
        }
            break;
        case FAVORIT_LISTPOPUP_FOREIGNACCOUNTNUMBER:
        {
            self.selectForeignAccountDic = _foreignAccountNumberList[anIndex];
            
            [_foreignAccountNumber setTitle:_selectForeignAccountDic[@"2"]
                                   forState:UIControlStateNormal];
            
            _foreignAccountNumber.accessibilityLabel = _selectForeignAccountDic[@"2"];
            [_foreignPasswd setEnabled:YES];
            [_foreignWithDrawal1 setEnabled:YES];
            [_foreignWithDrawal2 setEnabled:YES];
            
            [self setTextFieldTagOrder:_textFieldList];
            
            [_foreignPasswd setText:@""];
            self.encriptedForeignPasswd = @"";
        }
            break;
        case FAVORIT_LISTPOPUP_WONACCOUNTNUMBER:
        {
            self.selectWonAccountDic = _wonAccountNumberList[anIndex];
            
            [_wonAccountNumber setTitle:_selectWonAccountDic[@"2"] forState:UIControlStateNormal];
            _wonAccountNumber.accessibilityLabel = _selectWonAccountDic[@"2"];
            [_balance setText:@""];
            
            [_wonPasswd setText:@""];
            self.encriptedWonPasswd = @"";
        }
            break;
        default:
            break;
    }
}

- (void)listPopupViewDidCancel
{
    
}

@end
