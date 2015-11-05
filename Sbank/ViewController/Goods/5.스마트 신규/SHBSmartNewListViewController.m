//
//  SHBSmartNewListViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 11. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmartNewListViewController.h"
#import "SHBSmartNewListCell.h" // 금리우대설계서 cell
#import "SHBSmartNewListCell2.h" // 예적금맞춤설계서 cell
#import "SHBSmartNewListCell3.h" // 만기후맞춤설계서 cell
#import "SHBSmartNewListCell4.h" // 펀드맞춤설계서 cell
#import "SHBSmartNewListCell5.h" // ELD 예적금맞춤설계서 cell
#import "SHBSmartNewListCell6.h" // ELD 만기후맞춤설계서 cell
#import "SHBNotificationService.h" // 서비스
#import "SHBProductService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBNewProductListViewController.h" // 상품신규 목록

#import "SHBNewProductInfoViewController.h" // 상품신규 안내
#import "SHBEasyCloseViewController.h" // e-간편해지
#import "SHBELD_BA17_3ViewController.h" // ELD 상품 안내

@interface SHBSmartNewListViewController ()

@property (retain, nonatomic) NSMutableDictionary *selectDic;

@end

@implementation SHBSmartNewListViewController

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
    
    if (_isCoupon){
        
        [self setTitle:@"쿠폰조회"];
        self.strBackButtonTitle = @"스마트신규 추천 내역";
        
        [_subTitleView setHidden:NO];
        [_dataTable setFrame:CGRectMake(0, 44 + 37, 317, _dataTable.frame.size.height - 37)];
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:kD3251Id
                                                      viewController:self] autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                    @"처리구분" : @"1", // 1:조회
                                    @"조회기준" : @"2", // 2:고객별조회
                                    @"조회고객번호" : AppInfo.customerNo,
                                    @"조회시작일자" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                                    @"조회종료일자" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                                    }];
        
        [self.service start];
    }
    else {
        
        [self setTitle:@"스마트신규"];
        self.strBackButtonTitle = @"스마트신규 내역 조회";
        
        [_dataTable setTableHeaderView:_infoView];
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:SMART_NEW_LIST viewController:self] autorelease];
        [self.service start];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectDic = nil;
    
    [_dataTable release];
    [_subTitleView release];
    [_infoView release];
    [_noDataView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setSubTitleView:nil];
    [self setInfoView:nil];
    [self setNoDataView:nil];
    [super viewDidUnload];
}

#pragma mark - function

