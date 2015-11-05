//
//  SHBBranchesLocationMapViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define kAppId		@"83a1edd7278fa480d32dd93a263987d8"
#define kUserKey	@"583fb6ac981b688f17b3a421fd2c9449"

#import "SHBBranchesLocationMapViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesWaitingPeopleViewController.h"
#import "SHBBranchesService.h"
#import "SHBFindBranchesMapViewController.h"

@interface SHBBranchesLocationMapViewController ()

@end

@implementation SHBBranchesLocationMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_ivMapViewBox release];
    [_mapView release];
    [_lblBranch release];
    [_lblAddress release];
    [_lblTel release];
	[_twoBtnView release];
	[_oneBtnView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIvMapViewBox:nil];
    [self setMapView:nil];
    [self setLblBranch:nil];
    [self setLblAddress:nil];
    [self setLblTel:nil];
	[self setTwoBtnView:nil];
	[self setOneBtnView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"영업점/ATM찾기"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	NSString *strSubTitle = nil;
	switch (_viewType) {
		case ViewTypeBranch:
			strSubTitle = @"영업점 위치찾기";
			[self.oneBtnView removeFromSuperview];
            self.strBackButtonTitle = @"영업점 위치찾기";
			break;
		case ViewTypeATM:
			strSubTitle = @"ATM 위치찾기";
			[self.oneBtnView removeFromSuperview];
			[self.twoBtnView removeFromSuperview];
            self.strBackButtonTitle = @"ATM 위치찾기";
			break;
		case ViewTypeATMNoMap:
			strSubTitle = @"ATM 위치찾기";
			[self.oneBtnView removeFromSuperview];
			[self.twoBtnView removeFromSuperview];
            self.strBackButtonTitle = @"ATM 위치찾기";
			break;
		case ViewTypeWaitingPeople:
			strSubTitle = @"영업점 위치찾기";
			[self.twoBtnView removeFromSuperview];
            self.strBackButtonTitle = @"영업점 위치찾기";
			break;
			
		default:
            self.strBackButtonTitle = @"영업점/ATM 위치찾기";
			break;
	}
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:strSubTitle maxStep:0 focusStepNumber:0]autorelease]];
	
	UIImage *img = [UIImage imageNamed:@"box_infor"];
	[self.ivMapViewBox setImage:[img stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	[self.view removeGestureRecognizer:panRecognizer];
	
	// 맵뷰 세팅
	[self.mapView setZoomLevel:12];
    [self.mapView setMapType:KMapTypeStandard];
	[self.mapView setDelegate:self];
	
	@try {
		[self.mapView startMapService:kAppId UserKey:kUserKey];
		
		//		[self.mapView startMapService:kUserKey];
	}
	@catch (NSException *exception) {
		Debug(@"startMapService Error : %@", [exception reason]);
	}
	@finally {
		;
	}
	
	/*
	 0 - 세팅 준비,
	 1 - 세팅 실패,
	 2 - 재시도중,
	 3 - 정상적으로 세팅 완료
	 */
	Debug(@"check : %d", [self.mapView checkStartMapService]);
	
	[self setAppointedLocation];
	
	NSString *strAddress = _viewType == ViewTypeATMNoMap ? self.dicSelectedData[@"주소"] : self.dicSelectedData[@"지점주소"];
	CGSize size = [strAddress sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(246, 999) lineBreakMode:NSLineBreakByWordWrapping];
	FrameResize(self.lblAddress, width(self.lblAddress), size.height);
	FrameReposition(self.lblTel, left(self.lblTel), top(self.lblAddress)+height(self.lblAddress));
	
	[self.lblBranch setText:_viewType == ViewTypeATMNoMap ? self.dicSelectedData[@"자동화코너명"] : self.dicSelectedData[@"지점명"]];
	[self.lblAddress setText:strAddress];
	[self.lblTel setText:[self.dicSelectedData[@"지점대표전화번호"]isEqualToString:@"ATM"] ? nil : self.dicSelectedData[@"지점대표전화번호"]];
	
	Debug(@"%@", self.dicSelectedData[@"지점대표전화번호"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override
- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        for (SHBBaseViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[SHBFindBranchesMapViewController class]]) {
                SHBFindBranchesMapViewController *vc_ = (SHBFindBranchesMapViewController*)vc;
                [vc_.popupView showInView:self.navigationController.view animated:YES];
                
                break;
            }
        }
        
        [self.navigationController fadePopViewController];
    }
    else {
        [super navigationButtonPressed:sender];
    }
}

