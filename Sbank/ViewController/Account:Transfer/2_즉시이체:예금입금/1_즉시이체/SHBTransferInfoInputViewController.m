//
//  SHBTransferInfoInputViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTransferInfoInputViewController.h"
#import "SHBTransferComfirmViewController.h"
#import "SHBFreqTransferRegViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util

#import "SHBDeviceRegistServiceViewController.h"
#import "SHBIdentity2ViewController.h"
#import "SHBIdentity4ViewController.h"

@interface SHBTransferInfoInputViewController () <SHBIdentity2Delegate>
{
    int serviceType;
    NSString *encriptedPW;
    NSString *encriptedInAccNo;
    NSString *encriptedAmount;
    
    NSString *accGbn;       // 확장E2E 구분값
    NSUInteger accIdx;      // 확장E2E 인덱스
    
    int cmsFlag;
    
    SHBPopupView *comfirmPopupView;
    
    NSMutableArray *signDataArray;
    
    BOOL isMutiTransfer;
    int selectedTabIndex;
    
    BOOL isDuplicate;
    
    BOOL isWidgetSpeed;
}
@property (retain, nonatomic) NSString *encriptedPW;
@property (retain, nonatomic) NSString *encriptedInAccNo;
@property (retain, nonatomic) NSString *encriptedAmount;

@property (retain, nonatomic) NSString *accGbn;
@property (readonly, nonatomic) NSUInteger accIdx;

@property (nonatomic, retain) SHBPopupView *comfirmPopupView;
@property (nonatomic, retain) NSMutableArray *signDataArray;


- (BOOL)validationCheck;
- (BOOL)securityCenterCheck;
- (void)defaultTransferViewSetting;
- (void)additionTransferViewSetting;

@end

@implementation SHBTransferInfoInputViewController
@synthesize processFlag;
@synthesize service;
@synthesize outAccInfoDic;
@synthesize encriptedPW;
@synthesize encriptedInAccNo;
@synthesize encriptedAmount;
@synthesize accGbn;
@synthesize accIdx;

@synthesize comfirmPopupView;
@synthesize signDataArray;

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
            
            NSString *strOutAccNo = [self.outAccInfoDic[@"2"] stringByReplacingOccurrencesOfString:@"-" withString:@""];

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
            
            for(NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
            {
                if([dic[@"입금가능여부"] isEqualToString:@"1"]) // 정상교과장의 요청으로 예금종류 1 인 경우에서 바뀜(2013.04.03)  
                {
                    [tableDataArray addObject:@{
                     @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                     @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
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
            serviceType = 11;
            accGbn = @"SP";

            self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_LIST viewController:self] autorelease];
            [self.service start];
        }
            break;
        case 112500:    // 확인
        case 112600:    // 추가이체
        {
            if(![self validationCheck]) return;
            
            NSString *strOutAccNo = [self.outAccInfoDic[@"2"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strBankName = _btnSelectBank.titleLabel.text;
            NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            
            //이체금액
            self.encriptedAmount = [NSString stringWithFormat:@"<E2K_CHAR=%@>", [AppInfo encNfilterData:_txtInAmount.text]];
            
            if(sender.tag == 112600)
            {
                isDuplicate = NO;
                isMutiTransfer = YES;
                
                if([signDataArray count] == 5)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"추가이체는 최대 5건까지 가능합니다."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    [alert release];
                    
                    return;
                }
                
                for(NSDictionary *dic in signDataArray)
                {
                    if([[dic[@"SignData"][@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strOutAccNo] &&
                       [[dic[@"SignData"][@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strInAccNo] &&
                       [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] isEqualToString:strInAmount] &&
                       [dic[@"SignData"][@"입금은행"] isEqualToString:strBankName] &&
                       [dic[@"SignData"][@"받는통장메모"] isEqualToString:_txtRecvMemo.text])
                    {
                        isDuplicate = YES;
                    }
                }
            }
            else
            {
                _txtAccountPW.text = @"";
            }
            
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
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2049" viewController:self] autorelease];
                aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                            @"평생계좌번호" : strInAccNo,
                            }];
            }
            else
            {
                long long totTransAmt = [strInAmount longLongValue];
                
                for(NSDictionary *dic in signDataArray)
                {
                    totTransAmt += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] longLongValue];
                }
                
               // NSLog(@"accGbn %@",accGbn);
                aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                            @"출금계좌번호" : strOutAccNo,
                            @"출금계좌비밀번호" : self.encriptedPW,
                            @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                            @"입금계좌번호" : strInAccNo,
                            @"이체금액" : strInAmount,
                            @"목록합계금액" : [NSString stringWithFormat:@"%lld", totTransAmt],
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
                
                switch (processFlag)
                {
                    case 1: // 당행
                    {
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2001" viewController:self] autorelease];
                        
                        if (cmsFlag == 2)
                        {
                            aDataSet[@"거래구분"] = @"3";
                        }
                    }
                        break;
                    case 2: // 타행
                    {
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2011" viewController:self] autorelease];
                    }
                        break;
                    case 3: // 가상
                    {
                        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2041" viewController:self] autorelease];
                    }
                        break;
                }
                
                aDataSet[@"attributeNamed"] = @"전조회";
                aDataSet[@"attributeValue"] = @"true";
            }
            
            self.service.requestData = aDataSet;
            
            serviceType = 5 + processFlag;
            
            [self.service start];
            [aDataSet release];
        }
            break;
        case 112501:    // 이체실행
        {
            // 입금은행, 입금계좌, 금액, 받는통장메모, 내통장메모, CMS코드의 length가 모두 0인 경우 알럿 없음
            if (![_btnSelectBank.titleLabel.text isEqualToString:@"신한은행"] ||
                [_txtInAccountNo.text length] > 0 ||
                [_txtInAmount.text length] > 0 ||
                [_txtRecvMemo.text length] > 0 ||
                [_txtSendMemo.text length] > 0 ||
                [_txtCMSCode.text length] > 0) {
                
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"마지막 입력 건을 이체하기 위해선 '추가이체' 버튼을 눌러야 합니다. 마지막 건에 대한 추가이체 없이 계속 진행하시겠습니까?"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"예", @"아니오", nil] autorelease];
                
                [alert setTag:1100];
                [alert show];
                
                return;
            }
            
            _txtAccountPW.text = @"";
            
            AppInfo.commonDic = @{@"SignDataArray" : signDataArray};
            
            if (![self securityCenterCheck]) return;
            
            [self viewControllerDidSelectDataWithDic:nil];
        }
            break;
        case 112800:    // 취소
        {
            NSString *strMessage = [NSString stringWithFormat:@"순번%d의 이체내용을 취소하시겠습니까?", selectedTabIndex];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:strMessage
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"예", @"아니오", nil];
            
            alert.tag = 24680;
            [alert show];
            [alert release];
        }
            break;

        default:
            break;
    }
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

