//
//  SHBExRateRequestViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExRateRequestViewController.h"
#import "SHBExRateDetailViewController.h"
#import "SHBExchangeService.h"
//#import "SHBListPopupView.h" // list popup
#import "SHBExRatePopupView.h"

@interface SHBExRateRequestViewController () <SHBPopupViewDelegate, SHBExRatePopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *inquiryCountList; // 회차
//@property (retain, nonatomic) SHBTextField *currentTextField; // 선택한 textField

@property (retain, nonatomic) SHBExRatePopupView *countPopupView; // 회차

@end

@implementation SHBExRateRequestViewController
@synthesize widgetBtn;

#pragma mark - Button
- (IBAction)inquiryCountBtn:(UIButton *)sender
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];

    int inputDate = [[_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
	int currntDate = [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
	if (inputDate > currntDate) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"해당일에 대한 고시회차가 존재하지 않습니다."];
        return;
    }

    // F3740 전문호출
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"조회일자" : [_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"고시구분" : @"3",
                            @"출력방향" : @"2",
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3740_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];

    
    
//    if ([_inquiryCountList count] == 0) {
//        
//        // F3740 전문호출
//        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
//                                @{
//                                @"조회일자" : [_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
//                                @"고시구분" : @"3",
//                                @"출력방향" : @"2",
//                                }];
//        
//        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3740_SERVICE
//                                                       viewController:self] autorelease];
//        self.service.requestData = aDataSet;
//        [self.service start];
//
//    } else {
////        SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"회차"
////          SHBExRatePopupView *popupView = [[[SHBExRatePopupView alloc] initWithTitle:@"회차"
////                                                                       options:_inquiryCountList
////                                                                       CellNib:@"SHBExRatePopupCell"
////                                                                         CellH:32
////                                                                   CellDispCnt:5
////                                                                    CellOptCnt:2] autorelease];
////        [popupView setDelegate:self];
////        [popupView showInView:self.navigationController.view animated:YES];
//        
//        self.countPopupView = [[[SHBExRatePopupView alloc] initWithTitle:@"회차"
//                                                              SubViewHeight:160] autorelease];
//        [_countPopupView.tableView setDataSource:self];
//        [_countPopupView.tableView setDelegate:self];
//        _countPopupView.sorTDelegate = self;
//        
//        [_countPopupView showInView:self.navigationController.view animated:YES];
//
//    }
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
//    if ([_txtInDate.text length] == 0 || [_txtInDate.text length] != 8) {
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"조회기준일을 입력하세요."];
//        return;
//    }

    // 조회기준일
    if ([_txtInDate.textField.text length] == 0 || [_txtInDate.textField.text length] != 10) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"조회기준일을 입력하여 주십시오."];
        return;
    }

    int inputDate = [[_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
	int currntDate = [[[SHBAppInfo sharedSHBAppInfo].tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
	if (inputDate > currntDate) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"당일 이후 고시일자로 조회할 수 없습니다."];
        return;
    }
    
    NSString *tempInquiryCount;
    
    if ([_inquiryCountBtn.titleLabel.text isEqualToString:@"최종회차"]) {
        tempInquiryCount = @"0";
    } else {
        tempInquiryCount = _inquiryCountBtn.titleLabel.text;
    }
    // F3730 전문호출
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"조회일자" : [_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"고시회차" : tempInquiryCount,
                            @"통화코드" : @"",
                            @"reservationField1" : @"코드별환율조회",
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3730_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];

}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_inquiryCountList count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHBExRatePopupCell"];
    if (cell ==  nil) {
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"SHBExRatePopupCell" owner:self options:nil];
		
		//xib파일의 객체중에 #번째 객체를 셋팅
//		if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"]){
//			cell = [cellArray objectAtIndex:1];
//		}else{
			cell = [cellArray objectAtIndex:0];
//		}
		
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    
    
//     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHBExRatePopupCell"];
//    
//    if (cell == nil) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBExRatePopupCell"
//                                                       owner:self options:nil];
//        cell = (NSClassFromString(@"SHBExRatePopupCell") *)array[0];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
    
    OFDataSet *cellDataSet = _inquiryCountList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    self.selectCouponDic = _couponList[indexPath.row];
    
    [_countPopupView close];
//    [_coupon setText:[NSString stringWithFormat:@"%@%% 우대", _selectCouponDic[@"환전우대율"]]];
    [_inquiryCountBtn setTitle:_inquiryCountList[indexPath.row][@"고시회차"] forState:UIControlStateNormal];

}