- (void)setD3249Data:(NSMutableArray *)array
{
    // 금리우대설계서
    
    for (SHBDataSet *dataSet in array) {
        
        [dataSet insertObject:@"D3249"
                       forKey:@"serviceCode"
                      atIndex:0];
        
        CGSize labelSize = [dataSet[@"상품명"] sizeWithFont:[UIFont systemFontOfSize:15]
                                        constrainedToSize:CGSizeMake(250, 999)
                                            lineBreakMode:NSLineBreakByTruncatingTail];
        
        if (labelSize.height >= 30) {
            
            [dataSet insertObject:@"38"
                           forKey:@"_상품명높이"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"신청금액"]]]
                       forKey:@"_가입금액"
                      atIndex:0];
        
        if ([dataSet[@"기간월"] length] == 0) {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@일", dataSet[@"기간일"]]
                           forKey:@"_가입기간"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"기간월"]]
                           forKey:@"_가입기간"
                          atIndex:0];
        }
        
        if ([dataSet[@"회전주기"] isEqualToString:@"0"]) {
            
            [dataSet insertObject:@"없음"
                           forKey:@"_회전주기"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"회전주기"]]
                           forKey:@"_회전주기"
                          atIndex:0];
        }
        
        if ([dataSet[@"이자지급주기"] isEqualToString:@"0"]) {
            
            [dataSet insertObject:@"만기지급"
                           forKey:@"_지급주기"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"이자지급주기"]]
                           forKey:@"_지급주기"
                          atIndex:0];
        }
        
        if ([dataSet[@"이자지급방법"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"이자지급식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        else if ([dataSet[@"이자지급방법"] isEqualToString:@"2"]) {
            
            [dataSet insertObject:@"만기일시복리식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"만기일시지급식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%.3lf%%", [dataSet[@"승인이율"] doubleValue]]
                       forKey:@"_적용금리"
                      atIndex:0];
        
        [dataSet insertObject:dataSet[@"승인신청직원명"]
                       forKey:@"_상담직원"
                      atIndex:0];
    }
}

- (void)setD3251Data:(NSMutableArray *)array
{
    // 예적금맞춤설계서, 만기후 맞춤설계서
    
    for (SHBDataSet *dataSet in array) {
        
        [dataSet insertObject:@"D3251"
                       forKey:@"serviceCode"
                      atIndex:0];
        
        if ([dataSet[@"상품코드"] hasPrefix:@"209"]) {
            
            NSString *name = @"";
            
            for (int i = 0; i < [dataSet[@"상품명"] length]; i++) {
                
                if ([dataSet[@"상품명"] characterAtIndex:i] == ' ') {
                    
                    name = [dataSet[@"상품명"] stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"\n"];
                    
                    break;
                }
            }
            
            [dataSet insertObject:name
                           forKey:@"_상품명"
                          atIndex:0];
            
            CGSize labelSize = [dataSet[@"_상품명"] sizeWithFont:[UIFont systemFontOfSize:15]
                                            constrainedToSize:CGSizeMake(250, 999)
                                                lineBreakMode:NSLineBreakByTruncatingTail];
            
            if (labelSize.height >= 30) {
                
                [dataSet insertObject:@"38"
                               forKey:@"_상품명높이"
                              atIndex:0];
            }
        }
        else {
            
            CGSize labelSize = [dataSet[@"상품명"] sizeWithFont:[UIFont systemFontOfSize:15]
                                           constrainedToSize:CGSizeMake(250, 999)
                                               lineBreakMode:NSLineBreakByTruncatingTail];
            
            if (labelSize.height >= 30) {
                
                [dataSet insertObject:@"38"
                               forKey:@"_상품명높이"
                              atIndex:0];
            }
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"신규금액"]]]
                       forKey:@"_가입금액"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"계약기간"]]
                       forKey:@"_가입기간"
                      atIndex:0];
        
        if ([dataSet[@"지급주기"] isEqualToString:@"0"]) {
            
            [dataSet insertObject:@"만기지급"
                           forKey:@"_지급주기"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"지급주기"]]
                           forKey:@"_지급주기"
                          atIndex:0];
        }
        
        if ([dataSet[@"이자지급방법"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"이자지급식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        else if ([dataSet[@"이자지급방법"] isEqualToString:@"2"]) {
            
            [dataSet insertObject:@"만기일시복리식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"만기일시지급식"
                           forKey:@"_이자지급방법"
                          atIndex:0];
        }
        
        if ([dataSet[@"자동이체여부"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"신청"
                           forKey:@"_자동이체신청여부"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"미신청"
                           forKey:@"_자동이체신청여부"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"자동이체금액"]]]
                       forKey:@"_자동이체금액"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@(%@)", dataSet[@"등록직원명"], dataSet[@"등록지점명"]]
                       forKey:@"_상담직원"
                      atIndex:0];
        
        [dataSet insertObject:[SHBUtility getDateWithDash:dataSet[@"종료일자"]]
                       forKey:@"_유효기간"
                      atIndex:0];
        
        CGSize labelSize = [dataSet[@"E간편해지상품명"] sizeWithFont:[UIFont systemFontOfSize:15]
                                               constrainedToSize:CGSizeMake(250, 999)
                                                   lineBreakMode:NSLineBreakByTruncatingTail];
        
        if (labelSize.height >= 30) {
            
            [dataSet insertObject:@"38"
                           forKey:@"_E간편해지상품명높이"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"E간편해지잔액"]]]
                       forKey:@"_E간편해지잔액"
                      atIndex:0];
        
        if ([dataSet[@"E간편해지만기일자"] length] == 8) {
            
            [dataSet insertObject:[NSString stringWithFormat:@"%@.%@.%@",
                                   [dataSet[@"E간편해지만기일자"] substringWithRange:NSMakeRange(0, 4)],
                                   [dataSet[@"E간편해지만기일자"] substringWithRange:NSMakeRange(4, 2)],
                                   [dataSet[@"E간편해지만기일자"] substringWithRange:NSMakeRange(6, 2)]]
                           forKey:@"_E간편해지만기일자"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:dataSet[@"E간편해지만기일자"]
                           forKey:@"_E간편해지만기일자"
                          atIndex:0];
        }
    }
}

