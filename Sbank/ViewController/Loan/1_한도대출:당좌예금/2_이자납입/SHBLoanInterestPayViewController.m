//
//  SHBLoanInterestPayViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 28..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanInterestPayViewController.h"
#import "SHBLoanInterestPayComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanInterestPayViewController ()
{
    NSString *encriptedPW;
    NSString *strAccName;
    
    NSInteger serviceType;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (nonatomic, retain) NSString *strAccName;
- (BOOL)validationCheck;
@end

@implementation SHBLoanInterestPayViewController
@synthesize service;
@synthesize accountInfo;
@synthesize encriptedPW;
@synthesize strAccName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            if(![self validationCheck]) return;
            
            serviceType = 1;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : self.accountInfo[@"대출계좌번호"]}] autorelease];
            [self.service start];
        }
            break;
        case 200:
        {
            AppInfo.isNeedClearData = YES;
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (serviceType == 1)
    {
        long long remainPaymentMoney = 0;
        long long transferMoney = 0;
        
        remainPaymentMoney = [aDataSet[@"지불가능잔액->originalValue"] longLongValue];
        transferMoney = [[self.data[@"이자합계금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
        
        if (remainPaymentMoney < transferMoney)
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                                 message:[NSString stringWithFormat:@"계좌 잔액이 부족합니다(지불가능금액 %@원). 계속 진행하시겠습니까?", aDataSet[@"지불가능잔액"]]
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"예", @"아니오", nil] autorelease];
            [alertView setTag:3333];
            [alertView show];
            
            self.service = nil;
            
            return NO;
        }
        
        serviceType = 2;
        
        self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
        self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                             @"출금계좌번호" : self.accountInfo[@"대출계좌번호"],
                                                                             @"출금은행구분" : @"1",
                                                                             @"출금계좌비밀번호" : self.encriptedPW,
                                                                             @"납부금액" : self.data[@"이자합계금액"],
                                                                             }] autorelease];
        [self.service start];
        _txtAccountPW.text = @"";
    }
    else if (serviceType == 2)
    {
        NSMutableDictionary *signInfoDic = [[[NSMutableDictionary alloc] initWithDictionary:
                                             @{
                                               @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"대출계좌번호", @"출금계좌번호", @"이자금액", @"출금금액"],
                                               @"제목" : @"대출 이자납입",
                                               @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                               @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                               @"대출계좌번호" : ((UILabel *)_lblData[0]).text,
                                               @"출금계좌번호" : ((UILabel *)_lblData[0]).text,
                                               @"이자금액" : ((UILabel *)_lblData[1]).text,
                                               @"출금금액" : ((UILabel *)_lblData[1]).text,
                                               @"대출계좌명" : strAccName,
                                               @"출금계좌비밀번호" : self.encriptedPW,
                                               @"한도대출계좌번호" : self.accountInfo[@"대출계좌번호"],
                                               }] autorelease];
        
        AppInfo.commonDic = (NSDictionary *)signInfoDic;
        
        SHBLoanInterestPayComfirmViewController *nextViewController = [[[SHBLoanInterestPayComfirmViewController alloc] initWithNibName:@"SHBLoanInterestPayComfirmViewController" bundle:nil] autorelease];
        [self.navigationController pushFadeViewController:nextViewController];
    }
    
    return NO;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 3333)
    {
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            serviceType = 2;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                 @"출금계좌번호" : self.accountInfo[@"대출계좌번호"],
                                                                                 @"출금은행구분" : @"1",
                                                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                                                 @"납부금액" : self.data[@"이자합계금액"],
                                                                                 }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
        }
        else
        {
            AppInfo.isNeedClearData = YES;
            [self.navigationController fadePopViewController];
        }
    }
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];

    self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
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
    
    self.title = @"이자조회/납입";
    self.strBackButtonTitle = @"이자납입 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이자납입" maxStep:3 focusStepNumber:1] autorelease]];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
    
    self.strAccName = [accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"];
    
    [_lblAccName initFrame:_lblAccName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [_lblAccName setCaptionText:self.strAccName];
    
    NSArray *dataArray = @[
    [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
    [NSString stringWithFormat:@"%@원", self.data[@"이자합계금액"]],
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.encriptedPW = nil;
    
    [_lblData release];
    [_txtAccountPW release];
    [_lblAccName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblData:nil];
    [self setTxtAccountPW:nil];
    [self setLblAccName:nil];
    [super viewDidUnload];
}
@end
