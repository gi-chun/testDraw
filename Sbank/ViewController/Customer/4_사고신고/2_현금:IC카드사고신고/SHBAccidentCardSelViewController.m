//
//  SHBAccidentCardSelViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentCardSelViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBAccidentCardCompleteViewController.h" // 현금/IC카드 사고신고 완료

@interface SHBAccidentCardSelViewController ()

@end

@implementation SHBAccidentCardSelViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    [self setTitle:@"사고신고"];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_accident release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAccident:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBAccidentCardInfoViewController") class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
            
            break;
        }
    }
    
    if (!AppInfo.errorType) {
        SHBAccidentCardCompleteViewController *viewController = [[[SHBAccidentCardCompleteViewController alloc] initWithNibName:@"SHBAccidentCardCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

#pragma mark - Button

/// 사고신고
- (IBAction)accidentBtn:(UIButton *)sender
{
    [_accident setSelected:![sender isSelected]];
}

/// 확인
- (IBAction)yesBtn:(UIButton *)sender
{
    if (![_accident isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 여부를 선택하여 주십시오"];
        return;
    }
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"사고신고";
    
    AppInfo.electronicSignCode = CUSTOMER_E4141;
    AppInfo.electronicSignTitle = @"현금/IC카드 사고신고";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)계좌번호: %@", AppInfo.commonDic[@"계좌번호"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)사고신고: %@", AppInfo.commonDic[@"_카드종류"]]];
    
    NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *time = [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"거래구분" : @"0",
                           @"고객번호" : AppInfo.customerNo,
                           //@"주민번호" : AppInfo.ssn,
                           //@"주민번호" : [AppInfo getPersonalPK],
                           @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                           @"전송일자시간" : [NSString stringWithFormat:@"%@%@", date, time],
                           @"등록해제구분" : @"1",
                           @"분실구분" : @"3",
                           @"사고신고건수" : @"1",
                           }];
    
    SHBDataSet *vectorSet = [SHBDataSet dictionaryWithDictionary:
                             @{
                             @"매체종류" : AppInfo.commonDic[@"금융IC매체종류"],
                             @"계좌과목코드" : AppInfo.commonDic[@"계좌과목코드"],
                             @"계좌일련번호" : AppInfo.commonDic[@"계좌일련번호"],
                             @"발급번호" : AppInfo.commonDic[@"발급번호"],
                             }];
    
    if ([vectorSet[@"매체종류"] isEqualToString:@"52"] || [vectorSet[@"매체종류"] isEqualToString:@"53"]) {
        [vectorSet insertObject:AppInfo.commonDic[@"CSN번호"]
                         forKey:@"카드번호"
                        atIndex:0];
    }
    else {
        [vectorSet insertObject:[AppInfo.commonDic[@"카드번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]
                         forKey:@"카드번호"
                        atIndex:0];
    }
    
    dataSet.vectorTitle = @"사고신고목록";
    [dataSet insertObject:vectorSet
                   forKey:@"vector0"
                  atIndex:0];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4141
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 취소
- (IBAction)noBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([_delegate respondsToSelector:@selector(accidentCardSelCancel)]) {
        [_delegate accidentCardSelCancel];
    }
    
    [self.navigationController fadePopViewController];
}

@end
