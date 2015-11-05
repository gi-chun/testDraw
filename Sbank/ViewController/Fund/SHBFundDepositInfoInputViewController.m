//
//  SHBFundDepositInfoInputViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundDepositInfoInputViewController.h"
#import "SHBFundDepositSecurityCardViewController.h"
#import "SHBAccountService.h"
#import "SHBFundService.h"

#define ENC_PW_PREFIX @"<E2K_NUM="
#define ENC_PW_SUFFIX @">"

@interface SHBFundDepositInfoInputViewController ()
{
    int serviceType;
}

@property (retain, nonatomic) NSString *encriptedPassword; // 계좌비밀번호

@end

@implementation SHBFundDepositInfoInputViewController

@synthesize dicDataDictionary;
@synthesize data_D6210;
@synthesize data_D6100;
@synthesize canTransferAccountList;
@synthesize balance;
@synthesize listArray;

#pragma mark -

- (NSString *)addComma:(Float64)number point:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.02lf", number];
    }
    else {
        string = [NSString stringWithFormat:@"%.lf", number];
    }
    
    NSString *str = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *num = [NSNumber numberWithLongLong:[str longLongValue]];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    NSString *commaString = [numberFormatter stringForObjectValue:num];
    [numberFormatter release];
    
    return commaString;
}

#pragma makr -
#pragma mark Private Method

