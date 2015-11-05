//
//  SHBAlertPopupView.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 26..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBAlertPopupView.h"


@implementation SHBAlertPopupView
{
    int bannerIdx;
}
#define POP_VIEW_TAG 9099
#define MSG_LABEL_TAG 9100

#pragma mark -
#pragma mark - Synthesize

@synthesize delegate;
@synthesize mainView;
@synthesize myTag;
//@synthesize buttonIdx;

#pragma mark -
#pragma mark - initialization

- (id)initWithString:(NSString *)aString ButtonCount:(int)count SubViewHeight:(float)height alertTag:(int)aTag aTarget:(id)aTarget tSelector:(SEL)aSelector btnTitle:(NSString *)aBtnTitle alertType:(int)aType
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        //aString = @"♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다. ♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.♧ 폰뱅킹 1일/1회 이체한도가 3월 24일부터 5백만원으로 축소됩니다.♧ 보다 안전한 금융거래를 위해 안심거래 서비스 등 보안센터 기능을 이용 하시기 바랍니다.";
        //aString = @"신한S뱅크를 로그아웃 하시겠습니까?";
        BOOL isLogoutAlert = NO;
        if ([SHBUtility isFindString:aString find:@"로그아웃 하시겠습니까"])
        {
            //isLogoutAlert = YES;
            //aString = @"\n\n\n\n\n\n\n\n신한S뱅크를 로그아웃 하시겠습니까?";
            NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M003List.vector.data"];
            if ([tickArray count] > 0)
            {
                srand(time(NULL));
                bannerIdx = rand()%[tickArray count];
                
                NSDictionary *nDic = [tickArray objectAtIndex:bannerIdx];
                NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
                
                NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
                NSString *fileName = [paths objectAtIndex:[paths count]-1];
                NSString *cachePath = [NSString stringWithFormat:@"%@/out/",[SHBUtility getCachesDirectory]];
                NSString *filePath = [cachePath stringByAppendingString:fileName];
                
                
                if (![SHBUtility isExistFile:filePath])
                {
                    isLogoutAlert = NO;
                    
                }else
                {
                    isLogoutAlert = YES;
                    //aString = @"\n\n\n\n\n\n\n신한S뱅크mini를 로그아웃 하시겠습니까?";
                    aString = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n%@",aString];
                }
            }
        }
        
        
        if ([SHBUtility isFindString:aString find:@"(60초) 로그아웃 예정입니다."])
        {
          isBlockChangeMessage = NO;
        }else
        {
          isBlockChangeMessage = YES;
        }
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"alertLimitClose" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessage) name:@"alertChangeMessage" object:nil];
        
        alertTarget = aTarget;
        targetSelector = aSelector;
        
		self.backgroundColor = [UIColor clearColor];
		
        UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 273, 0)];
        
		[stringLabel setBackgroundColor:[UIColor clearColor]];
        //[stringLabel setBackgroundColor:[UIColor blueColor]];
		[stringLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[stringLabel setTextColor:[UIColor blackColor]];
		[stringLabel setText:aString];
        stringLabel.tag = MSG_LABEL_TAG;
        
        if (aType == ONFAlertTypeOneButton || aType == ONFAlertTypeTwoButton)
        {
            [stringLabel setTextAlignment:NSTextAlignmentCenter];
        }else if (aType == ONFAlertTypeOneButtonServer || aType == ONFAlertTypeTwoButtonServer)
        {
            //[stringLabel setTextAlignment:NSTextAlignmentLeft];
            [stringLabel setTextAlignment:NSTextAlignmentCenter];
        }else
        {
            [stringLabel setTextAlignment:NSTextAlignmentCenter];
        }
        
        [stringLabel setNumberOfLines:0];
        
        // 자동으로 높이 계산
        CGSize withinSize = CGSizeMake(stringLabel.frame.size.width, FLT_MAX);
        CGSize size = [aString sizeWithFont:stringLabel.font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
        
        // 24는 여백크기
        float fltSize = 24;
        float optSize = 0;
        if (AppInfo.commonNotiOption != -1)
        {
            //공지사항 옵션
            switch (AppInfo.commonNotiOption)
            {
                case 0:
                {
                    //옵션없음
                    optSize = 0;
                }
                    break;
                case 1:
                {
                    //다시보지 않기
                    optSize =  30;
                }
                    break;
                case 2:
                {
                    optSize = 30;
                    //7일간 보지 않기
                }
                    break;
                    
                default:
                {
                    optSize = 0;
                }
                    break;
            }
        }
        
        //NSLog(@"label height:%f",size.height + fltSize);
        
        [stringLabel setFrame:CGRectMake(0, 0, 273, size.height+24)];
        //48=top 이미지 높이, 60=버튼배치영역사이즈, 24=텍스트여백영역
		// Popup Image
		float top = (self.frame.size.height - (stringLabel.frame.size.height+60+48+24))/2;
        //최소 사이즈
        if ((size.height + fltSize) < 101)
        {
            top = (self.frame.size.height - (101+60+48+24+optSize))/2;
        }
        //최대사이즈
        if ((stringLabel.frame.size.height+60+48) > rect.size.height)
        {
            top = 20.0f;
        }
        // 팝업 자체
        UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(16, top, 293, (stringLabel.frame.size.height+60+48 + optSize))];
        //최소 사이즈
        if ((size.height + fltSize) < 101)
        {
            [popupView setFrame:CGRectMake(16, top, 293, 101+60+48+optSize)];
        }
        
        //최대 사이즈
        if ((popupView.frame.size.height + 20) > rect.size.height)
        {
            [popupView setFrame:CGRectMake(16, top, 293, rect.size.height - 40)];
        }
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = POP_VIEW_TAG;
        
        
        //UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, 259, popupView.frame.size.height - 48 - 60)];
        UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 273, popupView.frame.size.height - 48 - 60)];
        [scrollView1 setContentSize:CGSizeMake(0, 0)];
        [scrollView1 setScrollEnabled:NO];
        
        if (scrollView1.frame.size.height < 101.0f)
        {
            //[scrollView1 setFrame:CGRectMake(15, 0, 265, 101)];
            [scrollView1 setFrame:CGRectMake(0, 0, 273, 101)];
        }
        
        //최소사이즈에 따른 한번 더 조정
        if (scrollView1.frame.size.height == 101)
        {
            //중앙에 배치
            //NSLog(@"scrollView1.frame.origin.y:%f",scrollView1.frame.origin.y);
            //NSLog(@"scrollView1.center.y:%f",scrollView1.center.y);
            //[stringLabel setFrame:CGRectMake(0, 101 - (size.height + fltSize + 24), 250, size.height + fltSize)];
            if ((size.height + fltSize) < 101 && (size.height + fltSize) >= 90)
            {
                [stringLabel setFrame:CGRectMake(0, 0, 273, size.height + fltSize)];
                
            }else if ((size.height + fltSize) >= 80 && (size.height + fltSize) < 90)
            {
                [stringLabel setFrame:CGRectMake(0, 5, 273, size.height + fltSize)];
                
            }else if ((size.height + fltSize) >= 70 && (size.height + fltSize) < 80)
            {
                [stringLabel setFrame:CGRectMake(0, 10, 273, size.height + fltSize)];
                
            }else if ((size.height + fltSize) >= 60 && (size.height + fltSize) < 70)
            {
                [stringLabel setFrame:CGRectMake(0, 15, 273, size.height + fltSize)];
                
            }else if ((size.height + fltSize) >= 50 && (size.height + fltSize) < 60)
            {
                [stringLabel setFrame:CGRectMake(0, 20, 273, size.height + fltSize)];
                
            }else if ((size.height + fltSize) < 50)
            {
                [stringLabel setFrame:CGRectMake(0, 25, 273, size.height + fltSize)];
            }
            
        }
        //최대 사이즈보다 큰경우
        if (scrollView1.frame.size.height < size.height)       // scroll이 있는 경우
        {

//            if (optSize > 0)
//            {
//                [scrollView1 setFrame:CGRectMake(scrollView1.frame.origin.x, scrollView1.frame.origin.y, scrollView1.frame.size.width, scrollView1.frame.size.height - 30)];
//                [scrollView1 setContentSize:CGSizeMake(0, size.height + fltSize - 100)];
//                
//            }else
//            {
//                [scrollView1 setContentSize:CGSizeMake(0, size.height + fltSize)];
//            }
            [scrollView1 setContentSize:CGSizeMake(0, size.height + fltSize)];
            [scrollView1 setScrollEnabled:YES];
        }
        
        UIButton *button1;
        UIButton *button2 = nil;
        
        // 버튼이 하나의 경우
        if (count == 1)
        {
            button1 = [[UIButton alloc] initWithFrame:CGRectMake(88,
                                                                 14,
                                                                 120,
                                                                 29)];
            
            button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            
            NSString *btnTitle = @"확인";
            if ([aBtnTitle length] > 0)
            {
                btnTitle = aBtnTitle;
            }
            [button1 setTitle:btnTitle forState:UIControlStateNormal];
            [button1 setTitle:aBtnTitle forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button1 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
        }
        else        // 버튼이 2개인 경우
        {
            
            NSArray *btnTtitleArray = [aBtnTitle componentsSeparatedByString:@","];
            // button1,2 일반적인 확인 취소 버튼 위치 값에 맞췄다
            button1 = [[UIButton alloc] initWithFrame:CGRectMake(48,
                                                                 14,
                                                                 95,
                                                                 29)];
            
            NSString *btnTitle1 = @"예";
            NSString *btnTitle2 = @"아니오";
            
            button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            
            if ([btnTtitleArray count] == 2)
            {
                if ([btnTtitleArray[0] length] > 0)
                {
                    btnTitle1 = btnTtitleArray[0];
                }
                
                if ([btnTtitleArray[1] length] > 0)
                {
                    btnTitle2 = btnTtitleArray[1];
                }
                
                
            }
            [button1 setTitle:btnTitle1 forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button1 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(confirmPopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
            
            button2 = [[UIButton alloc] initWithFrame:CGRectMake(151,
                                                                 14,
                                                                 95,
                                                                 29)];
            
            button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            [button2 setTitle:btnTitle2 forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[[UIImage imageNamed:@"btn_btype2.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
        }
		
        //알림종류 이미지 표현
        UIImageView *topLogoImageView = [[UIImageView alloc] init];
        if (aType == ONFAlertTypeOneButton || aType == ONFAlertTypeTwoButton)
        {
            [topLogoImageView setFrame:CGRectMake(110, 10, 66, 26)];
            [topLogoImageView setImage:[UIImage imageNamed:@"alert_notice_tit.png"]];
            
        }else if (aType == ONFAlertTypeOneButtonServer || aType == ONFAlertTypeTwoButtonServer)
        {
            [topLogoImageView setFrame:CGRectMake(29, 10, 235, 26)];
            [topLogoImageView setImage:[UIImage imageNamed:@"alert_server_tit.png"]];
        }
        //신한로고
        UIImageView	*logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(195,48 + scrollView1.frame.size.height - 101, 98, 101)];
        UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 293, 48)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 293, scrollView1.frame.size.height)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollView1.frame.size.height + 48, 293, 60)];
        btmImageView.userInteractionEnabled = YES;
        
		[topImageView setImage:[UIImage imageNamed:@"alert_top_new.png"]];
		[midImageView setImage:[UIImage imageNamed:@"alert_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"alert_bottom_new.png"]];
		[logoImageView setImage:[UIImage imageNamed:@"alert_img.png"]];
        mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 48, 273, scrollView1.frame.size.height)];
        
        
		mainView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
        //scrollView1.backgroundColor = [UIColor yellowColor];
        
        //NSLog(@"scrollView1.frame.size.height:%f",scrollView1.frame.size.height);
        //mainView.backgroundColor = [UIColor grayColor];
        
        
        
        [topImageView addSubview:topLogoImageView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
        [btmImageView addSubview:button1];
        [btmImageView addSubview:button2];
		[popupView addSubview:btmImageView];
        [popupView addSubview:logoImageView];
        [mainView addSubview:scrollView1];
		[popupView addSubview:mainView];
        [scrollView1 addSubview:stringLabel];
        
        UIButton *bannerBtn;
        if (isLogoutAlert)
        {
            
            NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M003List.vector.data"];
            
            
            if ([tickArray count] > 0)
            {
                bannerBtn = [[UIButton alloc] initWithFrame:CGRectMake(2,
                                                                       48,
                                                                       288,
                                                                       130)];
                srand(time(NULL));
                bannerIdx = rand()%[tickArray count];
                NSLog(@"bannerIdx:%i",bannerIdx);
                NSDictionary *nDic = [tickArray objectAtIndex:bannerIdx];
                NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
                
                NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
                NSString *fileName = [paths objectAtIndex:[paths count]-1];
                NSString *cachePath = [NSString stringWithFormat:@"%@/out/",[SHBUtility getCachesDirectory]];
                NSString *filePath = [cachePath stringByAppendingString:fileName];
                UIImage *bannerImg;
                
                if (![SHBUtility isExistFile:filePath])
                {
                    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
                    bannerImg = [UIImage imageWithData:imgData];
                }else
                {
                    bannerImg = [UIImage imageWithContentsOfFile:filePath];
                }
                
                [bannerBtn setBackgroundImage:bannerImg forState:UIControlStateNormal];
                [bannerBtn addTarget:self action:@selector(touchBannerButton) forControlEvents: UIControlEventTouchUpInside];
                [popupView addSubview:bannerBtn];
                //[popupView bringSubviewToFront:bannerBtn];
                [bannerBtn release];
            }
            
        }
        
        if (AppInfo.commonNotiOption != -1)
        {
            if (AppInfo.commonNotiOption != 0)
            {
                UIButton *chkbtn = [[UIButton alloc] initWithFrame:CGRectMake(55, scrollView1.frame.size.height - 40, 20, 20)];
                [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
                [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
                [chkbtn addTarget:self action:@selector(touchChkBox:) forControlEvents:UIControlEventTouchUpInside];
                chkbtn.tag = 1267;
                //chkbtn.accessibilityLabel = @"일주일 동안 안보기 선택";
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, scrollView1.frame.size.height - 40, 150, 20)];
                [dateLabel setBackgroundColor:[UIColor clearColor]];
                [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
                [dateLabel setTextColor:[UIColor blackColor]];
                
                if (AppInfo.commonNotiOption == 1)
                {
                    [dateLabel setText:@"다시보지 않기"];
                    chkbtn.accessibilityLabel = @"다시보지 않기 선택";
                    [chkbtn setFrame:CGRectMake(65, scrollView1.frame.size.height - 40, 20, 20)];
                    [dateLabel setFrame:CGRectMake(95, scrollView1.frame.size.height - 40, 150, 20)];
                }else if (AppInfo.commonNotiOption == 2)
                {
                    [dateLabel setText:@"일주일 동안 안보기"];
                    chkbtn.accessibilityLabel = @"일주일 동안 안보기 선택";
                }
                
                
                [dateLabel setTextAlignment:NSTextAlignmentLeft];
                [dateLabel setNumberOfLines:1];
                [dateLabel setIsAccessibilityElement:NO];
                [mainView addSubview:chkbtn];
                [mainView addSubview:dateLabel];
                [chkbtn release];
                [dateLabel release];
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
                {
                    [scrollView1 setFrame:CGRectMake(scrollView1.frame.origin.x, scrollView1.frame.origin.y, scrollView1.frame.size.width, (scrollView1.frame.size.height + 10) - (optSize + fltSize))];
                }else
                {
                    [scrollView1 setFrame:CGRectMake(scrollView1.frame.origin.x, scrollView1.frame.origin.y, scrollView1.frame.size.width, (scrollView1.frame.size.height + 10) - (optSize + fltSize))];
                }
                
            }
            
        }
        
        
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            [dimmButton setFrame:CGRectMake(0, -20, rect.size.width, rect.size.height + 20)];
        }
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        //[dimmButton setBackgroundColor:[UIColor clearColor]];
		//[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
        if (aType == ONFAlertTypeOneButton || aType == ONFAlertTypeTwoButton)
        {
            //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
            //dimmButton.accessibilityLabel = @"알림";
            [topImageView setIsAccessibilityElement:YES];
            topImageView.accessibilityLabel = @"알림";
            topImageView.accessibilityTraits = UIAccessibilityTraitNone;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, topImageView);
        }else if (aType == ONFAlertTypeOneButtonServer || aType == ONFAlertTypeTwoButtonServer)
        {
            //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
            //dimmButton.accessibilityLabel = @"처리중 오류가 발생하였습니다";
            [topImageView setIsAccessibilityElement:YES];
            topImageView.accessibilityLabel = @"처리중 오류가 발생하였습니다";
            topImageView.accessibilityTraits = UIAccessibilityTraitNone;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, topImageView);
        }

		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
		[dimmButton release];
        [stringLabel release];
		[button1 release];
        [button2 release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
        [scrollView1 release];
		[popupView release];
    }
    return self;
}

