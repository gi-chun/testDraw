//
//  SHBSMSInfoViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSMSInfoViewController.h"
#import "SHBAccountService.h"
#import "SHBSMSEditViewController.h"
#import "SHBAddressBookViewController.h"

@interface SHBSMSInfoViewController ()
{
    NSString *strSender;
    NSString *strReceiver;
    NSString *strAccount;
    NSString *strMoney;
    NSString *strBankName;
}
@property (retain, nonatomic) NSString *strSender;
@property (retain, nonatomic) NSString *strReceiver;
@property (retain, nonatomic) NSString *strAccount;
@property (retain, nonatomic) NSString *strMoney;
@property (retain, nonatomic) NSString *strBankName;
@end

@implementation SHBSMSInfoViewController
@synthesize pViewController;
@synthesize pSelector;
@synthesize strSender;
@synthesize strReceiver;
@synthesize strAccount;
@synthesize strMoney;
@synthesize strBankName;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
        case 100:
        {
            SHBSMSEditViewController *nextViewController = [[[SHBSMSEditViewController alloc] initWithNibName:@"SHBSMSEditViewController" bundle:nil] autorelease];
            nextViewController.pViewController = self;
            nextViewController.pSelector = @selector(senderChange:);
            [self.navigationController pushFadeViewController:nextViewController];
            nextViewController.txtSenderName.text = self.strSender;
        }
            break;
        case 200:
        {
            SHBAddressBookViewController *nextViewController = [[[SHBAddressBookViewController alloc] initWithNibName:@"SHBAddressBookViewController" bundle:nil] autorelease];
            nextViewController.pViewController = self;
            nextViewController.pSelector = @selector(recvTelChange:);
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 300:
        {
            if(![self validationCheck]) return;
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2010" viewController:self] autorelease];
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                    @"보내는분전화번호" : [_txtSendTelNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"받는분전화번호" : [_txtRecvTelNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"문자내용" : _lblData01.text,
                                    }];
            
            self.service.requestData = aDataSet;
            [self.service start];
            [aDataSet release];
        }
            break;
        case 400:
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지

	if(_lblData01.text != nil && [_lblData01.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 80 )
	{
        strAlertMessage = @"‘메시지’는 80자까지 가능합니다.";
        goto ShowAlert;
	}
    
	if(_txtSendTelNo.text == nil ||
	   [_txtSendTelNo.text length] <= 0 ||
	   [_txtSendTelNo.text length] > 12 ||
	   [_txtSendTelNo.text length] <= 8)
	{
        strAlertMessage = @"‘발신자 휴대폰번호’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
	
	if(_txtRecvTelNo.text == nil ||
	   [_txtRecvTelNo.text length] <= 0 ||
	   [_txtRecvTelNo.text length] > 12 ||
	   [_txtRecvTelNo.text length] <= 8)
	{
        strAlertMessage = @"‘수신자 휴대폰번호’의 입력값이 유효하지 않습니다.";
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

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"문자메세지가 정상적으로 발송 되었습니다.\n항상 저희 은행을 이용해 주셔서 감사합니다."
												   delegate:self
										  cancelButtonTitle:@"확인"
										  otherButtonTitles:nil];

	[alert show];
	[alert release];
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
	
    // 숫자이외에는 입력안되게 체크
    NSString *NUMBER_SET = @"0123456789";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (!basicTest && [string length] > 0 )
    {
        return NO;
    }
    if (dataLength + dataLength2 > 12)
    {
        return NO;
    }
	
    return YES;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
	if (buttonIndex == 0) {
        [self.pViewController performSelector:self.pSelector];
        [self.navigationController fadePopViewController];
	}
}

- (void)senderChange:(NSDictionary *)dic
{
    self.strSender = dic[@"Sender"];
}

- (void)recvTelChange:(NSDictionary *)dic
{
    _txtRecvTelNo.text = dic[@"TEL"];
    // 화면 문제로 추가
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
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

    self.title = AppInfo.eSignNVBarTitle;
    self.strBackButtonTitle = @"SMS 전송";

    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    if(self.data != nil)
    {
        self.strSender = self.data[@"입금자성명"];
        self.strReceiver = self.data[@"수취인성명"];
        self.strAccount = self.data[@"입금계좌번호"];
        self.strAccount = [self.strAccount stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
        self.strMoney = self.data[@"이체금액"];
        self.strBankName = self.data[@"입금은행"];
    }
    else
    {
        self.strSender = AppInfo.commonDic[@"입금자성명"];
        self.strReceiver = AppInfo.commonDic[@"수취인성명"];
        self.strAccount = AppInfo.commonDic[@"입금계좌번호"];
        self.strAccount = [self.strAccount stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
        self.strMoney = AppInfo.commonDic[@"이체금액"];
        self.strBankName = AppInfo.commonDic[@"입금은행"];
    }
    
    _txtSendTelNo.text = [AppInfo.phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];

    _lblData01.text = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.", self.strSender, self.strReceiver, self.strBankName, self.strAccount, self.strMoney];
    
    _txtSendTelNo.strLableFormat = @"입력된 발신자 휴대폰번호는 %@ 입니다";
    _txtSendTelNo.strNoDataLable = @"입력된 발신자 휴대폰번호가 없습니다";

    _txtRecvTelNo.strLableFormat = @"입력된 수신자 휴대폰번호는 %@ 입니다";
    _txtRecvTelNo.strNoDataLable = @"입력된 수신자 휴대폰번호가 없습니다";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    // delegate 삭제되는 문제로 추가
    ((UITextField *)_txtRecvTelNo).delegate = self;
    _txtRecvTelNo.accDelegate = self;
    ((UITextField *)_txtSendTelNo).delegate = self;
    _txtSendTelNo.accDelegate = self;
    
    _lblData01.text = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.", self.strSender, self.strReceiver, self.strBankName, self.strAccount, self.strMoney];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_lblData01 release];
    [_txtSendTelNo release];
    [_txtRecvTelNo release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setLblData01:nil];
    [self setTxtSendTelNo:nil];
    [self setTxtRecvTelNo:nil];
    [super viewDidUnload];
}

@end
