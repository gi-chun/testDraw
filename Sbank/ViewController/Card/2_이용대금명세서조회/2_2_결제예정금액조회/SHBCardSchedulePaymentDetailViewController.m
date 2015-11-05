//
//  SHBCardSchedulePaymentDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardSchedulePaymentDetailViewController.h"
#import "SHBCardService.h" // 서비스

@interface SHBCardSchedulePaymentDetailViewController ()

@end

@implementation SHBCardSchedulePaymentDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"이용대금 명세서 조회"];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"신한카드번호" : AppInfo.commonDic[@"카드번호"],
                           @"청구월일" : AppInfo.commonDic[@"결제일자"],
                           @"다원화순번" : AppInfo.commonDic[@"다원화순번"],
                           }];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2916
                                                 viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"청구금액"]]
                    forKey:@"_청구금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"일시불금액"]]
                    forKey:@"_일시불금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"할부금액"]]
                    forKey:@"_할부금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"현금서비스금액"]]
                    forKey:@"_현금서비스금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"론금액"]]
                    forKey:@"_론금액"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"회전결제"]]
                    forKey:@"_회전결제"
                   atIndex:0];
    [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"제수수료"]]
                    forKey:@"_제수수료"
                   atIndex:0];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

@end