- (void)touchBannerButton
{
    [self closePopupViewWithButton:nil];
    [self delyBannerClick];
    //[self performSelector:@selector(delyBannerClick) withObject:nil afterDelay:0.5];
    
}
- (void)delyBannerClick
{
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M003List.vector.data"];
    
    if ([tickArray count] == 0) {
        return;
    }
    
    NSDictionary *nDic = [tickArray objectAtIndex:bannerIdx];
    NSString *tickerURL = [NSString stringWithFormat:@"%@&EQUP_CD=SI",[nDic objectForKey:@"티커Url"]];
    
    
    SHBDataSet *bannerDic  = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                                 @"티커제목" : [nDic objectForKey:@"티커제목"],
                                 @"티커번호" : [nDic objectForKey:@"티커번호"],
                                 @"티커Url" : tickerURL,
                                 @"티커구분" : [nDic objectForKey:@"티커구분"],
                                 @"아이콘Url" : [nDic objectForKey:@"아이콘Url"],
                                 }] autorelease];
    
    
    if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"0"] || [[nDic objectForKey:@"티커구분"] isEqualToString:@"1"]) //새소식연결,이벤트
    {
        AppInfo.commonDic = @{ @"배너" : bannerDic };
        AppInfo.indexQuickMenu = 1;
        
        //메인배너 클릭시 무조건 기존 새소식으로 이동
        UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
        [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
        [AppDelegate.navigationController fadePopToRootViewController];
        [AppDelegate.navigationController pushSlideUpViewController:viewController];
        [viewController release];
        
    }  else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"2"]) //m신한 연결
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
    } else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"3"]) //기타
    {
        
        NSLog(@"티커Url:%@",[nDic objectForKey:@"티커Url"]);
        
        if ([SHBUtility isFindString:[nDic objectForKey:@"티커Url"] find:@"||"])
        {
            
            //1 스키마, 2 설치 URL
            NSArray *tickerArr = [[nDic objectForKey:@"티커Url"] componentsSeparatedByString:@"||"];
            NSLog(@"tickerArr:%@",tickerArr);
            if ([tickerArr count] >= 2)
            {
                //앱이 설치되어 있는지 확인
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tickerArr[0]]])
                {
                    //설치되어 있으면 바로 호출
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tickerArr[0]]];
                }else
                {
                    //설치 안되어 잇으면 설치 페이지 호출
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tickerArr[1]]];
                }
            }
        }else
        {
            //설치 url이 없으므로 그냥 호출
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
        }
        
        
    }
}
#pragma mark -
#pragma mark - Private Methods

