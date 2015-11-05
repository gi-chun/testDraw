//
//  SHBFundDrawingApplyViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundDrawingApplyViewController.h"
#import "SHBFundDrawingApplySecurityCardViewController.h"   //출금예약취소
#import "SHBUtility.h"
//#import "SHBScrollingTicker.h"
#import "SHBPushInfo.h"

@interface SHBFundDrawingApplyViewController ()
{
//    SHBScrollingTicker *scrollingTicker;
}

@end

@implementation SHBFundDrawingApplyViewController

@synthesize fundInfo, basicInfo;

@synthesize scrollView;

@synthesize basicLabel01;
@synthesize basicLabel02;
@synthesize basicLabel03;
@synthesize basicLabel04;
@synthesize basicLabel05;
@synthesize basicLabel06;
@synthesize basicLabel07;
@synthesize basicLabel08;
@synthesize basicLabel09;
@synthesize basicLabel10;
@synthesize basicLabel11;
@synthesize basicLabel12;
@synthesize basicLabel13;
@synthesize basicLabel14;
@synthesize basicLabel15;
@synthesize basicLabel16;
@synthesize basicLabel17;

// 기본데이터
- (void)displayBasicData
{
//    basicLabel01.text = [basicInfo objectForKey:@"계좌명"];
    // 신구 계좌에 따른 차이로 값 셋팅하여 들어온다
    basicLabel02.text = [basicInfo objectForKey:@"계좌번호표시"];
    basicLabel03.text = [basicInfo objectForKey:@"고객명"];
    basicLabel04.text = [basicInfo objectForKey:@"저축종류"];
    basicLabel05.text = [basicInfo objectForKey:@"신규일자"];
    if ([[basicInfo objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel06.text = [NSString stringWithFormat:@"원(%@)", [basicInfo objectForKey:@"통화종류"]];
    } else {
        basicLabel06.text = [basicInfo objectForKey:@"통화종류"];
    }
    basicLabel07.text = [basicInfo objectForKey:@"연결계좌번호"];
    basicLabel08.text = [fundInfo objectForKey:@"거래종류"];
    basicLabel09.text = [fundInfo objectForKey:@"거래일자"];
    basicLabel10.text = [fundInfo objectForKey:@"거래번호"];
    basicLabel11.text = [fundInfo objectForKey:@"취소여부"];
    basicLabel12.text = [fundInfo objectForKey:@"지급기준구분"];
    if ([[basicInfo objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel13.text = [[fundInfo objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래금액"] rangeOfString:@"."].location)];
    } else {
        basicLabel13.text = [fundInfo objectForKey:@"거래금액"];
    }
    basicLabel14.text = [fundInfo objectForKey:@"신청일자"];
    basicLabel15.text = [fundInfo objectForKey:@"기준가적용일자"];
    basicLabel16.text = [fundInfo objectForKey:@"처리예정일자"];
    basicLabel17.text = [fundInfo objectForKey:@"연동상대계좌번호"];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0: {
            
            // 현업의 요청으로 펀드출금예약취소에 대해서 스마트펀드센터를 호출하는 것으로 변경
            
//            NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
//            // 테스트를 위해
//            if (![SHBUtility isOPDate:[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""]] || time < 90000 || time > 150000) {
//                [UIAlertView showAlert:self
//                                  type:ONFAlertTypeOneButton
//                                   tag:0
//                                 title:@""
//                               message:@"09:00 ~ 15:00 까지만 이용 가능한 서비스입니다.(토요일, 휴일 불가능)"];
//
//                return;
//            } else {
//                SHBFundDrawingApplySecurityCardViewController *detailViewController = [[SHBFundDrawingApplySecurityCardViewController alloc] initWithNibName:@"SHBFundDrawingApplySecurityCardViewController" bundle:nil];
//                
//                detailViewController.data_D6010 = basicInfo;
//                detailViewController.data_D6020 = fundInfo;
//                
//                detailViewController.needsCert = YES;
//                
//                // 공인인증확인
//                [self checkLoginBeforePushViewController:detailViewController animated:YES];
//                [detailViewController release];
//
//            }
            
            SHBPushInfo *openURLManager = [SHBPushInfo instance];

            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartfundcenter://"]]) {
                
                [openURLManager requestOpenURL:@"smartfundcenter://" Parm:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id495878508?mt=8"]];
            }

        }
            break;
        case 1:
            [self.navigationController fadePopViewController];
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [scrollView release];
    
    [basicLabel01 release], basicLabel01 = nil;
    [basicLabel02 release], basicLabel02 = nil;
    [basicLabel03 release], basicLabel03 = nil;
    [basicLabel04 release], basicLabel04 = nil;
    [basicLabel05 release], basicLabel05 = nil;
    [basicLabel06 release], basicLabel06 = nil;
    [basicLabel07 release], basicLabel07 = nil;
    [basicLabel08 release], basicLabel08 = nil;
    [basicLabel09 release], basicLabel09 = nil;
    [basicLabel10 release], basicLabel10 = nil;
    [basicLabel11 release], basicLabel11 = nil;
    [basicLabel12 release], basicLabel12 = nil;
    [basicLabel13 release], basicLabel13 = nil;
    [basicLabel14 release], basicLabel14 = nil;
    [basicLabel15 release], basicLabel15 = nil;
    [basicLabel16 release], basicLabel16 = nil;
    [basicLabel17 release], basicLabel17 = nil;
    
    [_fundInfoView release];
    [_fundTickerName release];
    
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"펀드조회";
    self.strBackButtonTitle = @"펀드조회 상세";
    [self displayBasicData];
    
    // Scroll Label
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[basicInfo objectForKey:@"계좌명"]];

    
    [_fundInfoView setFrame:CGRectMake(0.0f, 0.0f, 317.0f, 681.0f)];
    [self.scrollView setContentSize:_fundInfoView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
