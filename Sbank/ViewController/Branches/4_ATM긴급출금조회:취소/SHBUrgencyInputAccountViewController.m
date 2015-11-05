//
//  SHBUrgencyInputAccountViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyInputAccountViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBUrgencyDetailViewController.h"

@interface SHBUrgencyInputAccountViewController ()

@property (nonatomic, retain) NSMutableArray *marrAccounts;	// 출금계좌번호 배열
@property (nonatomic, retain) NSDictionary *selectedData;	// 선택된 출금계좌
@property (nonatomic, retain) NSString *strEncryptedNum1;	// Encrypt된 계좌비밀번호

@end

@implementation SHBUrgencyInputAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_sbAccountNum release];
    [_tfAccountPW release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSbAccountNum:nil];
    [self setTfAccountPW:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
	[self setTitle:@"ATM긴급출금조회/취소"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금 조회" maxStep:0 focusStepNumber:0]autorelease]];
	
	[self.sbAccountNum setDelegate:self];
	[self.tfAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	
	self.contentScrollView.contentSize = CGSizeMake(317, 148);
    contentViewHeight = contentViewHeight > 148 ? contentViewHeight : 148;
    
    
    // ios7상단 스크롤
    FrameResize(self.scrollView, 317, height(self.scrollView));
    FrameReposition(self.scrollView, 0, 77);
    
    
    startTextFieldTag = 444000;
    endTextFieldTag = 444000;
	
	self.marrAccounts = [self outAccountList];
	self.selectedData = [self.marrAccounts objectAtIndex:0];
	[self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;
	if ([self.tfAccountPW.text length] != 4) {
		strMsg = @"계좌비밀번호를 입력하여 주십시오.";
	}
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		
		return;
	}
	
	self.service = [[[SHBBranchesService alloc]initWithServiceId:kC2090Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"출금계좌비밀번호" : self.strEncryptedNum1,
								@"출금계좌번호" : [self.selectedData objectForKey:@"출금계좌번호"],
								@"은행구분" : [self.selectedData objectForKey:@"은행구분"],
								}];
	[self.service start];
    
    
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	[selectBox setState:SHBSelectBoxStateSelected];
	
	if (selectBox == self.sbAccountNum) {
		if ([self.marrAccounts count]) {
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:2] autorelease];
			[popupView setDelegate:self];
			[popupView showInView:self.navigationController.view animated:YES];
		}
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	[self.sbAccountNum setState:SHBSelectBoxStateNormal];
	
	self.selectedData = [self.marrAccounts objectAtIndex:anIndex];
	
	[self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
    
    self.tfAccountPW.text = @"";
    self.strEncryptedNum1 = @"";
}

- (void)listPopupViewDidCancel
{
	[self.sbAccountNum setState:SHBSelectBoxStateNormal];
}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    Debug(@"EncriptedVaule: %@", value);
	
	if (textField == self.tfAccountPW) {
		self.strEncryptedNum1 = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
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
	if (self.service.serviceId == kC2090Id) {
		
		[self.tfAccountPW setText:nil];
		
		self.service = [[[SHBBranchesService alloc]initWithServiceId:kE1701Id viewController:self]autorelease];
		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
									@"출금계좌번호" : [self.selectedData objectForKey:@"출금계좌번호"],
									}];
		[self.service start];
	}
	else if (self.service.serviceId == kE1701Id)
	{
        [aDataSet insertObject:[self.selectedData objectForKey:@"2"]
                        forKey:@"2"
                       atIndex:0];
		
		SHBUrgencyDetailViewController *viewController = [[[SHBUrgencyDetailViewController alloc]initWithNibName:@"SHBUrgencyDetailViewController" bundle:nil]autorelease];
		viewController.data = aDataSet;
		[self checkLoginBeforePushViewController:viewController animated:YES];
        
        self.selectedData = [self.marrAccounts objectAtIndex:0];
        [self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
	}
	
	return NO;
}

@end
