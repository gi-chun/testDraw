//
//  SHBLoanBizNoVisitResultViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitResultViewController.h"
#import "SHBLoanBizNoVisitResultViewCell.h" // cell
#import "SHBLoanBizNoVisitResultViewCell2.h" // cell
#import "SHBLoanService.h" // 서비스
#import "SHBAccidentPopupView.h" // 팝업
#import "SHBGoodsSubTitleView.h"

#import "SHBLoanBizNoVisitResultRateView.h"
#import "SHBNewProductSeeStipulationViewController.h" // 약관보기
#import "SHBLoanBizNoVisitResult2ViewController.h" // 직장인 최적상품(무방문대출) 신청 연소득 확인 안내

@interface SHBLoanBizNoVisitResultViewController () <SHBPopupViewDelegate, SHBLoanBizNoVisitResultRateViewDelegate>

@property (retain, nonatomic) OFDataSet *L3665Dic;
@property (retain, nonatomic) OFDataSet *L3664Dic;
@property (retain, nonatomic) OFDataSet *D3220Dic;

@property (retain, nonatomic) NSMutableDictionary *selectL3661Dic;
@property (retain, nonatomic) NSMutableDictionary *selectL3665Dic;

@property (retain, nonatomic) NSMutableArray *L3661List;
@property (retain, nonatomic) NSMutableArray *L3665List;
@property (retain, nonatomic) NSMutableArray *L3664List;
@property (retain, nonatomic) NSMutableArray *D3220List;

@property (retain, nonatomic) SHBAccidentPopupView *popupView; // 금리 조회 결과

@property (retain, nonatomic) SHBLoanBizNoVisitResultRateView *rateView2; // 감면금리 항목명 및 금리

@end