- (void)setD6170Data:(NSMutableArray *)array
{
    // 펀드맞춤설계서
    
    for (SHBDataSet *dataSet in array) {
        
        [dataSet insertObject:@"D6170"
                       forKey:@"serviceCode"
                      atIndex:0];
        
        if ([dataSet[@"스마트업무구분"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"영업점상담후 펀드맞춤설계서"
                           forKey:@"_설계서명"
                          atIndex:0];
        }
        else if ([dataSet[@"스마트업무구분"] isEqualToString:@"2"]) {
            
            [dataSet insertObject:@"투자자성향별 펀드맞춤설계서"
                           forKey:@"_설계서명"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"펀드맞춤설계서"
                           forKey:@"_설계서명"
                          atIndex:0];
        }
        
        if ([dataSet[@"고객투자자성향등급"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"1등급 : 공격투자형"
                           forKey:@"_투자성향"
                          atIndex:0];
        }
        else if ([dataSet[@"고객투자자성향등급"] isEqualToString:@"2"]) {
            
            [dataSet insertObject:@"2등급 : 적극투자형"
                           forKey:@"_투자성향"
                          atIndex:0];
        }
        else if ([dataSet[@"고객투자자성향등급"] isEqualToString:@"3"]) {
            
            [dataSet insertObject:@"3등급 : 위험중립형"
                           forKey:@"_투자성향"
                          atIndex:0];
        }
        else if ([dataSet[@"고객투자자성향등급"] isEqualToString:@"4"]) {
            
            [dataSet insertObject:@"4등급 : 안정추구형"
                           forKey:@"_투자성향"
                          atIndex:0];
        }
        else if ([dataSet[@"고객투자자성향등급"] isEqualToString:@"5"]) {
            
            [dataSet insertObject:@"5등급 : 안정형"
                           forKey:@"_투자성향"
                          atIndex:0];
        }
        
        if ([dataSet[@"적립방법"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"임의식"
                           forKey:@"_적립방식"
                          atIndex:0];
        }
        else if ([dataSet[@"적립방법"] isEqualToString:@"2"]) {
            
            [dataSet insertObject:@"적립식"
                           forKey:@"_적립방식"
                          atIndex:0];
        }
        else if ([dataSet[@"적립방법"] isEqualToString:@"3"]) {
            
            [dataSet insertObject:@"거치식"
                           forKey:@"_적립방식"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@개월", dataSet[@"계약기간"]]
                       forKey:@"_저축기간"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"신규금액"]]]
                       forKey:@"_신규금액"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@%%", dataSet[@"목표수익률"]]
                       forKey:@"_목표수익률"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@%%", dataSet[@"위험수익률"]]
                       forKey:@"_위험수익률"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@일", dataSet[@"정기수익률발송일"]]
                       forKey:@"_정기수익률"
                      atIndex:0];
        
        if ([dataSet[@"자동이체여부"] isEqualToString:@"1"]) {
            
            [dataSet insertObject:@"신청"
                           forKey:@"_자동이체"
                          atIndex:0];
        }
        else {
            
            [dataSet insertObject:@"미신청"
                           forKey:@"_자동이체"
                          atIndex:0];
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dataSet[@"자동이체금액"]]]
                       forKey:@"_자동이체금액"
                      atIndex:0];
        
        [dataSet insertObject:[NSString stringWithFormat:@"%@ %@(%@)", dataSet[@"직급"], dataSet[@"등록직원명"], dataSet[@"등록지점명"]]
                       forKey:@"_상담직원"
                      atIndex:0];
        
        [dataSet insertObject:[SHBUtility getDateWithDash:dataSet[@"종료일자"]]
                       forKey:@"_설계서유효기간"
                      atIndex:0];
    }
}

