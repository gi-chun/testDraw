//
//  SHBLoanBizNoVisitApplyInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyInfoViewController.h"
#import "SHBLoanService.h" // 서비스

#import "SHBLoanBizNoVisitApplyStipulationViewController.h" // 신청 조회 및 실행 1단계 (신청내역)
#import "SHBLoanBizNoVisitApplyConfirmViewController.h" // 신청 조회 및 실행 5단계 (입력정보 확인)

@interface SHBLoanBizNoVisitApplyInfoViewController ()

@end

@implementation SHBLoanBizNoVisitApplyInfoViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인 무방문 신용대출 신청 조회 및 실행 4단계 인지세 부과 안내";
    
    [_contentSV addSubview:_contentView];
    [_contentSV setContentSize:_contentView.frame.size];
    
    self.data = [NSDictionary dictionaryWithDictionary:AppInfo.commonDic];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    AppInfo.serviceOption = @"직장인무방문대출";
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"대출승인번호" : self.data[@"신청번호"]
                                                                  }];
    
    self.service = nil;
    
    if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
        
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3224_SERVICE viewController:self] autorelease];
    }
    else {
        
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3225_SERVICE viewController:self] autorelease];
    }
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_contentSV release];
    [_contentView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentSV:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 확인
            
            SHBLoanBizNoVisitApplyConfirmViewController *viewController = [[[SHBLoanBizNoVisitApplyConfirmViewController alloc] initWithNibName:@"SHBLoanBizNoVisitApplyConfirmViewController" bundle:nil] autorelease];
            
            viewController.data = self.data;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 200: {
            
            // 취소
            
            for (SHBLoanBizNoVisitApplyStipulationViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBLoanBizNoVisitApplyStipulationViewController class]]) {
                    
                    [viewController clearViewData];
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    switch (self.service.serviceId) {
            
        case LOAN_L3224_SERVICE: {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data];
            
            [dic setObject:aDataSet[@"계좌번호"] forKey:@"_계좌번호"];
            [dic setObject:aDataSet[@"대출한도금액"] forKey:@"_신청금액"];
            [dic setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"대출한도금액"]] forKey:@"_신청금액원"];
            
            self.data = [NSDictionary dictionaryWithDictionary:dic];
        }
            break;
            
        case LOAN_L3225_SERVICE: {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data];
            
            if ([dic[@"신청구분CODE"] isEqualToString:@"30"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"32"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"33"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"34"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"36"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"37"] ||
                [dic[@"신청구분CODE"] isEqualToString:@"38"]) {
                
                if ([[aDataSet[@"BPR예약실행.대환전계좌번호"] substringToIndex:3] integerValue] < 300) {
                    
                    [dic setObject:aDataSet[@"BPR예약실행.대환전계좌번호"] forKey:@"_계좌번호"];
                }
                else {
                    
                    [dic setObject:aDataSet[@"BPR예약실행.연동지급계좌번호"] forKey:@"_계좌번호"];
                }
            }
            else {
                
                [dic setObject:aDataSet[@"BPR예약실행.연동계좌번호"] forKey:@"_계좌번호"];
            }
            
            [dic setObject:aDataSet[@"BPR예약실행.거래금액"] forKey:@"_신청금액"];
            [dic setObject:[NSString stringWithFormat:@"%@원", aDataSet[@"BPR예약실행.거래금액"]] forKey:@"_신청금액원"];
            
            self.data = [NSDictionary dictionaryWithDictionary:dic];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
