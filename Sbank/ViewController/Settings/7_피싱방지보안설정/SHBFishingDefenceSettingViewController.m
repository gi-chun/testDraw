//
//  SHBFishingDefenceSettingViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 4. 1..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBFishingDefenceSettingViewController.h"
#import "SHBSettingsService.h"
#import "SHBFishingDefenceDoneViewController.h"
#import "SHBUtility.h"
#import "SHBNoCertForCertLogInViewController.h"

@interface SHBFishingDefenceSettingViewController ()
{
    int serviceStep;
    int pageIndex;
    BOOL isMovePage;
}
@property (nonatomic, retain) NSString *imageName;

- (void)queryE4124;
- (void)registerE4124;
- (void)changeE4124;
- (void)dismissE4124;
@end

@implementation SHBFishingDefenceSettingViewController
@synthesize fishingTextField;
@synthesize fishingScrollView;
@synthesize registerView;
@synthesize changeView;
@synthesize image1View;
@synthesize image2View;
@synthesize image3View;
@synthesize page1ImageView;
@synthesize page2ImageView;
@synthesize page3ImageView;
@synthesize myFishingImageView;
@synthesize imageName;
@synthesize myFishingImageBgView;
@synthesize mySelectImageBgView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    //[imageName release];
    [myFishingImageBgView release];
    [mySelectImageBgView release];
    [myFishingImageView release];
    [page1ImageView release];
    [page2ImageView release];
    [page3ImageView release];
    [image1View release];
    [image2View release];
    [image3View release];
    [registerView release];
    [changeView release];
    [fishingScrollView release];
    [fishingTextField release];
    [super dealloc];
}


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
    startTextFieldTag = 100;
    endTextFieldTag = 100;
    self.title = @"피싱방지 보안설정";
    AppInfo.eSignNVBarTitle = @"피싱방지 보안설정";
    
    [self.contentScrollView setContentSize:CGSizeMake(317, 460)];
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    //이미지뷰들을 add한다.
    pageIndex = 0;
    [self.fishingScrollView addSubview:image1View];
    [self.fishingScrollView addSubview:image2View];
    [self.fishingScrollView addSubview:image3View];
    
    [self.image1View setFrame:CGRectMake(self.fishingScrollView.frame.size.width*0, 0.0f, self.image1View.frame.size.width, self.image1View.frame.size.height)];
    [self.image2View setFrame:CGRectMake(self.fishingScrollView.frame.size.width*1, 0.0f, self.image2View.frame.size.width, self.image2View.frame.size.height)];
    [self.image3View setFrame:CGRectMake(self.fishingScrollView.frame.size.width*2, 0.0f, self.image3View.frame.size.width, self.image3View.frame.size.height)];
    [self.fishingScrollView setContentSize:CGSizeMake(self.fishingScrollView.frame.size.width*3, self.fishingScrollView.frame.size.height)];
    
    //피싱방지 보안설정 상태
    //E4124  조회전문을 태운다
    self.changeView.frame = self.registerView.frame;
    self.registerView.hidden = YES;
    self.changeView.hidden = YES;
    [self queryE4124];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    
    switch (tmpBtn.tag)
    {
        case 2000:
        {
            //설정
            [self registerE4124];
        }
            break;
        case 2001:
        {
            //변경
            [self changeE4124];
        }
            break;
        case 2002:
        {
            //해지
            [self dismissE4124];
        }
            break;
        default:
            break;
    }
}

- (IBAction)iconTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    int imageNo = (tmpBtn.tag - 1000) + 1;
    if (imageNo < 10)
    {
        self.imageName = [NSString stringWithFormat:@"ANTPH00%i",imageNo];
    }else
    {
        self.imageName = [NSString stringWithFormat:@"ANTPH0%i",imageNo];
    }
    self.myFishingImageBgView.hidden = NO;
    self.myFishingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.imageName]];
    [self.mySelectImageBgView setImage:[UIImage imageNamed:@"imoti_bg_setting_line_b.png"]];
    
    CGRect rct = tmpBtn.frame;
    [self.myFishingImageBgView setFrame:CGRectMake(rct.origin.x - 7, rct.origin.y - 7, self.myFishingImageBgView.frame.size.width, self.myFishingImageBgView.frame.size.height)];
}

