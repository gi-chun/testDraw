//
//  SHBPrimiumTransferViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPrimiumTransferViewController.h"
#import "SHBPrimiumTransferComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBPrimiumTransferViewController ()
{
    int serviceType;
    NSString *encriptedPW;
    SHBTextField *currentTextField;
    NSDictionary *inAccInfoDic;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (assign, nonatomic) SHBTextField *currentTextField;
@property (nonatomic, retain) NSDictionary *inAccInfoDic;
- (BOOL)validationCheck;
@end

@implementation SHBPrimiumTransferViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize currentTextField;
@synthesize inAccInfoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
        case 100:    // 일부출금(수령액기준)
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
        }
            break;
        case 200:    // 일부출금(원금기준)
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
        }
            break;
        case 300:   // 입금은행
        {
            serviceType = 1;
            
            _btnInAccNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountList];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"입금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"입금계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 400:
        {
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
            
            serviceType = 2;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                         @"출금계좌비밀번호" : self.encriptedPW,
                                         @"출금계좌번호" : [_lblOutAccNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                         @"은행구분" : self.outAccInfoDic[@"은행구분"],
                                         }] autorelease];
            [self.service start];
        }
            break;
        case 500:
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
        case 0:
        {
            _lblInterrest.text = [NSString stringWithFormat:@"%@원", aDataSet[@"세후만기지급금액"]];
            
            self.data = aDataSet;
        }
            break;
        case 2:
        {
            int amount = [[_txtAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            
            if(_btnSelector2.isSelected)
            {
                amount = amount + [[_lblInterrest.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
            }
            
            AppInfo.commonDic = @{
            @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"이자계산 시작일자", @"이자계산 종료일자", @"출금금액"],
            @"제목" : @"프리미엄신탁출금",
            @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
            @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
            @"출금계좌번호" : _lblOutAccNo.text,
            @"입금은행" : @"신한은행",
            @"입금계좌번호" : _btnInAccNo.titleLabel.text,
            @"이자계산 시작일자" : self.data[@"이자계산시작일자"],
            @"이자계산 종료일자" : self.data[@"이자계산종료일자"],
            @"고객성명" : self.data[@"위탁자"],
            @"출금예상금액" : [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", amount]]],
            @"출금금액" : [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", amount]]],
            @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
            @"비밀번호" : self.encriptedPW,
            @"일부해지구분" : _btnSelector1.isSelected ? @"2" : @"1",
            @"일부해지금액" : _txtAmount.text,
            @"입금은행구분" : self.inAccInfoDic[@"은행구분"],
            @"신규일" : self.data[@"신규일자"],
            @"만기일" : self.data[@"만기일자"],
            @"출금방식" : _btnSelector1.isSelected ? @"일부출금(수령액기준)" : @"일부출금(원금기준)",
            @"전문번호" : AppInfo.serviceCode,
            };
            
            SHBPrimiumTransferComfirmViewController *nextViewController = [[[SHBPrimiumTransferComfirmViewController alloc] initWithNibName:@"SHBPrimiumTransferComfirmViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
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
	
	if (textField == _txtAmount )
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
    if (textField == _txtAmount)
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
            
        }
            break;
        case 1:
        {
            _btnInAccNo.selected = NO;
            self.inAccInfoDic = self.dataList[anIndex];
            
            [_btnInAccNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
            
            _btnInAccNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금계좌번호는 %@ 입니다", _btnInAccNo.titleLabel.text];
            _btnInAccNo.accessibilityHint = @"입금계좌번호를 바꾸시려면 이중탭 하십시오";
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnInAccNo);
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

        }
            break;
        case 1:
        {
            _btnInAccNo.selected = NO;

            if([_btnInAccNo.titleLabel.text isEqualToString:@"선택하세요."]){
                _btnInAccNo.accessibilityLabel = @"선택된 입금계좌번호가 없습니다";
            }else{
                _btnInAccNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금계좌번호는 %@ 입니다", _btnInAccNo.titleLabel.text];
            }
            
            _btnInAccNo.accessibilityHint = @"입금계좌번호를 바꾸시려면 이중탭 하십시오";
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnInAccNo);
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_btnInAccNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }

    if([strInAccNo isEqualToString:@"선택하세요."]){
        strAlertMessage = @"‘입금계좌’를 선택하세요.";
        goto ShowAlert;
    }
    
    if([strInAccNo length] == 0 || [strInAccNo length] > 14){
        strAlertMessage = @"‘입금계좌’ 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }
    
	if(_txtAmount.text == nil || [_txtAmount.text length] == 0 || [_txtAmount.text length] > 15 )
	{
        strAlertMessage = @"‘금액’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
    
	if([_txtAmount.text isEqualToString:@"0"])
	{
        strAlertMessage = @"‘금액’은 0원을 입력하실 수 없습니다.";
        goto ShowAlert;
	}
    
    long long amount = [[_txtAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
    long long interest = [[_lblInterrest.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
    
    if(_btnSelector1.isSelected && amount < interest)
    {
        strAlertMessage = [NSString stringWithFormat:@"수령액기준 출금인 경우 출금금액은 세후지급이자보다 커야합니다.\n입력한 출금금액 = %@,\n세후지급이자 = %@", _txtAmount.text , _lblInterrest.text];
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

    self.title = @"즉시이체/예금입금";
    self.strBackButtonTitle = @"마케프리미엄 출금 1단계";

    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"출금" maxStep:3 focusStepNumber:1] autorelease]];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    _lblOutAccNo.text = self.outAccInfoDic[@"계좌번호"];
    _lblBalance.text = self.outAccInfoDic[@"잔액"];
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    serviceType = 0;
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2035" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                 @"계좌번호" : self.outAccInfoDic[@"계좌번호"],
                                 @"은행구분" : self.outAccInfoDic[@"은행구분"],
                                 @"거래일자" : AppInfo.tran_Date,
                                 }] autorelease];
    [self.service start];
    
    _txtAmount.strLableFormat = @"입력된 금액은 %@ 원입니다";
    _txtAmount.strNoDataLable = @"입력된 금액이 없습니다";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        _txtAmount.text = @"";
        _lblKorMoney.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.encriptedPW = nil;
    
    [_lblOutAccNo release];
    [_lblInterrest release];
    [_btnSelector1 release];
    [_btnSelector2 release];
    [_txtAmount release];
    [_lblKorMoney release];
    [_txtAccountPW release];
    [_btnInAccNo release];
    [_lblBalance release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblOutAccNo:nil];
    [self setLblInterrest:nil];
    [self setBtnSelector1:nil];
    [self setBtnSelector2:nil];
    [self setTxtAmount:nil];
    [self setLblKorMoney:nil];
    [self setTxtAccountPW:nil];
    [self setBtnInAccNo:nil];
    [self setLblBalance:nil];
    [super viewDidUnload];
}
@end
