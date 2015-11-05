//
//  SHBTransferComfirmViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTransferComfirmViewController.h"
#import "SHBTransferCompleteViewController.h"
#import "SHBCertElectronicSignViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"

@interface SHBTransferComfirmViewController ()<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
    
    NSArray *dataArray;
}
@property (nonatomic, retain) NSArray *dataArray;
@end

@implementation SHBTransferComfirmViewController
@synthesize dataArray;

- (IBAction)selectTap:(UIButton *)sender {
    ((UIButton *)[_multiView viewWithTag:10]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:11]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:12]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:13]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:14]).enabled = YES;
    
    sender.enabled = NO;
    
    NSDictionary * dic = self.dataArray[sender.tag % 10][@"SignData"];
    _lblData01.text = dic[@"출금계좌번호표시용"];
    _lblData02.text = dic[@"입금은행"];
    _lblData03.text = dic[@"입금계좌번호"];
    _lblData04.text = dic[@"수취인성명"];
    _lblData05.text = dic[@"이체금액"];
    _lblData06.text = dic[@"수수료"];
    _lblData07.text = dic[@"받는통장메모"];
    _lblData08.text = dic[@"내통장메모"];
    _lblData09.text = dic[@"CMS코드"];
}

#pragma mark - 

- (NSString *)encodeStringXML:(NSString *)stringXML
{
    // SHBHTTPClient 와 동일하게 수정해야함
    //2014.09.01 윤운용 수정
    
    //NSLog(@"stringXML:%@",stringXML);
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
	//stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
	//stringXML = [stringXML stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	//stringXML = [stringXML stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    //stringXML = [stringXML stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
    return stringXML;
}

