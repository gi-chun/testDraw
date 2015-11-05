//
//  SHBAppPlusViewController.m
//  ShinhanBank
//
//  Created by 인성 여 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAppPlusViewController.h"
#import "SHBSettingsService.h"
#import "SHBPushInfo.h"

#define defaultX            16
#define defaultY            20
#define defaultPaddingX     17
#define defaultPaddingY     40
#define defaultMaxPageIn    12
#define defaultButtonSize   57

@interface SHBAppPlusViewController ()

@end

@implementation SHBAppPlusViewController


@synthesize btn_plus1;
@synthesize btn_plus2;
@synthesize btn_plus3;
@synthesize btn_plus4;
@synthesize sv_main;

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
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    [self navigationViewHidden];
	[self setBottomMenuView];
    
    selectedCatNum = 0;
    ListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    iconImageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
  
    catBtnArr = [[NSArray alloc] initWithObjects:btn_plus1,btn_plus2,btn_plus3,btn_plus4, nil];
    
	[self scrollViewDraw:nil];
    
    // 어플리스트 받기
	//[self requestAppList];
    
}


- (void) scrollViewDraw:(NSString *)title {
    NSLog(@"scrollViewDraw");
  

        
    //스크롤 뷰에 아이콘 이미지(버튼) 및 어플명 표시
    NSInteger drawPageCount = 1;
    UIButton *iconButton;
    NSInteger currentAppCount = 1;
    NSInteger currentX = defaultX;
    NSInteger currentY = defaultY;
    
    if (title == nil)
    {
        NSLog(@"타이틀 없음/은행");
        appListArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary *dic in AppInfo.otherAppArray)
        {
            if ([[dic objectForKey:@"앱구분명"] isEqualToString:@"은행"])
            {
                [appListArr addObject:dic];
            }
        }

        
    }
    
    else if([title isEqualToString:@"전체"])
    {
        NSLog(@"전체클릭 ");
        appListArr = [[NSMutableArray alloc] initWithArray:AppInfo.otherAppArray];
    }
    
    else
    {
        NSLog(@"타이틀 있음 ");
        
        appListArr = [[NSMutableArray alloc] initWithCapacity:0];
    
        for (NSDictionary *dic in AppInfo.otherAppArray)
        {
            if ([[dic objectForKey:@"앱구분명"] isEqualToString:title])
            {
                [appListArr addObject:dic];
            }
        }
    }
    
    for (NSDictionary *app in appListArr) {
        NSLog(@"currentX = %d  currentY = %d",currentX , currentY);
        
        //버튼 생성 및 레이블 생성
        iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setFrame:CGRectMake(currentX, currentY, defaultButtonSize, defaultButtonSize)];
        [iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = currentAppCount;
        [sv_main addSubview:iconButton];
        
        // 장애인모드
        [iconButton setAccessibilityLabel:[app objectForKey:@"앱이름"]]; //어플이름
        [iconButton setIsAccessibilityElement:YES];// 장애인모드 시작
        

        UILabel *lb_appname = [[UILabel alloc] initWithFrame:CGRectMake(currentX-5, currentY+defaultButtonSize, defaultButtonSize+10, 21)];
        [lb_appname setFont:[UIFont systemFontOfSize:13.0f]];
        [lb_appname setAdjustsFontSizeToFitWidth:YES];
        [lb_appname setMinimumFontSize:8.0f];
        [lb_appname setText:[NSString stringWithFormat:@"%@",[app objectForKey:@"앱이름"]]];
        [lb_appname setBackgroundColor:[UIColor clearColor]];
        [lb_appname setTextAlignment:UITextAlignmentCenter];
        [sv_main addSubview:lb_appname];
        [lb_appname release];
       
        
        // Button Image Setting
		NSArray *icoUrlArr = [[app objectForKey:@"아이콘URL"] componentsSeparatedByString:@"/"];
		if ([icoUrlArr count] > 0){
			int icoIdx = [icoUrlArr count] - 1;
			NSString *imgName = [icoUrlArr objectAtIndex:icoIdx];
			UIImage  *icoImage = [UIImage imageNamed:imgName];
			[iconButton setImage:icoImage forState:UIControlStateNormal];
		}
       
        
        
        NSArray *dataArr = [NSArray arrayWithObjects:iconButton, app, nil];
        [NSThread detachNewThreadSelector:@selector(imageDownload:) toTarget:self withObject:dataArr];
        
        currentX = currentX + defaultButtonSize + defaultPaddingX;
        
        if (currentAppCount%4 == 0) {
            //한 라인이 끝났을 경우
            currentX = defaultX + 320*(drawPageCount-1);                //X좌표는 기본좌표 + 페이지 카운트만큼 이동
            currentY = currentY + defaultButtonSize + defaultPaddingY;  //Y좌표는 한줄 아래로
        }
        
        currentAppCount++;
    }
    
    [sv_main setContentSize:CGSizeMake(sv_main.frame.size.width, currentY + defaultButtonSize + defaultPaddingY)];
    [sv_main setContentOffset:CGPointMake(0, 0)];
}


