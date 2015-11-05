//
//  SHBFindBranchesMapViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define kAppId		@"83a1edd7278fa480d32dd93a263987d8"
#define kUserKey	@"583fb6ac981b688f17b3a421fd2c9449"

#import "SHBFindBranchesMapViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBBranchesSetDistanceViewController.h"	// 설정버튼
#import "SHBBranchesListViewController.h"			// 목록버튼
#import "SHBFindBranchesLocationViewController.h"	// 검색버튼
#import "SHBBranchesWaitingPeopleViewController.h"	// 대기고객조회 팝업버튼
#import "SHBBranchesLocationMapViewController.h"	// 상세보기 팝업버튼

@interface SHBFindBranchesMapViewController ()
{
	CLLocationCoordinate2D currentPoint;
	
	BOOL isFirstStart;			// 처음 시작시에만 서비스요청, 그 이후엔 내위치/지정위치 버튼 눌렀을때만 서비스요청한다.
	BOOL isFinishedService;		// 서비스요청이 끝났는지 여부 : 서비스요청해서 데이터 받아오기 전까지는 NO
}

@property (nonatomic, retain) MKReverseGeocoder *geocoder;			// 현위치 실주소를 가져오기 위해 사용
@property (nonatomic, retain) NSMutableArray *marrSearchResults;	// 영업점/ATM 검색결과
@property (nonatomic, retain) NSDictionary *dicSelectedData;		// 선택된 영업점/ATM

@end

@implementation SHBFindBranchesMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		isFirstStart = YES;
		isFinishedService = YES;
    }
    return self;
}

- (void)dealloc {
	[_dicSelectedData release];
	[_marrSearchResults release];
	[_geocoder release];
	[_locationManager stopUpdatingLocation];
	[_locationManager release];
	[_mapView release];
	[_bottomView release];
	[_lblTopGuide release];
	[_lblBottomGuide release];
	[_popupView release];
	[_popupContentView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setMapView:nil];
	[self setBottomView:nil];
	[self setLblTopGuide:nil];
	[self setLblBottomGuide:nil];
	[self setPopupView:nil];
	[self setPopupContentView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"영업점/ATM찾기"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"위치기반 영업점/ATM 찾기" maxStep:0 focusStepNumber:0]autorelease]];
	[self.view removeGestureRecognizer:panRecognizer];
	
	FrameReposition(self.bottomView, 0, height(self.mapView));
	
	// 맵뷰 세팅
	[self.mapView setDelegate:self];
	[self.mapView setZoomLevel:8];
	[self.mapView setMapType:KMapTypeStandard];
	[self.mapView setUserLocationInfo:[UIImage imageNamed:@"icon_location01"] CompassImage:nil];
	
	// 첫화면에 보일 지역
	Coord outcoord = [self.mapView convertCoordinate:CoordMake(126.9747156, 37.56098557) inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
	KRegion region;
	region.center = outcoord;
	region.scale = 1;
	region.level = 8;
	[self.mapView setRegion:region];
	
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
	
	// CLLocationManger 세팅
	self.locationManager = [[[CLLocationManager alloc]init]autorelease];
	[self.locationManager setDelegate:self];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locationManager setDistanceFilter:100];
	[self.locationManager startUpdatingLocation];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideGuideText) userInfo:nil repeats:NO];
}

#pragma mark - 상,하단의 가이드 애니메이션
- (void)showGuideText
{
	if (top(self.lblTopGuide) >= 0) {
		return;
	}
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	FrameReposition(self.lblTopGuide, 0, top(self.lblTopGuide)+23);
	FrameReposition(self.lblBottomGuide, 0, top(self.lblBottomGuide)-23);
	[UIView commitAnimations];

	[NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(hideGuideText) userInfo:nil repeats:NO];
}

- (void)hideGuideText
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	FrameReposition(self.lblTopGuide, 0, top(self.lblTopGuide)-23);
	FrameReposition(self.lblBottomGuide, 0, top(self.lblBottomGuide)+23);
	[UIView commitAnimations];
}

#pragma mark - 현위치의 실제주소를 알아오고, 현위치의 영업점/ATM을 검색
- (void)getCurrentAddressAndSendService:(CLLocationCoordinate2D)aCoord
{
	Coord outcoord = [self.mapView convertCoordinate:CoordMake(aCoord.longitude, aCoord.latitude) inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];	// 좌표체계 변환
	[self.mapView setCenterCoordinate:outcoord animated:YES];
	
	self.geocoder = [[[MKReverseGeocoder alloc]initWithCoordinate:aCoord]autorelease];
	[self.geocoder setDelegate:self];
	[self.geocoder start];
	
	if (isFinishedService) {
		isFinishedService = NO;
		
		NSInteger nDistance = [[NSUserDefaults standardUserDefaults]distanceValue];
		self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4310Id viewController:self]autorelease];
		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
									@"위도좌표" : [NSString stringWithFormat:@"%f", aCoord.latitude],
									@"경도좌표" : [NSString stringWithFormat:@"%f", aCoord.longitude],
									@"조회반경" : [NSString stringWithFormat:@"%d000", nDistance == 0 ? 1 : nDistance],
									}];
		[self.service start];
	}
}

