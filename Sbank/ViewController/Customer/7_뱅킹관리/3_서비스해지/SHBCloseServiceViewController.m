//
//  SHBCloseServiceViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseServiceViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBSettingsService.h"
#import "SHBCloseServiceCompleteViewController.h"

@interface SHBCloseServiceViewController ()

@property (nonatomic, retain) NSMutableArray *marrAccounts;	// 출금계좌번호리스트
@property (nonatomic, retain) NSDictionary *selectedData;	// 선택한 계좌번호
@property (nonatomic, retain) NSString *strEncryptedPW;

@end

@implementation SHBCloseServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_selectedData release];
	[_strEncryptedPW release];
	[_sbAccountList release];
	[_tfAccountPW release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setSbAccountList:nil];
	[self setTfAccountPW:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"서비스해지"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    
    
    FrameResize(self.scrollView, 317, height(self.scrollView));
    FrameReposition(self.scrollView, 0, 77);
    
    
    
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"정보입력 및 서비스 해지 동의" maxStep:0 focusStepNumber:0]autorelease]];
	
    
	[self.sbAccountList setDelegate:self];
	[self.tfAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	
	self.marrAccounts = [self outAccountList];
    if ([self.marrAccounts count] > 0) {
        self.selectedData = [self.marrAccounts objectAtIndex:0];
        [self.sbAccountList setText:[self.selectedData objectForKey:@"2"]];
    }
	
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)yesBtnAction:(SHBButton *)sender
{
    if ([self.marrAccounts count] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"보유중인 출금계좌가 없습니다. 인터넷뱅킹의 출금 계좌관리를 확인하여 주시기 바랍니다."];
        return;
    }
    
	if ([self.tfAccountPW.text length] != 4) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"계좌비밀번호를 입력하여 주십시오."];
		
		return;
	}
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"출금계좌비밀번호" : self.strEncryptedPW,
						   @"출금계좌번호" : [self.selectedData objectForKey:@"2"],
						   @"은행구분" : [self.selectedData objectForKey:@"은행구분"],
						   }];
	self.service = [[[SHBSettingsService alloc]initWithServiceId:kC2090Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
    
}

- (IBAction)noBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    Debug(@"EncriptedVaule: %@", value);
	
	if (textField == self.tfAccountPW) {
		self.strEncryptedPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	if (selectBox == self.sbAccountList) {
		[selectBox setState:SHBSelectBoxStateSelected];
		
		if ([self.marrAccounts count]) {
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:4] autorelease];
			[popupView setDelegate:self];
			[popupView showInView:self.navigationController.view animated:YES];
		}
		else
		{
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"보유중인 출금계좌가 없습니다. 인터넷뱅킹의 출금 계좌관리를 확인하여 주시기 바랍니다."];
		}
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	[self.sbAccountList setState:SHBSelectBoxStateNormal];
	
	self.selectedData = [self.marrAccounts objectAtIndex:anIndex];
	
	[self.sbAccountList setText:[self.selectedData objectForKey:@"2"]];
}

- (void)listPopupViewDidCancel
{
	[self.sbAccountList setState:SHBSelectBoxStateNormal];
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType) {
		
		SHBCloseServiceCompleteViewController *viewController = [[SHBCloseServiceCompleteViewController alloc]initWithNibName:@"SHBCloseServiceCompleteViewController" bundle:nil];
		viewController.needsLogin = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (void)getElectronicSignCancel
{
	Debug(@"getElectronicSignCancel");
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBCloseServiceViewController class]])
//        {
//			[self.navigationController popToViewController:viewController animated:YES];
//			break;
//		}
//	}
//	[self.navigationController popToViewController:self animated:YES];
	//[AppDelegate.navigationController fadePopToRootViewController];
    //[AppDelegate.navigationController fadePopToRootViewController];
    self.marrAccounts = [self outAccountList];
    if ([self.marrAccounts count] > 0)
    {
        self.selectedData = [self.marrAccounts objectAtIndex:0];
        [self.sbAccountList setText:[self.selectedData objectForKey:@"2"]];
    }
	
	
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
	Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == kC2090Id)
	{
		[self.tfAccountPW setText:nil];
		
		AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"서비스해지";
		
		AppInfo.electronicSignCode = @"E4303";
		AppInfo.electronicSignTitle = @"서비스해지";
//		[AppInfo addElectronicSign:@"서비스해지"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:@"(3)서비스명: 신한S뱅크 서비스해지"];

		self.service = [[[SHBSettingsService alloc]initWithServiceId:kE4303Id viewController:self]autorelease];
		[self.service start];
	}

	
	return NO;
}


@end
