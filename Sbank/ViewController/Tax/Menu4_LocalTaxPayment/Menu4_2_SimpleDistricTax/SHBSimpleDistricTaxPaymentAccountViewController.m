//
//  SHBSimpleDistricTaxPaymentAccountViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 6..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSimpleDistricTaxPaymentAccountViewController.h"
#import "SHBGiroTaxListService.h"           // 지로 서비스
#import "SHBAccountService.h"               // 계좌관련 서비스
#import "SHBSimpleDistricSecurityViewController.h"      // 다음 view


@interface SHBSimpleDistricTaxPaymentAccountViewController ()

@end

@implementation SHBSimpleDistricTaxPaymentAccountViewController

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
    else if ( nil == secureTextField1.text || [secureTextField1.text isEqualToString:@""] )
    {
        strErrorMessage = @"출금계좌비밀번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( [secureTextField1.text length] != 4 )
    {
        strErrorMessage = @"출금계좌비밀번호는 4자리를 입력해 주십시오";
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
    switch ([sender tag]) {
            
        case 11:            // 계좌선택
        {
            [self getOutAccountList];
            
            // 계좌 리스트를 얻어온다
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:(NSMutableArray *)self.dataList CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 12:            // 잔액조회
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
            
        case 21:            // 납부버튼
        {
            if ([self checkException])
            {
                return;
            }
            
            SHBDataSet     *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                                           @{
                                           @"출금계좌비밀번호"          : secureTextField1.text,
                                           @"출금계좌번호"            : buttonAccount.titleLabel.text,
                                           @"은행구분"              : [dicAccountDic objectForKey:@"은행코드"], // (!주의)신, 구 계좌에 따른 값 변경 있음 정보처리되어서 옴
                                           @"납부금액"              : self.dicDataDictionary[@"납부금액"],
                                           @"reservationField1"    : @"NewJibang",
                                           @"reservationField2"    : @"G1414"
                                           }] autorelease];
            
            self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: LOCAL_TAX_ACCOUNT_CONFIRM  viewController: self] autorelease];
            self.service.previousData = dicDataDic;
            [self.service start];
            
            secureTextField1.text = @"";
            
        }
            break;
            
        case 22:            // 취소버튼
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
    if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2090"])      // 계좌가 확인된 경우
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            [self.dicDataDictionary setObject:buttonAccount.titleLabel.text forKey:@"출금계좌번호"];
            [self.dicDataDictionary setObject:self.encriptedPW forKey:@"출금계좌비밀번호"];
            
            SHBSimpleDistricSecurityViewController *viewController = [[SHBSimpleDistricSecurityViewController alloc] initWithNibName:@"SHBSimpleDistricSecurityViewController" bundle:nil];
            
            viewController.dicDataDictionary = self.dicDataDictionary;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
            return NO;
        }
    }
    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G1412"] )      // 납부금액 판단
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            if ([aDataSet[@"납기내후구분"] isEqualToString:@"B"])
            {
                [aDataSet setObject:aDataSet[@"납기내금액"] forKey:@"납부금액"];
            }
            else
            {
                [aDataSet setObject:aDataSet[@"납기후금액"] forKey:@"납부금액"];
            }
            
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"납부금액"]] forKey:@"납부금액원"];
            self.dicDataDictionary = aDataSet;              // data를 넘기기 위해
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D2004"] )           // 잔액을 넣는다
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            labelRemainAmount.text = [NSString stringWithFormat:@"출금가능잔액 %@원", [aDataSet objectForKey:@"지불가능잔액"]];
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark - SHBListPopupViewDelegate

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    if ( [self.dataList count] < 1 )
    {
        [buttonAccount setTitle:@"출금계좌정보가 없습니다" forState:UIControlStateNormal];
    }
    else
    {
        dicAccountDic = [self.dataList objectAtIndex:anIndex];
        [buttonAccount setTitle:[dicAccountDic objectForKey:@"2"] forState:UIControlStateNormal];
        
        labelRemainAmount.text = @"";
    }
    
    secureTextField1.text = @"";
}

- (void)listPopupViewDidCancel
{
    
}


#pragma mark -
#pragma mark SecureTextField Delegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // 필요시 super 호출
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}


#pragma mark -
#pragma mark Notifications

- (void)cancelButtonDidPush
{
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
    
    // title 설정
    self.title = @"지방세납부";
    self.strBackButtonTitle = @"간편납부번호 1단계";
    
    AppInfo.isNeedBackWhenError = YES;
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"전문종별코드" : @"0200",
                            @"거래구분코드" : @"531002",
                            @"이용기관지로번호" : [dicDataDictionary objectForKey:@"이용기관지로번호1"],
                            @"조회구분" : @"E",
                            @"전자납부번호" : [dicDataDictionary objectForKey:@"전자납부번호"],
                            @"예비1" : @""
                            }] autorelease];
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_DISTRIC_PAYMENT_DETAIL viewController: self ] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    [secureTextField1 showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
    
    // 계좌정보 set
    [self getOutAccountList];
    [self listPopupView:nil didSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SimpleDistricCancelButtonPushed" object:nil];
    // cancel button notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonDidPush) name:@"SimpleDistricCancelButtonPushed" object:nil];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SimpleDistricCancelButtonPushed" object:nil];
    
    [super dealloc];
}

@end
