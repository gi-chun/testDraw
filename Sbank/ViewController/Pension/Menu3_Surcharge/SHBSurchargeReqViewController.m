//
//  SHBSurchargeReqViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 19..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSurchargeReqViewController.h"
#import "SHBAccountService.h"               // 계좌관련 서비스
#import "SHBPentionService.h"               // 퇴직연금 서비스
#import "SHBSurchargeSecurityViewController.h"          // 다음 view


@interface SHBSurchargeReqViewController ()

@end

@implementation SHBSurchargeReqViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;
@synthesize encriptedPW;


#pragma makr -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString    *strErrorMessage = @"입력값을 확인해 주세요.";
    
    if ( nil == buttonAccount.titleLabel.text || [buttonAccount.titleLabel.text isEqualToString:@""] || [buttonAccount.titleLabel.text isEqualToString:@"출금계좌정보가 없습니다"] )
    {
        strErrorMessage = @"출금계좌를 선택하여 주십시오.";
        goto errorCase;
    }
    else if ( nil == textFieldPassword.text || [textFieldPassword.text isEqualToString:@""] )
    {
        strErrorMessage = @"출금계좌비밀번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [textFieldPassword.text length] != 4 )
    {
        strErrorMessage = @"출금계좌비밀번호는 4자리를 입력해 주십시오";
        goto errorCase;
    }
    else if ( nil == textFieldAmount.text || [textFieldAmount.text isEqualToString:@""] )
    {
        strErrorMessage = @"'이체금액'의 입력값이 유효하지 않습니다.";
        goto errorCase;
    }
    else if ( [textFieldAmount.text isEqualToString:@"0"] )
    {
        strErrorMessage = @"'이체금액'은 0원을 입력하실 수 없습니다.";
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


// 계좌확인 서비스 함수
- (void)requestConfirmService
{
    NSString *strReservationField2 = @"퇴직연금조회입금";
    
    if ( [self.dicDataDictionary[@"제도구분"] length] > 0 )
    {
        // 제도구분 여부에 따라 필드값이 달라지는듯
        strReservationField2 = @"퇴직연금입금";
    }
    
    // 확인필요
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"고객번호" : AppInfo.customerNo,
                            //@"주민번호" : AppInfo.ssn,
                            //@"주민번호" : [AppInfo getPersonalPK],
                            @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                            @"출금계좌번호" : buttonAccount.titleLabel.text,
                            @"출금계좌비밀번호" : self.encriptedPW,
                            @"입금은행코드" : @"88",
                            @"입금계좌번호" : labelAccount1.text,
                            @"이체금액" : textFieldAmount.text,
                            @"reservationField1" : @"퇴직입금",
                            @"reservationField2" : strReservationField2
                            }] autorelease];
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_SURCHARGE_CONFIRM viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    textFieldPassword.text = @"";
    labelAmountLeft.text = @"";
}