- (IBAction)selectTap:(UIButton *)sender {
    _btnTab.enabled = YES;
    _btnTab1.enabled = YES;
    _btnTab2.enabled = YES;
    _btnTab3.enabled = YES;
    _btnTab4.enabled = YES;
    _btnTab5.enabled = YES;

    sender.enabled = NO;
    
    selectedTabIndex = sender.tag % 10;
    
    if(sender == _btnTab)
    {
        [_cancelView removeFromSuperview];
        
        _inputView.frame = CGRectMake(0, 45, 317, 283);
        [_additionTransferBgView addSubview:_inputView];
        
        for(int i = 1; i < 6; i ++)
        {
            if(i <= [signDataArray count])
            {
                [self.view viewWithTag:112700 + i].hidden = NO;
            }
            else
            {
                [self.view viewWithTag:112700 + i].hidden = YES;
            }
        }
    }
    else
    {
        [_inputView removeFromSuperview];

        _cancelView.frame = CGRectMake(0, 32, 317, 318);
        [_additionTransferBgView addSubview:_cancelView];
        
        _lblData11.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"출금계좌번호표시용"];
        _lblData12.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"입금은행"];
        _lblData13.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"입금계좌번호"];
        _lblData14.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"수취인성명"];
        _lblData15.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"이체금액"];
        _lblData16.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"수수료"];
        _lblData17.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"받는통장메모"];
        _lblData18.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"내통장메모"];
        _lblData19.text = signDataArray[selectedTabIndex - 1][@"SignData"][@"CMS코드"];
        
        _lblTotCnt.text = [NSString stringWithFormat:@"%d건", [signDataArray count]];
        
        int totAmt = 0;
        int totInterest = 0;
        
        for(NSDictionary *dic in signDataArray)
        {
            totAmt += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] intValue];
            totInterest += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"수수료"]] intValue];
        }
        
        _lblTotAmt.text = [NSString stringWithFormat:@"%@(%@)원",
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totAmt]],
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totInterest]]];
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
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
        
        if (isWidgetSpeed)
        {
            isWidgetSpeed = NO;
            serviceType = 12;
            self.service = nil;
            NSLog(@"data:%@",self.data);
            self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_ITEM viewController:self] autorelease];
            self.service.previousData = [SHBDataSet dictionaryWithDictionary:@{
                                                                               @"KEY" : self.data[@"speedIndex"],
                                                                               //@"DATE" : self.data[@"updt"],
                                                                               }];
            [self.service start];
        }
        return NO;
    }
    