- (NSString *)decodeStringXML:(NSString *)stringXML
{
    //2014.09.01 윤운용 수정
    /*
    NSLog(@"stringXML:%@",stringXML);
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3C" withString:@"<"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3E" withString:@">"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%5B" withString:@"["];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];
    */
    
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3C" withString:@"<"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3E" withString:@">"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%5B" withString:@"["];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    return stringXML;
}

#pragma mark - Delegate : SHBSecretMediaDelegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    NSLog(@"confirmSecretData:%@",confirmData);
    NSLog(@"confirmSecretResult:%i",confirm);
    NSLog(@"confirmSecretMedia:%i",mediaType);
    
    AppInfo.eSignNVBarTitle = @"즉시이체/예금입금";

    AppInfo.electronicSignString = @"";
    
    if(self.dataArray)
    {
        AppInfo.electronicSignCode = @"D2003_MULTI";
        AppInfo.electronicSignTitle = @"추가이체";
        
        [AppInfo addElectronicSign:@""];
        
        NSMutableString *vectorXml = [NSMutableString stringWithFormat:@"<vector result=\"%d\" keepTransactionSession='true'>", [self.dataArray count]];
        int cnt = 1;
        for(NSDictionary *dic in self.dataArray)
        {
            NSDictionary *signDic = dic[@"SignData"];
            
            // 1.전문 생성
            [vectorXml appendFormat:@"<data vectorkey=\"%d\">", cnt - 1];

            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{}] autorelease];
            
            // 출금계좌 비밀번호 재설정(aDataSet에는 빈값이 들어 있다)
            aDataSet[@"출금계좌비밀번호"] = signDic[@"출금계좌비밀번호"];
            aDataSet[@"출금은행구분"] = signDic[@"출금은행구분"];
            
            if([signDic[@"전문번호"] isEqualToString:@"D2001"])   // 당행
            {
                aDataSet[@"전문구분"] = signDic[@"전문구분"];
                aDataSet[@"이체합계금액"] = [SHBUtility commaStringToNormalString:signDic[@"이체금액"]];

                aDataSet.serviceCode = @"D2003";
            }
            else if([signDic[@"전문번호"] isEqualToString:@"D2011"])  // 타행
            {
                aDataSet[@"이체합계금액"] = [SHBUtility commaStringToNormalString:signDic[@"이체금액"]];
                aDataSet[@"적용수수료금액"] = [SHBUtility commaStringToNormalString:signDic[@"수수료"]];
                
                aDataSet.serviceCode = @"D2013";
            }
            else if([signDic[@"전문번호"] isEqualToString:@"D2041"])  // 가상계좌
            {
                aDataSet.serviceCode = @"D2043";
                aDataSet[@"대체금액"] = [SHBUtility commaStringToNormalString:signDic[@"이체금액"]];
                
            }
            aDataSet[@"COM_SVC_CODE"] = aDataSet.serviceCode;

            NSMutableString *rootElement = [NSMutableString string];
            
            // requestMessage, responseMessage 끝부분에 _M을 붙여 주어야 한다.
            NSString *targetServer = [NSString stringWithFormat:@"S_RIB%@_M", aDataSet.serviceCode];
            NSString *responseMessage = [NSString stringWithFormat:@"R_RIB%@_M", aDataSet.serviceCode];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[dic[@"RecevieData"] componentsSeparatedByString:@"><"]];
            [rootElement appendFormat:@"%@ requestMessage=\"%@\" responseMessage=\"%@\" serviceCode=\"%@\"> ", tempArray[0], targetServer, responseMessage, aDataSet.serviceCode];
            [rootElement appendFormat:@"%@", [self.dataParser stringForDataSet:aDataSet]];

            for(NSString *strData in tempArray)
            {
                strData = [NSString stringWithFormat:@"<%@>", strData];
                if([strData rangeOfString:@"/>"].location != NSNotFound)
                {
                    if(![strData hasPrefix:@"<출금계좌비밀번호 "] && ![strData hasPrefix:@"<COM_SVC_CODE "] &&
                       ![strData hasPrefix:@"<출금계좌번호 "] && ![strData hasPrefix:@"<입금계좌번호 "] &&
                       ![strData hasPrefix:@"<입금은행코드 "] && ![strData hasPrefix:@"<중복여부 "] &&
                       ![strData hasPrefix:@"<출금계좌부기명 "] && ![strData hasPrefix:@"<입금계좌성명 "] &&
                       ![strData hasPrefix:@"<출금계좌통장메모 "] && ![strData hasPrefix:@"<입금계좌통장메모 "])
                    {
                        [rootElement appendString:strData];
                    }
                    else if([strData hasPrefix:@"<출금계좌부기명 "])
                    {
                        NSString *strTemp = @"";
                        strTemp = [strData stringByReplacingOccurrencesOfString:@"<출금계좌부기명 setSession=\"출금계좌부기명\" value=\"" withString:@""];
                        strTemp = [strTemp stringByReplacingOccurrencesOfString:@"\"/>" withString:@""];
                        
                        strTemp = [self encodeStringXML:strTemp];
                        
                        [rootElement appendFormat:@"<출금계좌부기명 setSession=\"출금계좌부기명\" value=\"%@\"/>", strTemp];
                    }
                    else if([strData hasPrefix:@"<입금계좌성명 "])
                    {
                        NSString *strTemp = @"";
                        strTemp = [strData stringByReplacingOccurrencesOfString:@"<입금계좌성명 setSession=\"입금계좌성명\" value=\"" withString:@""];
                        strTemp = [strTemp stringByReplacingOccurrencesOfString:@"\"/>" withString:@""];
                        
                        strTemp = [self encodeStringXML:strTemp];
                        
                        [rootElement appendFormat:@"<입금계좌성명 setSession=\"입금계좌성명\" value=\"%@\"/>", strTemp];
                    }
                    else if([strData hasPrefix:@"<출금계좌통장메모 "])
                    {
                        [rootElement appendFormat:@"<출금계좌통장메모 originalValue=\"%@\" value=\"%@\"/>", signDic[@"내통장메모"], signDic[@"내통장메모"]];
                    }
                    else if([strData hasPrefix:@"<입금계좌통장메모 "])
                    {
                        [rootElement appendFormat:@"<입금계좌통장메모 originalValue=\"%@\" value=\"%@\"/>", signDic[@"받는통장메모"], signDic[@"받는통장메모"]];
                    }
                }
            }
            
            NSString *outAccNo = [signDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *inAccNo = [signDic[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [rootElement appendFormat:@"<출금계좌번호 originalValue=\"%@\" setSession=\"출금계좌번호\" value=\"%@\"/>", outAccNo, outAccNo];
            [rootElement appendFormat:@"<입금계좌번호 originalValue=\"%@\" setSession=\"입금계좌번호\" value=\"%@\"/>", inAccNo, inAccNo];
            [rootElement appendFormat:@"<입금은행코드 getCode=\"bank_code_smart\" setSession=\"입금은행코드\" value=\"%@\"/>", AppInfo.codeList.bankCode[signDic[@"입금은행"]]];
            [rootElement appendFormat:@"<중복여부 setSession=\"중복여부\" value=\"%@\"/>", [signDic[@"중복이체여부"] isEqualToString:@"중복이체승인함"] ? @"1" : @"0"];
            
            [rootElement appendFormat:@"<%@", [tempArray lastObject]];
            
            [vectorXml appendString:rootElement];
            
            [vectorXml appendString:@"</data>"];

            // 2.전자서명 값 설정
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"순번%d", cnt]];
            cnt += 1;
            
            for (int i = 1; i < [signDic[@"SignDataList"] count]; i ++)
            {
                NSString *strFieldName = signDic[@"SignDataList"][i];
                
                if ([strFieldName isEqualToString:@"출금계좌번호"])
                {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                                i,
                                                strFieldName,
                                                signDic[@"출금계좌번호표시용"]]];
                }
                else
                {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                                i,
                                                strFieldName,
                                                signDic[strFieldName]]];
                }
            }
        }
        [vectorXml appendString:@"</vector>"];
        
        //전자서명을 할 수 있는 뷰 컨트롤러를 호출한다.
        SHBCertElectronicSignViewController *eSignViewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewController" bundle:nil];
        
        eSignViewController.httpBody = vectorXml; //전문 재전송을 위해 생성된 전문을 넘겨준다.
        NSLog(@"vectorXml:%@",vectorXml);
        //eSignViewController.serviceUrl = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, MULTI_TRANSFER_URL, @""];
        eSignViewController.serviceUrl = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, MULTI_TRANSFER_URL, @""];
        [AppDelegate.navigationController pushFadeViewController:eSignViewController];
        [eSignViewController release];
    }
    else
    {
        //[AppInfo addElectronicSign:AppInfo.commonDic[@"제목"]];
        
        for (int i = 1; i < [AppInfo.commonDic[@"SignDataList"] count]; i ++)
        {
            NSString *strFieldName = AppInfo.commonDic[@"SignDataList"][i];
            
            if ([strFieldName isEqualToString:@"출금계좌번호"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                            i,
                                            strFieldName,
                                            AppInfo.commonDic[@"출금계좌번호표시용"]]];
            }
            else
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)%@: %@",
                                            i,
                                            strFieldName,
                                            AppInfo.commonDic[strFieldName]]];
            }
        
        }
        
        SHBDataSet *aDataSet = nil;
        
        if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2001"])   // 당행
        {
            AppInfo.electronicSignCode = @"D2003";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2003" viewController:self] autorelease];
            
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                         @"전문구분" : AppInfo.commonDic[@"전문구분"],
                         @"출금계좌번호" : [AppInfo.commonDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                         @"이체합계금액" : [SHBUtility commaStringToNormalString:AppInfo.commonDic[@"이체금액"]],
                         }] autorelease];
        }
        else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2011"])  // 타행
        {
            AppInfo.electronicSignCode = @"D2013";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2013" viewController:self] autorelease];
            
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                         @"출금계좌번호" : [AppInfo.commonDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                         @"이체합계금액" : [SHBUtility commaStringToNormalString:AppInfo.commonDic[@"이체금액"]],
                         @"적용수수료금액" : [SHBUtility commaStringToNormalString:AppInfo.commonDic[@"수수료"]],
                         }] autorelease];
        }
        else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2041"])  // 가상계좌
        {
        
            AppInfo.electronicSignCode = @"D2043";
            AppInfo.electronicSignTitle = AppInfo.commonDic[@"제목"];
            
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2043" viewController:self] autorelease];
            
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                         @"출금계좌번호" : [AppInfo.commonDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                         }] autorelease];
        }
        
        self.service.requestData = aDataSet;
        [self.service start];
    }
 }

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    AppInfo.isNeedClearData = YES;
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
    }
    else {
        [self.navigationController fadePopViewController];
    }
}