- (void)newProductJoin
{
    // SHBEasyCloseCompleteViewController, SHBNoticeSmartNewViewController 동일하게 수정 필요
    
    if ([_selectDic[@"인터넷신규여부"] isEqualToString:@"1"] && [_selectDic[@"모바일신규여부"] isEqualToString:@"0"]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"선택하신 상품은 인터넷뱅킹에서만 가능한 상품입니다."];
        return;
    }
    
    if ([_selectDic[@"일인일계좌가입여부"] isEqualToString:@"1"]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"해당 상품은 1인 1계좌만 가입 가능합니다. 기 가입여부를 확인하세요.\n※ 만기일자 이후 또는 기 가입계좌 해지 후 실행하시기 바랍니다."];
        return;
    }
    
    if ([_selectDic[@"상품코드"] length] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신한S뱅크에서 미판매중인 상품입니다."];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                               @"productCode" : [SHBUtility nilToString:_selectDic[@"상품코드"]],
                                                                               @"recStaffNo" : [SHBUtility nilToString:_selectDic[@"등록직원"]],
                                                                               @"_등록직원" : [SHBUtility nilToString:_selectDic[@"등록직원"]],
                                                                               @"_등록직원명" : [SHBUtility nilToString:_selectDic[@"등록직원명"]],
                                                                               @"_등록지점" : [SHBUtility nilToString:_selectDic[@"등록지점"]],
                                                                               @"_등록지점명" : [SHBUtility nilToString:_selectDic[@"등록지점명"]],
                                                                               @"_스마트신규금액" : [SHBUtility nilToString:_selectDic[@"신규금액"]],
                                                                               @"_스마트신규이자지급방법" : [SHBUtility nilToString:_selectDic[@"이자지급방법"]],
                                                                               @"_스마트신규지급주기" : [SHBUtility nilToString:_selectDic[@"지급주기"]]
                                                                               }];
    
    if ([_selectDic[@"상품코드"] hasPrefix:@"209"]) {
        
        // ELD 상품
        
        SHBELD_BA17_3ViewController *viewController = [[[SHBELD_BA17_3ViewController alloc] initWithNibName:@"SHBELD_BA17_3ViewController" bundle:nil] autorelease];
        
        [viewController executeWithDic:dic];
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        return;
    }
    
    SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
    
    viewController.mdicPushInfo = dic;
    viewController.dicSmartNewData = _selectDic;
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)easyClose
{
    // SHBNoticeSmartNewViewController 동일하게 수정 필요
    
    SHBEasyCloseViewController *viewController = [[[SHBEasyCloseViewController alloc] initWithNibName:@"SHBEasyCloseViewController" bundle:nil] autorelease];
    
    viewController.needsCert = YES;
    viewController.smartNewDic = _selectDic;
    viewController.data = @{
                            @"계좌번호" : [SHBUtility nilToString:_selectDic[@"E간편해지계좌번호"]],
                            @"_계좌번호" : [SHBUtility nilToString:_selectDic[@"E간편해지계좌번호"]],
                            @"_과목명" : [SHBUtility nilToString:_selectDic[@"E간편해지상품명"]],
                            @"계좌번호" : [SHBUtility nilToString:_selectDic[@"E간편해지계좌번호"]]
                            };
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - UIButton

- (IBAction)moveToNewProduct:(id)sender
{
    SHBNewProductListViewController *viewController = [[[SHBNewProductListViewController alloc] initWithNibName:@"SHBNewProductListViewController" bundle:nil] autorelease];
    
    [self.navigationController pushFadeViewController:viewController];
}

#pragma mark - UITableView Button

- (void)tableViewJoinPressed:(UIButton *)sender
{
    self.selectDic = self.dataList[sender.tag];
    
    // 하단 내용 수정시 SHBNoticeSmartNewViewController 동일하게 수정 필요
    
    if ([_selectDic[@"serviceCode"] isEqualToString:@"D3249"]) {
        
        // 금리우대설계서
        
        if ([_selectDic[@"상품코드"] length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"신한S뱅크에서 미판매중인 상품입니다."];
            return;
        }
        
        if (![_selectDic[@"상품코드"] isEqualToString:@"200009201"] && // MINT(민트) 정기예금 (영업점용)
            ![_selectDic[@"상품코드"] isEqualToString:@"200013601"] && // S드림 정기예금
            ![_selectDic[@"상품코드"] isEqualToString:@"200003401"] && // Tops 회정정기예금
            ![_selectDic[@"상품코드"] isEqualToString:@"200009301"] )  // 신한그린愛너지 정기예금
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                             message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                            delegate:self
                                                   cancelButtonTitle:@"확인"
                                                   otherButtonTitles:@"업데이트", nil] autorelease];
            
            [alert setTag:4321];
            [alert show];
            
            return;
        }
        
        self.service = nil;
        self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_INFO_SERVICE
                                                           viewController:self] autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                                                          @"상품코드" : _selectDic[@"상품코드"],
                                                                          }];
        [self.service start];
    }
    else if ([_selectDic[@"serviceCode"] isEqualToString:@"D3251"]) {
        
        if ([_selectDic[@"스마트신규구분"] isEqualToString:@"1"]) {
            
            // 예적금맞춤설계서
            
            [self newProductJoin];
        }
        else if ([_selectDic[@"스마트신규구분"] isEqualToString:@"2"]) {
            
            // 만기후 맞춤설계서
            
            if ([_selectDic[@"E간편해지계좌상태"] isEqualToString:@"1"]) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeTwoButton
                                   tag:101010
                                 title:@""
                               message:@"만기경과 상품은 이미 해지된 상태입니다. 영업점에서 추천드린 상품 가입 화면으로 이동하시겠습니까?"];
                return;
            }
            
            if ([_selectDic[@"일인일계좌가입여부"] isEqualToString:@"1"]) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:202020
                                 title:@""
                               message:@"해당 상품은 1인 1계좌만 가입 가능합니다. 기 가입여부를 확인하세요.\n※ 만기일자 이후 또는 기 가입계좌 해지 후 실행하시기 바랍니다."];
                return;
            }
            
            [self easyClose];
        }
    }
    else if ([_selectDic[@"serviceCode"] isEqualToString:@"D6170"]) {
        
        NSString *parm = [NSString stringWithFormat:@"&cusNum=%@&regNum=%@", _selectDic[@"고객번호"], _selectDic[@"등록순번"]];
        
        [[SHBPushInfo instance] requestOpenURL:@"smartfundcenter://F5008" Parm:parm];
    }
}