//    if ([aDataSet[@"블랙리스트차단구분"] isEqualToString:@"5"])
//    {
//        //3개월 이상 이체 안한고객 ARS 인증 태움
//        NSString *msg = @"전자금융 의심거래 방지를 위한\n본인확인절차 강화로\n추가인증을 진행하게\n되었습니다.\n추가인증 완료 후 거래하여\n주시기 바랍니다.";
//        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10987 title:nil message:msg];
//        return NO;
//    }
    switch (serviceType) {
        case -1:
        {
            serviceType = 0;
            
            // 추가인증 정보조회
            self.securityCenterService = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
            [_securityCenterService start];
        }
            break;
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
            long long remainPaymentMoney = 0;
            long long transferMoney = 0;
            
            remainPaymentMoney = aDataSet[@"지불가능잔액->originalValue"] != nil ? [aDataSet[@"지불가능잔액->originalValue"] longLongValue] : [aDataSet[@"지불가능잔액"] longLongValue];
            transferMoney = [aDataSet[@"이체금액->originalValue"] longLongValue];
            
            if([signDataArray count] > 0)
            {
                
                for(NSDictionary *dic in signDataArray)
                {
                    if([dic[@"SignData"][@"출금계좌번호"] isEqualToString:self.outAccInfoDic[@"2"]])
                    {
                        transferMoney += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] longLongValue];
                    }
                }
            }
            
            if (remainPaymentMoney < transferMoney)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"이체하려는 금액이 출금가능잔액을 초과합니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
                [alert release];
                
                self.service = nil;
                
                return NO;
            }

            NSString *strFee = @"";
            if(serviceType == 8)
            {
                strFee = [NSString stringWithFormat:@"%@원", aDataSet[@"수수료"]];
            }
            else
            {
                strFee = (aDataSet[@"적용수수료금액"] == nil || [aDataSet[@"적용수수료금액"] isEqualToString:@""]) ? @"0원" : [NSString stringWithFormat:@"%@원", aDataSet[@"적용수수료금액"]];
            }
            
            NSMutableDictionary *signInfoDic = [[[NSMutableDictionary alloc] initWithDictionary:
                                                 @{
                                                 @"거래일자" : aDataSet[@"COM_TRAN_DATE"],
                                                 @"거래시간" : aDataSet[@"COM_TRAN_TIME"],
                                                 @"출금계좌번호" : self.outAccInfoDic[@"2"], //([aDataSet[@"구출금계좌번호"] length] > 0) ? aDataSet[@"구출금계좌번호"] : aDataSet[@"출금계좌번호"],
                                                 @"출금계좌번호표시용" : _btnAccountNo.titleLabel.text,
                                                 @"입금은행" : [AppInfo.codeList bankNameFromCode:aDataSet[@"입금은행코드"]],
                                                 @"입금계좌번호" : _txtInAccountNo.text, //([aDataSet[@"구입금계좌번호"] length] > 0) ? aDataSet[@"구입금계좌번호"] : aDataSet[@"입금계좌번호"],
                                                 @"수취인성명" : aDataSet[@"입금계좌성명"],
                                                 @"이체금액" : [NSString stringWithFormat:@"%@원", _txtInAmount.text],
                                                 @"CMS코드" : _txtCMSCode.text,
                                                 @"받는통장메모" : aDataSet[@"입금계좌통장메모"],
                                                 @"내통장메모" : aDataSet[@"출금계좌통장메모"],
                                                 @"중복이체여부" : ([aDataSet[@"중복여부"] isEqualToString:@"1"]) ? @"중복이체승인함" : (isDuplicate ? @"중복이체승인함" : @"해당없음"),
                                                 @"입금자성명" : aDataSet[@"출금계좌성명"],
                                                 @"수수료우대내역" : @"",
                                                 @"수수료" : strFee,
                                                 @"전문구분" : (cmsFlag == 2) ? @"3" : @"1",
                                                 @"출금은행구분" : self.outAccInfoDic[@"은행구분"],
                                                 @"출금계좌비밀번호" : self.encriptedPW,
                                                 @"전문번호" : AppInfo.serviceCode,
                                                 }] autorelease];
            signInfoDic[@"SignDataList"] = @[@"제목", @"거래일자", @"거래시간", @"출금계좌번호", @"입금은행", @"입금계좌번호", @"수취인성명", @"이체금액", @"수수료", @"받는통장메모", @"내통장메모", @"CMS코드", @"중복이체여부"];

            switch (serviceType) {
                case 6:
                {
                    signInfoDic[@"제목"] = @"당행이체";
                }
                    break;
                case 7:
                {
                    signInfoDic[@"제목"] = @"타행이체";
                    
                    int temp1 = [[aDataSet[@"정상수수료금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
                    int temp2 = [[aDataSet[@"적용수수료금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue];
                    if(temp1 != temp2)
                    {
                        if([aDataSet[@"수수료우대사유코드"] isEqualToString:@"133"])
                        {
                            signInfoDic[@"수수료우대내역"] = [NSString stringWithFormat:@"%@님은 법원고객입니다. 수수료 %@원으로 우대받으셨습니다.", aDataSet[@"출금계좌성명"], aDataSet[@"적용수수료금액"]];
                        }
                        else
                        {
                            signInfoDic[@"수수료우대내역"] = [NSString stringWithFormat:@"%@원을 우대받으셨습니다. 우대사유 : %@",
                                                       [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", temp1 - temp2]],
                                                       aDataSet[@"수수료우대사유"]];
                        }
                    }
                }
                    break;
                case 8:
                {
                    signInfoDic[@"제목"] = @"가상계좌 이체";
                }
                    break;
                    
                default:
                    break;
            }
            AppInfo.commonDic = (NSDictionary *)signInfoDic;

            _lblData01.text = AppInfo.commonDic[@"출금계좌번호표시용"];
            _lblData02.text = AppInfo.commonDic[@"입금은행"];
            _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
            _lblData04.text = AppInfo.commonDic[@"수취인성명"];
            _lblData05.text = AppInfo.commonDic[@"이체금액"];
            _lblData06.text = AppInfo.commonDic[@"수수료"];
            _lblData07.text = AppInfo.commonDic[@"받는통장메모"];
            _lblData08.text = AppInfo.commonDic[@"내통장메모"];
            _lblData09.text = AppInfo.commonDic[@"CMS코드"];
            
            NSString *receiveData = [[[NSString alloc] initWithData:aContent encoding:NSUTF8StringEncoding] autorelease];
            NSArray *tempArray = [receiveData componentsSeparatedByString:@"?>"];

            [signDataArray addObject:@{@"SignData" : signInfoDic, @"RecevieData" : tempArray[1]}];
            
            if ([aDataSet[@"중복여부"] isEqualToString:@"1"] || isDuplicate)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"중복이체 여부를 확인바랍니다."
                                                                message:@"당일 동일한 계좌, 동일한 금액의 이체거래가 있습니다. 또는 목록에 동일한 거래가 있습니다. 이체 내용이 정확한지 다시 한 번 확인하여 주시기 바랍니다. \n이체거래를 계속하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오",nil];
                
                alert.tag = 4989;
                [alert show];
                [alert release];
                
                self.service = nil;
                
                if(isMutiTransfer)
                {
                    [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
                    _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
                    _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
                    
                    _txtInAccountNo.text = @"";
                    _txtInAmount.text = @"";
                    _txtRecvMemo.text = @"";
                    _txtSendMemo.text = @"";
                    _txtCMSCode.text = @"";
                    _lblKorMoney.text = @"";
                }
                
                
                return NO;
            }
            
            if(isMutiTransfer)
            {
                [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
                _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
                _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
                _txtInAccountNo.text = @"";
                _txtInAmount.text = @"";
                _txtRecvMemo.text = @"";
                _txtSendMemo.text = @"";
                _txtCMSCode.text = @"";
                _lblKorMoney.text = @"";
                
                [comfirmPopupView showInView:self.navigationController.view animated:YES];
                [self additionTransferViewSetting];
            }
            else
            {
                [signDataArray removeAllObjects];
                
                if (![self securityCenterCheck]) return NO;
                
                [self viewControllerDidSelectDataWithDic:nil];
            }
            
        }
            break;
        case 9: // 평생계좌 이체
        {
            self.service = nil;
            
            NSString *tmp = aDataSet[@"입금모가상계좌번호"];
            
            NSString *strOutAccNo = [self.outAccInfoDic[@"2"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strBankName = _btnSelectBank.titleLabel.text;
            NSString *strInAmount = [_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];

            SHBDataSet *dataSet = [[SHBDataSet alloc] initWithDictionary:@{
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
                                   }];
            
            if(tmp == nil || [tmp length] == 0)
            {
                serviceType = 6;
                
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2001" viewController:self] autorelease];
                
                if (cmsFlag == 2)
                {
                    dataSet[@"거래구분"] = @"3";
                }
            }
            else
            {
                serviceType = 8;
                
                self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2041" viewController:self] autorelease];
                
                dataSet[@"OA가상계좌번호"] = tmp;
            }
            
            dataSet[@"attributeNamed"] = @"전조회";
            dataSet[@"attributeValue"] = @"true";
            
            self.service.requestData = dataSet;
            [self.service start];
            [dataSet release];
        }
            break;
        case 10:
        {
            if([aDataSet[@"RESULT"] isEqualToString:@"OK"])
            {
                [signDataArray removeObjectAtIndex:selectedTabIndex - 1];
                
                if([signDataArray count]> 0)
                {
                    [self selectTap:_btnTab];
                }
                else
                {
                    [self defaultTransferViewSetting];
                }
            }
        }
            break;
        case 11:
        {
            self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                NSString *strMessage = @"등록된 스피드이체 업무가 없습니다.\n‘스피드이체’ 등록 화면으로 이동 하시겠습니까?\n\n(스피드이체 등록은 조회이체>계좌관리>스피드이체관리 메뉴에서 ‘등록’ '변경' 하실 수 있습니다.)";
                
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
        case 12:
        {
            
            //위젯스피드이체
            BOOL isFind = YES;
            //NSMutableArray *tmpDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            //tmpDataArray = [aDataSet arrayWithForKeyPath:@"data.WIDGET_INFO"];
            //NSLog(@"aaaa:%@",aDataSet);
            /*
            if(tmpDataArray == nil || [tmpDataArray count] == 0)
            {
                
                NSString *strMessage = @"등록된 스피드이체 업무가 없습니다.\n‘스피드이체’ 등록 화면으로 이동 하시겠습니까?\n\n(스피드이체 등록은 조회이체>계좌관리>스피드이체관리 메뉴에서 ‘등록’ '변경' 하실 수 있습니다.)";
                
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
            */
            SHBDataSet *findSet = (SHBDataSet *)aDataSet;
//            for(SHBDataSet *dic in tmpDataArray)
//            {
//                
//                if ([self.data[@"speedIndex"] isEqualToString:dic[@"등록일시"]])
//                {
//                    //위젯에 등록된 스피드 이체건을 찾음
//                    isFind = YES;
//                    findSet = dic;
//                    NSLog(@"aaaa:%@",findSet);
//                    break;
//
//                }
//            }
            
            
            if (isFind)
            {
                
                NSString *strAccNo = [findSet[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                /*
                NSString *strCurAccNo = [self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *strCurOldAccNo = [self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if ([strCurAccNo length] > 0 || [strCurOldAccNo length] > 0)
                {
                    if(![strAccNo isEqualToString:strCurAccNo] &&
                       ![strAccNo isEqualToString:strCurOldAccNo])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"출금계좌번호가 변경되었습니다."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"확인"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                        [alert release];
                        
                        _txtAccountPW.text = @"";
                    }
                }
                */
                for(NSDictionary *dic in [self outAccountList])
                {
                    if([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo] ||
                       [[dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                    {
                        self.outAccInfoDic = dic;
                        
                        if ([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                        {
                            [_btnAccountNo setTitle:dic[@"출금계좌번호"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [_btnAccountNo setTitle:dic[@"구출금계좌번호"] forState:UIControlStateNormal];
                        }
                        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
                        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
                        
                        _lblBalance.hidden = YES;
                        break;
                    }
                }
                
                
                [_btnSelectBank setTitle:[AppInfo.codeList bankNameFromCode:findSet[@"입금은행코드"]] forState:UIControlStateNormal];
                _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
                _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
                
                _txtInAccountNo.text = findSet[@"입금계좌번호"];
                _txtInAmount.text = [SHBUtility normalStringTocommaString:[findSet[@"이체금액"] stringByReplacingOccurrencesOfString:@"원" withString:@""]];
                _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]];
                _txtRecvMemo.text = findSet[@"받는분통장메모"];
                _txtSendMemo.text = findSet[@"보내는분통장메모"];
                _txtCMSCode.text = @"";
                
            }else
            {
                //찾지못한경우
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:13579 title:nil message:@"등록된 스피드이체 업무가 없습니다.\n‘스피드이체’ 등록 화면으로 이동 하시겠습니까?\n\n(스피드이체 등록은 조회이체>계좌관리>스피드이체관리 메뉴에서 ‘등록’ '변경' 하실 수 있습니다.)"];
                _txtAccountPW.text = @"";
                
                return NO;
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

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    SHBTransferComfirmViewController *nextViewController = [[[SHBTransferComfirmViewController alloc] initWithNibName:@"SHBTransferComfirmViewController" bundle:nil] autorelease];
    [self.navigationController pushFadeViewController:nextViewController];
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    switch ([alertView tag]) {
        case 100:
        {
            serviceType = -1;
            
            //NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, REMOVE_TRANSFER_URL, @""];
            NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
            NSString *strBody = @"";
            
            if([self.signDataArray count] == 0)
            {
                strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"A\"/></REMOVE>"];
            }
            else
            {
                strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"%d\"/></REMOVE>", [self.signDataArray count] - 1];
            }
            
            [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
        }
            break;
        case 13579:
        {
            if (buttonIndex == 0)
            {
                SHBFreqTransferRegViewController *nextViewController = [[[SHBFreqTransferRegViewController alloc] initWithNibName:@"SHBFreqTransferRegViewController" bundle:nil] autorelease];
                nextViewController.nType = 9;
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 24680:
        {
            if (buttonIndex == 0)
            {
                serviceType = 10;
                
                //NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, REMOVE_TRANSFER_URL, @""];
                NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
                NSString *strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"%d\"/></REMOVE>", selectedTabIndex - 1];
                [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
            }
        }
            break;
        case 4989:
        {
            if (buttonIndex == 0) {
                if(isMutiTransfer)
                {
                    _txtInAmount.text = @"";
                    _txtRecvMemo.text = @"";
                    _txtSendMemo.text = @"";
                    _txtCMSCode.text = @"";
                    _lblKorMoney.text = @"";
                    
                    [comfirmPopupView showInView:self.navigationController.view animated:YES];
                    [self additionTransferViewSetting];
                }
                else
                {
                    [signDataArray removeAllObjects];
                    
                    if (![self securityCenterCheck]) return;
                    
                    [self viewControllerDidSelectDataWithDic:nil];
                }
            }
            else
            {
                serviceType = -1;
                
                //NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, REMOVE_TRANSFER_URL, @""];
                NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
                NSString *strBody = @"";
                
                if([self.signDataArray count] == 0)
                {
                    strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"A\"/></REMOVE>"];
                }
                else
                {
                    strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"%d\"/></REMOVE>", [self.signDataArray count] - 1];
                }
                
                [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
                
                [self.signDataArray removeLastObject];
                
                if([self.signDataArray count] == 0)
                {
                    [self defaultTransferViewSetting];
                }
                else
                {
                    selectedTabIndex = [self.signDataArray count];
                }
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
            break;
            
        case 1100:
        {
            if (buttonIndex == alertView.firstOtherButtonIndex) {
                _txtAccountPW.text = @"";
                
                AppInfo.commonDic = @{@"SignDataArray" : signDataArray};
                
                if (![self securityCenterCheck]) return;
                
                [self viewControllerDidSelectDataWithDic:nil];
            }
        }
            break;
//        case 10987:
//        {
//            if (AppInfo.lastViewController != nil)
//            {
//                AppInfo.lastViewController = nil;
//            }
//            SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
//            [viewController setServiceSeq:SERVICE_2MONTH_OVER];
//            viewController.needsLogin = YES;
//            [self checkLoginBeforePushViewController:viewController animated:YES];
//            //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
//            [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@""];
//            [viewController release];
//        }
//            break;
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
    
    if([string length] > 1)
    {
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
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

- (void)onPressSecureKeypad:(NSString*)pPlainText encText:(NSString*)pEncText
{
     //NSLog(@"pPlainText:%@",pPlainText);
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
        case 3: //본인계좌
        {
            self.encriptedInAccNo = @"";
            
            [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
            _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
            _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
            _txtInAccountNo.text = self.dataList[anIndex][@"2"];
            
            
            _txtInAmount.text = @"";
            _lblKorMoney.text = @"";
            _txtRecvMemo.text = @"";
            _txtSendMemo.text = @"";
            _txtCMSCode.text = @"";
            
            //E2E 확장 본인계좌
            accIdx = anIndex;
           // NSLog(@"accIdx %d", anIndex);

            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112400];
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
            _txtRecvMemo.text = @"";
            _txtSendMemo.text = @"";
            _txtCMSCode.text = @"";

            
            
            //E2E 확장
            accIdx = anIndex;
            
            
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:serviceType == 4 ? 112401 : 112402];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
        case 11:  //스피드이체
        {
            self.encriptedInAccNo = @"";
            
            NSString *strAccNo = [self.dataList[anIndex][@"3"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strCurAccNo = [self.outAccInfoDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strCurOldAccNo = [self.outAccInfoDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if(![strAccNo isEqualToString:strCurAccNo] &&
               ![strAccNo isEqualToString:strCurOldAccNo])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금계좌번호가 변경되었습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                _txtAccountPW.text = @"";
            }

            for(NSDictionary *dic in [self outAccountList])
            {
                if([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo] ||
                   [[dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                {
                    self.outAccInfoDic = dic;
                    
                    if ([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                    {
                        [_btnAccountNo setTitle:dic[@"출금계좌번호"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [_btnAccountNo setTitle:dic[@"구출금계좌번호"] forState:UIControlStateNormal];
                    }
                    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
                    _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
                    
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
            _txtCMSCode.text = @"";
            
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
        case 11:
        {
            UIButton *btn = (UIButton *)[self.inputView viewWithTag:112403];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, btn);
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)validationCheck
{
	NSString *strAlertMessage = nil;		// 출력할 메세지
    
    NSString *strInAccNo = [_txtInAccountNo.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strBankName = _btnSelectBank.titleLabel.text;

    _txtInAccountNo.text = strInAccNo;
    
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
    
	if([strInAccNo length] == 12 && [strBankName isEqualToString:@"신한은행"] &&
       ([[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] >= 250
        && [[strInAccNo substringWithRange:NSMakeRange(0, 3)] intValue] <= 259))
	{
        strAlertMessage = @"펀드계좌는 즉시이체에서 이체하실 수 없습니다.";
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
        
        if(isMutiTransfer && [signDataArray count] == 0) [self defaultTransferViewSetting];
        
		return NO;
	}
	
	return YES;
}

- (NSString *)getServiceCode:(NSString *)strBankName withAccCode:(NSString *)strAccCode
{
    strAccCode = [strAccCode stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSInteger flag;
    
    // 1:당행, 2:타행, 3:가상, 4:평생계좌 구분
    if([strBankName isEqualToString:@"신한은행"] || [strBankName isEqualToString:@"구조흥은행"])
    {
        if([strAccCode length] == 11)
        {
            if([strBankName isEqualToString:@"신한은행"])
            {
                if([[strAccCode substringFromIndex:3] hasPrefix:@"99"])
                {
                    flag = 3;
                }
                else
                {
                    flag = 1;
                }
            }
            else
            {
                flag = 3;
            }
        }
        else if([strAccCode length] == 14)
        {
            if([[strAccCode substringFromIndex:3] hasPrefix:@"901"] || [strAccCode hasPrefix:@"562"])
            {
                flag = 3;
            }
            else
            {
                flag = 1;
            }
        }
        else
        {
            flag = 1;
        }
        
        if([strAccCode length] >= 10 && [strAccCode length] <= 14 && [strAccCode hasPrefix:@"0"])
        {
            flag = 4;
        }
    }
    else
    {
        flag = 2;
    }
    
    NSString *serviceCode = @"";
    
    switch (flag)
    {
        case 1: // 당행
        {
            serviceCode = @"D2003";
        }
            break;
        case 2: // 타행
        {
            serviceCode = @"D2013";
        }
            break;
        case 3: // 가상
        {
            serviceCode = @"D2043";
        }
            break;
        case 4: // 평생
        {
            serviceCode = @"D2003";
        }
            break;
    }
    
    return serviceCode;
}

- (BOOL)securityCenterCheck // 이체정보 입력 후 "추가이체", "확인" 버튼 선택 시 호출됨
{
    // (5) <추가인증 여부 체크>
    if (![_securityCenterDataSet[@"C2403_2채널인증여부"] isEqualToString:@"Y"]) { // 추가인증 안한 고객인 경우(C2403_2채널인증여부:Y가 아닐경우)
        
        // (1) <보안매체>
        if (![_securityCenterDataSet[@"점자보안카드사용여부"] isEqualToString:@"Y"] &&
            ![_securityCenterDataSet[@"OTP사용여부"] isEqualToString:@"Y"]) { // 보안카드인 경우(점자보안카드사용여부 == N and OTP사용여부 == N)
            
            long long inAmount = [[_txtInAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체금액
            
            if (isMutiTransfer) { // 추가이체인 경우
                
                for(NSDictionary *dic in signDataArray) {
                    
                    inAmount += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] longLongValue]; // 이체금액 합산
                }
                
                AppInfo.transferDic = @{
                                        @"추가이체여부" : @"Y",
                                        @"입금은행명" : _btnSelectBank.titleLabel.text,
                                        @"추가이체건수" : [NSString stringWithFormat:@"%d", [signDataArray count]],
                                        @"추가_입금은행코드" : AppInfo.codeList.bankCode[signDataArray[0][@"SignData"][@"입금은행"]],
                                        @"추가_입금은행명" : signDataArray[0][@"SignData"][@"입금은행"],
                                        @"추가_입금계좌번호" : signDataArray[0][@"SignData"][@"입금계좌번호"],
                                        @"추가_입금계좌성명" : signDataArray[0][@"SignData"][@"수취인성명"],
                                        @"추가_이체금액" : [SHBUtility commaStringToNormalString:signDataArray[0][@"SignData"][@"이체금액"]],
                                        @"계좌번호_상품코드" : @"",
                                        @"거래금액" : [NSString stringWithFormat:@"%lld", inAmount],
                                        @"서비스코드" : [self getServiceCode:signDataArray[0][@"SignData"][@"입금은행"]
                                                              withAccCode:signDataArray[0][@"SignData"][@"입금계좌번호"]],
                                        };
            }
            else { // 일반이체인 경우
                
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
                                        @"서비스코드" : [self getServiceCode:_btnSelectBank.titleLabel.text
                                                              withAccCode:_txtInAccountNo.text],
                                        };
            }
            
            long long checkAmount = [[_securityCenterDataSet[@"이체추가인증기준금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]; // 이체추가인증기준금액
            
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
                        
                        [viewController executeWithTitle:@"즉시이체/예금입금" Step:0 StepCnt:0 NextControllerName:nil];
                        [viewController subTitle:@"추가인증 방법 선택"];
                        
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES; // 수취인 조회
}

- (void)defaultTransferViewSetting
{
    isMutiTransfer = NO;
    selectedTabIndex = 1;

    [signDataArray removeAllObjects];
    
    [_inputView removeFromSuperview];
    [_additionTransferBgView removeFromSuperview];
    [_buttonView2 removeFromSuperview];
    
    _inputView.frame = CGRectMake(0, 125, 317, 283);
    _buttonView1.frame = CGRectMake(0, 418, 317, 86);
    
    [_contentsView addSubview:_inputView];
    [_contentsView addSubview:_buttonView1];
    
    self.contentScrollView.contentSize = CGSizeMake(317, 504);
    _contentsView.frame = CGRectMake(0, 0, 317, 504);
    contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
}

- (void)additionTransferViewSetting
{
    isMutiTransfer = YES;
    
    if([signDataArray count] == 1)
    {
        [_inputView removeFromSuperview];
        [_buttonView1 removeFromSuperview];
        
        _additionTransferBgView.frame = CGRectMake(0, 125, 317, 350);
        
        _buttonView2.frame = CGRectMake(0, 485, 317, 117);
        
        [_contentsView addSubview:_additionTransferBgView];
        [_contentsView addSubview:_buttonView2];
        
        self.contentScrollView.contentSize = CGSizeMake(317, 602);
        _contentsView.frame = CGRectMake(0, 0, 317, 602);
        contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
    }
    
    [self selectTap:_btnTab];
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

#pragma mark - Push
- (void)executeWithDic:(NSMutableDictionary *)mDic	// 푸쉬로 왔으면
{
	[super executeWithDic:mDic];
	if (mDic) {
        self.data = (NSDictionary *)mDic;
	}
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

    self.title = @"즉시이체/예금입금";
    self.strBackButtonTitle = @"즉시이체 1단계";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"즉시이체" maxStep:3 focusStepNumber:1] autorelease]];
    
    self.contentScrollView.contentSize = CGSizeMake(317.0f, 504.0f);
    contentViewHeight = contentViewHeight > self.contentScrollView.contentSize.height ? contentViewHeight : self.contentScrollView.contentSize.height;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222005;
    
    isDuplicate = NO;
    
    // 계좌비밀번호
    [self.txtAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 입금계좌번호
    [self.txtInAccountNo showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:17];
    self.txtInAccountNo.secureTextEntry=NO;
    
    [accGbn release]; accGbn = nil;
    
    processFlag = 0;
    cmsFlag = 0;
    
    comfirmPopupView = [[SHBPopupView alloc] initWithTitle:@"수취인 확인" subView:_comfirmView];
    comfirmPopupView.delegate = self;
    
    isMutiTransfer = NO;
    selectedTabIndex = 1;
    signDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    isWidgetSpeed = NO;
    serviceType = -1;
    
//    NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
//    NSString *strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"A\"/></REMOVE>"];
//    [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
    
    if(!self.isPushAndScheme)
    {
        NSDictionary *dic = self.outAccInfoDic[@"계좌정보상세"];
        
        self.outAccInfoDic = @{
        @"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
        @"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
        @"은행코드" : [dic objectForKey:@"은행코드"],
        @"신계좌변환여부" : [dic objectForKey:@"신계좌변환여부"],
        @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
        @"출금계좌번호" : [dic objectForKey:@"계좌번호"],
        @"구출금계좌번호" : [dic objectForKey:@"구계좌번호"] == nil ? @"" : [dic objectForKey:@"구계좌번호"],
        };
        
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
    }
    else
    {
        if([self.data[@"category"] isEqualToString:@"01"])
        {
            NSString *strAccNo = self.data[@"withdrawalAccNo"];
            
            for(NSDictionary *dic in [self outAccountList])
            {
                if([[dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo] ||
                   [[dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strAccNo])
                {
                    self.outAccInfoDic = dic;
                    
                    [_btnAccountNo setTitle:dic[@"2"] forState:UIControlStateNormal];
                    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
                    _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
                    break;
                }
            }
        }
        else if ([self.data[@"category"] isEqualToString:@"03"])
        {
            //2014.07.11 추가(붉은용오름)
            //위젯스피드 이체
            NSLog(@"self.data:%@",self.data);
            
            isWidgetSpeed = YES;
            
            //E2114 추가인증정보 가져오는 서비스를 날린뒤 스피드이체 정보 서비스 전문을 날린다.
            
        }
        else
        {
            self.outAccInfoDic = [self outAccountList][0];
            [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
            _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
            _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
        }
        
        _txtInAccountNo.text = self.data[@"depositAccNo"];
        _txtInAmount.text = [SHBUtility normalStringTocommaString:self.data[@"amount"]];
        _lblKorMoney.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:_txtInAmount.text]];
    }
    
   // _txtInAccountNo.strLableFormat = @"입력된 입금계좌는 %@ 입니다";
   // _txtInAccountNo.strNoDataLable = @"입력된 입금계좌가 없습니다";
    
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

    BOOL isExecClear = NO;
    
    // 추가이체가 아닌경우는 세션을 클리어 한다.
    if([signDataArray count] == 0)
    {
        serviceType = -1;
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
        NSString *strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"A\"/></REMOVE>"];
        [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
        
        isExecClear = YES;
    }
    
    if(AppInfo.isNeedClearData)
    {
        if(!isExecClear)
        {
            serviceType = -1;
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, REMOVE_TRANSFER_URL, @""];
            NSString *strBody = [NSString stringWithFormat:@"<REMOVE><INDEX value=\"A\"/></REMOVE>"];
            [self.client request:strURL postBody:strBody signText:nil signTitle:nil];
        }
        
        AppInfo.isNeedClearData = NO;
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
        
        processFlag = 0;
        cmsFlag = 0;
        
        _lblBalance.hidden = YES;
        _lblKorMoney.text = @"";
        [_btnSelectBank setTitle:@"신한은행" forState:UIControlStateNormal];
        _btnSelectBank.accessibilityLabel = [NSString stringWithFormat:@"선택된 입금은행은 %@ 입니다", _btnSelectBank.titleLabel.text];
        _btnSelectBank.accessibilityHint = @"입금은행을 바꾸시려면 이중탭 하십시오";
        
        _txtInAccountNo.text = @"";
        _txtInAmount.text = @"";
        _txtRecvMemo.text = @"";
        _txtSendMemo.text = @"";
        _txtCMSCode.text = @"";

        [self defaultTransferViewSetting];
    }
    
    if (serviceType != -1) {
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        // 추가인증 정보조회
        self.securityCenterService = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
        [_securityCenterService start];
    }
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
    [_comfirmView release];
    [comfirmPopupView release];
    [signDataArray release];
    
    [_contentsView release];
    [_inputView release];
    [_buttonView1 release];
    [_buttonView2 release];
    [_additionTransferBgView release];
    [_lblTotCnt release];
    [_lblTotAmt release];
    [_btnTab release];
    [_btnTab1 release];
    [_btnTab2 release];
    [_btnTab3 release];
    [_btnTab4 release];
    [_btnTab5 release];
    [_cancelView release];
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [_lblData11 release];
    [_lblData12 release];
    [_lblData13 release];
    [_lblData14 release];
    [_lblData15 release];
    [_lblData16 release];
    [_lblData17 release];
    [_lblData18 release];
    [_lblData19 release];
    
    [_securityCenterService release]; _securityCenterService = nil;
    [_securityCenterDataSet release]; _securityCenterDataSet = nil;
    
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
    [self setComfirmView:nil];
    [self setComfirmPopupView:nil];
    
    [self setContentsView:nil];
    [self setInputView:nil];
    [self setButtonView1:nil];
    [self setButtonView2:nil];
    [self setAdditionTransferBgView:nil];
    [self setLblTotCnt:nil];
    [self setLblTotAmt:nil];
    [self setBtnTab:nil];
    [self setBtnTab1:nil];
    [self setBtnTab2:nil];
    [self setBtnTab3:nil];
    [self setBtnTab4:nil];
    [self setBtnTab5:nil];
    [self setCancelView:nil];
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [self setLblData11:nil];
    [self setLblData12:nil];
    [self setLblData13:nil];
    [self setLblData14:nil];
    [self setLblData15:nil];
    [self setLblData16:nil];
    [self setLblData17:nil];
    [self setLblData18:nil];
    [self setLblData19:nil];
    [super viewDidUnload];
}
@end
