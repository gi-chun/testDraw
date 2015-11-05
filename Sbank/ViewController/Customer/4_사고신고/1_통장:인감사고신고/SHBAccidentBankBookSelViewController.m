//
//  SHBAccidentBankBookSelViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentBankBookSelViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBAccidentBankBookCompleteViewController.h" // 통장/인감 사고신고 완료

@interface SHBAccidentBankBookSelViewController ()

@end

@implementation SHBAccidentBankBookSelViewController

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
    
    if ([dataSet[@"_사고신고여부"] isEqualToString:@"통장"]) {
        [_bankbook setEnabled:NO];
        
    }
    else if ([dataSet[@"_사고신고여부"] isEqualToString:@"인감"]) {
        [_seal setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_bankbook release];
    [_seal release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBankbook:nil];
    [self setSeal:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBAccidentBankBookInfoViewController") class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
            
            break;
        }
    }
    
    if (!AppInfo.errorType) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:self.service.requestData[@"계좌번호구분"]
                forKey:@"_계좌번호"];
        
        if ([_bankbook isSelected] && [_seal isSelected]) {
            [dic setObject:@"통장분실,인감분실"
                    forKey:@"_사고등록여부"];
        }
        else if ([_bankbook isSelected] && ![_seal isSelected]) {
            [dic setObject:@"통장분실"
                    forKey:@"_사고등록여부"];
        }
        else if (![_bankbook isSelected] && [_seal isSelected]) {
            [dic setObject:@"인감분실"
                    forKey:@"_사고등록여부"];
        }
        
        AppInfo.commonDic = (NSDictionary *)dic;
        
        SHBAccidentBankBookCompleteViewController *viewController = [[[SHBAccidentBankBookCompleteViewController alloc] initWithNibName:@"SHBAccidentBankBookCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

#pragma mark - Button

/// 통장
- (IBAction)bankbookBtn:(UIButton *)sender
{
    [_bankbook setSelected:![sender isSelected]];
}

/// 인감
- (IBAction)sealBtn:(UIButton *)sender
{
    [_seal setSelected:![sender isSelected]];
}

/// 예
- (IBAction)yesBtn:(UIButton *)sender
{
    if (![_bankbook isSelected] && ![_seal isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"사고신고 할 항목을 선택하여 주십시오"];
        return;
    }
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"사고신고";
    
    AppInfo.electronicSignCode = CUSTOMER_E4131;
    AppInfo.electronicSignTitle = @"통장/인감 사고신고";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)계좌번호: %@", AppInfo.commonDic[@"2"]]];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"거래점용은행구분" : @"1",
                           @"계좌번호" : AppInfo.commonDic[@"계좌번호"],
                           @"거래점용계좌번호" : AppInfo.commonDic[@"계좌번호"],
                           @"계좌번호구분" : AppInfo.commonDic[@"2"],
                           @"업무구분" : @"1",
                           @"신고유형" : @"2",
                           @"기준일자" : AppInfo.tran_Date,
                           }];
    
    if ([_bankbook isSelected] && [_seal isSelected]) {
        [AppInfo addElectronicSign:@"(4)사고신고: 통장,인감"];
        
        [dataSet insertObject:@"12005"
                       forKey:@"등록해제코드"
                      atIndex:0];
    }
    else if ([_bankbook isSelected] && ![_seal isSelected]) {
        [AppInfo addElectronicSign:@"(4)사고신고: 통장"];
        
        [dataSet insertObject:@"12007"
                       forKey:@"등록해제코드"
                      atIndex:0];
    }
    else if (![_bankbook isSelected] && [_seal isSelected]) {
        [AppInfo addElectronicSign:@"(4)사고신고: 인감"];
        
        [dataSet insertObject:@"12006"
                       forKey:@"등록해제코드"
                      atIndex:0];
    }
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4131
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 아니오
- (IBAction)noBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([_delegate respondsToSelector:@selector(accidentBankBookSelCancel)]) {
        [_delegate accidentBankBookSelCancel];
    }
    
    [self.navigationController fadePopViewController];
}

@end

