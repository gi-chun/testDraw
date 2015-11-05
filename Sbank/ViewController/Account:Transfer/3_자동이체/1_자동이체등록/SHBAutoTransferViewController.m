//
//  SHBAutoTransferViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferViewController.h"
#import "SHBAutoTransferInfoViewController.h"
#import "SHBAutoTransferComfirmViewController.h"
#import "SHBAskStaffViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"
#import "SHBDeviceRegistServiceViewController.h"
#import "SHBIdentity2ViewController.h"

@interface SHBAutoTransferViewController () <SHBIdentity2Delegate>
{
    int serviceType;
    NSString *encriptedPW;
    NSString *encriptedInAccNo;
    NSString *encriptedAmount;
    
    NSString *accGbn;       // 확장E2E 구분값
    NSUInteger accIdx;      // 확장E2E 인덱스
    
    int cmsFlag;
    
    NSMutableDictionary *codeDic;
    BOOL isRead1;  // 자동이체안내 버튼
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *encriptedInAccNo;
@property (retain, nonatomic) NSString *encriptedAmount;

@property (retain, nonatomic) NSString *accGbn;
@property (readonly, nonatomic) NSUInteger accIdx;
@property (nonatomic, retain) NSMutableDictionary *codeDic;

- (BOOL)securityCenterCheck;
- (BOOL)isMonthLastDate:(NSString *)aDate;
- (void)defaultValueSetting;
- (BOOL)validationCheck;

@end

@implementation SHBAutoTransferViewController
@synthesize processFlag;
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize codeDic;
@synthesize encriptedInAccNo;
@synthesize encriptedAmount;
@synthesize accGbn;
@synthesize accIdx;


- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
        case 112000:    // 자동이체 안내
        {
            
            isRead1 = YES;
            
            _isInfoBack = YES;
            
            SHBAutoTransferInfoViewController *nextViewController = [[[SHBAutoTransferInfoViewController alloc] initWithNibName:@"SHBAutoTransferInfoViewController" bundle:nil] autorelease];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 112100:    // 출금계좌번호
        {
            serviceType = 0;
            
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountList];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112200:    // 잔액조회
        {
            serviceType = 1;
            
            NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if([strOutAccNo isEqualToString:@"출금계좌정보가 없습니다."])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : strOutAccNo}] autorelease];
            [self.service start];
        }
            break;
        case 112300:    // 입금은행
        {
            serviceType = 2;
            
            _btnSelectBank.selected = YES;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"은행목록" options:AppInfo.codeList.bankList CellNib:@"SHBBankListPopupCell" CellH:32 CellDispCnt:9 CellOptCnt:1];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 112400:    // 본인계좌
        {
            serviceType = 3;
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            //for(NSDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
            //NSLog(@"aaaa:%@",AppInfo.accountD0011);
            for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
            {
//              자동이체의 경우 적금계좌도 보여야함.  NSLog(@"%@", dic);
//                if([dic[@"예금종류"] isEqualToString:@"1"] || [dic[@"예금종류"] isEqualToString:@"2"])
                if([dic[@"입금가능여부"] isEqualToString:@"1"]) // 정상교과장의 요청으로 예금종류 1 인 경우에서 바뀜(2013.04.03)
                {
                    [tableDataArray addObject:@{
                     @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                     @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"]
                     }];
                }
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"본인계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
            
             accGbn = @"MY";
        }
            break;
        case 112401:    // 최근입금계좌
        {
            serviceType = 4;
            accGbn = @"LA";
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2520" viewController: self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }
            break;
        case 112402:    // 자주쓰는계좌
        {
            serviceType = 5;
             accGbn = @"FA";
            
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2210" viewController: self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
            [self.service start];
        }
            break;
        case 112500:    // 이체주기
        {
            serviceType = 10;
            _btnTransferTerm.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"1개월", @"2" : @"01"},
                                     @{@"1" : @"2개월", @"2" : @"02"},
                                     @{@"1" : @"3개월", @"2" : @"03"},
                                     @{@"1" : @"6개월", @"2" : @"06"},
                                     @{@"1" : @"월요일", @"2" : @"91"},
                                     @{@"1" : @"화요일", @"2" : @"92"},
                                     @{@"1" : @"수요일", @"2" : @"93"},
                                     @{@"1" : @"목요일", @"2" : @"94"},
                                     @{@"1" : @"금요일", @"2" : @"95"},
                                     @{@"1" : @"매일", @"2" : @"99"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"이체주기"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:5
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 112600:    // 이체종류
        {
            serviceType = 11;
            _btnTransferType.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"입출금통장간", @"2" : @"05"},
                                     @{@"1" : @"적금/신탁/청약", @"2" : @"01"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"이체종류"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:2
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 112700:    // 12개월
        case 112701:    // 24개월
        case 112702:    // 36개월
        {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            
            if(_startDateField.textField.text == nil || [_startDateField.textField.text isEqualToString:@""])
            {
                [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:1 toDay:0]] animated:NO];

            }
            
            NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
            [comps setMonth:(12 * (([sender tag] % 10) + 1) - 1)];
            
            
            NSDate *startDate = [dateFormatter dateFromString:_startDateField.textField.text];
            
//            if (UIAccessibilityIsVoiceOverRunning())
//            {
//                NSString *tmpStr;
//                tmpStr = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"년" withString:@"."];
//                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"월" withString:@"."];
//                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"일" withString:@""];
//                
//                startDate = [dateFormatter dateFromString:tmpStr];
//            }
            NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:startDate  options:0];
            [_endDateField selectDate:endDate animated:NO];
        }
            break;
        case 112900:    // 휴일이체구분
        {
            serviceType = 12;
            _btnHoliday.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"휴일익일이체", @"2" : @"0"},
                                     @{@"1" : @"휴일전일이체", @"2" : @"1"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"휴일이체구분"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:2
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 113000:    // 말일이체구분
        {
            serviceType = 13;
            _btnLastDay.selected = YES;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                     @{@"1" : @"아니오", @"2" : @"0"},
                                     @{@"1" : @"예", @"2" : @"1"},
                                     ]];
            
            self.dataList = (NSArray *)array;
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"말일이체구분"
                                                                           options:array
                                                                           CellNib:@"SHBBankListPopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:2
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case 113100:
        {
            SHBAskStaffViewController *nextViewController = [[[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil] autorelease];
            [nextViewController executeWithTitle:@"권유직원 조회" ReturnViewController:self];
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 113200:    // 확인
        {
    
            if(![self validationCheck]) return;
            _txtAccountPW.text = @"";
                        
            
             //만기일 확인 위해 전문 전송 2013.11.12 (정과장요청)
             NSString *BankName = _btnSelectBank.titleLabel.text;
             NSDictionary *dic = @{
             @"입금계좌번호" : [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
             @"입금은행코드" : AppInfo.codeList.bankCode[BankName],
             @"이체종류" : codeDic[@"이체종류"],
             @"이체종료일자" : [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
             };
             
             self.service = [[[SHBAccountService alloc] initWithServiceId:AUTO_TRANSFER_INSERT viewController:self] autorelease];
             self.service.previousData = (SHBDataSet *)dic;
             [self.service start];
             
            
        }
          break;
        case 113300:    // 취소
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}




- (void)Transfer
{
    NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;
    NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //이체금액
    self.encriptedAmount = [NSString stringWithFormat:@"<E2K_CHAR=%@>", [AppInfo encNfilterData:_txtInAmount.text]];
    
    
    // 1:당행, 2:타행, 3:가상, 4:평생계좌 구분
    if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구조흥은행"])
    {
        if([strInAccNo length] == 11)
        {
            if([strBankName isEqualToString:@"신한은행"])
            {
                if([[strInAccNo substringFromIndex:3] hasPrefix:@"99"])
                {
                    processFlag = 3;
                }
                else
                {
                    processFlag = 1;
                }
            }
            else
            {
                processFlag = 3;
            }
        }
        else if([strInAccNo length] == 14)
        {
            if([[strInAccNo substringFromIndex:3] hasPrefix:@"901"] || [strInAccNo hasPrefix:@"562"])
            {
                processFlag = 3;
            }
            else
            {
                processFlag = 1;
            }
        }
        else
        {
            processFlag = 1;
        }
        if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
        {
            processFlag = 4;
        }
    }
    else
    {
        processFlag = 2;
    }
    
    //
    if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
    {
        cmsFlag = 1;
    }
    else
    {
        switch ([strInAccNo length]) {
            case 11:
            case 12:
            {
                cmsFlag = 1;
            }
                break;
            case 13:
            {
                if([[strInAccNo substringFromIndex:3] hasPrefix:@"81"] || [[strInAccNo substringFromIndex:3] hasPrefix:@"82"])
                {
                    cmsFlag = 2;
                }
                else
                {
                    cmsFlag = 1;
                }
            }
                break;
            case 14:
            {
                if([strInAccNo hasPrefix:@"560"])
                {
                    cmsFlag = 2;
                }
                else if([strInAccNo hasPrefix:@"561"])
                {
                    if([[strInAccNo substringFromIndex:3] hasPrefix:@"910"])
                    {
                        cmsFlag = 1;
                    }
                    else
                    {
                        cmsFlag = 2;
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    
    SHBDataSet *aDataSet = nil;
    
    if(processFlag == 4)    // 평생계좌
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"평생계좌는 자동이체 등록 대상이 아닙니다. 평생계좌의 유동성계좌로 거래해 주십시오."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    else
    {
        
        NSString *strTransferDate = [_startDateField.textField.text substringFromIndex:8];
        
        if([codeDic[@"말일이체구분"] isEqualToString:@"1"] && [strTransferDate isEqualToString:@"28"])
        {
            strTransferDate = @"31";
        }
        
        
        aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                    @"출금계좌번호" : strOutAccNo,
                    @"출금계좌비밀번호" : self.encriptedPW,
                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                    @"입금계좌번호" : strInAccNo,
                    @"이체금액" : strInAmount,
                    @"이체일자" : strTransferDate,
                    @"이체주기" : codeDic[@"이체주기"],
                    @"이체종류" : codeDic[@"이체종류"],
                    @"이체시작일자" : [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                    @"이체종료일자" : [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""],
                    @"휴일이체구분" : codeDic[@"휴일이체구분"],
                    @"말일이체구분" : codeDic[@"말일이체구분"],
                    @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                    @"은행이름" : strBankName,
                    @"입금계좌통장메모" : _txtRecvMemo.text == nil ? @"" : _txtRecvMemo.text,
                    @"출금계좌통장메모" : _txtSendMemo.text == nil ? @"" : _txtSendMemo.text,
                    @"권유직원번호" : _txtEmployee.text,
                    @"_ExtE2E123_입금계좌번호" : [accGbn isEqualToString:@"ST"] ? self.encriptedInAccNo : @"",
                    @"_ExtE2E123_이체금액" : self.encriptedAmount,
                    @"_IP_ACC_GBN_" :accGbn,
                    @"_AMT_GBN_" : @"ST",
                    @"_IP_ACC_IDX_" : [accGbn isEqualToString:@"ST"] ? @"" : [NSString stringWithFormat:@"%d", accIdx]
                    }];
        
        switch (processFlag)
        {
            case 1: // 당행
            {
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2201" viewController:self] autorelease];
                //
                //                        if (cmsFlag == 2)
                //                        {
                //                            aDataSet[@"거래구분"] = @"3";
                //                        }
            }
                break;
            case 2: // 타행
            {
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2231" viewController:self] autorelease];
            }
                break;
            case 3: // 가상
            {
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2241" viewController:self] autorelease];
            }
                break;
        }
    }
    
    self.service.requestData = aDataSet;
    
    serviceType = 5 + processFlag;
    
    [self.service start];
    [aDataSet release];
}

- (IBAction)closeNormalPad:(id)sender
{
    
     UIButton *btn = sender;
    
    [super closeNormalPad:sender];
    
    if (btn.tag == 999)  // 계좌번호
    {
        [_txtAccountPW becomeFirstResponder];
    }
    
    else if (btn.tag == 888)  // 입금계좌번호
    {
        [_txtInAccountNo becomeFirstResponder];
    }


}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (self.service.serviceId == AUTO_TRANSFER_INSERT) {
        
        if ([aDataSet[@"RESULT"] isEqualToString:@"0"]) {
            
            [self Transfer];
        }
        
        return NO;
    }
    
    if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E2114"]) {
        
        self.securityCenterDataSet = aDataSet;
        
        // 안심거래서비스 체크
        if ([aDataSet[@"안심거래서비스가입여부"] isEqualToString:@"Y"] && [aDataSet[@"안심거래서비스기기여부"] isEqualToString:@"N"] && [AppInfo.userInfo[@"안심거래서비스사용여부"] isEqualToString:@"Y"])
        {
            
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:9877
                             title:@""
                           message:@"안심거래 서비스 신청 고객님은 등록하신 기기로만 이체 거래가 가능합니다. 안심거래 서비스의 기기 추가등록은 인근 영업점을 방문하시어 1회용 인증번호 수령 후 가능합니다."];
            return NO;

           
        }

        
        // 이용기기등록고객 체크
        if ([aDataSet[@"PC지정등록신청여부"] isEqualToString:@"Y"]) {
            
            // 이용기기체크
            if (![aDataSet[@"PC지정등록MAC여부"] isEqualToString:@"Y"]) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:9876
                                 title:@""
                               message:@"고객님께서는 이용기기 등록 서비스에 가입되어 있습니다. 현재 이용기기를 등록하기 위하여 이용기기 등록 서비스로 이동합니다."];
                return NO;
            }
        }
        
        return NO;
    }
    else if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"D2204"]) {
        
        if (![self securityCenterCheck]) return NO;
        
        [self viewControllerDidSelectDataWithDic:nil];
        
        return NO;
    }
    
    switch (serviceType) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            _lblBalance.text = [NSString stringWithFormat:@"출금가능잔액 %@원", aDataSet[@"지불가능잔액"]];
            _lblBalance.hidden = NO;
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            self.dataList = [aDataSet arrayWithForKey:@"최근입금계좌"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"최근 이용하신 입금계좌가 존재하지 않습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : [AppInfo.codeList bankNameFromCode:dic[@"최근입금은행코드"]],
                 @"2" : dic[@"최근입금계좌성명"],
                 @"3" : dic[@"최근입금계좌번호"],
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"최근입금계좌" options:tableDataArray CellNib:@"SHBRecentAccountCell" CellH:60 CellDispCnt:5 CellOptCnt:3];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 5:
        {
            self.dataList = [aDataSet arrayWithForKey:@"입금계좌"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"등록되어 있는 자주쓰는 입금계좌가 존재하지 않습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : [AppInfo.codeList bankNameFromCode:dic[@"입금은행코드"]],
                 @"2" : dic[@"입금계좌성명"],
                 @"3" : dic[@"입금계좌번호"],
                 @"4" : [NSString stringWithFormat:@"별명 : %@", dic[@"nick_name"]],
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"자주쓰는계좌" options:tableDataArray CellNib:@"SHBFrequentAccountCell" CellH:86 CellDispCnt:3 CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 6: // 당행이체
        case 7: // 타행이체
        case 8: // 가상계좌 이체
        {
            
            NSMutableDictionary *signInfoDic = [[[NSMutableDictionary alloc] initWithDictionary:
                                                 @{
                                                 @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"입금계좌예금주", @"이체주기", @"이체시작일", @"이체종료일", @"이체금액", @"말일이체", @"휴일이체", @"받는통장메모", @"내통장메모"],
                                                 @"제목" : @"자동이체의 약관내용을 확인하고 신청합니다.",
                                                 @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                                 @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                                 @"출금계좌번호" : _btnAccountNo.titleLabel.text, 
                                                 @"입금은행" : [AppInfo.codeList bankNameFromCode:aDataSet[@"입금은행코드"]],
                                                 @"입금계좌번호" : _txtInAccountNo.text, 
                                                 @"입금계좌예금주" : aDataSet[@"입금계좌성명"],
                                                 @"이체주기" : _btnTransferTerm.titleLabel.text,
                                                 @"이체시작일" : _startDateField.textField.text,
                                                 @"이체종료일" : _endDateField.textField.text,
                                                 @"이체금액" : [NSString stringWithFormat:@"%@원", _txtInAmount.text],
                                                 @"말일이체" : [_btnLastDay.titleLabel.text isEqualToString:@"예"] ? @"신청함" : @"신청안함",
                                                 @"휴일이체" : _btnHoliday.titleLabel.text,
                                                 @"받는통장메모" : aDataSet[@"입금계좌통장메모"],
                                                 @"내통장메모" : aDataSet[@"출금계좌통장메모"],
                                                 @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                                 @"권유직원번호" : _txtEmployee.text,
                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                 @"입금은행코드" : aDataSet[@"입금은행코드"],
                                                 @"이체종류" : codeDic[@"이체종류"],
                                                 @"전문번호" : AppInfo.serviceCode,
                                                 @"RecvData" : aDataSet,
                                                 }] autorelease];
            
            AppInfo.commonDic = (NSDictionary *)signInfoDic;
            
            if (serviceType == 7) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"타행자동이체는 이체 지정일 전 영업일 20시 이후에 출금되어 지정일 오전에 타행계좌로 입금됩니다. 단, 이체 지정일이 휴일인 경우 지정일 익 영업일 오전에 타행계좌로 입금됩니다."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인", nil];
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }
            
            // 이체종류가 적금/신탁/청약 인 경우
            if ([codeDic[@"이체종류"] isEqualToString:@"01"]) {
                
                NSString *strTransferDate = aDataSet[@"이체일자"];
                
                if ([self.data[@"말일이체구분"] isEqualToString:@"1"] && [self.data[@"이체일자"] isEqualToString:@"28"]) {
                    
                    strTransferDate = @"31";
                }
                
                SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{ @"반복횟수" : @"1",
                                                                              @"일괄_업무구분" : @"12",
                                                                              @"일괄_출금계좌번호" : aDataSet[@"출금계좌번호"],
                                                                              @"일괄_입금계좌번호" : aDataSet[@"입금계좌번호"],
                                                                              @"일괄_이체종류" : codeDic[@"이체종류"],
                                                                              @"일괄_이체주기" : aDataSet[@"이체주기"],
                                                                              @"일괄_이체일자" : strTransferDate,
                                                                              @"일괄_이체시작일자" : aDataSet[@"이체시작일자"],
                                                                              @"일괄_이체종료일자" : aDataSet[@"이체종료일자"],
                                                                              @"일괄_이체금액" : aDataSet[@"이체금액"],
                                                                              @"일괄_말일이체구분" : aDataSet[@"말일이체구분"],
                                                                              @"일괄_휴일이체구분" : aDataSet[@"휴일이체구분"],
                                                                              @"일괄_메모" : aDataSet[@"출금계좌통장메모"],
                                                                              @"일괄_입금계좌통장메모" : aDataSet[@"입금계좌통장메모"],
                                                                              @"출금은행구분" : self.outAccInfoDic[@"은행구분"] }];
                
                self.service = nil;
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2204" viewController:self] autorelease];
                self.service.requestData = dataSet;
                
                [self.service start];
            }
            else {
                
                if (![self securityCenterCheck]) return NO;
                
                [self viewControllerDidSelectDataWithDic:nil];
            }
        }
            break;

        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 9876) {
        // 이용기기 등록 메뉴로 이동
        
        SHBDeviceRegistServiceViewController *viewController = [[[SHBDeviceRegistServiceViewController alloc] initWithNibName:@"SHBDeviceRegistServiceViewController" bundle:nil] autorelease];
        
        [self.navigationController popToRootWithFadePushViewController:viewController];
    }
    
    else if (alertView.tag == 9877) {
        // 안심거래 알럿 후 메인으로 이동 
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    else if (alertView.tag == 9999 && buttonIndex == alertView.cancelButtonIndex)
    {
        SHBPushInfo *openURLManager = [SHBPushInfo instance];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartfundcenter://"]])
        {
            
            [openURLManager requestOpenURL:@"smartfundcenter://" Parm:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id495878508?mt=8"]];
        }

       
    }
    else {
        if (buttonIndex == 0)
        {
            if (![self securityCenterCheck]) return;
            
            [self viewControllerDidSelectDataWithDic:nil];
        }
    }
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtRecvMemo || textField == _txtSendMemo)
    {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		//한글 7자 제한(영문 14자)
		if (dataLength + dataLength2 > 16)
        {
			return NO;
		}
	}
	else if (textField == _txtInAccountNo ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 17)
        {
			return NO;
		}
	}
	else if (textField == _txtInAmount )
    {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 14)
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
                _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
                _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
				return NO;
			}
		}
	}
	else if (textField == _txtEmployee ) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 8)
        {
			return NO;
		}
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if (textField == _txtInAmount)
    {
        _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
    }
    else if(textField == _txtRecvMemo && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtRecvMemo.text = [SHBUtility substring:_txtRecvMemo.text ToMultiByteLength:14];
	}
    
    else if([_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"])
    {
        if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"‘내통장메모’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            _txtSendMemo.text = [SHBUtility substring:_txtSendMemo.text ToMultiByteLength:14];
        }
    }
    
    else if(![_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"])
	{
        
        if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 10 )// 타행
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘내통장메모’ 내용이 입력한도를 초과했습니다.(한글 5자, 영숫자 10자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
            [alert show];
            [alert release];
            _txtSendMemo.text = [SHBUtility substring:_txtSendMemo.text ToMultiByteLength:10];
        }
	}

    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textField);
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    if (textField.tag == 222000)  // 비밀번호
    {
        
        self.encriptedPW = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
    }
    
    if (textField.tag == 222001) //입금계좌
    {
        self.encriptedInAccNo = [[[NSString alloc] initWithFormat:@"<E2K_NUM=%@>", value] autorelease];
        [accGbn release]; accGbn = nil;
        accGbn = @"ST";
    }
    

    
}

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
            self.outAccInfoDic = self.dataList[anIndex];
            
            [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
            
            // 출금계좌가 변경되면 암호 초기화
            _txtAccountPW.text = @"";
            _lblBalance.hidden = YES;
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
        case 2:
        {
            _btnSelectBank.selected = NO;
            [_btnSelectBank setTitle:AppInfo.codeList.bankList[anIndex][@"1"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 3:
        {
              self.encriptedInAccNo = @"";
            
            
            [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";

            _txtInAccountNo.text = self.dataList[anIndex][@"2"];
            [_btnTransferType setTitle:@"선택하세요" forState:UIControlStateNormal];
            _btnTransferType.accessibilityLabel = @"선택된 이체종류가 없습니다.";
            _btnTransferTerm.accessibilityHint = @"이체종류를 바꾸시려면 이중탭 하십시오";
            
            //E2E 확장 본인계좌
            accIdx = anIndex;
            // NSLog(@"accIdx %d", anIndex);
            
            

            UIButton *btn = (UIButton *)[self.view viewWithTag:112400];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 4:
        case 5:
        {
            
            self.encriptedInAccNo = @"";
            
            
            [_btnSelectBank setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";

            _txtInAccountNo.text = self.dataList[anIndex][@"3"];
            [_btnTransferType setTitle:@"선택하세요" forState:UIControlStateNormal];
            _btnTransferType.accessibilityLabel = @"선택된 이체종류가 없습니다.";
            _btnTransferTerm.accessibilityHint = @"이체종류를 바꾸시려면 이중탭 하십시오";
            
            //E2E 확장
            accIdx = anIndex;
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:serviceType == 4 ? 112401 : 112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 10:    // 이체주기
        {
            _btnTransferTerm.selected = NO;
            [_btnTransferTerm setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"이체주기"] = self.dataList[anIndex][@"2"];
            
            _btnTransferTerm.accessibilityLabel = [NSString stringWithFormat:@"선택된 이체주기는 %@ 입니다", _btnTransferTerm.titleLabel.text];
            _btnTransferTerm.accessibilityHint = @"이체주기를 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferTerm);
        }
            break;
        case 11:    // 이체종류
        {
            _btnTransferType.selected = NO;
            [_btnTransferType setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"이체종류"] = self.dataList[anIndex][@"2"];
            
            _btnTransferType.accessibilityLabel = [NSString stringWithFormat:@"선택된 이체주기는 %@ 입니다", _btnTransferType.titleLabel.text];
            _btnTransferTerm.accessibilityHint = @"이체종류를 바꾸시려면 이중탭 하십시오";

            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferType);
        }
            break;
        case 12:    // 휴일이체구분
        {
            _btnHoliday.selected = NO;
            [_btnHoliday setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"휴일이체구분"] = self.dataList[anIndex][@"2"];
            
            _btnHoliday.accessibilityLabel = [NSString stringWithFormat:@"선택된 휴일이체구분은 %@ 입니다", _btnHoliday.titleLabel.text];
            _btnHoliday.accessibilityHint = @"휴일이체구분을 바꾸시려면 이중탭 하십시오";
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnHoliday);
        }
            break;
        case 13:    // 말일이체구분
        {
            _btnLastDay.selected = NO;
            [_btnLastDay setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
            codeDic[@"말일이체구분"] = self.dataList[anIndex][@"2"];
            
            _btnLastDay.accessibilityLabel = [NSString stringWithFormat:@"선택된 말일이체구분은 %@ 입니다", _btnLastDay.titleLabel.text];
            _btnLastDay.accessibilityHint = @"말일이체구분을 바꾸시려면 이중탭 하십시오";

            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnLastDay);
        }
            break;
            
        default:
            break;
    }
    
    [self defaultValueSetting];
}

- (void)listPopupViewDidCancel{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
        }
            break;
        case 2:
        {
            _btnSelectBank.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnSelectBank);
        }
            break;
        case 3:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112400];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 4:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112401];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 5:
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 10:    // 이체주기
        {
            _btnTransferTerm.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferTerm);
        }
            break;
        case 11:    // 이체종류
        {
            _btnTransferType.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnTransferType);
        }
            break;
        case 12:    // 휴일이체구분
        {
            _btnHoliday.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnHoliday);
        }
            break;
        case 13:    // 말일이체구분
        {
            _btnLastDay.selected = NO;
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnLastDay);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -SHBDateFieldDelegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
{
    [self defaultValueSetting];
}