- (void)showAlertView
{
	UIView *popupView = [self viewWithTag:POP_VIEW_TAG];
    popupView.transform = CGAffineTransformMakeScale(.2, .2);
    popupView.alpha = 0;
    
    [UIView animateWithDuration:0.35 animations:^{
        popupView.alpha = 1;
        popupView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)closeAlertView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	UIView *popupView = [self viewWithTag:POP_VIEW_TAG];
    
    [UIView animateWithDuration:.35 animations:^{
        popupView.transform = CGAffineTransformMakeScale(.2, .2);
        popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    
    if (animated) {
        [self showAlertView];
    }
}

// 왼쪽 버튼 시
- (void)confirmPopupViewWithButton:(UIButton*)sender
{
    // tell the delegate the cancellation
//    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidConfirm)])
//    {
//        [self.delegate popupViewDidConfirm];
//    }
    
    if (alertTarget != nil && targetSelector != nil)
    {
        //self.buttonIdx = 0;
        [alertTarget performSelector:targetSelector withObject:0];
        
        alertTarget = nil;
        targetSelector = nil;
    }
    // dismiss self
    [self closeAlertView];
}

//오른쪽 버튼 시
- (void)closePopupViewWithButton:(UIButton*)sender
{
	// tell the delegate the cancellation
//    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidCancel)])
//    {
//        [self.delegate popupViewDidCancel];
//    }
    
    if (AppInfo.commonNotiOption != -1)
    {
        
        UIButton *tmpBtn = (UIButton *)[self viewWithTag:1267];
        if (tmpBtn != nil)
        {
            if ([tmpBtn isSelected])
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                switch (AppInfo.commonNotiOption)
                {
                    case 1:
                    {
                        //다시보지 않기
                        [defaults setObject:[NSString stringWithFormat:@"%i",AppInfo.commonNotiOption] forKey:@"NotiType"];
                        [defaults setObject:@"" forKey:@"NotiDate"];
                    }
                        break;
                    case 2:
                    {
                        //7일간보지않기
                        
                        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
                        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
                        
                        [defaults setObject:[NSString stringWithFormat:@"%i",AppInfo.commonNotiOption] forKey:@"NotiType"];
                        [defaults setObject:currentDate forKey:@"NotiDate"];
                    }
                        break;
                    default:
                    {
                        [defaults setObject:@"" forKey:@"NotiType"];
                    }
                        break;
                }
                [defaults synchronize];
                
            }
            
        }
        AppInfo.commonNotiOption = -1;
    }
    
    // dismiss self
    if (alertTarget != nil && targetSelector != nil)
    {
        //self.buttonIdx = 1;
        [alertTarget performSelector:targetSelector withObject:1];
        
        alertTarget = nil;
        targetSelector = nil;
    }
    [self closeAlertView];
}

- (void)logoutClose
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (alertTarget != nil && targetSelector != nil)
    {
        //self.buttonIdx = 1;
        [alertTarget performSelector:targetSelector withObject:1];
        
        alertTarget = nil;
        targetSelector = nil;
    }
    [self closeAlertView];
}

- (void)changeMessage
{
    if (!isBlockChangeMessage)
    {
        UILabel *myLabel = (UILabel *)[self viewWithTag:MSG_LABEL_TAG];
        myLabel.text = AppInfo.dummyStr;
    }
    
}

- (IBAction)touchChkBox:(id)sender
{
    NSLog(@"클릭");
    [sender setSelected:![sender isSelected]];
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    self.mainView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
