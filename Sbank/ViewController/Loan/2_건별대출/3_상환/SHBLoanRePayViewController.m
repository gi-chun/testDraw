//
//  SHBLoanRePayViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanRePayViewController.h"
#import "SHBLoanRePayComfirmViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBLoanRePayViewController ()
{
    int serviceType;
    NSString *encriptedPW;
    NSString *strAccName;
    NSString *strC2090Money;

    
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (nonatomic, retain) NSString *strAccName;
@property (nonatomic, retain) NSString *strC2090Money;

- (BOOL)validationCheck;
@end

@implementation SHBLoanRePayViewController
@synthesize nType;    // 0:원리금 상환, 1:원금 상환 
@synthesize service;
@synthesize accountInfo;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize strAccName;
@synthesize strC2090Money;
@synthesize l_noti;



- (IBAction)buttonTouchUpInside:(UIButton *)sender
{

    NSString *strOutAccNo;
    
    switch ([sender tag]) {

        case 101:    // 근저당권완제여부
        {
            [sender setSelected:!sender.selected];
            
            self.lastAgreeCheck = [sender isSelected];
        }
            break;
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
           strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
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
            
            strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            serviceType = 4;
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
            
//            else
//            {
//                 serviceType = 2;
//                // self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2090" viewController:self] autorelease];
//                self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
//                self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
//                                             @"출금계좌번호" : self.outAccInfoDic[@"2"],
//                                             @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
//                                             @"출금계좌비밀번호" : self.encriptedPW,
//                                             @"납부금액" : self.strC2090Money,
//                                             }] autorelease];
//                [self.service start];
//                _txtAccountPW.text = @"";
//            }
            
          
        }
            break;
        case 400:
        {
            [_btn_lastAgreeCheck setSelected:NO];
            [AppDelegate.navigationController fadePopViewController];
            [AppDelegate.navigationController fadePopViewController];
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
            self.service = nil;
            
            serviceType = 3;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L1221" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                         @"여신계좌번호" : accountInfo[@"대출계좌번호"],
                                         @"거래금액" : self.data[@"거래금액"],
                                         @"출금계좌번호" : self.outAccInfoDic[@"2"],
                                         @"출금계좌비밀번호" : self.encriptedPW,
                                         }] autorelease];
            [self.service start];
            
            return NO;
        }
            break;
        case 3:
        {
            
            long long nTempAmt = [aDataSet[@"상환이자->originalValue"] longLongValue] - [aDataSet[@"정상이자합계금액->originalValue"] longLongValue];
            long long nTempAmt2 = 0;
            if(nType == 0)
            {
                nTempAmt2 = [aDataSet[@"원리금합계->originalValue"] longLongValue] - [aDataSet[@"환출이자->originalValue"] longLongValue];
            }
            else
            {
                nTempAmt2 = [[SHBUtility commaStringToNormalString:((UILabel *)_lblData2[5]).text] longLongValue] - [aDataSet[@"환출이자->originalValue"] longLongValue];
            }
            
            AppInfo.commonDic = @{
            @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"대출계좌번호", @"출금계좌번호", @"대출잔액", @"상환원금", @"중도상환수수료", @"(정상이자금액)", @"(연체이자금액)", @"상환이자금액", @"환출이자금액", @"상환금액합계", @"상환후 대출잔액", @"출금금액"],
            @"제목" : nType == 0 ? @"대출원리금상환" : @"대출원금상환",
            @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
            @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
            @"대출계좌번호" : [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
            @"출금계좌번호" : _btnAccountNo.titleLabel.text,
            @"대출잔액" : [NSString stringWithFormat:@"%@원", aDataSet[@"거래전잔액"]],
            @"상환원금" : [NSString stringWithFormat:@"%@원", aDataSet[@"이자계산내역.원금"]],
            @"중도상환수수료" : [NSString stringWithFormat:@"%@원", aDataSet[@"중도상환수수료"]],
            @"(정상이자금액)" : nType == 0 ? [NSString stringWithFormat:@"%@원", aDataSet[@"정상이자합계금액"]] : @"0원",
            @"(연체이자금액)" : [NSString stringWithFormat:@"%@원", aDataSet[@"연체이자합계금액"]],
            @"상환이자금액" : nType == 0 ? [NSString stringWithFormat:@"%@원", aDataSet[@"상환이자"]] : [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", nTempAmt]],
            @"환출이자금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"환출이자"]],
            @"상환금액합계" : nType == 0 ? ((UILabel *)_lblData1[7]).text : ((UILabel *)_lblData2[5]).text,
            @"상환후 대출잔액" : [NSString stringWithFormat:@"%@원", aDataSet[@"거래후잔액"]],
            @"출금금액" : [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", nTempAmt2]]],
            @"대출계좌명" : self.strAccName,
            @"출금계좌비밀번호" : self.encriptedPW,
            @"출금신계좌번호" : self.outAccInfoDic[@"출금계좌번호"],
            };
            
            SHBLoanRePayComfirmViewController *nextViewController = [[[SHBLoanRePayComfirmViewController alloc] initWithNibName:@"SHBLoanRePayComfirmViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 4:
        {
            //D2004 원장 잔액 체크 후 알럿
            
            long long remainPaymentMoney = [aDataSet[@"지불가능잔액->originalValue"] longLongValue];
            long long transferMoney = [[self.strC2090Money stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
            
            if (remainPaymentMoney < transferMoney)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"계좌 잔액이 부족합니다(지불가능금액 %@원). 계속 진행하시겠습니까?", aDataSet[@"지불가능잔액"]]
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오", nil];
                [alert setTag:3333];
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }
            
            /*
            if ([[self.strC2090Money stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
                [aDataSet[@"원장잔액->originalValue"] longLongValue])
            {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                                     message:[NSString stringWithFormat:@"계좌 잔액이 부족합니다.\n계좌잔액=[%@]",aDataSet[@"원장잔액"]]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"확인"
                                                           otherButtonTitles:nil] autorelease];
                [alertView show];
                return NO;
            }
             */
            
            serviceType = 2;
            // self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2090" viewController:self] autorelease];
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2092" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                         @"출금계좌번호" : self.outAccInfoDic[@"2"],
                                         @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                         @"출금계좌비밀번호" : self.encriptedPW,
                                         @"납부금액" : self.strC2090Money,
                                         }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
        }
            break;
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark - AlertView

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
                                         @"출금계좌번호" : self.outAccInfoDic[@"2"],
                                         @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                         @"출금계좌비밀번호" : self.encriptedPW,
                                         @"납부금액" : self.strC2090Money,
                                         }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
        }
        else
        {
            [AppDelegate.navigationController fadePopViewController];
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
    
    
    if ([self.data[@"근저당권완제여부"] isEqualToString:@"1"])
    //if ([self.data[@"근저당권완제여부"] isEqualToString:@""] || self.data[@"근저당권완제여부"] == nil)
    {
        
        if (![self isLastAgreeCheck])
        {
            strAlertMessage = @"대출 완제시 근저당권 관련 안내를 확인하시기 바랍니다.";
            goto ShowAlert;
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

    self.title = @"대출조회/상환";
    self.strBackButtonTitle = @"대출상환 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"대출상환" maxStep:3 focusStepNumber:1] autorelease]];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
    
    
    self.strAccName = [accountInfo[@"대출상품명"] isEqualToString:@""] ? accountInfo[@"대출과목명"] : accountInfo[@"대출상품명"];
    
    [_btn_lastAgreeCheck setHidden:YES];
    
    if(nType == 0)
    {
        [self.contentScrollView addSubview:_accountInfoView1];
        CGRect viewRect = _comfirmView.frame;
        viewRect.origin.y = _accountInfoView1.frame.size.height + 10;
        _comfirmView.frame = viewRect;
        
        self.strC2090Money = self.data[@"원리금합계"];

        long long nTempAmt = [self.data[@"수입이자->originalValue"] longLongValue] +
        [[self.data[@"중도상환수수료"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] + 
        [[self.data[@"거래금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
        
        [_lblAccName1 initFrame:_lblAccName1.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
        [_lblAccName1 setCaptionText:self.strAccName];
        
        NSArray *dataArray = @[
        [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
        [NSString stringWithFormat:@"%@원", self.data[@"거래금액"]],
        [NSString stringWithFormat:@"%@원", self.data[@"중도상환수수료"]],
        [NSString stringWithFormat:@"%@원", self.data[@"정상이자합계금액"]],
        [NSString stringWithFormat:@"%@원", self.data[@"연체이자합계금액"]],
        [NSString stringWithFormat:@"%@원", self.data[@"수입이자"]],
        [NSString stringWithFormat:@"%@원", self.data[@"환출이자"]],
        [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", nTempAmt]]],
        [NSString stringWithFormat:@"%@원", self.data[@"거래후잔액"]],
        ];
        
        for(int i = 0; i < [_lblData1 count]; i ++)
        {
            UILabel *label = _lblData1[i];
            label.text = dataArray[i];
        }
        
            }
    else
    {
        [self.contentScrollView addSubview:_accountInfoView2];
        CGRect viewRect = _comfirmView.frame;
        viewRect.origin.y = _accountInfoView2.frame.size.height + 10;
        _comfirmView.frame = viewRect;
        
		long long nTempAmt = [self.data[@"원리금합계->originalValue"] longLongValue] - [self.data[@"정상이자합계금액->originalValue"] longLongValue];

        self.strC2090Money = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", nTempAmt]];
        
        nTempAmt = [[self.data[@"연체이자합계금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] +
        [[self.data[@"중도상환수수료"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] +
        [[self.data[@"거래금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];

        [_lblAccName2 initFrame:_lblAccName2.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
        [_lblAccName2 setCaptionText:self.strAccName];
        
        NSArray *dataArray = @[
        [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
        [NSString stringWithFormat:@"%@원", self.data[@"거래금액"]],
        [NSString stringWithFormat:@"%@원", self.data[@"중도상환수수료"]],
        [NSString stringWithFormat:@"%@원", self.data[@"연체이자합계금액"]],
        [NSString stringWithFormat:@"%@원", self.data[@"환출이자"]],
        [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", nTempAmt]]],
        [NSString stringWithFormat:@"%@원", self.data[@"거래후잔액"]],
        ];
        
        for(int i = 0; i < [_lblData2 count]; i ++)
        {
            UILabel *label = _lblData2[i];
            label.text = dataArray[i];
        }

        

    }
    
    self.contentScrollView.contentSize =CGSizeMake(317, _comfirmView.frame.origin.y + _comfirmView.frame.size.height);
    contentViewHeight = self.contentScrollView.contentSize.height;
    
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
    
    if ([self.data[@"근저당권완제여부"] isEqualToString:@"1"])
    //if ([self.data[@"근저당권완제여부"] isEqualToString:@""] || self.data[@"근저당권완제여부"] == nil)
    {
        [l_noti setText:@"근저당권 설정과 관련된 모든 대출을 상환하신 경우 근저당권 말소 또는 유지와 관련하여 대출받으신 영업점에서 상담해야 함을 확인합니다."];
        
        [_btn_lastAgreeCheck setHidden:NO];
        [_btn_lastAgreeCheck setSelected:NO];
        
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
    [_lblData1 release];
    [_lblData2 release];
    [_txtAccountPW release];
    [_accountInfoView1 release];
    [_accountInfoView2 release];
    [_comfirmView release];
    [_lblAccName1 release];
    [_lblAccName2 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnAccountNo:nil];
    [self setLblBalance:nil];
    [self setLblData1:nil];
    [self setLblData2:nil];
    [self setTxtAccountPW:nil];
    [self setAccountInfoView1:nil];
    [self setAccountInfoView2:nil];
    [self setComfirmView:nil];
    [self setLblAccName1:nil];
    [self setLblAccName2:nil];
    [super viewDidUnload];
}

@end
