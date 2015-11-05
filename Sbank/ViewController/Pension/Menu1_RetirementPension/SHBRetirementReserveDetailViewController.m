//
//  SHBRetirementReserveDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 13..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReserveDetailViewController.h"
#import "SHBPentionService.h"               // 퇴직연금 서비스


@interface SHBRetirementReserveDetailViewController ()

@end

@implementation SHBRetirementReserveDetailViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 21:            // 확인 버튼
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3700"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            // 필요한 정보 추가
//            [aDataSet setObject:dicDataDictionary[@"가입자명"] forKey:@"가입자명"];
            // 인터넷 뱅킹 따라감
            [aDataSet setObject:[AppInfo.userInfo objectForKey:@"고객성명"] forKey:@"가입자성명"];
            [aDataSet setObject:dicDataDictionary[@"플랜명"] forKey:@"플랜명"];
            
            // 단위 추가
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"적립금평가금액"]] forKey:@"적립금평가금액원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"부담금총합계"]] forKey:@"부담금총합계원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"사용자부담금합계"]] forKey:@"사용자부담금합계원"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"가입자부담금합계"]] forKey:@"가입자부담금합계원"];
            
            [aDataSet setObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"기간별수익률_설정후"]] forKey:@"기간별수익률_설정후%"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"기간별수익률1개월"]] forKey:@"기간별수익률1개월%"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"기간별수익률3개월"]] forKey:@"기간별수익률3개월%"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"기간별수익률6개월"]] forKey:@"기간별수익률6개월%"];
            [aDataSet setObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"기간별수익률1년"]] forKey:@"기간별수익률1년%"];
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    for (int i = 3000; i < 3013; i++)
    {
        UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:i];
        [self.view viewWithTag:i].accessibilityLabel = tmpLabel.text;
    }
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self.view viewWithTag:3000]);
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self.view viewWithTag:2999]);
    return YES;
}


#pragma mark -
#pragma mark Xcode Generate

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
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [scrollView1 setFrame:CGRectMake(scrollView1.frame.origin.x, scrollView1.frame.origin.y + 20, scrollView1.frame.size.width, scrollView1.frame.size.height - 20)];
    }
    // title 설정
    self.title = @"퇴직연금 적립금조회";
    self.strBackButtonTitle = @"퇴직연금 적립금 조회 상세";
    
    AppInfo.isNeedBackWhenError = YES;
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW765000Q0",
                            @"고객구분" : @"3",
                            @"플랜번호" : dicDataDictionary[@"플랜번호"],
                            @"가입자번호" : dicDataDictionary[@"가입자번호"],
                            @"제도구분" : dicDataDictionary[@"제도구분코드"],
                            @"페이지인덱스" : @"1",
                            @"전체조회건수" : @"0",
                            @"페이지패치건수" : @"500",
                            @"예비필드" : @""
                            }] autorelease];
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_RESERVE_LIST_DETAIL viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    // realView가 더 클경우 지정
    contentViewHeight = viewRealView.frame.size.height;
    [scrollView1 setContentSize:CGSizeMake(viewRealView.frame.size.width, viewRealView.frame.size.height)];
    
    
    // ios7상단 스크롤
    FrameResize(scrollView1, 317, height(scrollView1));
    FrameReposition(scrollView1, 0, 44);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}
@end