- (void)dealloc
{
    self.detailData = nil;
    self.inquiryCountList = nil;
    [widgetBtn release];
    [_txtInDate release];
    
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    startTextFieldTag = 222000;
    endTextFieldTag = 222000;

    self.title = @"환율조회";
    
    self.strBackButtonTitle = @"환율조회 입력";
    
    [self.binder bind:self dataSet:_detailData];
    self.inquiryCountList = [NSMutableArray array];

//    [_txtInDate setAccDelegate:self];
    [_txtInDate initFrame:_txtInDate.frame];
    _txtInDate.textField.font = [UIFont systemFontOfSize:14];
    _txtInDate.textField.textAlignment = UITextAlignmentLeft;
    _txtInDate.delegate = self;
    [_txtInDate selectDate:[NSDate date] animated:NO];

    
    //NSLog(@"aaaa:%@",AppInfo.tran_Date);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerWidget:(id)sender
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
    {
        NSString *msg = _detailData[@"1"];
        msg = [msg stringByReplacingOccurrencesOfString:_detailData[@"3"] withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"(" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@")" withString:@""];
        msg = [NSString stringWithFormat:@"홈 화면에 %@\n아이콘이 생성됩니다.\n등록 하시겠습니까?",msg];
        [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1562 title:@"" message:msg];
        return;
    }else
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"iOS 5.0 이상 버젼에서\n등록 가능 합니다."];
    }
}

#pragma mark - UITextField

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.currentTextField = (SHBTextField *)textField;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
//    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    if (textField == _txtInDate) {
//        if ([number length] <= 8) {
//            [textField setText:number];
//        }
//        
//        return NO;
//    }
    
    return YES;
}

//#pragma mark - SHBTextField
//
//- (void)didPrevButtonTouch
//{
//	[_currentTextField resignFirstResponder];
//}
//
//- (void)didNextButtonTouch
//{
//	[_currentTextField resignFirstResponder];
//}
//
//- (void)didCompleteButtonTouch
//{
//	[_currentTextField resignFirstResponder];
//}

#pragma mark - Delegate : SHBDateFieldDelegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
{
	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
    [dateField setDate:date];
}

- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date
{
	NSLog(@"=====>>>>>>> [11] DatePicker 데이터 변경시");
}

- (void)didPrevButtonTouchWithdateField:(SHBDateField*)dateField
{
	NSLog(@"=====>>>>>>> [12] DatePicker 이전버튼");
}

- (void)didNextButtonTouchWithdateField:(SHBDateField*)dateField
{
	NSLog(@"=====>>>>>>> [13] DatePicker 다음버튼");
}

- (void)currentDateField:(SHBDateField *)dateField
{
    // 현재 올라와 있는 입력창을 내려준다.
    [self.curTextField resignFirstResponder];
    
	NSLog(@"=====>>>>>>> [14] 현재 데이트 피커 : 데이트 피커의 위치이동이 필요할시 작성");
    
}

- (void)sortProcess
{
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.inquiryCountList] autorelease];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    for (int i = [tempArray count] - 1; i >=0; i--)
    {
        [tempList addObject:[tempArray objectAtIndex:i]];
    }
    
    self.inquiryCountList = tempList;

//    NSMutableArray *tempSortArray = [[[NSMutableArray alloc] initWithArray:self.inquiryCountList] autorelease];
//    
////    if(sender.isSelected)
////    {
////        sender.selected = NO;
////    }
////    else
////    {
////        sender.selected = YES;
////    }
//    
//    NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"고시회차" ascending:NO];
//    [tempSortArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
//    [sortOrder release];
//
//    NSMutableArray *tempSortList = [[NSMutableArray alloc] init];
//
//    for (int i = [tempSortArray count] - 1; i >=0; i--)
//    {
//        [tempSortList addObject:[tempSortArray objectAtIndex:i]];
//    }
//
//    self.inquiryCountList = tempSortList;

    [_countPopupView.tableView reloadData];
}


#pragma mark - SHBListPopupView

//- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
//- (void)listPopupView:(SHBExRatePopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
//{
//    [_inquiryCountBtn setTitle:_inquiryCountList[anIndex][@"고시회차"] forState:UIControlStateNormal];
//}
//
//- (void)listPopupViewDidCancel
//{
//    
//}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (self.service.serviceId) {
        case EXCHANGE_F3730_SERVICE:
        {
            NSLog(@"aDataSet : %@", aDataSet);
            //NSLog(@"detailData : %@", self.dataList);
            self.dataList = [aDataSet arrayWithForKeyPath:@"조회내역.vector.data"];
            
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
            NSDictionary *item = [[NSDictionary alloc] init];
            
            for (int i = 0; i < [tempArray count]; i++)
            {
                item = [tempArray objectAtIndex:i];
                if ([[item objectForKey:@"통화CODE"] isEqualToString:[self.detailData objectForKey:@"3"]]) {
                    break;
                }
            }

            [item setValue:[self.detailData objectForKey:@"1"] forKey:@"통화목록"];
            [item setValue:aDataSet[@"고시일자"] forKey:@"고시일자"];
            [item setValue:[NSString stringWithFormat:@"%@/%@회차", aDataSet[@"고시시간"], aDataSet [@"고시회차"]] forKey:@"고시시간회차"];
            [item setValue:[NSString stringWithFormat:@"%@원", item[@"전신환매도환율"]] forKey:@"전신환매도환율원"];
            [item setValue:[NSString stringWithFormat:@"%@원", item[@"전신환매입환율"]] forKey:@"전신환매입환율원"];
            [item setValue:[NSString stringWithFormat:@"%@원", item[@"지폐매도환율"]] forKey:@"지폐매도환율원"];
            [item setValue:[NSString stringWithFormat:@"%@원", item[@"지폐매입환율"]] forKey:@"지폐매입환율원"];
            [item setValue:[NSString stringWithFormat:@"%@원", item[@"매매기준환율"]] forKey:@"매매기준환율원"];
            [item setValue:[NSString stringWithFormat:@"%@", item[@"대미환산환율"]] forKey:@"대미환산환율원"];
            
            SHBExRateDetailViewController *viewController = [[SHBExRateDetailViewController alloc] initWithNibName:@"SHBExRateDetailViewController" bundle:nil];
            [viewController setDetailData:[NSMutableDictionary dictionaryWithDictionary:item]];
            
//            [self checkLoginBeforePushViewController:viewController animated:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            [item release];
            [viewController release];
        }
            break;
        case EXCHANGE_F3740_SERVICE:
        {
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKeyPath:@"조회내역.vector.data"]) {
                [dic setObject:[NSString stringWithFormat:@"%@회차", dic[@"고시회차"]]
                        forKey:@"1"];
                [dic setObject:[NSString stringWithFormat:@"%@", dic[@"고시시간"]]
                        forKey:@"2"];
            }

            self.dataList = [aDataSet arrayWithForKeyPath:@"조회내역.vector.data"];

            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
            NSMutableArray *tempList = [[NSMutableArray alloc] init];
            
            for (int i = [tempArray count] - 1; i >=0; i--)
            {
                [tempList addObject:[tempArray objectAtIndex:i]];
            }

            self.inquiryCountList = tempList;
            
            if ([_inquiryCountList count] == 0) {
                // 환전통화 가져오기 에러
                
                if (![SHBUtility isOPDate:[_txtInDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"해당일은 영업일이 아닙니다.(토,공휴일)"];
                } else {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"해당일에 대한 고시회차가 존재하지 않습니다."];
                }
                
                return NO;
            }
            
//            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"회차"
//            SHBExRatePopupView *popupView = [[[SHBExRatePopupView alloc] initWithTitle:@"회차"
//                                                                           options:_inquiryCountList
//                                                                           CellNib:@"SHBExRatePopupCell"
//                                                                             CellH:32
//                                                                       CellDispCnt:5
//                                                                        CellOptCnt:2] autorelease];
//            [popupView setDelegate:self];
//            [popupView showInView:self.navigationController.view animated:YES];
            
            
            self.countPopupView = [[[SHBExRatePopupView alloc] initWithTitle:@"회차"
                                                               SubViewHeight:160] autorelease];
            [_countPopupView.tableView setDataSource:self];
            [_countPopupView.tableView setDelegate:self];
            _countPopupView.sorTDelegate = self;
            
            [_countPopupView showInView:self.navigationController.view animated:YES];

            
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	Debug(@"executeWithDic : %@",mDic);
    if (self.isPushAndScheme && mDic)
    {
        NSString *tmpStr = mDic[@"speedIndex"];
        NSArray *tmpArray = [tmpStr componentsSeparatedByString:@","];
        if ([tmpArray count] == 2)
        {
            NSString *tmpStr = tmpArray[0];
            tmpStr = [tmpStr stringByRemovingPercentEncoding];
            
            OFDataSet *aDataSet = [OFDataSet dictionaryWithDictionary:
                                    @{
                                      @"1" : tmpStr,
                                      @"2" : @"",
                                      @"3" : tmpArray[1],
                                      }];
            
            _detailData = [aDataSet copy];
        
            if ([SHBUtility isFindString:AppInfo.tran_Date find:@"-"])
            {
                AppInfo.tran_Date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                                     
            }
            //NSLog(@"aaaa:%@",_detailData);
            
        }
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // base view 동작 필요한 경우위해 super 호출
    [super alertView:alert clickedButtonAtIndex:buttonIndex];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0 && alert.tag == 1562 && buttonIndex == 0)
    {
        NSString *msg = _detailData[@"1"];
        msg = [msg stringByReplacingOccurrencesOfString:_detailData[@"3"] withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"(" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *nickName = [NSString stringWithFormat:@"S뱅크%@",msg];
        nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        
        NSString *spIdx = [NSString stringWithFormat:@"%@,%@",_detailData[@"1"],_detailData[@"3"]];
        spIdx = [spIdx stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        spIdx = [spIdx stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        spIdx = [spIdx stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        spIdx = [spIdx stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        NSString *argStr = [NSString stringWithFormat:@"screenID=F3730_01&nickName=%@&speedIndex=%@",nickName,spIdx];
        #ifdef DEVELOPER_MODE
                NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"dev-m.shinhan.com", WIDGET_SERVICE_URL,argStr];
        #else
                NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"m.shinhan.com", WIDGET_SERVICE_URL,argStr];
        #endif
        //NSLog(@"aaaa:%@",urlStr);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}
@end
