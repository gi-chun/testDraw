//
//  SHBAccidentSearchCardViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchCardViewController.h"
#import "SHBCustomerService.h"
#import "SHBAccidentSearchCardListViewController.h"

@interface SHBAccidentSearchCardViewController ()

@end

@implementation SHBAccidentSearchCardViewController

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
	[self setTitle:@"사고신고 조회"];
    
    self.strBackButtonTitle = @"현금/IC카드사고신고조회 메인";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    NSLog(@"aDataSet : %@", aDataSet);

    NSMutableArray *tempDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSString *tempCardType = @"";

    AppInfo.commonDic = @{
                        @"고객명" : aDataSet[@"고객명"],
                        //@"주민등록번호" : AppInfo.ssn,  //aDataSet[@"COM_JUMIN_NO"],
                        @"주민등록번호" : [AppInfo getPersonalPK],  //aDataSet[@"COM_JUMIN_NO"],
                        //@"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                        };
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"시작라인"]) {
        // 카드종류구분
        if ([dic[@"금융IC매체종류"] isEqualToString:@"1"])
        {
            tempCardType = @"현금카드";            
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"11"])
        {
            tempCardType = @"직불카드";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"21"])
        {
            tempCardType = @"K-CASH";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"22"])
        {
            tempCardType = @"몬덱스";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"31"])
        {
            tempCardType = @"금융IC";
        }
        
        if ([dic[@"금융IC매체종류"] isEqualToString:@"32"])
        {
            tempCardType = @"모바일IC";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"51"])
        {
            tempCardType = @"신용카드";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"52"])
        {
            tempCardType = @"신용카드IC";
        }
        if ([dic[@"금융IC매체종류"] isEqualToString:@"53"])
        {
            tempCardType = @"신용카드모바일IC";
        }
        [dic setObject:tempCardType forKey:@"카드종류"];

//        // 구계좌확인
//        if ([[tmp objectForKey:@"발급원장.통합전계좌번호"]length] > 0)
//        {
//            [listItemDic setObject:[tmp objectForKey:@"발급원장.통합전계좌번호"] forKey:@"beforeAccount"];
//        }
        
        [tempDataArray addObject:dic];

    }
    
    NSLog(@"tempDataArray : %@", tempDataArray);

    if ([[aDataSet arrayWithForKey:@"시작라인"] count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"사고신고된 현금/IC카드가 없습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
        
        return NO;
    }
    
	SHBAccidentSearchCardListViewController *viewController = [[[SHBAccidentSearchCardListViewController alloc] initWithNibName:@"SHBAccidentSearchCardListViewController" bundle:nil] autorelease];
    [viewController setListData:(NSArray *)tempDataArray];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];

    
    return YES;
}

#pragma mark - Action
- (IBAction)refBtnAction:(UIButton *)sender {
    // E4140 전문호출
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"거래구분" : @"1",
                            @"은행CODE" : @"0",
                            @"입력_정보구분" : @"1",
                            @"입력_상태구분" : @"12",
                            @"입력_카드종류" : @"99",
                            @"입력_조회범위" : @"1",
                            @"입력_MS_IC구분" : @"9",
                            }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_E4140_SERVICE viewController: self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
    
}

@end
