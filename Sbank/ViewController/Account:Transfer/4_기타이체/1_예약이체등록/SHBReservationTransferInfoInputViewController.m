//
//  SHBReservationTransferInfoInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 31..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservationTransferInfoInputViewController.h"
#import "SHBReservationTransferComfirmViewController.h"
#import "SHBFreqTransferRegViewController.h"
#import "SHBUtility.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBIdentity2ViewController.h" // 추가인증
#import "SHBDeviceRegistServiceViewController.h" // 추가인증

@interface SHBReservationTransferInfoInputViewController () <SHBIdentity2Delegate>
{
    int serviceType;
    NSString *encriptedPW;
    NSString *encriptedInAccNo;
    NSString *encriptedAmount;
    
    NSString *accGbn;       // 확장E2E 구분값
    NSUInteger accIdx;      // 확장E2E 인덱스
    
    int processFlag;
    int cmsFlag;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *encriptedInAccNo;
@property (retain, nonatomic) NSString *encriptedAmount;

@property (retain, nonatomic) NSString *accGbn;
@property (readonly, nonatomic) NSUInteger accIdx;
@property (nonatomic, retain) NSString *strBankGubun;

- (BOOL)validationCheck;

@end

@implementation SHBReservationTransferInfoInputViewController
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize encriptedInAccNo;
@synthesize encriptedAmount;
@synthesize accGbn;
@synthesize accIdx;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];

    switch ([sender tag]) {
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
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self] autorelease];
            self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : _btnAccountNo.titleLabel.text}] autorelease];
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
            for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
            {
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
        case 112403:    // 스피드이체
        {
            serviceType = 9;
             accGbn = @"SP";
            
            self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_LIST viewController:self] autorelease];
            [self.service start];
        }
            break;
        case 112500:    // 예약이체시간 오전9시 ~ 10시에 이체
        {
            if(sender.isSelected) return;
            
            _btnSelectTime1.selected = YES;
            _btnSelectTime2.selected = NO;
        }
            break;
        case 112501:    // 예약이체시간 오후3시 ~ 4시에 이체
        {
            if(sender.isSelected) return;
            
            _btnSelectTime1.selected = NO;
            _btnSelectTime2.selected = YES;
        }
            break;
        case 112600:    // 확인
        {
            if(![self validationCheck]) return;
            
            _txtAccountPW.text = @"";
            
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
                //                if([strInAccNo length] >= 10 && [strInAccNo length] <= 14 && [strInAccNo hasPrefix:@"0"])
                //                {
                //                    processFlag = 4;
                //                }
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
            
            if(processFlag == 1 && cmsFlag != 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"CMS가상계좌는 예약이체할 수 없습니다."]
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
                
            }
            
            switch (processFlag)
            {
                case 1: // 당행
                {
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2101" viewController:self] autorelease];
                }
                    break;
                case 2: // 타행
                {
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2104" viewController:self] autorelease];
                }
                    break;
                case 3: // 가상
                {
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2105" viewController:self] autorelease];
                }
                    break;
            }
            NSLog(@"%@", self.outAccInfoDic);
            
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                    @"이체요청일자" : _reservationDate.textField.text,
                                    @"이체요청시간" : _btnSelectTime1.isSelected ? @"0900" :  @"1500",
                                    @"출금계좌번호" : strOutAccNo,
                                    @"출금계좌비밀번호" : self.encriptedPW,
                                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                    @"입금계좌번호" : strInAccNo,
                                    @"이체금액" : strInAmount,
                                    @"목록합계금액" : strInAmount,
                                    @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                    @"은행이름" : strBankName,
                                    @"입금계좌통장메모" : _txtRecvMemo.text,
                                    @"출금계좌통장메모" : _txtSendMemo.text,
                                    @"CMS코드" : _txtCMSCode.text,
                                    @"_ExtE2E123_입금계좌번호" : [accGbn isEqualToString:@"ST"] ? self.encriptedInAccNo : @"",
                                    @"_ExtE2E123_이체금액" : self.encriptedAmount,
                                    @"_IP_ACC_GBN_" :accGbn,
                                    @"_AMT_GBN_" : @"ST",
                                    @"_IP_ACC_IDX_" : [accGbn isEqualToString:@"ST"] ? @"" : [NSString stringWithFormat:@"%d", accIdx]
                                    }];
            
            self.service.requestData = aDataSet;
            serviceType = 5 + processFlag;
            
            [self.service start];
            [aDataSet release];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    SHBReservationTransferComfirmViewController *nextViewController = [[[SHBReservationTransferComfirmViewController alloc] initWithNibName:@"SHBReservationTransferComfirmViewController" bundle:nil] autorelease];
    [self.navigationController pushFadeViewController:nextViewController];
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
    /*
    // 이용기기 외 추가인증 서비스 체크 - 테스트용
    aDataSet[@"PC지정등록신청여부"] = @"Y";
    aDataSet[@"PC지정등록MAC여부"] = @"N";
     */
    
    // 추가인증 정보 조회
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
            
            // 이용기기 체크
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
            
            NSString *strFee = @"";
            if(serviceType == 8)
            {
                strFee = [NSString stringWithFormat:@"%@원", aDataSet[@"수수료"]];
            }
            else
            {
                strFee = (aDataSet[@"적용수수료금액"] == nil || [aDataSet[@"적용수수료금액"] isEqualToString:@""]) ? @"0원" : [NSString stringWithFormat:@"%@원", aDataSet[@"적용수수료금액"]];
            }
            AppInfo.commonDic = @{
            @"SignDataList" : @[@"제목", @"거래일자", @"거래시간", @"이체예정일자", @"이체예정시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"수취인성명", @"이체금액", @"받는통장메모", @"내통장메모", @"CMS코드"],
            @"제목" : @"예약이체",
            @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
            @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
            @"이체예정일자" : aDataSet[@"이체요청일자"],
            @"이체예정시간" : [aDataSet[@"이체요청시간"] isEqualToString:@"0900"] ? @"09:00" : @"15:00",
            @"출금계좌번호" : _btnAccountNo.titleLabel.text, //([aDataSet[@"구출금계좌번호"] length] > 0) ? aDataSet[@"구출금계좌번호"] : aDataSet[@"출금계좌번호"],
            @"입금은행" : [AppInfo.codeList bankNameFromCode:aDataSet[@"입금은행코드"]],
            @"입금계좌번호" : _txtInAccountNo.text, //([aDataSet[@"구입금계좌번호"] length] > 0) ? aDataSet[@"구입금계좌번호"] : aDataSet[@"입금계좌번호"],
            @"수취인성명" : aDataSet[@"입금계좌성명"],
            @"이체금액" : [NSString stringWithFormat:@"%@원", aDataSet[@"이체금액"]],
            @"CMS코드" : _txtCMSCode.text,
            @"받는통장메모" : aDataSet[@"입금계좌통장메모"],
            @"내통장메모" : aDataSet[@"출금계좌통장메모"],
            @"전화번호" : _securityCenterDataSet[@"휴대폰번호"], //aDataSet[@"전화번호"],
            @"수수료" : strFee,
            @"전문번호" : AppInfo.serviceCode
            };
            
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
                                            @"서비스코드" : @"D2103",
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
                                
                                [viewController executeWithTitle:@"기타이체" Step:0 StepCnt:0 NextControllerName:nil];
                                [viewController subTitle:@"추가인증 방법 선택"];
                                
                                return NO;
                            }
                        }
                    }
                }
            }
            
            [self viewControllerDidSelectDataWithDic:nil];
        }
            break;
        case 9:
        {
            self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                NSString *strMessage = @"등록된 스피드이체 업무가 없습니다.\n‘스피드이체’ 등록 화면으로  이동 하시겠습니까?\n\n(스피드이체 등록은 조회이체>계좌관리>스피드이체관리 메뉴에서 ‘등록’’변경’하실 수 있습니다.)";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:strMessage
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인", @"취소",nil];
                alert.tag = 13579;
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : dic[@"입금계좌별명"],
                 @"2" : [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dic[@"이체금액"]]],
                 @"3" : dic[@"출금계좌번호"],
                 @"4" : [AppInfo.codeList bankNameFromCode:dic[@"입금은행코드"]],
                 @"5" : dic[@"입금계좌번호"],
                 @"6" : dic,
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"스피드이체" options:tableDataArray CellNib:@"SHBFreqTransferCell" CellH:110 CellDispCnt:3 CellOptCnt:5];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ([alertView tag]) {
        case 13579:
        {
            if (buttonIndex == 0) {
                SHBFreqTransferRegViewController *nextViewController = [[[SHBFreqTransferRegViewController alloc] initWithNibName:@"SHBFreqTransferRegViewController" bundle:nil] autorelease];
                nextViewController.nType = 9;
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 9876:
        {
            // 이용기기 등록 메뉴로 이동
            SHBDeviceRegistServiceViewController *viewController = [[[SHBDeviceRegistServiceViewController alloc] initWithNibName:@"SHBDeviceRegistServiceViewController" bundle:nil] autorelease];
            [self.navigationController popToRootWithFadePushViewController:viewController];
        }
            break;
        case 9877:
        {
            // 안심거래 알럿 후 메인으로 이동
            [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        }
        default:
            break;
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
	else if (textField == _txtCMSCode ) { //CMS코드는 19자리 제한
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
        
		if (dataLength + dataLength2 > 21)
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
    else if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtSendMemo.text = [SHBUtility substring:_txtSendMemo.text ToMultiByteLength:14];
	}
    else if(_txtCMSCode.text != nil && [_txtCMSCode.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 19 )
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"‘CMS 코드’ 내용이 입력한도를 초과했습니다.(한글 9자, 영숫자 19자)"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        _txtCMSCode.text = [SHBUtility substring:_txtCMSCode.text ToMultiByteLength:19];
	}
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

#pragma mark - identity2 Delegate

- (void)identity2ViewControllerCancel
{
    AppInfo.isNeedClearData = YES;
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
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.btnAccountNo);
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
            
            _txtInAmount.text = @"";
            _lblKorMoney.text = @"";
            _reservationDate.textField.text = @"";
            _btnSelectTime1.selected = YES;
            _btnSelectTime2.selected = NO;
            _txtRecvMemo.text = @"";
            _txtSendMemo.text = @"";
            _txtCMSCode.text = @"";
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

            _txtInAmount.text = @"";
            _lblKorMoney.text = @"";
            _reservationDate.textField.text = @"";
            _btnSelectTime1.selected = YES;
            _btnSelectTime2.selected = NO;
            _txtRecvMemo.text = @"";
            _txtSendMemo.text = @"";
            _txtCMSCode.text = @"";
            
            //E2E 확장
            accIdx = anIndex;
            

            UIButton *btn = (UIButton *)[self.inputView viewWithTag:serviceType == 4 ? 112401 : 112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 9:
        {
            NSString *strAccNo = [self.dataList[anIndex][@"3"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strCurAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if(![strAccNo isEqualToString:strCurAccNo])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금계좌번호가 변경되었습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
            }
            
            _reservationDate.textField.text = @"";
            _btnSelectTime1.selected = YES;
            _btnSelectTime2.selected = NO;
            _txtCMSCode.text = @"";
            
            for(NSDictionary *dic in [self outAccountList])
            {
                if([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo] ||
                   [[dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                {
                    self.outAccInfoDic = dic;
                    
                    [_btnAccountNo setTitle:dic[@"2"] forState:UIControlStateNormal];
                    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
                    _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
                    
                    // 출금계좌가 변경되면 암호 초기화
                    _txtAccountPW.text = @"";
                    _lblBalance.hidden = YES;
                    break;
                }
            }
            
            [_btnSelectBank setTitle:self.dataList[anIndex][@"4"] forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            
            _txtInAccountNo.text = self.dataList[anIndex][@"5"];
            _txtInAmount.text = [self.dataList[anIndex][@"2"] stringByReplacingOccurrencesOfString:@"원" withString:@""];
            _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]];
            _txtRecvMemo.text = self.dataList[anIndex][@"6"][@"받는분통장메모"];
            _txtSendMemo.text = self.dataList[anIndex][@"6"][@"보내는분통장메모"];

            
            //E2E 확장
            accIdx = anIndex;
            
            
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112403];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        default:
            break;
    }
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
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112400];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 4:
        {
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112401];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 5:
        {
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 9:
        {
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112403];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Delegate : SHBDateFieldDelegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
{
	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
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
	[self.curTextField resignFirstResponder];
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;
    
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
        strAlertMessage = @"증권사계좌는 예약이체에서 이체하실 수 없습니다.";
        goto ShowAlert;
	}
    
	if([strInAccNo length] == 12 && [strBankName isEqualToString:@"신한은행"] &&
       ([[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] >= 250
        && [[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] <= 259))
	{
        strAlertMessage = @"펀드계좌는 예약이체에서 이체하실 수 없습니다.";
        goto ShowAlert;
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
    
    if(_reservationDate.textField.text == nil || [_reservationDate.textField.text isEqualToString:@""])
    {
        strAlertMessage = @"‘예약일자’를 선택하여 주십시오.";
        goto ShowAlert;
    }

    if([_reservationDate.textField.text isEqualToString:AppInfo.tran_Date])
    {
        if((_btnSelectTime1.isSelected && [SHBUtility getCurrentHour] > 9)
           || (_btnSelectTime2.isSelected && [SHBUtility getCurrentHour] > 15))
        {
            strAlertMessage = @"현재시간 이전으로는 예약이체가 불가능합니다.";
            goto ShowAlert;
        }
    }
    
//    if (UIAccessibilityIsVoiceOverRunning())
//    {
//        NSString *tmpStr = _reservationDate.textField.text;
//        tmpStr = [_reservationDate.textField.text stringByReplacingOccurrencesOfString:@"년" withString:@""];
//        tmpStr = [_reservationDate.textField.text stringByReplacingOccurrencesOfString:@"월" withString:@""];
//        tmpStr = [_reservationDate.textField.text stringByReplacingOccurrencesOfString:@"일" withString:@""];
//        
//        if(![SHBUtility isOPDate:tmpStr])
//        {
//            strAlertMessage = @"‘예약일자’는 평일만 가능합니다.\n토요일 및 공휴일은 불가능한\n서비스 입니다.";
//            goto ShowAlert;
//        }
//        
//    }else
//    {
        if(![SHBUtility isOPDate:[_reservationDate.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""]])
        {
            strAlertMessage = @"‘예약일자’는 평일만 가능합니다.\n토요일 및 공휴일은 불가능한\n서비스 입니다.";
            goto ShowAlert;
        }
    //}
    
    
    
	if(_txtRecvMemo.text != nil && [_txtRecvMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘받는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}
    
	if(_txtSendMemo.text != nil && [_txtSendMemo.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 14 )
	{
        strAlertMessage = @"‘보내는분 통장표시’ 내용이 입력한도를 초과했습니다.(한글 7자, 영숫자 14자)";
        goto ShowAlert;
	}
    
	if(_txtCMSCode.text != nil && [_txtCMSCode.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean] > 19 )
	{
        strAlertMessage = @"‘CMS 코드’ 내용이 입력한도를 초과했습니다.(한글 9자, 영숫자 19자)";
        goto ShowAlert;
	}

	if(_txtCMSCode.text != nil && [_txtCMSCode.text length] > 0 && ![strBankName isEqualToString:@"신한은행"])
	{
        for (int i = 0; i < [_txtCMSCode.text length]; i++) {
            NSInteger ch = [_txtCMSCode.text characterAtIndex:i];
            /**
             A~Z : 65 ~ 90
             a~z : 97 ~ 122
             0~9 : 48 ~ 57
             **/
            if (!((32 == ch) || (48 <= ch && ch <= 57) || (65 <= ch && ch <=92) || (97 <= ch && ch <= 122))) {
                strAlertMessage = @"‘CMS 코드’ 타행이체의 경우 영문숫자만 입력 가능 합니다.";
                goto ShowAlert;

                break;
            }
        }
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"기타이체";
    self.strBackButtonTitle = @"예약이체 등록 1단계";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예약이체 등록" maxStep:3 focusStepNumber:1] autorelease]];
    
    self.contentScrollView.contentSize = CGSizeMake(317.0f, 559.0f);
    contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222005;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 입금계좌번호
    [self.txtInAccountNo showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:17];
    self.txtInAccountNo.secureTextEntry=NO;
    
    
    [accGbn release]; accGbn = nil;
    
	[_reservationDate initFrame:_reservationDate.frame];
    _reservationDate.textField.font = [UIFont systemFontOfSize:15];
    _reservationDate.textField.textAlignment = UITextAlignmentLeft;
    _reservationDate.delegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *dateMin = [dateFormatter dateFromString:AppInfo.tran_Date];
    NSDate *dateMax = [dateFormatter dateFromString:[SHBUtility dateStringToMonth:6 toDay:0]];
    [dateFormatter release];
    
    [_reservationDate setmaximumDate:dateMax];
    [_reservationDate setminimumDate:dateMin];

    _reservationDate.textField.placeholder = @"(6개월 이내, 토요일/휴일 불가)";
    
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
    
  //  _txtInAccountNo.strLableFormat = @"입력된 입금계좌는 %@ 입니다";
  //  _txtInAccountNo.strNoDataLable = @"입력된 입금계좌가 없습니다";
    
    _txtInAmount.strLableFormat = @"입력된 금액은 %@ 원입니다";
    _txtInAmount.strNoDataLable = @"입력된 금액이 없습니다";
    
    _txtRecvMemo.strLableFormat = @"입력된 받는통장메모는 %@ 입니다";
    _txtRecvMemo.strNoDataLable = @"입력된 받는통장메모가 없습니다. (선택)7자이내로 입력가능합니다";
    _txtSendMemo.strLableFormat = @"입력된 내통장메모는 %@ 입니다";
    _txtSendMemo.strNoDataLable = @"입력된 내통장메모가 없습니다. (선택)7자이내로 입력가능합니다";
    _txtCMSCode.strLableFormat = @"입력된 CMS코드는 %@ 입니다";
    _txtCMSCode.strNoDataLable = @"입력된 CMS코드가 없습니다. (선택)";
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
        
        _lblBalance.hidden = YES;
        [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
        _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
        _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
        
        _txtInAccountNo.text = @"";
        _txtInAmount.text = @"";
        _lblKorMoney.text = @"";
        _reservationDate.textField.text = @"";
        _btnSelectTime1.selected = YES;
        _btnSelectTime2.selected = NO;
        _txtRecvMemo.text = @"";
        _txtSendMemo.text = @"";
        _txtCMSCode.text = @"";
        
        NSArray * accountArray = [self outAccountList];
        
        if([accountArray count] != 0)
        {
            self.outAccInfoDic = accountArray[0];
            [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
            
            // 출금계좌가 변경되면 암호 초기화
            _txtAccountPW.text = @"";
        }
        else
        {
            [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
            _btnAccountNo.enabled = NO;
        }
    }
    
    // 추가인증 정보조회
    self.securityCenterService = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
    [_securityCenterService start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.encriptedPW = nil;
    
    [_btnAccountNo release];
    [_btnSelectBank release];
    [_lblBalance release];
    [_lblKorMoney release];
    [_txtInAccountNo release];
    [_txtInAmount release];
    [_txtRecvMemo release];
    [_txtSendMemo release];
    [_txtCMSCode release];
    [_txtAccountPW release];
    [_btnSelectTime1 release];
    [_btnSelectTime2 release];
    [_reservationDate release];
    
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnAccountNo:nil];
    [self setBtnSelectBank:nil];
    [self setLblBalance:nil];
    [self setLblKorMoney:nil];
    [self setTxtInAccountNo:nil];
    [self setTxtInAmount:nil];
    [self setTxtRecvMemo:nil];
    [self setTxtSendMemo:nil];
    [self setTxtCMSCode:nil];
    [self setTxtAccountPW:nil];
    [self setBtnSelectTime1:nil];
    [self setBtnSelectTime2:nil];
    [self setReservationDate:nil];
    
    self.securityCenterService = nil;
    self.securityCenterDataSet = nil;
    
    [super viewDidUnload];
}

@end