- (void)queryE4124
{
    serviceStep = 1;
    NSLog(@"aaaa:%@",AppInfo.userInfo[@"고객번호"]);
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                  @"업무구분" : @"4",
                                  @"고객번호" : @"",
                                  @"이미지ID" : @"",
                                  @"이미지URL" : @"",
                                  @"본인확인문구" : @"",
                                  @"사용여부" : @"1",
                                  }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBSettingsService alloc] initWithServiceId:FISHING_DEFENCE viewController:self] autorelease];
    self.service.requestData = forwardData;
    AppInfo.serviceOption = @"fishing_query";
    [self.service start];
    
}

- (void)registerE4124
{
    if (self.myFishingImageView.image == nil)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"피싱방지 보안 이미지를 선택하세요."];
        return;
    }
    NSString *fishingStr = self.fishingTextField.text;
    if ([fishingStr length] == 0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"본인 확인 문구를 입력하세요."];
        [self.fishingTextField becomeFirstResponder];
        return;
    }else
    {
        //자릿수 체크
        if ([fishingStr length] < 5 || [fishingStr length] > 8)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"최소5자에서 최대 8자 이내로\n입력 가능합니다."];
            [self.fishingTextField becomeFirstResponder];
            return;
        }
    }
    
    serviceStep = 2;
    AppInfo.electronicSignString = @"";
    AppInfo.electronicSignCode = @"E4124_A";
    AppInfo.electronicSignTitle = @"피싱방지 서비스를 설정/변경합니다.";
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"1. 신청내용"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)신청인성명: %@", AppInfo.userInfo[@"고객성명"]]];
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                  @"업무구분" : @"1",
                                  @"고객번호" : @"",
                                  @"이미지ID" : self.imageName,
                                  @"이미지URL" : @"",
                                  @"본인확인문구" : fishingStr,
                                  @"사용여부" : @"1",
                                  }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBSettingsService alloc] initWithServiceId:FISHING_DEFENCE viewController:self] autorelease];
    self.service.requestData = forwardData;
    AppInfo.serviceOption = @"fishing_register";
    //AppInfo.serviceOption = @"fishing_query";
    [self.service start];
}

- (void)changeE4124
{
    if (self.myFishingImageView.image == nil)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"피싱방지 보안 이미지를 선택하세요."];
        return;
    }
    NSString *fishingStr = self.fishingTextField.text;
    if ([fishingStr length] == 0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"본인 확인 문구를 입력하세요."];
        [self.fishingTextField becomeFirstResponder];
        return;
    }else
    {
        //자릿수 체크
        if ([fishingStr length] < 5 || [fishingStr length] > 8)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"최소5자에서 최대 8자 이내로\n입력 가능합니다."];
            [self.fishingTextField becomeFirstResponder];
            return;
        }
    }
    
    serviceStep = 3;
    AppInfo.electronicSignString = @"";
    AppInfo.electronicSignCode = @"E4124_B";
    AppInfo.electronicSignTitle = @"피싱방지 서비스를 설정/변경합니다.";
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"1. 변경내용"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)신청인성명: %@", AppInfo.userInfo[@"고객성명"]]];
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                  @"업무구분" : @"1",
                                  @"고객번호" : @"",
                                  @"이미지ID" : self.imageName,
                                  @"이미지URL" : @"",
                                  @"본인확인문구" : fishingStr,
                                  @"사용여부" : @"1",
                                  }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBSettingsService alloc] initWithServiceId:FISHING_DEFENCE viewController:self] autorelease];
    self.service.requestData = forwardData;
    AppInfo.serviceOption = @"fishing_change";
    //AppInfo.serviceOption = @"fishing_query";
    [self.service start];
}