#pragma mark - etc
- (void)setAppointedLocation
{
	[self.mapView removeAllOverlays];
	//NSLog(@"abcd:%@",self.dicSelectedData);
	double latitude = [[self.dicSelectedData objectForKey:@"지점위도좌표"]doubleValue];
	double longitude = [[self.dicSelectedData objectForKey:@"지점경도좌표"]doubleValue];
	Coord convertedCoord = [self.mapView convertCoordinate:CoordMake(longitude, latitude) inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
	
	KRegion region;
	region.center = convertedCoord;
	region.scale = 1;
	region.level = 12;
	[self.mapView setRegion:region];
	
	[self.mapView setCenterCoordinate:convertedCoord animated:YES];
	
#if 0
	MarkerOverlay *overlay = [[[MarkerOverlay alloc]initWithType:0]autorelease];
	[overlay setCoord:self.mapView.centerCoordinate];
	[self.mapView addOverlay:overlay];
#else
	ImageOverlay *overlay = [[[ImageOverlay alloc]initWithImage:[UIImage imageNamed:@"icon_location02"]]autorelease];
	[overlay setCoord:self.mapView.centerCoordinate];
	[self.mapView addOverlay:overlay];
#endif
}

#pragma mark - Action
- (IBAction)refreshBtnAction:(UIButton *)sender {
	[self setAppointedLocation];
}

- (IBAction)callBtnAction:(SHBButton *)sender {
	NSString *strPhoneNumber = self.dicSelectedData[@"지점대표전화번호"];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", strPhoneNumber]]];
}

- (IBAction)waitingPeopleBtnAction:(SHBButton *)sender {
	NSString *strNum = [[self.dicSelectedData objectForKey:@"점번호"]substringFromIndex:1];
	self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4308Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"작업구분" : @"S",
								@"조회점번호" : strNum,
								}];
	[self.service start];
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
	if (self.service.serviceId == kE4308Id)
	{
		/**
		 조회점번호 = 1100;
		 COM_JSTAR_VALUE = SHB01          395       15674;
		 COM_EF_TIME = 213319;
		 창구구분1 = 01;
		 창구구분5 = 05;
		 COM_SEC_CHK = ;
		 COM_UPMU_GBN = R;
		 COM_JUMIN_NO = 0;
		 COM_CIF_NO = 0;
		 COM_WEB_DOMAIN = etcwb1t1;
		 COM_NO_SEND = ;
		 COM_SEC_CHAL1 = ;
		 대기고객수2 = 00005;
		 대기고객수4 = 00005;
		 창구구분2 = 02;
		 대기고객수6 = 00005;
		 COM_TRAN_TIME = 21:33:35;
		 대기고객수8 = 00005;
		 COM_SUBCHN_KBN = 02;
		 COM_RESULT_CD = 0;
		 COM_CHANNEL_KBN = DT;
		 창구구분6 = 06;
		 COM_EF_YOIL = 5;
		 입력조회구분 = S;
		 COM_SYS_GBN = T;
		 입력점번호 = 1100;
		 창구구분3 = 03;
		 COM_ECHO_TYPE = ;
		 창구구분7 = 07;
		 COM_EF_DATE = 20121207;
		 COM_TRAN_DATE = 2012.12.07;
		 COM_USER_ERR = ;
		 필러 = 00001;
		 COM_YEYAK_ICHE = ;
		 COM_SVC_CODE = E4308;
		 COM_ICHEPSWD_CHK = ;
		 COM_FILLER1 = ;
		 COM_EF_SERIALNO = 20781546;
		 COM_SEC_CHAL2 = ;
		 COM_LANGUAGE = 1;
		 대기고객수1 = 00005;
		 대기고객수3 = 00005;
		 COM_IP_ADDR = 59.7.254.139;
		 COM_TRAN_TIME->originalValue = 213335;
		 대기고객수5 = 00005;
		 COM_PKTLEN = 262;
		 COM_TRAN_DATE->originalValue = 20121207;
		 대기고객수7 = 00005;
		 창구구분4 = 04;
		 창구구분8 = 08;
		 COM_PG_SERIAL = ;
		 COM_FILLER2 = ;
		 COM_END_MARK = ZZ;
		 */
		
		SHBBranchesWaitingPeopleViewController *viewController = [[[SHBBranchesWaitingPeopleViewController alloc]initWithNibName:@"SHBBranchesWaitingPeopleViewController" bundle:nil]autorelease];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.showLocationBtn = NO;
		viewController.data = aDataSet;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
	
	return NO;
}

//#pragma mark - KMapView Delegate
//- (void)mapTouchBegan:(KMapView*)mapView Events:(UIEvent*)event
//{
//	[self.view removeGestureRecognizer:panRecognizer];
//}
//
//- (void)mapTouchEnded:(KMapView*)mapView Events:(UIEvent*)event
//{
//	[self.view addGestureRecognizer:panRecognizer];
//}

@end
