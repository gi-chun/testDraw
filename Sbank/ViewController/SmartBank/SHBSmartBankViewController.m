//
//  SHBSmartBankViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSmartBankViewController.h"
#import "SHBPushInfo.h"

#define defaultX            5
#define defaultY            0
#define defaultPaddingX     15
#define defaultPaddingY     40
#define defaultMaxPageIn    12
#define defaultButtonSize   57

@interface SHBSmartBankViewController ()

@end

@implementation SHBSmartBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
	
	SafeRelease(listArray);
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"스마트금융";
	
	boxImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	listArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	//[NSThread detachNewThreadSelector:@selector(drawAppList) toTarget:self withObject:nil];
	
	[self drawAppList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawAppList{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	for (NSDictionary *dic in AppInfo.otherAppArray){
		if ([[dic objectForKey:@"앱구분명"] isEqualToString:@"은행"]){
			[listArray addObject:dic];
		}
	}
	
	UIButton *iconButton;
	NSInteger appCount = 1;
    NSInteger currentX = defaultX;
    NSInteger currentY = defaultY;
    
	for (NSDictionary *app in listArray) {
        //버튼 생성 및 레이블 생성
        iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setFrame:CGRectMake(currentX, currentY, defaultButtonSize, defaultButtonSize)];
        [iconButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = appCount;
        [appScrollView addSubview:iconButton];
        
		
        UILabel *lb_appname = [[UILabel alloc] initWithFrame:CGRectMake(currentX-5, currentY+defaultButtonSize, defaultButtonSize+10, 21)];
        [lb_appname setFont:[UIFont systemFontOfSize:13.0f]];
        [lb_appname setAdjustsFontSizeToFitWidth:YES];
        [lb_appname setMinimumFontSize:8.0f];
        [lb_appname setText:[NSString stringWithFormat:@"%@",[app objectForKey:@"앱이름"]]];
        [lb_appname setBackgroundColor:[UIColor clearColor]];
        [lb_appname setTextAlignment:UITextAlignmentCenter];
        [appScrollView addSubview:lb_appname];
        [lb_appname release];
        
		// Button Image Setting
		NSArray *icoUrlArr = [[app objectForKey:@"아이콘URL"] componentsSeparatedByString:@"/"];
		if ([icoUrlArr count] > 0){
			int icoIdx = [icoUrlArr count] - 1;
			NSString *imgName = [icoUrlArr objectAtIndex:icoIdx];
			UIImage  *icoImage = [UIImage imageNamed:imgName];
			[iconButton setImage:icoImage forState:UIControlStateNormal];
		}
		
		currentX = currentX + defaultButtonSize + defaultPaddingX;
        
        if (appCount%4 == 0) {
            //한 라인이 끝났을 경우
            currentX = defaultX;
            currentY = currentY + defaultButtonSize + defaultPaddingY;  //Y좌표는 한줄 아래로
        }
        
        appCount++;
    }
	
	[appScrollView setContentSize:CGSizeMake(appScrollView.frame.size.width, currentY + defaultButtonSize + defaultPaddingY)];
	
	[pool release];
}

- (void)iconButtonPressed:(UIButton *)sender{
    NSDictionary *nDic = [listArray objectAtIndex:[sender tag]-1];
	
    SHBPushInfo *openURLManager = [SHBPushInfo instance];
    [openURLManager requestOpenURL:[nDic objectForKey:@"패키지_스키마"] Parm:nil];
    
}


- (IBAction)buttonPressed:(UIButton *)sender{
	[self.navigationController fadePopViewController];
}


@end