- (void) imageDownload:(NSArray *)dataArr{
    UIButton *btn = [dataArr objectAtIndex:0];      //이미지를 다운받을 버튼
    NSDictionary *dic = [dataArr objectAtIndex:1];  //앱 데이터
    

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *img; 
    NSString *url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"아이콘URL"] ];  // IMAGE_DOWNLOAD_URL
      
    //이미지 다운로드 및 저장
    img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    //버튼에 이미지 셋팅
    [btn setImage:img forState:UIControlStateNormal];
    
    
    [pool release];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc
{
   [btn_plus1 release];
   [btn_plus2 release];
   [btn_plus3 release];
   [btn_plus4 release];
    [sv_main release];
    [super dealloc];
}






#pragma mark - Action
- (IBAction)closeBtnAction:(UIButton *)sender {
    AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

#pragma mark -
#pragma mark ButtonAction
//메뉴 버튼 클릭시
- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    
    
    [self cleanScrollView];
    
    if (sender == btn_plus1) {
        [btn_plus1 setEnabled:NO];
        [btn_plus2 setEnabled:YES];
        [btn_plus3 setEnabled:YES];
        [btn_plus4 setEnabled:YES];
        
    }
    
    else if (sender == btn_plus2) {
        [btn_plus1 setEnabled:YES];
        [btn_plus2 setEnabled:NO];
        [btn_plus3 setEnabled:YES];
        [btn_plus4 setEnabled:YES];
        

    }
    
    else if (sender == btn_plus3) {
     
        [btn_plus1 setEnabled:YES];
        [btn_plus2 setEnabled:YES];
        [btn_plus3 setEnabled:NO];
        [btn_plus4 setEnabled:YES];

    }

    
    else if (sender == btn_plus4) {
        
        [btn_plus1 setEnabled:YES];
        [btn_plus2 setEnabled:YES];
        [btn_plus3 setEnabled:YES];
        [btn_plus4 setEnabled:NO];
        
     
    }
    
    [self scrollViewDraw:sender.titleLabel.text];
}


- (void)requestAppList{

	
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"getAppList",
								@"앱구분" : @"009",
								@"OS구분" : @"A",
								}] autorelease];
	self.service = [[[SHBSettingsService alloc] initWithServiceId:APPLIST_TASK1 viewController:self] autorelease];
    self.service.requestData = forwardData;
    [self.service start];
	
}








#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
    
 
    if (self.service.serviceId == APPLIST_TASK1)
    {
        self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
        NSLog(@"self.dataList : [%@]",self.dataList);
       
        
        //화면 데이터 셋팅
        [self scrollViewDraw:apptitle];
        
    }
    
  
    return NO;
    
    
}



//아이콘 클릭시 이벤트 처리
- (void) iconButtonClick:(UIButton *)sender{
    NSLog(@"===========iconButtonClick sender Tag = %d",[sender tag]-1);
     NSLog(@"===========appListArr = %@",appListArr);
    
    NSDictionary *dic = [appListArr objectAtIndex:[sender tag]-1];
	
    NSLog(@"패키지_스키마= %@",[dic objectForKey:@"패키지_스키마"]);
    
   // NSURL *url = [NSURL URLWithString:[dic objectForKey:@"패키지_스키마"]];  //[app objectForKey:@"앱이름"]
  //  NSLog(@"url = %@",url);
    
    
    SHBPushInfo *openURLManager = [SHBPushInfo instance];
    
    if ([[dic objectForKey:@"패키지_스키마"] isEqualToString:@"smartfundcenter://"])
    {
        AppInfo.smartFundType = 1;
    }
    
    [openURLManager requestOpenURL:[dic objectForKey:@"패키지_스키마"] Parm:nil];
    
    
}


- (void) cleanScrollView{
    NSLog(@"cleanScrollView");
    NSArray *subView = [sv_main subviews];
    for (UIView *view in subView) {
        [view removeFromSuperview];
    }
}


@end