- (void)dismissE4124
{
    serviceStep = 4;
    AppInfo.electronicSignString = @"";
    AppInfo.electronicSignCode = @"E4124_C";
    AppInfo.electronicSignTitle = @"피싱방지 서비스를 해지합니다.";
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"1. 해지내용"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)신청인성명: %@", AppInfo.userInfo[@"고객성명"]]];
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                  @"업무구분" : @"1",
                                  @"고객번호" : @"",
                                  @"이미지ID" : @"",
                                  @"이미지URL" : @"",
                                  @"본인확인문구" : @"",
                                  @"사용여부" : @"2",
                                  }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBSettingsService alloc] initWithServiceId:FISHING_DEFENCE viewController:self] autorelease];
    self.service.requestData = forwardData;
    AppInfo.serviceOption = @"fishing_dismiss";
    //AppInfo.serviceOption = @"fishing_query";
    [self.service start];
}
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    AppInfo.commonDic = nil;
    
    
    
    if (serviceStep == 1)
    {
        if (AppInfo.isLogin == LoginTypeIDPW)
        {
            NSMutableArray *tmpArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] initWithCapacity:0];
            tmpArray1 = [AppInfo loadCertificates];
            
            NSString *dday;
            for (int i = 0; i < [tmpArray1 count]; i++)
            {
                dday = [[tmpArray1 objectAtIndex:i] expire];
                int dDay = [SHBUtility getDDay:dday];
                
                if (dDay < 0) //만료일이 지났으면...
                {
                    
                    
                }else //만료일이 지나지 않았으면 넣는다.
                {
                    [tmpArray2 addObject:[tmpArray1 objectAtIndex:i]];
                }
            }
            tmpArray1 = tmpArray2;
            if ([tmpArray1 count] == 0)
            {
                //유효한 인증서가 없으면....
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1982 title:@"" message:@"보유중인 인증서가 없습니다.\n인증서 가져오기 후 재시도해 주십시오."];
                return NO;
            }
        }
        //조회
        //신청 화면을 보여줄지, 변경, 해지 화면을 보여줄지 결정
        if ([aDataSet[@"사용여부"] isEqualToString:@"1"])
        {
            //설정
            self.registerView.hidden = YES;
            self.changeView.hidden = NO;
            self.fishingTextField.text = aDataSet[@"본인확인문구"];
            NSString *myImageName = [NSString stringWithFormat:@"%@.png",aDataSet[@"이미지ID"]];
            self.myFishingImageView.image = [UIImage imageNamed:myImageName];
            self.imageName = aDataSet[@"이미지ID"];
            
            if ([self.imageName length] > 0)
            {
                self.myFishingImageBgView.hidden = NO;
                [self.mySelectImageBgView setImage:[UIImage imageNamed:@"imoti_bg_setting_line_b.png"]];
                int imgID = [[self.imageName substringFromIndex:5] intValue];
                UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:(1000 + imgID - 1)];
                CGRect rct = tmpBtn.frame;
                [self.myFishingImageBgView setFrame:CGRectMake(rct.origin.x - 7, rct.origin.y - 7, self.myFishingImageBgView.frame.size.width, self.myFishingImageBgView.frame.size.height)];
            }else
            {
                self.myFishingImageBgView.hidden = YES;
                [self.mySelectImageBgView setImage:[UIImage imageNamed:@"imoti_bg_unselect.png"]];
            }
            
        }else
        {
            //미설정
            self.changeView.hidden = YES;
            self.registerView.hidden = NO;
            self.fishingTextField.text = @"";
            self.imageName = @"";
            self.myFishingImageBgView.hidden = YES;
            [self.mySelectImageBgView setImage:[UIImage imageNamed:@"imoti_bg_unselect.png"]];
        }
        return NO;
    }
    
    return NO;
    
}

