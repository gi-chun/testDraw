//
//  SHBGiftCancelListViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelListViewController.h"
#import "SHBGiftService.h" // 서비스
#import "SHBGiftCancelListCell.h" // cell
#import "SHBListPopupView.h" // list popup

#import "SHBGiftCancelDetailViewController.h" // 상품권 취소

@interface SHBGiftCancelListViewController ()

@end

@implementation SHBGiftCancelListViewController

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
    
    [self setTitle:@"모바일상품권 구매취소"];
    self.strBackButtonTitle = @"모바일상품권 구매취소 취소할 상품권 목록";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"거래구분" : @"3",
                              @"업무유형" : @"1",
                              @"기관코드" : @"",
                              @"판매금액" : @"",
                              @"계좌구분" : _selectAccountDic[@"은행구분"],
                              @"지급계좌번호" : _selectAccountDic[@"2"],
                              @"계좌비밀번호" : @"",
                              @"센터처리번호" : @"",
                              @"구매자휴대폰" : @"",
                              @"받는분휴대폰" : @"",
                              @"구매자성명" : AppInfo.userInfo[@"고객성명"],
                              @"받는분성명" : @"",
                              @"전달메세지" : @"",
                              @"취소시구매일자" : @"",
                              @"취소시구매승인번호" : @""
                              }];
    
    self.service = nil;
    self.service = [[[SHBGiftService alloc] initWithServiceId:GIFT_E1720 viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBGiftCancelListCell"
                   dataSetList:@"상품권취소대상.vector.data"];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectAccountDic = nil;
    
    [_dataTable release];
    [_infoLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setInfoLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    for (NSMutableDictionary *dic in self.service.dataList) {
        
        // 아래 내용 수정시 SHBGiftCancelSearchViewController 에서도 동일하게 수정 필요
        
        if ([dic[@"상품권명"] isEqualToString:@"EMART"]) {
            
            [dic setObject:@"신세계상품권" forKey:@"_상품권명"];
        }
        else if ([dic[@"상품권명"] isEqualToString:@"CULTU"]) {
            
            [dic setObject:@"문화상품권" forKey:@"_상품권명"];
        }
        
        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"구매금액"]] forKey:@"_구매금액"];
        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"환급금액"]] forKey:@"_환급금액"];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        NSDate *date = [dateFormatter dateFromString:dic[@"판매일자"]];
        
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        NSString *dateStr = [dateFormatter stringFromDate:date];
        
        [dic setObject:dateStr forKey:@"_구매일자"];
        
        [dic setObject:_selectAccountDic[@"2"] forKey:@"_계좌번호"];
        [dic setObject:_selectAccountDic[@"은행구분"] forKey:@"_계좌구분"];
    }
    
    [_infoLabel setText:[NSString stringWithFormat:@"최근거래내역 %d건이 조회되었습니다.", [self.service.dataList count]]];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.service.dataList[indexPath.row];
    
    SHBGiftCancelDetailViewController *viewController = [[[SHBGiftCancelDetailViewController alloc] initWithNibName:@"SHBGiftCancelDetailViewController" bundle:nil] autorelease];
    
    viewController.data = dic;
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
