//
//  SHBFundTransInfoInputViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundTransInfoInputViewController.h"
#import "SHBFundSecurityCardViewController.h"   // 펀드출금 3단계 - 보안카드입력

#import "SHBListPopupView.h"    // list popup
#import "SHBFundPopupView.h"    // list popup
#import "SHBFundListCell.h"     // list Cell

#import "SHBFundService.h"

#define ENC_PW_PREFIX @"<E2K_NUM="
#define ENC_PW_SUFFIX @">"

// list popup tag
enum FOREXREQUEST_LISTPOPUP_TAG {
    FUND_LISTPOPUP_TRANS
};

@interface SHBFundTransInfoInputViewController ()
<SHBListPopupViewDelegate>
{
    int serviceType;
}

@property (retain, nonatomic) NSMutableArray *transList; // 출금방식
@property (retain, nonatomic) SHBFundPopupView *drawingPopupView; // 출금계좌리스트팝업
@property (retain, nonatomic) NSString *encriptedPassword; // 계좌비밀번호

- (NSString *)addComma:(Float64)number point:(BOOL)isPoint;

@end

@implementation SHBFundTransInfoInputViewController

@synthesize data_D6310;

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
    
    if([[data_D6310 objectForKey:@"저축종류"] isEqualToString:@"적립식"] &&
	   [[data_D6310 objectForKey:@"만기일자"] intValue] >= [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue])
	{
        strErrorMessage = @"적립식상품은 만기일 이전에는 출금거래가 되지 않으며, 해지거래(영업점/인터넷뱅킹)만 가능합니다.";
        goto errorCase;
	}
	
	if([[data_D6310 objectForKey:@"저축종류"] isEqualToString:@"거치식"] &&
	   [[data_D6310 objectForKey:@"만기일자"] intValue] >= [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue])
	{
        strErrorMessage = @"거치식상품은 만기일 이전에는 출금거래가 되지 않으며, 해지거래(영업점/인터넷뱅킹)만 가능합니다.";
        goto errorCase;
	}
    
    NSInteger money = [[_textInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    
    if ([_transBtn.titleLabel.text length] == 0 ||
        [_transBtn.titleLabel.text isEqualToString:@"선택하세요."]) {
        strErrorMessage = @"출금방식의 입력값이 유효하지 않습니다.";
        goto errorCase;
    }
    else if ([_transBtn.titleLabel.text isEqualToString:@"금액출금"]) {
        if ( _textInAmount.text == nil || [_textInAmount.text isEqualToString:@""] )
        {
            strErrorMessage = @"금액의 입력값이 유효하지 않습니다.";
            goto errorCase;
        }
        else if (money == 0) {
            strErrorMessage = @"금액은 0원을 입력하실 수 없습니다.";
            goto errorCase;
        }
    }
    else if ([_transBtn.titleLabel.text isEqualToString:@"좌수출금"]) {
        if ( _textInAmount.text == nil || [_textInAmount.text isEqualToString:@""] )
        {
            strErrorMessage = @"좌수의 입력값이 유효하지 않습니다.";
            goto errorCase;
        }
        else if (money == 0) {
            strErrorMessage = @"좌수는 0을 입력하실 수 없습니다.";
            goto errorCase;
        }
    }
    if ( nil == _passwd.text || [_passwd.text isEqualToString:@""] )
    {
        strErrorMessage = @"계좌비밀번호를 입력해 주십시오.";
        goto errorCase;
    }
    if ( [_passwd.text length] != 4 )
    {
        strErrorMessage = @"계좌비밀번호는 4자리를 입력해 주십시오";
        goto errorCase;
    }
    
    return isError;
    
errorCase:
    {
        isError = YES;
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        
        return isError;
    }
    
}


- (IBAction)closeNormalPad:(id)sender
{
    //SHBSecureTextField *tmp = sender;
    //NSLog(@"closeNormalPad");
    [super closeNormalPad:sender];
    
    [self.passwd becomeFirstResponder];
    
}

// 다음 화면에서 cancel 시
- (void)cancelButtonPushed
{
    [_transBtn setTitleColor:[UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_transBtn setTitle:@"선택하세요." forState:UIControlStateNormal];
    
    _textInAmount.text = @"";
}

- (void)dealloc
{
    _drawingPopupView = nil;
    _encriptedPassword = nil;
    _transList = nil;
    
    [data_D6310 release];
    [_amountLabel release], _amountLabel = nil;
    [_accountNo release], _accountNo = nil;
    [_textInAmount release];
    [_transBtn release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonReceived" object:nil];

    [super dealloc];
}

- (void)viewDidUnload {
    [self setTransBtn:nil];
    [self setTextInAmount:nil];
    [self setPasswd:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;

    self.title = @"펀드출금";
    self.strBackButtonTitle = @"펀드출금 2단계";
    
    _transList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_transBtn setTitleColor:[UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    // SHBTextField setFrame & setDelegate
	[_textInAmount setAccDelegate:self];
	[_textInAmount setFrame:_textInAmount.frame];
    
    // 계좌비밀번호
    [_passwd showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 취소 버튼 노티
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonReceived" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPushed) name:@"cancelButtonReceived" object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
        case 10: {
            
            if ([self checkValidation])
            {
                return;
            }
            serviceType = 0;
            
            // D6320 전문호출
            SHBDataSet *aDataSet = [SHBDataSet dictionary];
            
            NSString *tempJob; // 업무구분
            NSString *tempAmount1; // 지급금액
            NSString *tempAmount2; // 지급좌수
            
            if ([_transBtn.titleLabel.text isEqualToString:@"전액출금"]) {
                tempJob = @"2";
                tempAmount1 = @"";
                tempAmount2 = @"";
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"금액출금"]) {
                tempJob = @"1";
                tempAmount1 = _textInAmount.text;
                tempAmount2 = @"";
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"좌수출금"]) {
                tempJob = @"1";
                tempAmount1 = @"";
                tempAmount2 = _textInAmount.text;
            }
            
            if ([[data_D6310 objectForKey:@"신계좌변환여부"] isEqualToString:@"1"] || [[data_D6310 objectForKey:@"구계좌사용여부"] isEqualToString:@"0"])
            {
                [aDataSet setDictionary:
                 @{
                 @"계좌번호" : [data_D6310 objectForKey:@"계좌번호"],
                 @"은행구분" : @"1",//[data_D6310 objectForKey:@"은행구분"],        // 신계좌의 경우는 은행구분값은 1이다
                 @"고객번호" : AppInfo.customerNo,
                 @"업무구분" : tempJob,
                 @"조회여부" : @"Y",
                 @"지급금액" : tempAmount1,
                 @"지급좌수" : tempAmount2,
                 }];
            } else
            {
                // 구계좌의 경우 통신을 구계좌번호로 보낸다
                [aDataSet setDictionary:
                 @{
                 @"계좌번호" : [data_D6310 objectForKey:@"구계좌번호"],
                 @"은행구분" : [data_D6310 objectForKey:@"은행구분"],
                 @"고객번호" : AppInfo.customerNo,
                 @"업무구분" : tempJob,
                 @"조회여부" : @"Y",
                 @"지급금액" : tempAmount1,
                 @"지급좌수" : tempAmount2,
                 }];
            }
            self.service = [[[SHBFundService alloc] initWithServiceId: FUND_DRAWING_INPUT  viewController: self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
            // C2092
            
        }
            break;
        case 20: {
            [_transList removeAllObjects];
            
            // 전액출금은 MMF만 해당됨
            NSArray *nameArray;
            NSArray *codeArray;
            
            if ([[data_D6310 objectForKey:@"계좌번호"] hasPrefix:@"251"]) {
                nameArray = @[ @"전액출금", @"금액출금", @"좌수출금", ];
                codeArray = @[ @"전액출금", @"금액출금", @"좌수출금", ];
            } else {
                nameArray = @[ @"금액출금", @"좌수출금", ];
                codeArray = @[ @"금액출금", @"좌수출금", ];
            }
            for (int i = 0; i < [nameArray count]; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                [dic setObject:[nameArray objectAtIndex:i] forKey:@"1"];
                [dic setObject:[codeArray objectAtIndex:i] forKey:@"code"];
                
                [_transList addObject:dic];
            }
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금방식"
                                                                           options:_transList
                                                                           CellNib:@"SHBFundListCell"
                                                                             CellH:32
                                                                       CellDispCnt:5
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView setTag:FUND_LISTPOPUP_TRANS];
            [popupView showInView:self.navigationController.view animated:YES];
            
        }
            break;
        case 30:
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
//	NSLog(@"# 리스트성 팝업에서 자료 선택 완료");
    
    switch ([listPopView tag]) {
        case FUND_LISTPOPUP_TRANS:
        {
            [_transBtn setTitle:[[_transList objectAtIndex:anIndex] objectForKey:@"1"]
                       forState:UIControlStateNormal];
            [_transBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0] forState:UIControlStateNormal];

            if ([_transBtn.titleLabel.text isEqualToString:@"전액출금"]) {
                _textInAmount.enabled = NO;
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"금액출금"]) {
                _textInAmount.enabled = YES;
                _amountLabel.text = @"금액(원)";
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"좌수출금"]) {
                _textInAmount.enabled = YES;
                _amountLabel.text = @"좌수";
            }
        }
            break;
        default:
            break;
    }
    
    _textInAmount.text = @"";
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            // 전문 D6320의 데이터를 취득하고
//            NSDictionary *tempData_D6320 = self.service.responseData;
            NSString *tempValue = @"";
            
            if ([_transBtn.titleLabel.text isEqualToString:@"전액출금"]) {
                tempValue = @"전액출금";
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"금액출금"]) {
                tempValue = @"금액출금";
            }
            else if ([_transBtn.titleLabel.text isEqualToString:@"좌수출금"]) {
                tempValue = @"좌수출금";
            }
            
            [aDataSet insertObject:tempValue forKey:@"표시구분" atIndex:0];
            data_D6320 = self.service.responseData;
            
            // D2092전문을 보낸다.
            serviceType = 2;
            
            NSString *tempStr1;
            NSString *tempStr2;
            
            if([[data_D6310 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
            {
                tempStr1 = [[data_D6310 objectForKey:@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                tempStr2 = [data_D6310 objectForKey:@"은행구분"];
            }
            else
            {
                tempStr1 = [[data_D6310 objectForKey:@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                tempStr2 = @"1";
            }
            
            // D2092 전문 호출
            // release 처리
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"출금계좌비밀번호"       : _encriptedPassword,
                                    @"출금계좌번호"          : tempStr1,
                                    @"은행구분"             : tempStr2,
                                    @"reservationField1"  : @"FundWithdraw"
                                    }] autorelease];
            
            self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DRAWING_CONFIRM viewController: self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
        }
            break;
            
        case 1:
        {
        }
            break;
            
        case 2:
        {
            // 펀드출금 3단계 호출
            SHBFundSecurityCardViewController *detailViewController = [[SHBFundSecurityCardViewController alloc] initWithNibName:@"SHBFundSecurityCardViewController" bundle:nil];
            
            detailViewController.data_D6320 = data_D6320;
            [detailViewController.data_D6320 setValue:_encriptedPassword forKey:@"출금계좌비밀번호"];
            detailViewController.data_D6310 = data_D6310;
            
            // 화면 전환시 비밀번호에 입력된 값을 지운다.
            _passwd.text =@"";
            
            [self.navigationController pushFadeViewController:detailViewController];
            [detailViewController release];
            
        }
            break;
        default:
            break;
    }
    
    return YES;
}

@end
