//
//  SHBNewProductWABSDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 2. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNewProductWABSDetailViewController.h"
#import "SHBProductService.h" // 서비스

#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductSignUpViewController.h"

@interface SHBNewProductWABSDetailViewController ()

@end

@implementation SHBNewProductWABSDetailViewController

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
    
    [self setTitle:@"예금/적금 가입"];
    
    NSString *subTitle = [NSString stringWithFormat:@"신한 재형저축 신청결과 조회/취소"];
    
    self.strBackButtonTitle = subTitle;
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:subTitle maxStep:0 focusStepNumber:0] autorelease]];
    
    if (([[_dicSelectedData objectForKey:@"거래채널유형"] isEqualToString:@"D0"] ||
        [[_dicSelectedData objectForKey:@"거래채널유형"] isEqualToString:@"DT"]) &&
        [[_dicSelectedData objectForKey:@"계좌상태"] isEqualToString:@"91"]) {
        [_cancel setHidden:NO];
    }
    else {
        [_cancel setHidden:YES];
    }
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:_dicSelectedData];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dicSelectedData = nil;
    
    [_cancel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - 

- (IBAction)cancelBtn:(UIButton *)sender
{
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"거래구분" : @"0",
                           @"계좌번호" : [_dicSelectedData objectForKey:@"계좌번호"],
                           @"거래점용계좌번호" : [_dicSelectedData objectForKey:@"계좌번호"],
                           @"대상거래시작일자" : [_dicSelectedData objectForKey:@"예약신규일"],
                           @"대상거래종료일자" : [_dicSelectedData objectForKey:@"예약신규일"],
                           }];
    
    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *oldDate = [[SHBUtility dateStringToMonth:0 toDay:-1] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger beforeDate = [[SHBUtility getPreOPDate:oldDate] integerValue]; // 전영업일
    
    if ([[_dicSelectedData objectForKey:@"예약신규일"] integerValue] == [date integerValue]) { // 정정
        
    }
    else if ([[_dicSelectedData objectForKey:@"예약신규일"] integerValue] == beforeDate) { // 후송정정
        [dataSet insertObject:[_dicSelectedData objectForKey:@"예약신규일"]
                       forKey:@"후송일자"
                      atIndex:0];
    }
    else {
        [dataSet insertObject:[_dicSelectedData objectForKey:@"예약신규일"]
                       forKey:@"기산일자"
                      atIndex:0];
    }
    
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kD3320Id viewController:self] autorelease];
    self.service.requestData = dataSet;
	[self.service start];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    SHBNewProductSignUpViewController *viewController = [[[SHBNewProductSignUpViewController alloc] initWithNibName:@"SHBNewProductSignUpViewController" bundle:nil] autorelease];
    
    [_dicSelectedData setObject:@"1" forKey:@"재형저축신청취소"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[aDataSet arrayWithForKey:@"조회내역"][0]];
    
    [dic addEntriesFromDictionary:_dicSelectedData];
    
    [dic setObject:dic[@"_상품명"] forKey:@"상품명"];
    
    viewController.dicSelectedData = dic;
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

@end
