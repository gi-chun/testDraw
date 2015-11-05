//
//  SHBLoginSettingViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoginSettingViewController.h"

@interface SHBLoginSettingViewController ()

@property (nonatomic, retain) NSMutableArray *marrCertificates;		// 공인인증서 배열
@property (nonatomic, retain) NSMutableDictionary *selectedData;	// 선택된 데이터

@end

@implementation SHBLoginSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_marrCertificates release];
	[_selectedData release];
	[_sbCertificate release];
	[_btnRadio1 release];
	[_btnRadio2 release];
	[_btnRadio3 release];
	[_ivBox release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setSbCertificate:nil];
	[self setBtnRadio1:nil];
	[self setBtnRadio2:nil];
	[self setBtnRadio3:nil];
	[self setIvBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
//    }
	[self setTitle:@"로그인 설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	UIImage *img = [UIImage imageNamed:@"box_infor.png"];
	self.ivBox.image = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
	[self.view viewWithTag:NAVI_BACK_BTN_TAG].accessibilityLabel = [NSString stringWithFormat:@"%@ 뒤로이동", @"환경설정"];
	NSMutableArray *marr = [AppInfo loadCertificates];		// 공인인증서 목록 가져오기
	
	self.marrCertificates = [NSMutableArray array];
	
	for (CertificateInfo *ci in marr)
	{
		NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
		[mdic setObject:ci.user forKey:@"1"];
		[mdic setObject:[NSString stringWithFormat:@"발급자 : %@",ci.issuer] forKey:@"2"];
		[mdic setObject:[NSString stringWithFormat:@"만료일 : %@",ci.expire] forKey:@"3"];
		[mdic setObject:ci.type forKey:@"4"];
		[self.marrCertificates addObject:mdic];
	}
	
	SettingsLoginType type = [[NSUserDefaults standardUserDefaults]loginTypeForSetting];
	switch (type) {
		case SettingsLoginTypeDefault:
			[self.btnRadio1 setSelected:YES];
			break;
		case SettingsLoginTypeCertificate:
			[self.btnRadio2 setSelected:YES];
			break;
		case SettingsLoginTypeCertificateSelected:
			[self.btnRadio3 setSelected:YES];
			break;
			
		default:
			//[self.btnRadio1 setSelected:YES];
			break;
	}
	
	[self.sbCertificate setText:@"지정인증서 선택"];
	[self.sbCertificate setDelegate:self];
	
	if ([self.btnRadio3 isSelected]) {
		self.sbCertificate.accessibilityLabel = @"지정인증서 선택 버튼 활성화";
		NSMutableDictionary *mdic = [[NSUserDefaults standardUserDefaults]certificateData];
		if (mdic) {
			[self.sbCertificate setState:SHBSelectBoxStateNormal];
			
			[self.sbCertificate setText:[mdic objectForKey:@"1"]];
		}
		else
		{
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"로그인 설정으로 지정해놓은 인증서가 삭제되거나 만료되어, 로그인 설정이 초기화 되었습니다. 다시 설정해 주시기 바랍니다."];
			
			[self.btnRadio1 setSelected:YES];
			[self.btnRadio2 setSelected:NO];
			[self.btnRadio3 setSelected:NO];
            
            [self.sbCertificate setState:SHBSelectBoxStateDisabled];
            type = SettingsLoginTypeDefault;
            [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:type];
            [[NSUserDefaults standardUserDefaults]setCertificateData:nil];
		}
	}
	else
	{
		[self.sbCertificate setState:SHBSelectBoxStateDisabled];
        self.sbCertificate.accessibilityLabel = @"지정인증서 선택 버튼 비활성화";
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - etc
- (void)showPopupView
{
	[self.sbCertificate setState:SHBSelectBoxStateSelected];
	
	if ([self.marrCertificates count]) {
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"인증서 목록"
																	   options:self.marrCertificates
																	   CellNib:@"SHBLoginSettingCell"
																		 CellH:69
																   CellDispCnt:5
																	CellOptCnt:3] autorelease];
		[popupView setDelegate:self];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else
	{
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"보유중인 인증서가 없습니다. 다른 로그인 설정을 선택하여 주십시오."];
	}
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
//	[self.btnRadio1 setSelected:NO];
//	[self.btnRadio2 setSelected:NO];
//	[self.btnRadio3 setSelected:NO];
//	[sender setSelected:YES];
	
	if (sender == self.btnRadio3) {
        self.sbCertificate.accessibilityLabel = @"지정인증서 선택 버튼 활성화";
		[self.sbCertificate setState:SHBSelectBoxStateNormal];
		
		if (![sender isSelected]) {
			[self showPopupView];
		}
		
		[self.btnRadio1 setSelected:NO];
		[self.btnRadio2 setSelected:NO];
		[sender setSelected:YES];
	}
	else
	{
        self.sbCertificate.accessibilityLabel = @"지정인증서 선택 버튼 비활성화";
		[self.sbCertificate setState:SHBSelectBoxStateDisabled];
		
		[self.btnRadio1 setSelected:NO];
		[self.btnRadio2 setSelected:NO];
		[self.btnRadio3 setSelected:NO];
		[sender setSelected:YES];
        [self.sbCertificate setText:@"지정인증서 선택"];
	}
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	SettingsLoginType type = SettingsLoginTypeNone;
    
    if ([self.btnRadio1 isSelected]) {
        type = SettingsLoginTypeDefault;
    }else if ([self.btnRadio2 isSelected]) {
		type = SettingsLoginTypeCertificate;
	}
	else if ([self.btnRadio3 isSelected])
    {
		type = SettingsLoginTypeCertificateSelected;
		
		if ([self.sbCertificate.text isEqualToString:@"지정인증서 선택"] || ![self.sbCertificate.text length]) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"설정하실 인증서를 선택하여 주십시오."];
			
			return;
		}
		
		[[NSUserDefaults standardUserDefaults]setCertificateData:self.selectedData];
	}
	
	[[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:type];
	
    NSLog(@"aaaa:%@",[[NSUserDefaults standardUserDefaults]certificateData]);
    
	[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:333 title:@"" message:@"로그인 설정이 변경되었습니다."];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 333) {
		[self.navigationController fadePopViewController];
	}
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	if (selectBox == self.sbCertificate) {
		[self showPopupView];
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	[self.sbCertificate setState:SHBSelectBoxStateNormal];
	
	self.selectedData = [self.marrCertificates objectAtIndex:anIndex];
	
	[self.sbCertificate setText:[self.selectedData objectForKey:@"1"]];
}

- (void)listPopupViewDidCancel
{
	[self.sbCertificate setState:SHBSelectBoxStateNormal];
}

@end