- (void)getElectronicSignResult:(NSNotification *)noti
{
    
    if ([noti userInfo])
    {
        NSLog(@"cccc:%@",[noti userInfo]);
        if (serviceStep == 2)
        {
            //설정
            AppInfo.serviceOption = @"fishing_register";
            AppInfo.userInfo[@"피싱방지이미지"] = [[noti userInfo] objectForKey:@"이미지ID"];
            AppInfo.userInfo[@"피싱방지문구"] = [[noti userInfo] objectForKey:@"본인확인문구"];
            //NSString *myImageName = [NSString stringWithFormat:@"%@.png",[[noti userInfo] objectForKey:@"이미지ID"]];
            //self.myFishingImageView.image = [UIImage imageNamed:myImageName];
        }else if (serviceStep == 3)
        {
            //변경
            AppInfo.serviceOption = @"fishing_change";
            AppInfo.userInfo[@"피싱방지이미지"] = [[noti userInfo] objectForKey:@"이미지ID"];
            AppInfo.userInfo[@"피싱방지문구"] = [[noti userInfo] objectForKey:@"본인확인문구"];
            //NSString *myImageName = [NSString stringWithFormat:@"%@.png",[[noti userInfo] objectForKey:@"이미지ID"]];
            //self.myFishingImageView.image = [UIImage imageNamed:myImageName];
        }else if (serviceStep == 4)
        {
            //해지
            AppInfo.serviceOption = @"fishing_dismiss";
            AppInfo.userInfo[@"피싱방지이미지"] = @"";
            AppInfo.userInfo[@"피싱방지문구"] = @"";
            self.myFishingImageView.image = nil;
        }
        
        /*
        AppInfo.commonDic = @{
                              @"피싱방지사용여부" : [[noti userInfo] objectForKey:@"사용여부"],
                              @"본인확인문구" : AppInfo.userInfo[@"피싱방지문구"],
                              @"이미지ID" : AppInfo.userInfo[@"피싱방지이미지"],
                              @"업무" : AppInfo.serviceOption,
                              };
        */
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        //[imageName release];
        [myFishingImageView release];
        [page1ImageView release];
        [page2ImageView release];
        [page3ImageView release];
        [image1View release];
        [image2View release];
        [image3View release];
        [registerView release];
        [changeView release];
        [fishingScrollView release];
        [fishingTextField release];
        // success의 경우
        SHBFishingDefenceDoneViewController *viewController = [[SHBFishingDefenceDoneViewController alloc] initWithNibName:@"SHBFishingDefenceDoneViewController" bundle:nil];
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
    }

}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    //[imageName release];
    [myFishingImageView release];
    [page1ImageView release];
    [page2ImageView release];
    [page3ImageView release];
    [image1View release];
    [image2View release];
    [image3View release];
    [registerView release];
    [changeView release];
    [fishingScrollView release];
    [fishingTextField release];
    
    if ([AppDelegate.navigationController.viewControllers count] == 3)
    {
        [AppDelegate.navigationController fadePopViewController];
    }else if ([AppDelegate.navigationController.viewControllers count] == 4)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
    
}

#pragma mark - Delegate : UIScrollViewDelegate
//페이지 이동이 실행되고 있는 동안 계속 호출됩니다.
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isMovePage)
    {
        self.view.userInteractionEnabled = NO;
    }
    
    if (scrollView == self.fishingScrollView)
    {
        if( self.fishingScrollView.contentOffset.x == 0 )
        {
            //맨앞
            
        }else if( self.fishingScrollView.contentOffset.x == self.fishingScrollView.contentSize.width - self.fishingScrollView.frame.size.width)
        {
            //맨뒤
            
        }else
        {
            //중간
        }
    }
}

// 스크롤뷰의 스크롤이 된후 실행됨.(called when scroll view grinds to a halt)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isMovePage) isMovePage = NO;
    
    self.view.userInteractionEnabled = YES;
    if (scrollView == self.fishingScrollView)
    {
        
    
        int newIndex = [self getCurrentPageNumInScollerView:self.fishingScrollView pageWidth:self.fishingScrollView.frame.size.width];
        
        if ( pageIndex != newIndex)
        {
            pageIndex = newIndex;
        }
        if (pageIndex == 0)
        {
            self.page1ImageView.image = [UIImage imageNamed:@"page_on.png"];
            self.page2ImageView.image = [UIImage imageNamed:@"page_off.png"];
            self.page3ImageView.image = [UIImage imageNamed:@"page_off.png"];
        }else if (pageIndex == 1)
        {
            self.page1ImageView.image = [UIImage imageNamed:@"page_off.png"];
            self.page2ImageView.image = [UIImage imageNamed:@"page_on.png"];
            self.page3ImageView.image = [UIImage imageNamed:@"page_off.png"];
        }else if (pageIndex == 2)
        {
            self.page1ImageView.image = [UIImage imageNamed:@"page_off.png"];
            self.page2ImageView.image = [UIImage imageNamed:@"page_off.png"];
            self.page3ImageView.image = [UIImage imageNamed:@"page_on.png"];
        }
        
    }
    //NSLog(@"pageIndex:%i",pageIndex);
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (isMovePage) isMovePage = NO;
    self.view.userInteractionEnabled = YES;
 
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (isMovePage) isMovePage = NO;
    self.view.userInteractionEnabled = YES;
}

- (int)getCurrentPageNumInScollerView:(UIScrollView *)scrollView pageWidth:(CGFloat)pageWidth{
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    
    return currentPage;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1982)
    {
		[AppDelegate.navigationController fadePopToRootViewController];
        SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
	}
}
@end