#pragma mark - 전자 서명 노티피케이션 정보를 받는다.
- (void) getElectronicSignResult:(NSNotification *)noti
{
    SHBTransferCompleteViewController *nextViewController = [[[SHBTransferCompleteViewController alloc] initWithNibName:@"SHBTransferCompleteViewController" bundle:nil] autorelease];
    if(self.dataArray)
    {
        //nextViewController.dataList = noti.userInfo[@"data"];
        
        NSArray *array = [noti.userInfo arrayWithForKeyPath:@"data"];
        
        for (NSMutableDictionary *dic in array) {
            for (NSString *key in dic.allKeys) {
                [dic setObject:[self decodeStringXML:dic[key]] forKey:key];
            }
        }
        
        nextViewController.dataList = array;
    }
    else
    {
        nextViewController.data = noti.userInfo;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void) getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    AppInfo.isNeedClearData = YES;
    
    [self.navigationController fadePopViewController];
    
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *viewController = self.navigationController.viewControllers[count - 2];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SHBMobileCertificateStep2ViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"SHBARSCertificateStep2ViewController")]) {
        
        [self.navigationController fadePopToViewController:self.navigationController.viewControllers[count - 5]];
    }
    else {
        [self.navigationController fadePopViewController];
    }
}

- (void) getElectronicSignError
{
 
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
    
    self.title = @"즉시이체/예금입금";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이체정보 확인" maxStep:3 focusStepNumber:2] autorelease]];
    
    int originY = 258;
    
    self.dataArray = AppInfo.commonDic[@"SignDataArray"];
    
    if(self.dataArray)
    {
        _lineView.backgroundColor = [UIColor clearColor];

        NSDictionary * dic = self.dataArray[0][@"SignData"];
        _lblData01.text = dic[@"출금계좌번호표시용"];
        _lblData02.text = dic[@"입금은행"];
        _lblData03.text = dic[@"입금계좌번호"];
        _lblData04.text = dic[@"수취인성명"];
        _lblData05.text = dic[@"이체금액"];
        _lblData06.text = dic[@"수수료"];
        _lblData07.text = dic[@"받는통장메모"];
        _lblData08.text = dic[@"내통장메모"];
        _lblData09.text = dic[@"CMS코드"];
        
        if ([dic[@"제목"] isEqualToString:@"가상계좌 이체"]) {
            _lblData10.text = @"가상계좌는 본인계좌가 아니며, 입금 시 이용기관 명의의 수납계좌로 입금됩니다.";
        }
        
        [_dataView removeFromSuperview];
        
        _dataView.frame = CGRectMake(0, 32, 317, 258);
        [_multiView addSubview:_dataView];
        _multiView.frame = CGRectMake(0, 10, 317, 356);
        [_infoView addSubview:_multiView];

        _lblTotCnt.text = [NSString stringWithFormat:@"%d건", [self.dataArray count]];
        
        int totAmt = 0;
        int totInterest = 0;
        
        for(NSDictionary *dic in self.dataArray)
        {
            totAmt += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] intValue];
            totInterest += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"수수료"]] intValue];
        }
        
        _lblTotAmt.text = [NSString stringWithFormat:@"%@(%@)원",
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totAmt]],
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totInterest]]];

        for(int i = 0; i < 5; i ++)
        {
            if(i < [self.dataArray count])
            {
                [_multiView viewWithTag:10 + i].hidden = NO;
            }
            else
            {
                [_multiView viewWithTag:10 + i].hidden = YES;
            }
        }
        
        originY = 370;
    }
    else
    {
        _lblData01.text = AppInfo.commonDic[@"출금계좌번호표시용"];
        _lblData02.text = AppInfo.commonDic[@"입금은행"];
        _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
        _lblData04.text = AppInfo.commonDic[@"수취인성명"];
        _lblData05.text = AppInfo.commonDic[@"이체금액"];
        _lblData06.text = AppInfo.commonDic[@"수수료"];
        _lblData07.text = AppInfo.commonDic[@"받는통장메모"];
        _lblData08.text = AppInfo.commonDic[@"내통장메모"];
        _lblData09.text = AppInfo.commonDic[@"CMS코드"];
        
        if ([AppInfo.commonDic[@"제목"] isEqualToString:@"가상계좌 이체"]) {
            _lblData10.text = @"가상계좌는 본인계좌가 아니며, 입금 시 이용기관 명의의 수납계좌로 입금됩니다.";
        }
       
    }
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType intValue] == 5)
    { //otp 사용
        secretotpView = [[SHBSecretOTPViewController alloc] init];
        secretotpView.targetViewController = self;

        _secretView.frame = CGRectMake(0.0f, originY, 317.0f, secretotpView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, originY + _secretView.frame.size.height);
        
        [_secretView addSubview:secretotpView.view];
        
        secretotpView.delegate = self;
        
        if(self.dataArray) // 추가이체
        {
            secretotpView.nextSVC = @"D2003";

        }
        else
        {
            if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2001"])   // 당행
            {
                secretotpView.nextSVC = @"D2003";
            }
            else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2011"])  // 타행
            {
                secretotpView.nextSVC = @"D2013";
            }
            else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2041"])  // 가상계좌
            {
                secretotpView.nextSVC = @"D2043";
               
            }
        }
        
        secretotpView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    else
    {
        secretcardView = [[SHBSecretCardViewController alloc] init];
        secretcardView.targetViewController = self;
        
        _secretView.frame = CGRectMake(0.0f, originY, 317.0f, secretcardView.view.frame.size.height);
        _infoView.frame = CGRectMake(0, 0, 317, originY + _secretView.frame.size.height);
        
        [_secretView addSubview:secretcardView.view];
        
        [secretcardView setMediaCode:[secutryType intValue] previousData:nil];
        secretcardView.delegate = self;
        
        if(self.dataArray) // 추가이체
        {
            secretcardView.nextSVC = @"D2003";
            
        }
        else
        {
            if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2001"])   // 당행
            {
                secretcardView.nextSVC = @"D2003";
            }
            else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2011"])  // 타행
            {
                secretcardView.nextSVC = @"D2013";
            }
            else if([AppInfo.commonDic[@"전문번호"] isEqualToString:@"D2041"])  // 가상계좌
            {
               
                secretcardView.nextSVC = @"D2043";
            }
        }
        
        
        secretcardView.selfPosY = _secretView.frame.origin.y + self.contentScrollView.frame.origin.y - 44.0f;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(317.0f, _infoView.frame.size.height);
    contentViewHeight = self.contentScrollView.frame.size.height < self.contentScrollView.contentSize.height ? self.contentScrollView.contentSize.height : self.contentScrollView.frame.size.height;

	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //전자 서명 결과값 받는 옵저버 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [secretcardView release];
    [secretotpView release];
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [_infoView release];
    [_secretView release];
    [_dataView release];
    [_multiView release];
    [_lineView release];
    [_lblTotCnt release];
    [_lblTotAmt release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLblData01:nil];
    [self setLblData02:nil];
    [self setLblData03:nil];
    [self setLblData04:nil];
    [self setLblData05:nil];
    [self setLblData06:nil];
    [self setLblData07:nil];
    [self setLblData08:nil];
    [self setLblData09:nil];
    [self setInfoView:nil];
    [self setSecretView:nil];
    [self setDataView:nil];
    [self setMultiView:nil];
    [self setLineView:nil];
    [self setLblTotCnt:nil];
    [self setLblTotAmt:nil];
    [super viewDidUnload];
}
@end
