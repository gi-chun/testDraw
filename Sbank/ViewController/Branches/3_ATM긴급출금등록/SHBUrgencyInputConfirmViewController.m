//
//  SHBUrgencyInputConfirmViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyInputConfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBUrgencyPaymentCompleteViewController.h"
#import "SHBUrgencyInputInfoViewController.h"

@interface SHBUrgencyInputConfirmViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBUrgencyInputConfirmViewController

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
	[_otpViewController release];
	[_cardViewController release];
	[_lblAccountNum release];
	[_lblAmount release];
	[_lblPhoneNum release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setLblAccountNum:nil];
	[self setLblAmount:nil];
	[self setLblPhoneNum:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"ATM긴급출금등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금등록 정보확인" maxStep:3 focusStepNumber:2]autorelease]];
	
	self.lblAccountNum.text = [self.data objectForKey:@"2"];
	self.lblAmount.text = [NSString stringWithFormat:@"%@원", [self.data objectForKey:@"거래금액출력용"]];
	self.lblPhoneNum.text = [self.data objectForKey:@"SMS송신휴대폰번호"];
	
	fCurrHeight = 95;
	[self setSecretMediaView];
	
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"notiESignError" object:nil];
	
	self.contentScrollView.contentSize = CGSizeMake(317, fCurrHeight);
    contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)setSecretMediaView
{
	UIView *secretMediaView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
	[self.contentScrollView addSubview:secretMediaView];
	
	NSInteger secutryType = [[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue];
    
    if (secutryType == 1 || secutryType == 2 || secutryType == 3 || secutryType == 4)
    {           //보안카드
        
        SHBSecretCardViewController *vc = [[[SHBSecretCardViewController alloc] init] autorelease];
        vc.targetViewController = self;
        [secretMediaView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		
		[secretMediaView setFrame:CGRectMake(0, fCurrHeight+=4, 317, vc.view.bounds.size.height)];
		
		vc.selfPosY = fCurrHeight+37;
		fCurrHeight += vc.view.bounds.size.height;
        
        /* previousData는 이전 전문 파싱값을 넘겨줄 필요가 있을때 넘겨준다
         연속적으로 이체할때 보안 카드 확인값이 변경되므로 값을 알아야됨 - 아직 미구현
         */
        [vc setMediaCode:secutryType previousData:nil];
        vc.delegate = self;
        
		self.cardViewController = vc;
    }
    else if (secutryType == 5)
    {           //OTP
        
        SHBSecretOTPViewController *vc = [[[SHBSecretOTPViewController alloc] init] autorelease];
        vc.targetViewController = self;
        
        [secretMediaView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		
		[secretMediaView setFrame:CGRectMake(0, fCurrHeight+=4, 317, vc.view.bounds.size.height)];
		
		vc.selfPosY = fCurrHeight+37;
		fCurrHeight += vc.view.bounds.size.height;
        
        vc.delegate = self;
		
		self.otpViewController = vc;
    }
}

#pragma mark - SHBSecretCard Delegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
	
	if (confirm == 1) {
		
		AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"ATM긴급출금 등록";
		
		AppInfo.electronicSignCode = @"E1700";
		AppInfo.electronicSignTitle = @"ATM긴급출금 등록";
		
//		[AppInfo addElectronicSign:@"ATM긴급출금 등록"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)계좌번호: %@", [self.data objectForKey:@"2"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)신청금액: %@원", [self.data objectForKey:@"거래금액출력용"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)SMS수신휴대폰번호: %@", [self.data objectForKey:@"SMS송신휴대폰번호"]]];
		[AppInfo addElectronicSign:@"(6)서비스명: ATM긴급출금 등록"];
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"업무구분" : @"4",
							   @"출금계좌번호" : [self.data objectForKey:@"출금계좌번호"],
							   @"본인확인번호" : [self.data objectForKey:@"본인확인번호"],
							   @"거래금액" : [self.data objectForKey:@"거래금액"],
							   @"SMS송신휴대폰번호" : [[self.data objectForKey:@"SMS송신휴대폰번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
//							   @"attributeNamed" : @"useSign",
//							   @"attributeValue" : @"true",
							   }];
		
		self.service = [[[SHBBranchesService alloc]initWithServiceId:kE1700Id viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}

- (void)cancelSecretMedia
{
	[self backToInputInfoViewController];
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType) {
		
		NSString *str = [[noti userInfo]objectForKey:@"등록일자"];
		NSString *strDate = [NSString stringWithFormat:@"%@.%@.%@", [str substringWithRange:NSMakeRange(0, 4)], [str substringWithRange:NSMakeRange(4, 2)], [str substringWithRange:NSMakeRange(6, 2)]];
		
		SHBUrgencyPaymentCompleteViewController *viewController = [[[SHBUrgencyPaymentCompleteViewController alloc]initWithNibName:@"SHBUrgencyPaymentCompleteViewController" bundle:nil]autorelease];
		viewController.data = self.data;
		viewController.strRequestDate = strDate;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
}

- (void)getElectronicSignCancel
{
	[self backToInputInfoViewController];
}

- (void)getElectronicSignServerError
{
	[self backToInputInfoViewController];
}

#pragma mark - etc
- (void)backToInputInfoViewController
{
	for (SHBUrgencyInputInfoViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBUrgencyInputInfoViewController class]]) {
			[viewController initializeData];
			
			[self.navigationController popToViewController:viewController animated:YES];
			break;
		}
	}
}

@end