@implementation SHBLoanBizNoVisitResultViewController

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
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 약관";
    
    [self navigationBackButtonHidden];
    
    self.L3661List = [_L3661Dic arrayWithForKey:@"최적상품LIST"];
    
    for (NSMutableDictionary *dic in _L3661List) {
        
        [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"산출한도"]] forKey:@"_산출한도"];
    }
    
    if ([_L3661List count] == 0) {
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"직장인 최적상품(무방문대출) 신청" maxStep:4 focusStepNumber:4] autorelease]];
        
        [_infoView initFrame:_infoView.frame];
        [_infoView setText:@"<midGray_13>문의사항은 신한은행 </midGray_13><midRed_13>스마트론센터 1588-8641(1)번</midRed_13><midGray_13>으로 연락 주시기 바랍니다.</midGray_13>"];
        
        [_contentSV setHidden:NO];
        
        [_contentSV addSubview:_noDataView];
        [_contentSV setContentSize:_noDataView.frame.size];
        
        [_dataTable setHidden:YES];
    }
    else {
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"직장인 최적상품(무방문대출) 신청" maxStep:6 focusStepNumber:4] autorelease]];
        
        [_contentSV setHidden:YES];
        
        [_dataTable setHidden:NO];
        [_dataTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.L3661Dic = nil;
    self.C2800Dic = nil;
    
    self.L3665Dic = nil;
    self.L3664Dic = nil;
    self.D3220Dic = nil;
    
    self.selectL3661Dic = nil;
    self.selectL3665Dic = nil;
    
    self.L3661List = nil;
    self.L3665List = nil;
    self.L3664List = nil;
    self.D3220List = nil;
    
    self.popupView = nil;
    self.rateView2 = nil;
    
    [_contentSV release];
    [_noDataView release];
    [_infoView release];
    [_dataTable release];
    [_dataTable2 release];
    [_rateView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentSV:nil];
    [self setNoDataView:nil];
    [self setInfoView:nil];
    [self setDataTable:nil];
    [self setDataTable2:nil];
    [self setRateView:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)requestL3665:(NSDictionary *)dic
{
    self.selectL3661Dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    // 새희망홀씨대출은 영업점에서만 신청가능하므로 해당 내용만 보여주고 진행되지 않음
    if ([_selectL3661Dic[@"상품코드"] isEqualToString:@"611114900"]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"새희망홀씨대출은 당행 론센터 운영 지침에 의해 인터넷으로 신규 불가한 상품입니다.\n본 상품에 대한 신규 및 상담은 대출희망 영업점으로 방문하시기 바랍니다."];
        return;
    }
    else {
        
        // 엘리트론을 선택했을 경우 팝업창
        if ([_selectL3661Dic[@"상품코드"] isEqualToString:@"612211100"] || [_selectL3661Dic[@"상품코드"] isEqualToString:@"612241100"]) {
            
            if ([_selectL3661Dic[@"정책코드"] isEqualToString:@"6128"]) {
                
                // 원클릭 급여이체 엘리트론 안내 팝업창
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:55355
                                 title:@""
                               message:@"선택하신 상품은 무서류, 무방문 대출로서 유선으로 재직 확인이 가능한 경우에만 대출이 가능합니다.유선으로 재직 확인이 불가능하거나 대출금액이 30백만원을 초과하는 경우 영업점 상담을 부탁드립니다.\n\n전화안내 : 1577-8000"];
                return;
            }
            else {
                
                // 일반 엘리트론 안내 팝업창
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:55355
                                 title:@""
                               message:@"엘리트론은 업체에 따라 퇴직연금 가입, 급여이체 등 추가요건이 필요할 수 있으며, 경우에 따라 엘리트론 신규가 불가할 수 있습니다."];
                return;
            }
        }
        
        // 원클릭 스마트론 선택시 팝업창
        if ([_selectL3661Dic[@"상품코드"] isEqualToString:@"611115700"] || [_selectL3661Dic[@"상품코드"] isEqualToString:@"611143700"]) {
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:55355
                             title:@""
                           message:@"재직증명서 팩스 제출이 필요한 대출입니다.신청완료 후 팩스 발송 부탁드립니다.\n\nFAX : 0505-177-0077"];
            return;
        }
        
        // 원클릭 급여이체 스마트론 선택시 팝업창
        if ([_selectL3661Dic[@"상품코드"] isEqualToString:@"611111100"] || [_selectL3661Dic[@"상품코드"] isEqualToString:@"611141100"]) {
            
            if ([_selectL3661Dic[@"정책코드"] isEqualToString:@"6215"]) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:55355
                                 title:@""
                               message:@"무서류 대출 상품입니다.재직업체에 따라 재직증명서 팩스 발송을 요청할 수도 있습니다.전화로 요청 시 적극 협조 부탁드립니다."];
                return;
            }
        }
    }
    
    AppInfo.serviceOption = @"직장인무방문대출";
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"업무구분" : @"2",
                                                                  @"신청번호" : _L3661Dic[@"신청번호"],
                                                                  @"_상품CODE_" : _selectL3661Dic[@"상품코드"],
                                                                  @"_정책코드_" : _selectL3661Dic[@"정책코드"]
                                                                  }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3665_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)requestL3664:(NSDictionary *)dic
{
    self.selectL3665Dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    AppInfo.serviceOption = @"직장인무방문대출";
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                 @"신청번호" : _L3661Dic[@"신청번호"],
                                                                 @"고객번호" : AppInfo.customerNo,
                                                                 @"조회구분" : @"9",
                                                                 @"상품CODE" : _selectL3661Dic[@"상품코드"],
                                                                 @"정책금융CODE" : _selectL3661Dic[@"정책코드"],
                                                                 @"금리구분" : _selectL3665Dic[@"금리구분"],
                                                                 @"시장금리종류" : _selectL3665Dic[@"시장금리종류"],
                                                                 @"시장기간물종류" : _selectL3665Dic[@"시장기간물종류"],
                                                                 @"대출기간" : @"12",
                                                                 @"대출기간단위CODE" : @"1",
                                                                 @"신청구분" : @"10",
                                                                 @"상환방법CODE" :@"1",
                                                                 @"신청일자" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                                                                 @"기관코드" : _selectL3665Dic[@"업체번호"]
                                                                 }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3664_SERVICE viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