#pragma mark - OverlayView Set
- (void)setOverlayView
{
	[self.mapView removeAllOverlays];
	
	if ([self.marrSearchResults count]) {
		for (NSDictionary *dic in self.marrSearchResults)
		{
			UIImage *img = nil;
			if ([dic[@"구분"]isEqualToString:@"1"]) {
				img = [UIImage imageNamed:@"icon_branch"];
			}
			else
			{
				img = [UIImage imageNamed:@"icon_atm01"];
			}
			
			double latitude = [[dic objectForKey:@"지점위도좌표"]doubleValue];
			double longitude = [[dic objectForKey:@"지점경도좌표"]doubleValue];
			
			Coord convertedCoord = [self.mapView convertCoordinate:CoordMake(longitude, latitude) inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
			ImageOverlay *overlay = [[[ImageOverlay alloc]initWithImage:img]autorelease];
			[overlay setCoord:convertedCoord];
			[overlay setUserInfo:dic];
			[overlay setDelegate:self];
			
			[self.mapView addOverlay:overlay];			
		}
	}
	else
	{
		
	}
}

#pragma mark - Overlay Delegate
- (void)overlayTouched:(Overlay *)overlay
{
	NSDictionary *dic = [overlay userInfo];
	self.dicSelectedData = dic;
	
	UIButton *btnWaiting = (UIButton *)[self.popupContentView viewWithTag:1002];
	UIButton *btnSee = (UIButton *)[self.popupContentView viewWithTag:1003];
	
	NSString *strTitle = nil;
	if ([dic[@"구분"]isEqualToString:@"1"]) {
		strTitle = @"영업점";
		
		[btnWaiting setHidden:NO];
		FrameReposition(btnSee, 143, top(btnSee));
	}
	else
	{
		strTitle = @"ATM";
		
		[btnWaiting setHidden:YES];
		FrameReposition(btnSee, 82, top(btnSee));
	}
	
	UILabel *lblTitle = (UILabel *)[self.popupContentView viewWithTag:1000];
	[lblTitle setText:dic[@"지점명"]];
	
	UILabel *lblTel = (UILabel *)[self.popupContentView viewWithTag:1001];
	[lblTel setText:dic[@"지점대표전화번호"]];
	
	SHBPopupView *pv = [[[SHBPopupView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 정보", strTitle] subView:self.popupContentView]autorelease];
	[pv showInView:self.navigationController.view animated:YES];
	self.popupView = pv;
}

#pragma mark - PopupView Button Action
// 대기고객수 버튼 (팝업뷰)
- (IBAction)waitingPeopleBtnActionInPopupView:(SHBButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    
	NSString *strNum = [[self.dicSelectedData objectForKey:@"점번호"]substringFromIndex:1];
	self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4308Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"작업구분" : @"S",
								@"조회점번호" : strNum,
								}];
	[self.service start];
}

// 상세보기 버튼 (팝업뷰)
- (IBAction)seeDetailBtnActionInPopupView:(SHBButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    
    ViewType type = [[self.dicSelectedData objectForKey:@"구분"]isEqualToString:@"1"] ? ViewTypeBranch : ViewTypeATM;
	
	SHBBranchesLocationMapViewController *viewController = [[[SHBBranchesLocationMapViewController alloc]initWithNibName:@"SHBBranchesLocationMapViewController" bundle:nil]autorelease];
	viewController.dicSelectedData = self.dicSelectedData;
	viewController.viewType = type;
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - Action

// 내위치 버튼
- (IBAction)myLocationBtnAction:(UIButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    self.popupView = nil;
    
	[self getCurrentAddressAndSendService:currentPoint];
}

// 지정위치 버튼
- (IBAction)appointedLocationBtnAction:(UIButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    self.popupView = nil;
	
	Coord coord = [self.mapView convertCoordinate:self.mapView.centerCoordinate inCoordType:KCoordType_UTMK outCoordType:KCoordType_WGS84];
	
	CLLocationCoordinate2D coord2D;
	coord2D.latitude = coord.y;
	coord2D.longitude = coord.x;
	
	[self getCurrentAddressAndSendService:coord2D];
}

// 목록보기 버튼
- (IBAction)seeListBtnAction:(UIButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    self.popupView = nil;
    
	if ([self.marrSearchResults count]) {
		SHBBranchesListViewController *viewController = [[[SHBBranchesListViewController alloc]initWithNibName:@"SHBBranchesListViewController" bundle:nil]autorelease];
		viewController.dataList = self.marrSearchResults;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
	else
	{
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"검색된 영업점/ATM이 없습니다."];
	}
}

// 설정 버튼
- (IBAction)settingBtnAction:(UIButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    self.popupView = nil;
    
	SHBBranchesSetDistanceViewController *viewController = [[[SHBBranchesSetDistanceViewController alloc]initWithNibName:@"SHBBranchesSetDistanceViewController" bundle:nil]autorelease];
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

// 검색 버튼
- (IBAction)searchBtnAction:(UIButton *)sender {
    [self.popupView closePopupViewWithButton:nil];
    self.popupView = nil;
    
	SHBFindBranchesLocationViewController *viewController = [[[SHBFindBranchesLocationViewController alloc]initWithNibName:@"SHBFindBranchesLocationViewController" bundle:nil]autorelease];
	viewController.strMenuTitle = @"영업점/ATM 검색";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	currentPoint = newLocation.coordinate;
	/*
	 latitude = 37.5609
	 longitude = 126.974
	 */

	[self.mapView setShowUserLocation:UserLocationNorthUp];
	
	if (isFirstStart) {
		isFirstStart = NO;
		
		if (currentPoint.latitude != 0 && currentPoint.longitude != 0) {
			
			
			[self getCurrentAddressAndSendService:currentPoint];
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	currentPoint.latitude = 0;
	currentPoint.longitude = 0;
	
	[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"현재위치를 검색할 수 없습니다. 아이폰의 설정에서 '위치서비스'가 '켬'으로 되어 있는지 확인해주시기 바랍니다."];

	[self.mapView setShowUserLocation:UserLocationNone];
}

#pragma mark - MKReverseGeocoderDelegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSString *strAddress = [NSString stringWithFormat:@"현위치 : %@ %@ %@", placemark.locality ? placemark.locality : @"", placemark.subLocality ? placemark.subLocality : @"", placemark.thoroughfare ? placemark.thoroughfare : @""];
	[self.lblTopGuide setText:strAddress];
	
	[self showGuideText];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	[self.lblTopGuide setText:@"현재 주소를 표시할 수 없습니다."];
	[self showGuideText];
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
	if (self.service.serviceId == kE4310Id) {
		isFinishedService = YES;
		self.marrSearchResults = [aDataSet arrayWithForKey:@"검색결과"];
		
		/**
		 {
		 R_RIBE4310_1 =     {
		 지점명 = 세븐럭카지노서울힐튼;
		 지점주소 = 서울특별시 중구 남대문로5가 395 밀레니엄 서울힐튼호텔 세븐럭카지노 서울힐튼점;
		 지점위도좌표 = 37.555552077791;
		 지점대표전화번호 = ATM;
		 점번호 = 01439;
		 \352\265\254분 = 2;
		 지점경도좌표 = 126.975813635741;
		 }
		 ;
		 }
		 ,
		 {
		 R_RIBE4310_1 =     {
		 지점명 = 대도상가E동;
		 지점주소 = 서울특별시 중구 남창동 49-3 대도상가 E동 2층;
		 지점위도좌표 = 37.559051173702;
		 지점대표전화번호 = ATM;
		 점번호 = 01279;
		 구분 = 2;
		 지점경도좌표 = 126.977530235015;
		 }
		 ;
		 }
		 ,
		 {
		 R_RIBE4310_1 =     {
		 지점명 = \355\236\220튼호텔;
		 지점주소 = 서울특별시 중구 남대문로5가 395;
		 지점위도좌표 = 37.555200573972;
		 지점대표전화번호 = ATM;
		 점번호 = 01100;
		 구분 = 2;
		 지점경도좌표 = 126.975811827329;
		 }
		 ;
		 }
		 ,
		 {
		 R_RIBE4310_1 =     {
		 지점명 = 서대문;
		 지점주소 = 서울특별시 중구 순화동 1-170 (에이스타워);
		 지점위도좌표 = 37.563369214380;
		 지점대표전화번호 = 02-773-7555;
		 점번호 = 01273;
		 구분 = 1;
		 지점\352\262\275도좌표 = 126.969205570639;
		 }
		 ;
		 }
		 ,
		 */
		
		[self setOverlayView];
	}
	else if (self.service.serviceId == kE4308Id)
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
		[self.popupView closePopupViewWithButton:nil];
        self.popupView = nil;
		
		SHBBranchesWaitingPeopleViewController *viewController = [[[SHBBranchesWaitingPeopleViewController alloc]initWithNibName:@"SHBBranchesWaitingPeopleViewController" bundle:nil]autorelease];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.showLocationBtn = NO;
		viewController.data = aDataSet;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
	
	return NO;
}

@end
