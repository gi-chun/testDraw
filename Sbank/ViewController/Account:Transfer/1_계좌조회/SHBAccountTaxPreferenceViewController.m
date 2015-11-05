//
//  SHBAccountTaxPreferenceViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 6. 18..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBAccountTaxPreferenceViewController.h"
#import "SHBAccountService.h"

@interface SHBAccountTaxPreferenceViewController ()

@end

@implementation SHBAccountTaxPreferenceViewController

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
    
    [self setTitle:@"계좌조회"];
    
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D4220" viewController:self] autorelease];
    
    self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                @"업무구분" : @"4",
                                //@"주민번호" : AppInfo.ssn,
                                //@"주민번호" : [AppInfo getPersonalPK],
                                @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                @"주민번호구분" : @"1"
                                }];
    
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountNumber = nil;
    
    [super dealloc];
}

#pragma mark - function



#pragma mark - BUtton

- (IBAction)okPressed:(id)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    if ([self.service.strServiceCode isEqualToString:@"D4220"]) {
        [aDataSet insertObject:self.accountNumber
                        forKey:@"_계좌번호"
                       atIndex:0];
        [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"세금우대가입총액"]]
                        forKey:@"_가입총액"
                       atIndex:0];
        [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"세금우대한도잔액"]]
                        forKey:@"_한도잔액"
                       atIndex:0];
    }
    else {
        [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"세금우대가입액"]]
                        forKey:@"_저축상품가입액"
                       atIndex:0];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ([self.service.strServiceCode isEqualToString:@"D4220"]) {
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D4230" viewController:self] autorelease];
        
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                    @"업무구분" : @"7",
                                    @"은행구분" : @"1",
                                    @"조회계좌번호" : [self.accountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    //@"주민등록번호" : AppInfo.ssn,
                                    //@"주민등록번호" : [AppInfo getPersonalPK],
                                    @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    @"주민사업자구분" : @"1"
                                    }];
        
        [self.service start];
    }
    
    return YES;
}

@end
