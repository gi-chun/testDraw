//
//  SHBLoanCancelViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanCancelViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBLoanCancelComfirmViewController.h"


@interface SHBLoanCancelViewController ()
{
    NSString *encriptedPW;
   
}
@property (retain, nonatomic) NSString *encriptedPW;

- (BOOL)validationCheck;
@end

@implementation SHBLoanCancelViewController
@synthesize service;
@synthesize accountInfo;
@synthesize encriptedPW;


- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            if(![self validationCheck]) return;
            
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"C2090" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                                 @"출금계좌번호" : self.accountInfo[@"대출계좌번호"],
                                                                                 @"출금은행구분" : @"1",
                                                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                                                 }] autorelease];
            [self.service start];
            _txtAccountPW.text = @"";
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
    
    NSMutableDictionary *signInfoDic = [[[NSMutableDictionary alloc] initWithDictionary:
                                         @{
                                           @"제목" : @"한도대출 한도를 해지합니다.",
                                           @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                           @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                           @"대출계좌번호" : ((UILabel *)_lblData[0]).text,
                                           @"출금계좌비밀번호" : self.encriptedPW,
                                           @"대출계좌번호_전문" :accountInfo[@"대출계좌번호"],
                                           }] autorelease];
    
    AppInfo.commonDic = (NSDictionary *)signInfoDic;
    
    
    SHBLoanCancelComfirmViewController *nextViewController = [[[SHBLoanCancelComfirmViewController alloc] initWithNibName:@"SHBLoanCancelComfirmViewController" bundle:nil] autorelease];
    [self.navigationController pushFadeViewController:nextViewController];
    
    return NO;
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
    
    self.title = @"대출조회/한도해지";
    self.strBackButtonTitle = @"한도대출 해지 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"한도대출 해지" maxStep:3 focusStepNumber:1] autorelease]];
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
    
   
    
    NSArray *dataArray = @[
                           [accountInfo[@"신계좌변환여부"] isEqualToString:@"1"] ? accountInfo[@"대출계좌번호"] : accountInfo[@"구계좌번호"],
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
