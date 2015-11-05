//
//  SHBLoanCommonInterestPayViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanCommonInterestPayViewController.h"
#import "SHBLoanCommonInterestPayComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanCommonInterestPayViewController ()
{
    int serviceType;
    NSString *encriptedPW;
    NSString *strAccName;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (nonatomic, retain) NSString *strAccName;
- (BOOL)validationCheck;
@end

@implementation SHBLoanCommonInterestPayViewController
@synthesize service;
@synthesize accountInfo;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize strAccName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:    // 출금계좌번호
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
        case 200:    // 잔액조회
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
            
            serviceType = 1;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
        }
            break;
        case 300:
        {
            if(![self validationCheck]) return;

            serviceType = 2;
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
        }
            break;
        case 400:
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
            
            remainPaymentMoney = [aDataSet[@"지불가능잔액->originalValue"] longLongValue];
            transferMoney = [[self.data[@"합계금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
            
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
            
            serviceType = 3;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                 @"출금계좌번호" : self.outAccInfoDic[@"2"],
                                                                                 @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                                                 @"납부금액" : self.data[@"합계금액"],
                                                                                 }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
        }
            break;
        case 3:
        {
            AppInfo.commonDic = @{
                                  @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"대출계좌번호", @"출금계좌번호", @"이자납입기준일", @"정상이자금액", @"연체이자금액", @"이자금액합계"],
                                  @"제목" : @"대출 이자납입",
                                  @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                  @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                  @"대출계좌번호" : ((UILabel *)_lblData[0]).text,
                                  @"출금계좌번호" : _btnAccountNo.titleLabel.text,
                                  @"이자납입기준일" : ((UILabel *)_lblData[1]).text,
                                  @"정상이자금액" : ((UILabel *)_lblData[2]).text,
                                  @"연체이자금액" : ((UILabel *)_lblData[3]).text,
                                  @"이자금액합계" : ((UILabel *)_lblData[4]).text,
                                  @"대출계좌명" : strAccName,
                                  @"출금계좌비밀번호" : self.encriptedPW,
                                  };
            
            SHBLoanCommonInterestPayComfirmViewController *nextViewController = [[[SHBLoanCommonInterestPayComfirmViewController alloc] initWithNibName:@"SHBLoanCommonInterestPayComfirmViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
            
        default:
            break;
    }
    
    self.service = nil;
    
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
            serviceType = 3;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                 @"출금계좌번호" : self.outAccInfoDic[@"2"],
                                                                                 @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                                                 @"납부금액" : self.data[@"합계금액"],
                                                                                 }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
        }
        else
        {
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

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
            self.outAccInfoDic = self.dataList[anIndex];
            [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
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
    
    if([strOutAccNo isEqualToString:@"선택하세요."])
    {
        strAlertMessage = @"‘출금계좌’를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
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
    [SHBUtility getDateWithDash:self.data[@"이자수입종료일자"]],
    [NSString stringWithFormat:@"%@원", self.data[@"정상이자합계금액"]],
    [NSString stringWithFormat:@"%@원", self.data[@"연체이자합계금액"]],
    [NSString stringWithFormat:@"%@원", self.data[@"합계금액"]],
    ];
    
    for(int i = 0; i < [_lblData count]; i ++)
    {
        UILabel *label = _lblData[i];
        label.text = dataArray[i];
    }
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
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
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];

        self.outAccInfoDic = [self outAccountList][0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        _lblBalance.hidden = YES;
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
    [_lblData release];
    [_txtAccountPW release];
    [_lblAccName release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnAccountNo:nil];
    [self setLblBalance:nil];
    [self setLblData:nil];
    [self setTxtAccountPW:nil];
    [self setLblAccName:nil];
    [super viewDidUnload];
}
@end
