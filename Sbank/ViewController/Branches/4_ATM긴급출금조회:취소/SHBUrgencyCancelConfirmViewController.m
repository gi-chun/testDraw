//
//  SHBUrgencyCancelConfirmViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyCancelConfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBUrgencyInputAccountViewController.h"
#import "SHBUrgencyCancelCompleteViewController.h"

@interface SHBUrgencyCancelConfirmViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBUrgencyCancelConfirmViewController

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
	[_lblAccountNum release];
	[_lblAmount release];
	[_lblPhoneNum release];
	[_lblRequestDate release];
	[_lblRequestCnt release];
	[_lblPWErrorCnt release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setLblAccountNum:nil];
	[self setLblAmount:nil];
	[self setLblPhoneNum:nil];
	[self setLblRequestDate:nil];
	[self setLblRequestCnt:nil];
	[self setLblPWErrorCnt:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"ATM긴급출금조회/취소"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금 취소" maxStep:0 focusStepNumber:0]autorelease]];

	[self.lblAccountNum setText:[self.data objectForKey:@"2"]];
	[self.lblAmount setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"거래금액"]]];
	[self.lblPhoneNum setText:[self.data objectForKey:@"SMS송신휴대폰번호"]];
	[self.lblRequestDate setText:[self.data objectForKey:@"등록일자"]];
	[self.lblRequestCnt setText:[self.data objectForKey:@"등록회차"]];
	[self.lblPWErrorCnt setText:[self.data objectForKey:@"비밀번호오류횟수"]];
	
	fCurrHeight = 164;
	[self setSecretMediaView];
	
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
	
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
		AppInfo.eSignNVBarTitle = @"ATM긴급출금조회/취소";
		
		AppInfo.electronicSignCode = @"E1702";
		AppInfo.electronicSignTitle = @"ATM긴급출금 취소";
		
//		[AppInfo addElectronicSign:@"ATM긴급출금 취소"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)등록일자: %@", [self.data objectForKey:@"등록일자"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)등록시각: %@", [self.data objectForKey:@"등록시각"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)출금계좌: %@", [self.data objectForKey:@"2"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)취소금액: %@원", [self.data objectForKey:@"거래금액"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)SMS수신휴대폰번호: %@", [self.data objectForKey:@"SMS송신휴대폰번호"]]];
		[AppInfo addElectronicSign:@"(8)서비스명: ATM긴급출금 취소"];
		
		self.service = [[[SHBBranchesService alloc]initWithServiceId:kE1702Id viewController:self]autorelease];
		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
									@"출금계좌번호" : [self.data objectForKey:@"계좌번호"],
									}];;
		[self.service start];
	}
}

- (void)cancelSecretMedia
{
	[self backToInputAccountViewController];
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType) {
		
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[noti userInfo]];
        
        [dic setObject:[self.data objectForKey:@"2"]
                forKey:@"2"];
        
		SHBUrgencyCancelCompleteViewController *viewController = [[[SHBUrgencyCancelCompleteViewController alloc]initWithNibName:@"SHBUrgencyCancelCompleteViewController" bundle:nil]autorelease];
		viewController.data = dic;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
}

- (void)getElectronicSignCancel
{
	Debug(@"getElectronicSignCancel");
	[self backToInputAccountViewController];
}

#pragma mark - etc
- (void)backToInputAccountViewController
{
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBUrgencyInputAccountViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
			
			break;
		}
	}
}

@end