#pragma mark - Ask Staff

- (BOOL)securityCenterCheck
{
    NSString *serviceCode = @"";
    
    switch (processFlag) {
        case 1:
        case 3:
        {
            // 당행이체, 가상이체
            serviceCode = @"D2203";
        }
            break;
        case 2:
        {
            // 타행이체
            serviceCode = @"D2233";
        }
            break;
        default:
            break;
    }
    
    // (5) <추가인증 여부 체크>
    if (![_securityCenterDataSet[@"C2403_2채널인증여부"] isEqualToString:@"Y"]) { // 추가인증 안한 고객인 경우(C2403_2채널인증여부:Y가 아닐경우)
        
        // (1) <보안매체>
        if (![_securityCenterDataSet[@"점자보안카드사용여부"] isEqualToString:@"Y"] &&
            ![_securityCenterDataSet[@"OTP사용여부"] isEqualToString:@"Y"]) { // 보안카드인 경우(점자보안카드사용여부 == N and OTP사용여부 == N)
            
            long long inAmount = [[_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체금액
            long long checkAmount = [[_securityCenterDataSet[@"이체추가인증기준금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체추가인증기준금액
            
            AppInfo.transferDic = @{
                                    @"추가이체여부" : @"N",
                                    @"입금은행명" : _btnSelectBank.titleLabel.text,
                                    @"추가이체건수" : @"",
                                    @"추가_입금은행코드" : @"",
                                    @"추가_입금은행명" : @"",
                                    @"추가_입금계좌번호" : @"",
                                    @"추가_입금계좌성명" : @"",
                                    @"추가_이체금액" : @"",
                                    @"계좌번호_상품코드" : @"",
                                    @"거래금액" : [NSString stringWithFormat:@"%lld", inAmount],
                                    @"서비스코드" : serviceCode,
                                    };
            
            // (2) <금액체크>
            if ([_securityCenterDataSet[@"일누적이체금액"] longLongValue] + inAmount >= checkAmount) { // 이체추가인증기준금액 이상인 경우(해당금액 < 일누적이체금액 + 이체금액)
                
                // (3) <이용기기등록고객>
                if (![_securityCenterDataSet[@"PC지정등록신청여부"] isEqualToString:@"Y"]) { // 미등록인 경우(PC지정등록신청여부:N)
                    
                    // (8) <추가인증 체크>
                    if ([_securityCenterDataSet[@"이체추가인증신청여부"] isEqualToString:@"Y"]) { // 이체추가인증신청여부:Y인 경우
                        
                        // 추가인증 요청
                        SHBIdentity2ViewController *viewController = [[[SHBIdentity2ViewController alloc]initWithNibName:@"SHBIdentity2ViewController" bundle:nil] autorelease];
                        
                        viewController.needsLogin = YES;
                        viewController.delegate = self;
                        viewController.data = [NSDictionary dictionaryWithDictionary:_securityCenterDataSet];
                        viewController.serviceSeq = SERVICE_300_OVER;
                        
                        [self checkLoginBeforePushViewController:viewController animated:YES];
                        
                        [viewController executeWithTitle:@"자동이체" Step:0 StepCnt:0 NextControllerName:nil];
                        [viewController subTitle:@"추가인증 방법 선택"];
                        
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    if (mDic && mDic[@"행번"] && [mDic[@"행번"] length] > 0){
        _txtEmployee.text = mDic[@"행번"];
	}
    else {
        SHBAutoTransferComfirmViewController *nextViewController = [[[SHBAutoTransferComfirmViewController alloc] initWithNibName:@"SHBAutoTransferComfirmViewController" bundle:nil] autorelease];
        [self.navigationController pushFadeViewController:nextViewController];
    }
}

// 해당 달의 마지막 날 여부
- (BOOL)isMonthLastDate:(NSString *)aDate
{
    if (!aDate || [aDate length] != 10) {
        return NO;
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *firstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@.01", [aDate substringWithRange:NSMakeRange(0, 7)]]];
    
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	dateComponents.month = 1;
	dateComponents.day	 = -1;
	
	NSDate *dateMonthLastDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
																			   toDate:firstDate
																			  options:0];
	[dateComponents release];
	dateComponents = nil;
    
    NSString *strLastDate = [dateFormatter stringFromDate:dateMonthLastDate];
    
	return [strLastDate isEqualToString:aDate] ? YES : NO;
}

- (void)defaultValueSetting
{
    if([_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"])
    {
        _btnTransferTerm.enabled = YES;
        _btnTransferType.enabled = YES;
        _btnHoliday.enabled = YES;
        
        [_txtSendMemo setPlaceholder:@"한글3~7자이내, 영숫자5~14자이내"];
    }
    else
    {
        codeDic[@"이체주기"] = @"01";
        codeDic[@"이체종류"] = @"";
        codeDic[@"휴일이체구분"] = @"0";
        
        _btnTransferTerm.enabled = NO;
        [_btnTransferTerm setTitle:@"1개월" forState:UIControlStateNormal];
        
        _btnTransferType.enabled = NO;
        [_btnTransferType setTitle:@"선택하세요" forState:UIControlStateNormal];
        
        _btnHoliday.enabled = NO;
        [_btnHoliday setTitle:@"휴일익일이체" forState:UIControlStateNormal];
        
         [_txtSendMemo setPlaceholder:@"한글3~5자이내, 영숫자5~10자이내"];
    }
    
    if([_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"] && [[_btnTransferTerm.titleLabel.text substringFromIndex:1] isEqualToString:@"개월"] && [self isMonthLastDate:_startDateField.textField.text])
    {
        codeDic[@"말일이체구분"] = @"1";
        [_btnLastDay setTitle:@"예" forState:UIControlStateNormal];
        _btnLastDay.enabled = YES;
    }
    else
    {
        codeDic[@"말일이체구분"] = @"0";
        [_btnLastDay setTitle:@"아니오" forState:UIControlStateNormal];
        _btnLastDay.enabled = NO;
    }

    _btnTransferTerm.accessibilityLabel = [NSString stringWithFormat:@"선택된 이체주기는 %@ 입니다", _btnTransferTerm.titleLabel.text];
    _btnTransferTerm.accessibilityHint = @"이체주기를 바꾸시려면 이중탭 하십시오";

    _btnTransferType.accessibilityLabel = @"선택된 이체종류가 없습니다.";
    _btnTransferTerm.accessibilityHint = @"이체종류를 바꾸시려면 이중탭 하십시오";
    
    _btnLastDay.accessibilityLabel = [NSString stringWithFormat:@"선택된 말일이체구분은 %@ 입니다", _btnLastDay.titleLabel.text];
    _btnLastDay.accessibilityHint = @"말일이체구분을 바꾸시려면 이중탭 하십시오";
    
    _btnHoliday.accessibilityLabel = [NSString stringWithFormat:@"선택된 휴일이체구분은 %@ 입니다", _btnHoliday.titleLabel.text];
    _btnHoliday.accessibilityHint = @"휴일이체구분을 바꾸시려면 이중탭 하십시오";
}

#pragma mark - identity2 Delegate

- (void)identity2ViewControllerCancel
{
    AppInfo.isNeedClearData = YES;
}

#pragma mark - SHBDateField
- (void)currentDateField:(SHBDateField *)dateField
{
	[self.curTextField resignFirstResponder];
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;
    
    
    if(!isRead1){
        strAlertMessage = @"상단의 자동이체 안내를 읽고 확인 버튼을 선택하시기 바랍니다.";
        goto ShowAlert;
    }
    
    
    if([_txtAccountPW.text length] != 4){
        strAlertMessage = @"‘출금계좌비밀번호’는 4자리를 입력해 주십시오.";
        goto ShowAlert;
    }
    
    if([strInAccNo length] == 0 ||
       ([strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 14) ||
       (![strBankName isEqualToString:@"신한은행"] && [strInAccNo length] > 16)){
        strAlertMessage = @"‘입금계좌’ 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }
    
	if([strInAccNo isEqualToString:@"43501001190"] ||
	   [strInAccNo isEqualToString:@"34401162030"] ||
	   [strInAccNo isEqualToString:@"34401199090"] ||
	   [strInAccNo isEqualToString:@"34401093320"] ||
	   [strInAccNo isEqualToString:@"34401197940"] ||
	   [strInAccNo isEqualToString:@"38301000178"] ||
	   [strInAccNo isEqualToString:@"34401198298"] ||
	   [strInAccNo isEqualToString:@"36101100263"] ||
	   [strInAccNo isEqualToString:@"36101102088"] ||
	   [strInAccNo isEqualToString:@"36101103459"] ||
	   [strInAccNo isEqualToString:@"31801093322"] ||
	   [strInAccNo isEqualToString:@"30601236928"] ||
	   [strInAccNo isEqualToString:@"34401197933"] ||
	   [strInAccNo isEqualToString:@"36107101326"] ||
	   [strInAccNo isEqualToString:@"100018666254"] ||
	   [strInAccNo isEqualToString:@"100007460611"] ||
	   [strInAccNo isEqualToString:@"100014301031"] ||
	   [strInAccNo isEqualToString:@"100001298169"] ||
	   [strInAccNo isEqualToString:@"100014159385"] ||
	   [strInAccNo isEqualToString:@"100002114914"] ||
	   [strInAccNo isEqualToString:@"100014199383"] ||
	   [strInAccNo isEqualToString:@"100014283415"] ||
	   [strInAccNo isEqualToString:@"100014868899"] ||
	   [strInAccNo isEqualToString:@"100016904551"] ||
	   [strInAccNo isEqualToString:@"100011897988"] ||
	   [strInAccNo isEqualToString:@"100013946245"] ||
	   [strInAccNo isEqualToString:@"100014159378"] ||
	   [strInAccNo isEqualToString:@"150000497880"] )
	{
        strAlertMessage = @"증권사계좌는 자동이체등록을 하실 수 없습니다.";
        goto ShowAlert;
	}
    
	if([strInAccNo length] == 12 && [strBankName isEqualToString:@"신한은행"] &&
       ([[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] >= 250
        && [[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] <= 259))
	{
        strAlertMessage = @"펀드계좌 자동이체는 스마트 펀드센터 앱에서 가능합니다.";
        goto ShowAlert_fund;
	}
	
	if (([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo])
        || ([strBankName isEqualToString:@"신한은행"] && [[self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo]))
    {
        strAlertMessage = @"출금계좌와 입금계좌가 동일합니다.\n입출금계좌를 확인하십시오.";
        goto ShowAlert;
    }
    
	if(_txtInAmount.text == nil || [_txtInAmount.text length] == 0 || [_txtInAmount.text length] > 15 )
	{
        strAlertMessage = @"‘이체금액’의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
	}
    
	if([_txtInAmount.text isEqualToString:@"0"])
	{
        strAlertMessage = @"‘이체금액’은 0원을 입력하실 수 없습니다.";
        goto ShowAlert;
	}
    
    if([strBankName isEqualToString:@"신한은행"] &&  [_btnTransferType.titleLabel.text isEqualToString:@"선택하세요"])
    {
        strAlertMessage = @"이체종류를 선택하여 주십시오.";
        goto ShowAlert;
    }
    
    NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];

    if([startDate isEqualToString:@""])
    {
        strAlertMessage = @"이체시작일의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }

    if([endDate isEqualToString:@""])
    {
        strAlertMessage = @"이체종료일의 입력값이 유효하지 않습니다.";
        goto ShowAlert;
    }

    if([startDate intValue] > [endDate intValue])
    {
        strAlertMessage = @"이체종료일은 이체시작일보다 커야 합니다.";
        goto ShowAlert;
    }
    
    if([startDate intValue] == [endDate intValue])
    {
        strAlertMessage = @"이체시작일자와 이체종료일자를 동일한 날짜로 등록할 수 없습니다.";
        goto ShowAlert;
    }
    
    if(![strBankName isEqualToString:@"신한은행"] && [[SHBUtility dateStringToMonth:0 toDay:1] isEqualToString:_startDateField.textField.text] &&
       [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] intValue] > 163000)
    {
        strAlertMessage = @"타행 자동이체 시작일은 1영업일 16:30분전까지 등록 완료하셔야 합니다. 예)자동이체시작일이 D일이면, D-1일 16:30분 이전 등록완료 해야 합니다.";
        goto ShowAlert;
    }
    
	if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 0 && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] < 5 )
	{
        strAlertMessage = @"‘받는분 통장표시’ 내용은 한글3자이상 영문숫자 5자이상으로 입력하셔야 합니다.";
        goto ShowAlert;
	}
    
	if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}

	if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 0 && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] < 5 )
	{
        strAlertMessage = @"‘보내는분 통장표시’ 내용은 한글3자이상 영문숫자 5자이상으로 입력하셔야 합니다.";
        goto ShowAlert;
	}
    
	if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}
    
	if ([_txtEmployee.text length] > 0 && [_txtEmployee.text length] < 8){
        strAlertMessage = @"권유직원번호는 8자리를 입력하여 주십시오.";
        goto ShowAlert;
	}

    
ShowAlert_fund:     //자동이체 알럿 후 스마트펀드센터 앱으동
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:self
												   cancelButtonTitle:@"이동"
												   otherButtonTitles:@"취소",nil] autorelease];
		[alertView show];
        alertView.tag = 9999;
        
		return NO;
	}
    
    
    
ShowAlert:
	if (strAlertMessage != nil) {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
															 message:strAlertMessage
															delegate:nil
												   cancelButtonTitle:@"확인"
												   otherButtonTitles:nil] autorelease];
		[alertView show];
        
		return NO;
	}
	
	return YES;
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

    self.title = @"자동이체";
    self.strBackButtonTitle = @"자동이체 2단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"자동이체등록" maxStep:4 focusStepNumber:2] autorelease]];

    self.contentScrollView.contentSize = CGSizeMake(317, 896);
    contentViewHeight = 896;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222005;

    isRead1 = NO;
    
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 입금계좌번호
    [self.txtInAccountNo showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:17];
    self.txtInAccountNo.secureTextEntry=NO;
    
    [accGbn release]; accGbn = nil;
    
    
    processFlag = 0;
    cmsFlag = 0;

    codeDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    codeDic[@"이체주기"] = @"01";
    codeDic[@"이체종류"] = @"";
    codeDic[@"휴일이체구분"] = @"0";
    codeDic[@"말일이체구분"] = @"0";
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    // 기간지정 시작
    [_startDateField initFrame:_startDateField.frame];
    [_startDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_startDateField.textField setTextColor:RGB(44, 44, 44)];
    [_startDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_startDateField setDelegate:self];
    [_startDateField setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]]];
//    [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
    
    // 기간지정 종료
    [_endDateField initFrame:_endDateField.frame];
    [_endDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_endDateField.textField setTextColor:RGB(44, 44, 44)];
    [_endDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_endDateField setDelegate:self];
    [_endDateField setminimumDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]]];
//    [_endDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
    }
    else
    {
        [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        _btnAccountNo.enabled = NO;
    }

    //_txtInAccountNo.strLableFormat = @"입력된 입금계좌는 %@ 입니다";
    //_txtInAccountNo.strNoDataLable = @"입력된 입금계좌가 없습니다";
    
    _txtInAmount.strLableFormat = @"입력된 자동이체금액은 %@ 원입니다";
    _txtInAmount.strNoDataLable = @"입력된 자동이체금액이 없습니다";
    
    _txtRecvMemo.strLableFormat = @"입력된 받는통장메모는 %@ 입니다";
    _txtRecvMemo.strNoDataLable = @"입력된 받는통장메모가 없습니다. (선택)한글3~7자이내, 영숫자5~14자이내로 입력가능합니다";
    _txtSendMemo.strLableFormat = @"입력된 내통장메모는 %@ 입니다";
    _txtSendMemo.strNoDataLable = @"입력된 내통장메모가 없습니다. (선택)한글3~7자이내, 영숫자5~14자이내로 입력가능합니다";
    
    _txtEmployee.strLableFormat = @"입력된 권유직원번호는 %@ 입니다";
    _txtEmployee.strNoDataLable = @"입력된 권유직원번호가 없습니다. (선택)";
    
    [self defaultValueSetting];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(AppInfo.isNeedClearData)
    {
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        processFlag = 0;
        cmsFlag = 0;
        
        codeDic[@"이체주기"] = @"01";
        codeDic[@"이체종류"] = @"";
        codeDic[@"휴일이체구분"] = @"0";
        codeDic[@"말일이체구분"] = @"0";
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
        [_endDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:1]] animated:NO];
        
        _lblBalance.hidden = YES;
        _lblKorMoney.text = @"";
        [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
        _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
        _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";

        _txtInAccountNo.text = @"";
        _txtInAmount.text = @"";
        _txtRecvMemo.text = @"";
        _txtSendMemo.text = @"";
        _txtEmployee.text = @"";
        
        [self defaultValueSetting];
    }
    
    if (!_isInfoBack) {
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        // 추가인증 정보조회
        self.securityCenterService = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
        [_securityCenterService start];
    }
    
    _isInfoBack = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.encriptedPW = nil;
    
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
    [codeDic release];
    [_btnAccountNo release];
    [_btnSelectBank release];
    [_lblBalance release];
    [_lblKorMoney release];
    [_btnTransferTerm release];
    [_btnTransferType release];
    [_btnHoliday release];
    [_btnLastDay release];
    [_txtAccountPW release];
    [_txtInAccountNo release];
    [_txtInAmount release];
    [_txtRecvMemo release];
    [_txtSendMemo release];
    [_txtEmployee release];
    [_startDateField release];
    [_endDateField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnAccountNo:nil];
    [self setBtnSelectBank:nil];
    [self setLblBalance:nil];
    [self setLblKorMoney:nil];
    [self setBtnTransferTerm:nil];
    [self setBtnTransferType:nil];
    [self setBtnHoliday:nil];
    [self setBtnLastDay:nil];
    [self setTxtAccountPW:nil];
    [self setTxtInAccountNo:nil];
    [self setTxtInAmount:nil];
    [self setTxtRecvMemo:nil];
    [self setTxtSendMemo:nil];
    [self setTxtEmployee:nil];
    [self setStartDateField:nil];
    [self setEndDateField:nil];
    [super viewDidUnload];
}
@end