- (BOOL)checkValidation
{
    BOOL isError = NO;
    NSString    *strErrorMessage = @"입력값을 확인해 주세요.";
    
    NSInteger money = [[_textInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];

    if ([_accountNumber.titleLabel.text length] == 0 ||
        [_accountNumber.titleLabel.text isEqualToString:@"선택하세요."] || [_accountNumber.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다."]) {
        strErrorMessage = @"출금계좌번호를 선택해 주세요.";
        goto errorCase;
    }
    if ( nil == _passwd.text || [_passwd.text isEqualToString:@""] )
    {
        strErrorMessage = @"출금계좌비밀번호를 입력해 주십시오.";
        goto errorCase;
    }
    if ( [_passwd.text length] != 4 )
    {
        strErrorMessage = @"출금계좌비밀번호는 4자리를 입력해 주십시오";
        goto errorCase;
    }
    if ( _textInAmount.text == nil || [_textInAmount.text isEqualToString:@""] )
    {
        strErrorMessage = @"입력금액의 입력값이 유효하지 않습니다.";
        goto errorCase;
    }
    if (money == 0) {
        strErrorMessage = @"입금금액은 0원을 입력할 수 없습니다.";
        goto errorCase;
    }
    
    NSString *depositFlag = [data_D6210 objectForKey:@"저축종류"];
	NSString *minMoney = nil;
	long long nMinMoney;
	long long nCurMoney;
	
	if ([depositFlag isEqualToString:@"임의식"])
	{
		minMoney = [data_D6100 objectForKey:@"거치입금최소금액"];
	}
	else if ([depositFlag isEqualToString:@"적립식"])
	{
		minMoney = [data_D6100 objectForKey:@"적립입금최소금액"];
	}
	else if ([depositFlag isEqualToString:@"거치식"])
	{
		minMoney = [data_D6100 objectForKey:@"거치최소금액"];
	}
	
	if (minMoney != nil)
	{
		nMinMoney = [[minMoney stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
		nCurMoney = [[_textInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
		
		if (nMinMoney > nCurMoney)
		{
            strErrorMessage = [NSString stringWithFormat:@"최저 입금 가능금액 (%@) 이상 입력하세요.", minMoney];
            goto errorCase;
		}
	}

    return isError;
    
errorCase:
    {
        isError = YES;
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        
        return isError;
    }
    
}

// 다음 화면에서 cancel 시
- (void)cancelButtonPushed
{
    // 출금계좌번호 선택
    NSMutableArray *tableDataArray = [self outAccountList];
    
    if ([tableDataArray count] == 0)
    {
        _accountNumber.titleLabel.text = @"출금계좌정보가 없습니다.";
    }
    else
    {
        [_accountNumber setTitle:[[tableDataArray objectAtIndex:0] objectForKey:@"2"] forState:UIControlStateNormal];
    }
    
    _textInAmount.text = @"";
}

- (IBAction)closeNormalPad:(id)sender
{
//    NSLog(@"closeNormalPad");
    [super closeNormalPad:sender];
    
    [self.passwd becomeFirstResponder];
    
}

- (void)getAccountList
{
    // 출금계좌번호 선택
    NSMutableArray *tableDataArray = [self outAccountList];
    
    if ([tableDataArray count] == 0) {
        _accountNumber.titleLabel.text = @"출금계좌정보가 없습니다.";
    }
    else
    {
        [_accountNumber setTitle:[[tableDataArray objectAtIndex:0] objectForKey:@"2"] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [balance release], balance = nil;
    canTransferAccountList = nil;
    self.dataList = nil;
    [_accountNumber release];
    [_textInAmount release];
    [_minAmount release];
    [listArray release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonReceived" object:nil];
    
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAccountNumber:nil];
    [self setTextInAmount:nil];
    [self setMinAmount:nil];
    [self setPasswd:nil];
    [super viewDidUnload];
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
    
    self.title = @"펀드입금";
    self.strBackButtonTitle = @"펀드입금 2단계";

    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    canTransferAccountList = [[NSMutableArray alloc] initWithCapacity:0];
    listArray = [[NSMutableArray alloc] initWithCapacity:0];

    // 출금계좌번호
    [self getAccountList];

    // SHBTextField setFrame & setDelegate
	//[_textInAmount setAccDelegate:self];
	//[_textInAmount setFrame:_textInAmount.frame];
    
    //_textInAmount.accessibilityLabel = @"금액입력편집창";
    // 계좌비밀번호
    [_passwd showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 최저출금 금액 표시
    NSString *depositFlag = [data_D6210 objectForKey:@"저축종류"];
	NSString *minMoney = @"";
	
	if ([depositFlag isEqualToString:@"임의식"])
	{
		minMoney = [data_D6100 objectForKey:@"거치입금최소금액"];
	}
	else if ([depositFlag isEqualToString:@"적립식"])
	{
		minMoney = [data_D6100 objectForKey:@"적립입금최소금액"];
	}
	else if ([depositFlag isEqualToString:@"거치식"])
	{
		minMoney = [data_D6100 objectForKey:@"거치최소금액"];
	}

    _minAmount.text = [NSString stringWithFormat:@"최저입금가능액 : %@원", minMoney];
    
    // 취소 버튼 노티
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonReceived" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPushed) name:@"cancelButtonReceived" object:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 펀드입금 3단계
- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
            // 입금신청
        case 10: {
            
            if ([self checkValidation])
            {
                return;
            }
            
            serviceType = 0;
            // D6230 FUND_DEPOSIT_INPUT
            
            // C2090 전문호출
            // release 처리
            SHBDataSet *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                                           @{
                                           @"출금계좌비밀번호"       : _encriptedPassword,
                                           @"출금계좌번호"          : _accountNumber.titleLabel.text,
                                           @"은행구분"             : [data_D6100 objectForKey:@"은행구분"],     // (!주의)신, 구 계좌에 따른 값 변경 있음 정보처리되어서 옴
                                           @"납부금액"             : [_textInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""],
                                           @"reservationField1"  : @"FundDeposit"
                                           }] autorelease];
            
            self.service = [[[SHBFundService alloc] initWithServiceId: FUND_ACCOUNT_CONFIRM  viewController: self] autorelease];
            self.service.previousData = dicDataDic;
            [self.service start];

        }
            break;
            
            // 계좌선택
        case 20: {
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
            
            // 잔액조회
        case 30: {
            if ([_accountNumber.titleLabel.text length] == 0 ||
                [_accountNumber.titleLabel.text isEqualToString:@"선택하세요."] || [_accountNumber.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다."]) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"출금계좌번호를 선택해 주세요."];
                
                return;
            }
            
            serviceType = 1;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : _accountNumber.titleLabel.text}] autorelease];
            [self.service start];

        }
            break;
        case 40:
            [self.navigationController fadePopViewController];
            break;

        default:
            break;
    }
}

#pragma mark -
#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _textInAmount)
    {
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
            if ([number length] <= 13)
            {
                number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
                
                [textField setText:[self addComma:[number doubleValue] point:YES]];
            }
        }
        else
        {
            int nLen = [textField.text length];
            NSString *strStr = [textField.text substringToIndex:nLen - 1];
            textField.text = strStr;
            
            textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];

}
#pragma mark - Delegate : SHBListPopupView
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    [_accountNumber setTitle:[[self.dataList objectAtIndex:anIndex] objectForKey:@"2"] forState:UIControlStateNormal];
    balance.hidden = YES;

    _passwd.text = @"";
    
    if (UIAccessibilityIsVoiceOverRunning())
    {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _accountNumber);
    }
    
    
    
}



- (void)listPopupViewDidCancel
{
//	NSLog(@"# 리스트성 팝업에서 자료 선택 취소");
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            
            NSString *strAccount = [data_D6210 objectForKey:@"계좌번호"];
            // 구계좌의 경우
            if ([[data_D6210 objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[data_D6210 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
            {
                strAccount = [data_D6210 objectForKey:@"구계좌번호"];
            }
            
            SHBFundDepositSecurityCardViewController *detailViewController = [[SHBFundDepositSecurityCardViewController alloc] initWithNibName:@"SHBFundDepositSecurityCardViewController" bundle:nil];

            // 정보 setting
            detailViewController.dicDataDictionary = self.service.responseData;
            [detailViewController.dicDataDictionary setObject:_accountNumber.titleLabel.text forKey:@"출금계좌번호"];
            [detailViewController.dicDataDictionary setObject:_encriptedPassword forKey:@"출금계좌비밀번호"];
            [detailViewController.dicDataDictionary setObject:strAccount forKey:@"표시입금계좌번호"];
            
            detailViewController.basicInfo = self.data_D6210;
            detailViewController.fundInfo = self.data_D6100;

            // 화면 전환시 입력된 비밀번호 값을 지운다.
            _passwd.text = @"";

            // 출금계좌리스트 취득
            [self getAccountList];
            balance.text = @"";
            balance.hidden = YES;

            [self.navigationController pushFadeViewController:detailViewController];
            [detailViewController release];
        }
            break;
            
        case 1:
        {
            balance.text = [NSString stringWithFormat:@"출금가능잔액 : %@원", aDataSet[@"지불가능잔액"]];

            balance.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    if (UIAccessibilityIsVoiceOverRunning())
    {
        if ([textField.text length] > 0)
        {
            _textInAmount.accessibilityLabel = [NSString stringWithFormat:@"%@원",textField.text];
        }else
        {
           
            _textInAmount.accessibilityLabel = @"금액입력편집창";
        }
        
    }
}


@end