- (void)requestD3220
{
    AppInfo.serviceOption = @"직장인무방문대출";
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"기준일자" : AppInfo.tran_Date
                                                                  }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_D3220_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Button

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
            
        case LOAN_L3665_SERVICE: {
            
            self.L3665Dic = aDataSet;
        }
            break;
            
        case LOAN_L3664_SERVICE: {
            
            self.L3664Dic = aDataSet;
        }
            break;
            
        case LOAN_D3220_SERVICE: {
            
            self.D3220Dic = aDataSet;
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
            
        case LOAN_L3665_SERVICE: {
            
            self.L3665List = [aDataSet arrayWithForKey:@"금리명세LIST"];
            
            for (NSMutableDictionary *dic in _L3665List) {
                
                [dic setObject:[NSString stringWithFormat:@"%@%% ~ %@%%", dic[@"최저고시금리"], dic[@"최대고시금리"]] forKey:@"_금리"];
            }
            
            self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"금리 조회 결과"
                                                                             SubViewHeight:_rateView.frame.size.height + 6
                                                                            setContentView:_rateView] autorelease];
            
            [_popupView showInView:self.navigationController.view animated:YES];
            
            [_dataTable2 reloadData];
        }
            break;
            
        case LOAN_L3664_SERVICE: {
            
            self.L3664List = [aDataSet arrayWithForKey:@"일반감면LIST"];
            
            [_popupView fadeOut];
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanBizNoVisitResultRateView"
                                                           owner:self options:nil];
            self.rateView2 = (SHBLoanBizNoVisitResultRateView *)array[0];
            _rateView2.delegate = self;
            _rateView2.dataList = _L3664List;
            [_rateView2 showInView:self.navigationController.view animated:YES];
        }
            break;
            
        case LOAN_D3220_SERVICE: {
            
            
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 55355) {
        
        AppInfo.serviceOption = @"직장인무방문대출";
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                      @"업무구분" : @"2",
                                                                      @"신청번호" : _L3661Dic[@"신청번호"],
                                                                      @"_상품CODE_" : _selectL3661Dic[@"상품코드"],
                                                                      @"_정책코드_" : _selectL3661Dic[@"정책코드"]
                                                                      }];
        
        self.service = nil;
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3665_SERVICE viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _dataTable) {
        
        return [_L3661List count];
    }
    else if (tableView == _dataTable2) {
        
        return [_L3665List count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dataTable) {
        
        // 상품목록
        
        SHBLoanBizNoVisitResultViewCell *cell = (SHBLoanBizNoVisitResultViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBLoanBizNoVisitResultViewCell"];
        
        if (cell == nil) {
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanBizNoVisitResultViewCell"
                                                           owner:self options:nil];
            cell = (SHBLoanBizNoVisitResultViewCell *)array[0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        OFDataSet *cellDataSet = _L3661List[indexPath.row];
        [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
        
        [cell.productName initFrame:cell.productName.frame
                          colorType:RGB(44, 44, 44)
                           fontSize:15
                          textAlign:2];
        [cell.productName setCaptionText:cellDataSet[@"상품명"]];
        
        [cell.infoBtn setTag:indexPath.row];
        [cell.infoBtn addTarget:self action:@selector(infoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if (tableView == _dataTable2) {
        
        // 금리조회 결과
        
        SHBLoanBizNoVisitResultViewCell2 *cell = (SHBLoanBizNoVisitResultViewCell2 *)[tableView dequeueReusableCellWithIdentifier:@"SHBLoanBizNoVisitResultViewCell2"];
        
        if (cell == nil) {
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBLoanBizNoVisitResultViewCell2"
                                                           owner:self options:nil];
            cell = (SHBLoanBizNoVisitResultViewCell2 *)array[0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        OFDataSet *cellDataSet = _L3665List[indexPath.row];
        [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _dataTable) {
        
        [self requestL3665:_L3661List[indexPath.row]];
    }
    else if (tableView == _dataTable2) {
        
        [self requestL3664:_L3665List[indexPath.row]];
    }
}

#pragma mark - UITableView Button

- (void)infoBtnPressed:(UIButton *)sender
{
    OFDataSet *cellDataSet = _L3661List[sender.tag];
    
    SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
    
    viewController.strUrl = cellDataSet[@"WEB_VIEW_URL"];
    viewController.strName = @"직장인 무방문 신용대출";
    viewController.strBackButtonTitle = @"상품설명보기";
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - SHBLoanBizNoVisitResultRateView Delegate

- (void)loanBizNoVisitResultRateOK
{
    SHBLoanBizNoVisitResult2ViewController *viewController = [[[SHBLoanBizNoVisitResult2ViewController alloc] initWithNibName:@"SHBLoanBizNoVisitResult2ViewController" bundle:nil] autorelease];
    
    viewController.data = @{
                            @"_상품명" : _selectL3661Dic[@"상품명"],
                            @"_산출한도" : _selectL3661Dic[@"산출한도"],
                            @"_판정코드" : _selectL3661Dic[@"판정코드"],
                            @"_신청번호" : _L3661Dic[@"신청번호"],
                            @"_상품코드" : _selectL3661Dic[@"상품코드"],
                            @"_정책코드" : _selectL3661Dic[@"정책코드"],
                            @"_금리구분" : _selectL3665Dic[@"금리구분"],
                            @"_시장금리종류" : _selectL3665Dic[@"시장금리종류"],
                            @"_시장기간물종류" : _selectL3665Dic[@"시장기간물종류"],
                            @"_금리차등적용구분" : _selectL3665Dic[@"금리적용차등구분"],
                            @"_금리" : [NSString stringWithFormat:@"%@ %@", _selectL3665Dic[@"금리구분값"], _selectL3665Dic[@"_금리"]]
                            };
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