#pragma mark - Orchetsra Native

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    // 하단 내용 수정시 SHBNoticeSmartNewViewController 동일하게 수정 필요
    
    if (self.service.serviceId == kD3251Id) {
        
        [self setD3251Data:[aDataSet arrayWithForKey:@"등록내역"]];
    }
    else if (self.service.serviceId == SMART_NEW_LIST) {
        
        NSArray *array = [aDataSet arrayWithForKeyPath:@"data"];
        
        for (OFDataSet *dataSet in array) {
            
            if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D3249"]) {
                
                [self setD3249Data:[dataSet arrayWithForKey:@"등록내역"]];
            }
            else if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D3251"]) {
                
                [self setD3251Data:[dataSet arrayWithForKey:@"등록내역"]];
            }
            else if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D6170"]) {
                
                [self setD6170Data:[dataSet arrayWithForKey:@"LIST"]];
            }
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    // 하단 내용 수정시 SHBNoticeSmartNewViewController 동일하게 수정 필요
    
    if (self.service.serviceId == kD3251Id) {
        
        // 예적금맞춤설계서, 만기후 맞춤설계서
        
        if (_isCoupon) {
            
            self.dataList = [aDataSet arrayWithForKey:@"등록내역"];
            
            if ([self.dataList count] == 0) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:333
                                 title:@""
                               message:@"유효한 스마트신규 추천내역이 없습니다."];
                
                return NO;
            }
            
            [self.dataTable reloadData];
        }
    }
    else if (self.service.serviceId == SMART_NEW_LIST) {
        
        NSArray *array = [aDataSet arrayWithForKeyPath:@"data"];
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        
        for (OFDataSet *dataSet in array) {
            
            if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D3249"]) {
                
                [tmpArr addObjectsFromArray:[dataSet arrayWithForKey:@"등록내역"]];
            }
            else if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D3251"]) {
                
                [tmpArr addObjectsFromArray:[dataSet arrayWithForKey:@"등록내역"]];
            }
            else if ([dataSet[@"COM_SVC_CODE"] isEqualToString:@"D6170"]) {
                
                NSMutableArray *D6170Arr = [NSMutableArray array];
                
                for (NSDictionary *dic in [dataSet arrayWithForKey:@"LIST"]) {
                    
                    if ([dic[@"처리상태"] isEqualToString:@"1"] && ![dic[@"등록순번"] isEqualToString:@"0"]) {
                        
                        [D6170Arr addObject:dic];
                    }
                }
                
                [tmpArr addObjectsFromArray:D6170Arr];
            }
        }
        
        self.dataList = [NSArray arrayWithArray:tmpArr];
        
        if ([self.dataList count] == 0) {
            
            [_noDataView setFrame:_dataTable.frame];
            [self.view addSubview:_noDataView];
            [_dataTable setHidden:YES];
        }
        
        [self.dataTable reloadData];
    }
    else if (self.service.serviceId == COUPON_INFO_SERVICE) {
        
        [_selectDic setObject:@"1" forKey:@"영업점상품여부"];
        [_selectDic setObject:[NSString stringWithFormat:@"%.3lf", [_selectDic[@"승인이율"] doubleValue]]
                       forKey:@"적용금리"];
        
        SHBNewProductInfoViewController *viewController = [[[SHBNewProductInfoViewController alloc] initWithNibName:@"SHBNewProductInfoViewController" bundle:nil] autorelease];
        
        viewController.dicReceiveData = aDataSet;
        viewController.dicSelectedData = _selectDic;
      	[self checkLoginBeforePushViewController:viewController animated:YES];
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 333)
    {
        [self.navigationController fadePopViewController];
    }
    
    if (alertView.tag == 4321 && buttonIndex != alertView.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
    }
    
    if (alertView.tag == 101010 && buttonIndex == alertView.cancelButtonIndex) {
        
        [self newProductJoin];
    }
    else if (alertView.tag == 202020) {
        
        [self easyClose];
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    if ([cellDataSet[@"serviceCode"] isEqualToString:@"D3249"]) {
        
        // 금리우대설계서
        
        if (cellDataSet[@"_상품명높이"]) {
            
            return 300 + [cellDataSet[@"_상품명높이"] floatValue] - 16;
        }
        
        return 300;
    }
    else if ([cellDataSet[@"serviceCode"] isEqualToString:@"D3251"]) {
        
        if ([cellDataSet[@"스마트신규구분"] isEqualToString:@"1"]) {
            
            // 예적금맞춤설계서
            
            CGFloat height = 0;
            
            if (_isCoupon) {
                
                // 예적금맞춤설계서 쿠폰함에서 온 경우
                
                height -= 20;
            }
            /*
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                // ELD 예적금맞춤설계서
                
                if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                    
                    return 292 - height;
                }
                
                return 317 - height;
            }
            */
            
            if (cellDataSet[@"_상품명높이"]) {
                
                height += [cellDataSet[@"_상품명높이"] floatValue] - 16;
            }
            
            if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                
                height -= 25;
            }
            
            return 300 + height;
        }
        else if ([cellDataSet[@"스마트신규구분"] isEqualToString:@"2"]) {
            
            // 만기후 맞춤설계서
            /*
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                // ELD 만기후 맞춤설계서
                
                if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                    
                    return 417;
                }
                
                return 442;
            }
            */
            CGFloat productHeight = 0;
            
            if (cellDataSet[@"_E간편해지상품명높이"]) {
                
                productHeight += [cellDataSet[@"_E간편해지상품명높이"] floatValue] - 16;
            }
            
            if (cellDataSet[@"_상품명높이"]) {
                
                productHeight += [cellDataSet[@"_상품명높이"] floatValue] - 16;
            }
            
            if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                
                productHeight -= 25;
            }
            
            return 425 + productHeight;
        }
    }
    else if ([cellDataSet[@"serviceCode"] isEqualToString:@"D6170"]) {
        
        // 펀드맞춤설계서
        
        return 374;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    if ([cellDataSet[@"serviceCode"] isEqualToString:@"D3249"]) {
        
        // 금리우대설계서
        
        SHBSmartNewListCell *cell = (SHBSmartNewListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell"];
        
        if (!cell) {
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell"
                                                           owner:self options:nil];
            
            cell = (SHBSmartNewListCell *)array[0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
        
        if (cellDataSet[@"_상품명높이"]) {
            
            CGFloat productHeight = [cellDataSet[@"_상품명높이"] floatValue];
            
            FrameResize(cell.productName, width(cell.productName), productHeight);
            FrameReposition(cell.view01, left(cell.view01), top(cell.view01) + productHeight - 16);
        }
        
        [cell.productName setText:cellDataSet[@"상품명"]];
        
        [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
        [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
        
        [cell.joinBtn setTag:indexPath.row];
        [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if ([cellDataSet[@"serviceCode"] isEqualToString:@"D3251"]) {
        
        if ([cellDataSet[@"스마트신규구분"] isEqualToString:@"1"]) {
            /*
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                // ELD 예적금맞춤설계서
                
                SHBSmartNewListCell5 *cell = (SHBSmartNewListCell5 *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell5"];
                
                if (!cell) {
                    
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell5"
                                                                   owner:self options:nil];
                    
                    cell = (SHBSmartNewListCell5 *)array[0];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
                }
                
                [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
                
                [cell.view01 setHidden:NO];
                
                if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                    
                    [cell.view01 setHidden:YES];
                    
                    FrameResize(cell.smartNewView, width(cell.smartNewView), height(cell.smartNewView) - 25);
                }
                
                if (_isCoupon) {
                    
                    [cell.smartNewTitle setHidden:YES];
                    
                    CGRect frame = cell.smartNewView.frame;
                    frame.origin.y = 10;
                    [cell.smartNewView setFrame:frame];
                }
                
                [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
                [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
                
                [cell.joinBtn setTag:indexPath.row];
                [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            */
            // 예적금맞춤설계서
            
            SHBSmartNewListCell2 *cell = (SHBSmartNewListCell2 *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell2"];
            
            if (!cell) {
                
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell2"
                                                               owner:self options:nil];
                
                cell = (SHBSmartNewListCell2 *)array[0];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
            }
            
            [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
            
            if (cellDataSet[@"_상품명높이"]) {
                
                CGFloat productHeight = [cellDataSet[@"_상품명높이"] floatValue];
                
                FrameResize(cell.productName, width(cell.productName), productHeight);
                FrameResize(cell.smartNewView, width(cell.smartNewView), height(cell.smartNewView) + productHeight - 16);
            }
            
            [cell.view02 setHidden:NO];
            
            if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                
                [cell.view02 setHidden:YES];
                
                FrameResize(cell.smartNewView, width(cell.smartNewView), height(cell.smartNewView) - 25);
                FrameReposition(cell.view01, left(cell.view01), top(cell.view01) + 25);
            }
            
            if (_isCoupon) {
                
                [cell.smartNewTitle setHidden:YES];
                
                CGRect frame = cell.smartNewView.frame;
                frame.origin.y = 10;
                [cell.smartNewView setFrame:frame];
            }
            
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                [cell.productName setText:cellDataSet[@"_상품명"]];
            }
            else {
                
                [cell.productName setText:cellDataSet[@"상품명"]];
            }
            
            [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
            [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
            
            [cell.joinBtn setTag:indexPath.row];
            [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else if ([cellDataSet[@"스마트신규구분"] isEqualToString:@"2"]) {
            /*
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                // ELD 만기후 맞춤설계서
                
                SHBSmartNewListCell6 *cell = (SHBSmartNewListCell6 *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell6"];
                
                if (!cell) {
                    
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell6"
                                                                   owner:self options:nil];
                    
                    cell = (SHBSmartNewListCell6 *)array[0];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
                }
                
                [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
                
                [cell.view01 setHidden:NO];
                
                if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                    
                    [cell.view01 setHidden:YES];
                    
                    FrameReposition(cell.view02, 0, top(cell.view01));
                }
                
                [cell.easyCloseProductName setText:cellDataSet[@"E간편해지상품명"]];
                
                [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
                [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
                
                [cell.joinBtn setTag:indexPath.row];
                [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            */
            // 만기후 맞춤설계서
            
            SHBSmartNewListCell3 *cell = (SHBSmartNewListCell3 *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell3"];
            
            if (!cell) {
                
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell3"
                                                               owner:self options:nil];
                
                cell = (SHBSmartNewListCell3 *)array[0];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
            }
            
            [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
            
            if (cellDataSet[@"_E간편해지상품명높이"]) {
                
                CGFloat productHeight = [cellDataSet[@"_E간편해지상품명높이"] floatValue];
                
                FrameResize(cell.easyCloseProductName, width(cell.easyCloseProductName), productHeight);
                FrameReposition(cell.view01, left(cell.view01), top(cell.view01) + productHeight - 16);
            }
            
            if (cellDataSet[@"_상품명높이"]) {
                
                CGFloat productHeight = [cellDataSet[@"_상품명높이"] floatValue];
                
                FrameResize(cell.productName, width(cell.productName), productHeight);
                FrameResize(cell.view01, width(cell.view01), height(cell.view01) + productHeight - 16);
            }
            
            [cell.view02 setHidden:NO];
            
            if ([cellDataSet[@"계약기간"] isEqualToString:@"0"]) {
                
                [cell.view02 setHidden:YES];
                
                FrameResize(cell.view01, width(cell.view01), height(cell.view01) - 25);
                FrameReposition(cell.view03, left(cell.view03), top(cell.view03) + 25);
            }
            
            [cell.easyCloseProductName setText:cellDataSet[@"E간편해지상품명"]];
            
            if ([cellDataSet[@"상품코드"] hasPrefix:@"209"]) {
                
                [cell.productName setText:cellDataSet[@"_상품명"]];
            }
            else {
                
                [cell.productName setText:cellDataSet[@"상품명"]];
            }
            
            [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
            [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
            
            [cell.joinBtn setTag:indexPath.row];
            [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    else if ([cellDataSet[@"serviceCode"] isEqualToString:@"D6170"]) {
        
        // 펀드맞춤설계서
        
        SHBSmartNewListCell4 *cell = (SHBSmartNewListCell4 *)[tableView dequeueReusableCellWithIdentifier:@"SHBSmartNewListCell4"];
        
        if (!cell) {
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSmartNewListCell4"
                                                           owner:self options:nil];
            
            cell = (SHBSmartNewListCell4 *)array[0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
        
        [cell.productName initFrame:cell.productName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
        [cell.productName setCaptionText:cellDataSet[@"_투자성향"]];
        
        [cell.staff initFrame:cell.staff.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
        [cell.staff setCaptionText:cellDataSet[@"_상담직원"]];
        
        [cell.joinBtn setTag:indexPath.row];
        [cell.joinBtn addTarget:self action:@selector(tableViewJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
