//
//  SHBLoanBizNoVisitApplyListViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 31..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyListViewController.h"
#import "SHBLoanBizNoVisitApplyListCell.h" // cell
#import "SHBLoanService.h" // 서비스

#import "SHBLoanBizNoVisitApplyStipulationViewController.h" // 신청 조회 및 실행 1단계 (신청내역)

@interface SHBLoanBizNoVisitApplyListViewController ()

@end

@implementation SHBLoanBizNoVisitApplyListViewController

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
    self.strBackButtonTitle = @"직장인 무방문 신용대출 신청 조회 및 실행";
    
    [_info1 initFrame:_info1.frame];
    [_info1 setText:@"<midGray_13>문의사항은 신한은행 </midGray_13><midRed_13>스마트론센터 1588-8641(1)번</midRed_13><midGray_13>으로 연락 주시기 바랍니다.</midGray_13>"];
    
    [self reloadUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_dataTable release];
    [_info1 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setInfo1:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)reloadUI
{
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    AppInfo.serviceOption = @"직장인무방문대출";
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"업무구분" : @"1"
                                                                  }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3223_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Button

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        [self.navigationController fadePopToRootViewController];
        
        return;
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    switch (self.service.serviceId) {
            
        case LOAN_L3223_SERVICE: {
            
            self.dataList = [aDataSet arrayWithForKey:@"승인내역"];
            
            for (NSMutableDictionary *dic in self.dataList) {
                
                [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"대출신청정수금액"]]
                        forKey:@"_대출신청금액"];
                
                // 운용구분
                if ([dic[@"운용구분"] isEqualToString:@"1"]) {
                    
                    [dic setObject:@"건별거래" forKey:@"_운용구분"];
                }
                else if ([dic[@"운용구분"] isEqualToString:@"2"]) {
                    
                    [dic setObject:@"한도거래" forKey:@"_운용구분"];
                }
                else if ([dic[@"운용구분"] isEqualToString:@"3"]) {
                    
                    [dic setObject:@"유동성한도" forKey:@"_운용구분"];
                }
                else {
                    
                    [dic setObject:@"" forKey:@"_운용구분"];
                }
                
                // 상환구분
                if ([dic[@"상환구분"] isEqualToString:@"1"]) {
                    
                    [dic setObject:@"일시상환" forKey:@"_상환구분"];
                }
                else if ([dic[@"상환구분"] isEqualToString:@"2"]) {
                    
                    [dic setObject:@"원금분할상환" forKey:@"_상환구분"];
                }
                else if ([dic[@"상환구분"] isEqualToString:@"3"]) {
                    
                    [dic setObject:@"원리금균등분할상환" forKey:@"_상환구분"];
                }
                else {
                    
                    [dic setObject:@"" forKey:@"_상환구분"];
                }
                
                // 채권보전
                if ([dic[@"채권보전CODE"] isEqualToString:@"1"]) {
                    
                    [dic setObject:@"신용" forKey:@"_채권보전CODE"];
                }
                else if ([dic[@"채권보전CODE"] isEqualToString:@"2"]) {
                    
                    [dic setObject:@"신용 및 보증인" forKey:@"_채권보전CODE"];
                }
                else if ([dic[@"채권보전CODE"] isEqualToString:@"5"]) {
                    
                    [dic setObject:@"일부신용" forKey:@"_채권보전CODE"];
                }
                else if ([dic[@"채권보전CODE"] isEqualToString:@"7"]) {
                    
                    [dic setObject:@"전액담보" forKey:@"_채권보전CODE"];
                }
                else {
                    
                    [dic setObject:@"" forKey:@"_채권보전CODE"];
                }
                
                // 대출기간
                if ([dic[@"대출기간CODE"] isEqualToString:@"1"]) {
                    
                    [dic setObject:[NSString stringWithFormat:@"%@개월", dic[@"대출기간"]] forKey:@"_대출기간만료일"];
                }
                else if ([dic[@"대출기간CODE"] isEqualToString:@"2"]) {
                    
                    [dic setObject:[NSString stringWithFormat:@"%@일", dic[@"대출기간"]] forKey:@"_대출기간만료일"];
                }
                else if ([dic[@"채권보전CODE"] isEqualToString:@"3"]) {
                    
                    [dic setObject:[NSString stringWithFormat:@"%@", dic[@"만기일"]] forKey:@"_대출기간만료일"];
                }
                else {
                    
                    [dic setObject:@"" forKey:@"_대출기간만료일"];
                }
                
                [dic setObject:[NSString stringWithFormat:@"%@ %@", dic[@"_운용구분"], dic[@"신청구분"]] forKey:@"_대출"];
                
                // 한도, 건별 분류
                if ([dic[@"상품CODE"] length] > 5) {
                    
                    NSString *subStr = [dic[@"상품CODE"] substringWithRange:NSMakeRange(4, 1)];
                    
                    if ([subStr isEqualToString:@"4"]) {
                        
                        [dic setObject:@"한도" forKey:@"_대출종류"];
                    }
                    else {
                        
                        [dic setObject:@"건별" forKey:@"_대출종류"];
                    }
                }
                else {
                    
                    [dic setObject:@"" forKey:@"_대출종류"];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    switch (self.service.serviceId) {
            
        case LOAN_L3223_SERVICE: {
            
            if ([self.dataList count] == 0) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:29480
                                 title:@""
                               message:@"신청내역이 없습니다."];
                return NO;
            }
            
            [_dataTable reloadData];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBLoanBizNoVisitApplyListCell *cell = (SHBLoanBizNoVisitApplyListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBLoanBizNoVisitApplyListCell"];
    
    if (cell == nil) {
        
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanBizNoVisitApplyListCell"
                                                       owner:self options:nil];
		cell = (SHBLoanBizNoVisitApplyListCell *)array[0];
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    [cell.productName initFrame:cell.productName.frame
                      colorType:RGB(44, 44, 44)
                       fontSize:15
                      textAlign:0];
    [cell.productName setCaptionText:cellDataSet[@"상품명"]];
    [cell.productName.caption1 setFont:[UIFont boldSystemFontOfSize:15]];
    
    [cell.rate initFrame:cell.rate.frame
                      colorType:RGB(44, 44, 44)
                       fontSize:15
                      textAlign:2];
    [cell.rate setCaptionText:cellDataSet[@"금리명"]];
    
    
    if ([cellDataSet[@"최종상태번호"] integerValue] > 800 &&
        [cellDataSet[@"최종상태번호"] integerValue] < 900 &&
        [cellDataSet[@"신청구분"] isEqualToString:@"신규"]) {
        
        [cell.status setHidden:NO];
        [cell.status setTag:indexPath.row];
        [cell.status setTitle:@"대출실행" forState:UIControlStateNormal];
        [cell.status addTarget:self action:@selector(statusBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        [cell.status setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView Button

- (void)statusBtnPressed:(UIButton *)button
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataList[button.tag]];
    
    if ([dic[@"신청구분"] isEqualToString:@"신규"]) {
        
        self.data = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        SHBLoanBizNoVisitApplyStipulationViewController *viewController = [[[SHBLoanBizNoVisitApplyStipulationViewController alloc] initWithNibName:@"SHBLoanBizNoVisitApplyStipulationViewController" bundle:nil] autorelease];
        
        viewController.data = self.data;
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 29480) {
        
        [self.navigationController fadePopToRootViewController];
    }
}

@end