- (void)getOutAccountList
{
    NSMutableArray *tableDataArray = [self outAccountList];
    
    if ([tableDataArray count] == 0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"출금가능 계좌가 없습니다."];
        return;
    }
    
    // 계좌 정보 전달을 위해
    self.dataList = (NSArray *)tableDataArray;
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    [self didCompleteButtonTouch];
    
    switch ([sender tag]) {
            
        case 11:            // 계좌번호 버튼
        {
            [self getOutAccountList];
            
            // 계좌 리스트를 얻어온다
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:(NSMutableArray *)self.dataList CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 12:            // 잔액조회 버튼
        {
            if ( nil == buttonAccount.titleLabel.text || [buttonAccount.titleLabel.text isEqualToString:@""])
            {
                return;
            }
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : buttonAccount.titleLabel.text}] autorelease];
            [self.service start];
            
        }
            break;
            
        case 21:            // 확인 버튼
        {
            
            if ([self checkException])       // 예외처리
            {
                return;
            }
            
            if ( [self.dicDataDictionary[@"제도구분"] isEqualToString:@"2"] || [self.dicDataDictionary[@"제도구분코드"] isEqualToString:@"2"] )   // DC의 경우 입금 확인 가능한 계좌인지 먼저 확인 필요
            {
                OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                        @{
                                        @"서비스ID" : @"SRPW765060Q0",
                                        @"고객구분" : @"3",
                                        @"플랜번호" : self.dicDataDictionary[@"플랜번호"],
                                        @"가입자번호" : self.dicDataDictionary[@"가입자번호"],
                                        @"제도구분" : @"2",//self.dicDataDictionary[@"제도구분"],   // 조회화면(1번메뉴), 입금화면(3번메뉴)에서 오는 경우
                                        @"페이지인덱스" : @"1",                                   // 조회는 제도구분코드로, 입금에서는 제도구분으로 들어오나
                                        @"전체조회건수" : @"0",                                   // 값은 2로 동일하다
                                        @"페이지패치건수" : @"500",
                                        @"예비필드" : @"",
                                        @"이체금액" : textFieldAmount.text
                                        }] autorelease];
                
                self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_SURCHARGE_DC_CONFIRM viewController: self] autorelease];
                self.service.previousData = aDataSet;
                [self.service start];
                
                return;
            }
            
            // 계좌확인 서비스 실행
            [self requestConfirmService];
            
        }
            break;
            
        case 22:            // 취소 버튼
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D2004"] )           // 계좌 잔액의 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )              // 정상 case
        {
            labelAmountLeft.text = [NSString stringWithFormat:@"출금가능잔액 %@원", [aDataSet objectForKey:@"지불가능잔액"]];
            return NO;
        }
    }
    else if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3725"])        // DC 입금 가능 여부
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )          // 정상 case
        {
            // DC의 입금 가능의 경우 입금예정번호가 필요하다
            [self.dicDataDictionary setObject:aDataSet[@"입금예정번호"] forKey:@"입금예정번호"];
            
            // DC이면서 입금 가능한 경우 계좌확인 실행
            [self requestConfirmService];
            
            return NO;
        }
    }
    else if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D2031"])        // 계좌정보 확인이 된 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )          // 정상 case
        {
            [self.dicDataDictionary setObject:buttonAccount.titleLabel.text forKey:@"출금계좌번호"];
            [self.dicDataDictionary setObject:textFieldAmount.text forKey:@"이체금액"];
            [self.dicDataDictionary setObject:self.encriptedPW forKey:@"출금계좌비밀번호"];
            [self.dicDataDictionary setObject:labelAccount1.text forKey:@"입금계좌번호"];
            
            SHBSurchargeSecurityViewController *viewController = [[SHBSurchargeSecurityViewController alloc] initWithNibName:@"SHBSurchargeSecurityViewController" bundle:nil];
            
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}


#pragma mark -
#pragma mark SecureTextField Delegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // 필요시 super 호출
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}

- (IBAction)closeNormalPad:(id)sender
{
    [super closeNormalPad:sender];
    [textFieldPassword becomeFirstResponder];
}

#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 필요시 super 호출
    [super textFieldDidEndEditing:textField];
    
    if (textField == textFieldAmount)
    {
        if (![textFieldAmount.text isEqualToString:@""])
        {
            labelAmountString.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
        }
        else
        {
            labelAmountString.text = @"";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == textFieldAmount)
    {
        if ([textField.text length] > 13)
        {
            textField.text = [textField.text substringToIndex:14];
            return NO;
        }
        
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
            textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
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

#pragma mark -
#pragma mark - SHBListPopupView Delegate

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    if ( [self.dataList count] < 1 )
    {
        [buttonAccount setTitle:@"출금계좌정보가 없습니다" forState:UIControlStateNormal];
    }
    else
    {
        // 정보 setting
        dicAccountDic = [self.dataList objectAtIndex:anIndex];
        // 계좌번호를 넣는다
        [buttonAccount setTitle:[dicAccountDic objectForKey:@"2"] forState:UIControlStateNormal];
    }

    textFieldPassword.text = @"";
    labelAmountLeft.text = @"";
}

- (void)listPopupViewDidCancel
{
    
}


#pragma mark -
#pragma mark SHBTextField Delegate

- (void)didCompleteButtonTouch
{
    [super didCompleteButtonTouch];
}

#pragma mark -
#pragma mark Notifications

- (void)cancelButtonPushed
{
    labelAmountLeft.text = @"";
    textFieldAmount.text = @"";
    labelAmountString.text = @"";
    
    [self listPopupView:nil didSelectedIndex:0];
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    self.title = @"가입자부담금입금";
    self.strBackButtonTitle = @"가입자부담금입금 1단계";
    
    labelSubTitle.text = self.dicDataDictionary[@"플랜명"];
    
    // 부담금 통합계좌번호가 있는 경우
    if ( ([self.dicDataDictionary[@"부담금통합계좌번호"] length] > 0) )
    {
        labelAccount1.text = self.dicDataDictionary[@"부담금통합계좌번호"];
    }
    else
    {
        labelAccount1.text = self.dicDataDictionary[@"계좌번호"];
    }
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    [textFieldPassword showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    textFieldAmount.accDelegate = self;
    
    // 계좌정보 set
    [self getOutAccountList];
    [self listPopupView:nil didSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"surchargeCancelButtonPushed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPushed) name:@"surchargeCancelButtonPushed" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    self.encriptedPW = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"surchargeCancelButtonPushed" object:nil];
    
    [super dealloc];
}

@end
