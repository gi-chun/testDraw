//
//  SHBTransferCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTransferCompleteViewController.h"
#import "SHBFreqTransferRegComfirm2ViewController.h"
#import "SHBAccountService.h"
#import "SHBSMSInfoViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBKakao.h"
#import "SHBTickerView.h"

//#import <KakaoOpenSDK/KakaoOpenSDK.h>

#define SCHEMA_URL_MONEYMENTO @"asset://" // 머니멘토 앱 스키마

@interface SHBTransferCompleteViewController ()
{
    int serviceType;
    int selectIndex;
    BOOL isRegAccNo[5];
    BOOL isRegFreqTransfer[5];
    BOOL isSendSMS[5];
    
    NSString *_moneyMentoID;    // 머니멘토 ID
    BOOL _isMoneyMentoApp;      // 머니멘토 앱 설치 여부
    BOOL _isMoneyMentoSend;     // 머니멘토로 내역 전송 여부
    
    //배너를 위해
    
    IBOutlet SHBTickerView	*_tickerView;
    
    IBOutlet UIButton *_bannerMainBtn1;
    IBOutlet UIButton *_bannerMainBtn2;
    IBOutlet UIButton *_bannerMainBtn3;
    IBOutlet UIButton *_bannerMainBtn4;
    IBOutlet UIButton *_bannerMainBtn5;

    
    IBOutlet UIView *_bannerView;
    IBOutlet UIButton *_bannerListBtn;
    IBOutlet UIView *_bannerScrollContentsView;
    IBOutlet UIScrollView *_bannerScrollView;


}

//@property (nonatomic, retain) NSMutableDictionary* kakaoTalkLinkObjects;

- (void)moneyMentoSendRequest; // 머니멘토로 지출내역 전송요청

@end

@implementation SHBTransferCompleteViewController

- (IBAction)selectTap:(UIButton *)sender {
    ((UIButton *)[_multiView viewWithTag:10]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:11]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:12]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:13]).enabled = YES;
    ((UIButton *)[_multiView viewWithTag:14]).enabled = YES;
    
    sender.enabled = NO;
    selectIndex = sender.tag % 10;
    NSDictionary * dic = AppInfo.commonDic[@"SignDataArray"][selectIndex][@"SignData"];
    
    NSString *strBal = self.dataList[selectIndex][@"거래후잔액"];
    strBal = [SHBUtility normalStringTocommaString:strBal];
    
    _lblData01.text = dic[@"출금계좌번호표시용"];
    _lblData02.text = dic[@"입금은행"];
    _lblData03.text = dic[@"입금계좌번호"];
    _lblData04.text = dic[@"수취인성명"];
    _lblData05.text = dic[@"이체금액"];
    _lblData06.text = dic[@"수수료"];
    
    if ([self.dataList[selectIndex][@"입금은행코드"] integerValue] == 88 ||
        [self.dataList[selectIndex][@"입금은행코드"] integerValue] == 21 ||
        [self.dataList[selectIndex][@"입금은행코드"] integerValue] == 26) {
        
        // 당행
        
        _lblData07.text = self.dataList[selectIndex][@"입금계좌통장메모"];
    }
    else {
        
        // 타행 (입금계좌통장메모가 내려오지 않고 출금계좌성명으로 내려옴)
        
        _lblData07.text = self.dataList[selectIndex][@"출금계좌성명"];
    }
    
    _lblData08.text = self.dataList[selectIndex][@"출금계좌통장메모"];
    _lblData09.text = dic[@"CMS코드"];

    if(strBal == nil)
    {
        _lblData10.text = self.dataList[selectIndex][@"ERR_USER_MSG1"];
        _lblData12.text = @"오류내용";
        _lblTranResultState.text = @"오류";//;
        _btnRegAccNo.enabled = NO;
        _btnRegTransfer.enabled = NO;
        _btnSendSMS.enabled = NO;
        _btnSendKakao.enabled = NO;
        _btnSendGagebu.enabled = NO;
    }
    else
    {
        _lblData10.text = [NSString stringWithFormat:@"%@원", strBal];
        _lblData12.text = @"이체후잔액";
//        _lblTranResultTitle.textColor = RGB(0, 137, 220);
//        _lblTranResultState.textColor = RGB(0, 137, 220);
        _lblTranResultState.text = @"정상";
        _btnRegAccNo.enabled = YES;
        _btnRegTransfer.enabled = !isRegFreqTransfer[selectIndex];
        _btnSendSMS.enabled = !isSendSMS[selectIndex];
        _btnSendKakao.enabled = YES;
        _btnSendGagebu.enabled = YES;
    }
}



- (void)startTicker{
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M002List.vector.data"];
    
    if ([tickArray count] > 0)
    {
        
        UIImage *bannerImg;
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
        
            NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
            NSString *fileName = [paths objectAtIndex:[paths count]-1];
            NSString *cachePath = [NSString stringWithFormat:@"%@/eche/",[SHBUtility getCachesDirectory]];
            NSString *filePath = [cachePath stringByAppendingString:fileName];
            
            if (![SHBUtility isExistFile:filePath])
            {
                NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
                bannerImg = [UIImage imageWithData:imgData];
            }else
            {
                bannerImg = [UIImage imageWithContentsOfFile:filePath];
            }
            switch (i)
            {
                case 0:
                    
                    _bannerMainBtn1.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn1 setBackgroundImage:bannerImg forState:UIControlStateNormal];
                  
                    break;
                case 1:
                    
                    _bannerMainBtn2.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn2 setBackgroundImage:bannerImg forState:UIControlStateNormal];
                   
                    break;
                case 2:
                    
                    _bannerMainBtn3.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn3 setBackgroundImage:bannerImg forState:UIControlStateNormal];
                    
                    break;
                case 3:
                    
                    _bannerMainBtn4.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn4 setBackgroundImage:bannerImg forState:UIControlStateNormal];
                   
                    break;
                case 4:
              
                    _bannerMainBtn5.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn5 setBackgroundImage:bannerImg forState:UIControlStateNormal];
                   
                    break;
                default:
                    break;
            }
        }
      

    }
        
    if (tickArray){
        _tickerView.isSlideText = NO;
        
        
        [_tickerView executeWithData:tickArray];
        
        if ([tickArray count] > 3)
        {
           
            if ([tickArray count] == 4)
            {
                //_bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height - 45.0f);
                _bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height + 9);
            } else if ([tickArray count] == 5)
            {
                //_bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height );
                _bannerScrollView.contentSize = CGSizeMake(_bannerScrollContentsView.frame.size.width,_bannerScrollContentsView.frame.size.height+ 54);
            }
            
            
            
        } else if ([tickArray count] == 1)
        {
            
            //[_tickerView setFrame:CGRectMake(_tickerView.frame.origin.x - 17, _tickerView.frame.origin.y, _tickerView.frame.size.width, _tickerView.frame.size.height)];
            
            [_bannerListBtn setFrame:CGRectMake(_bannerListBtn.frame.origin.x, _bannerListBtn.frame.origin.y - 72.0f, _bannerListBtn.frame.size.width, _bannerListBtn.frame.size.height)];
            [_bannerView setFrame:CGRectMake(0, _bannerView.frame.origin.y + 72.0f, _bannerView.frame.size.width, _bannerView.frame.size.height - 112.0f)];
            [_bannerScrollView setFrame:CGRectMake(_bannerScrollView.frame.origin.x, _bannerScrollView.frame.origin.y + 130.0f, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
            
        } else if ([tickArray count] == 2)
        {
            
            [_bannerListBtn setFrame:CGRectMake(_bannerListBtn.frame.origin.x, _bannerListBtn.frame.origin.y - 36.0f, _bannerListBtn.frame.size.width, _bannerListBtn.frame.size.height)];
            [_bannerView setFrame:CGRectMake(0, _bannerView.frame.origin.y + 36.0f, _bannerView.frame.size.width, _bannerView.frame.size.height - 56.0f)];
            [_bannerScrollView setFrame:CGRectMake(_bannerScrollView.frame.origin.x, _bannerScrollView.frame.origin.y + 65.0f, _bannerScrollView.frame.size.width, _bannerScrollView.frame.size.height)];
        }
        
        
    }else{
        _tickerView.hidden = YES;

    }
    
    

}

- (IBAction)mainBannerContentClick:(id)sender  // 배너 클릭시 처리
{
    UIButton *tmpBtn = sender;
    int btnTag =  (tmpBtn.tag - 4000);
    //NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"TickerList.vector.data"];
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M002List.vector.data"];
    if ([tickArray count] == 0) {
        return;
    }
    
    NSDictionary *nDic = [tickArray objectAtIndex:btnTag];
    NSString *tickerURL = [NSString stringWithFormat:@"%@&EQUP_CD=SI",[nDic objectForKey:@"티커Url"]];
    
    
    SHBDataSet *bannerDic  = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                                 @"티커제목" : [nDic objectForKey:@"티커제목"],
                                 @"티커번호" : [nDic objectForKey:@"티커번호"],
                                 @"티커Url" : tickerURL,
                                 @"티커구분" : [nDic objectForKey:@"티커구분"],
                                 @"아이콘Url" : [nDic objectForKey:@"아이콘Url"],
                                 }] autorelease];
    
    
    if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"0"] || [[nDic objectForKey:@"티커구분"] isEqualToString:@"1"]) //새소식연결,이벤트
    {
        AppInfo.commonDic = @{ @"배너" : bannerDic };
        AppInfo.indexQuickMenu = 1;
        //2014.07.09 변경 : 로그인전과 로그인 후 알림 메인 UI 변경
        /*
         if (AppInfo.isLogin == LoginTypeNo)
         {
         UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuNotLogInViewController") class] alloc] initWithNibName:@"SHBNoticeMenuNotLogInViewController" bundle:nil];
         [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
         [self.navigationController fadePopToRootViewController];
         [AppDelegate.navigationController pushSlideUpViewController:viewController];
         [viewController release];
         }else
         {
         UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
         [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
         [self.navigationController fadePopToRootViewController];
         [AppDelegate.navigationController pushSlideUpViewController:viewController];
         [viewController release];
         }
         */
        //메인배너 클릭시 무조건 기존 새소식으로 이동
        UIViewController *viewController = [[[NSClassFromString(@"SHBNoticeMenuViewController") class] alloc] initWithNibName:@"SHBNoticeMenuViewController" bundle:nil];
        [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
        [self.navigationController fadePopToRootViewController];
        [AppDelegate.navigationController pushSlideUpViewController:viewController];
        [viewController release];
        
    }  else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"2"]) //m신한 연결
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
    } else if ([[nDic objectForKey:@"티커구분"] isEqualToString:@"3"]) //기타
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[nDic objectForKey:@"티커Url"]]];
        
    }
}




- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 100:   // 자주쓰는 계좌등록
        {
            if(isRegAccNo[selectIndex])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"이미등록된 계좌입니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            serviceType = 0;
            
            if([_lblData03.text isEqualToString:@"43501001190"] ||
               [_lblData03.text isEqualToString:@"34401162030"] ||
               [_lblData03.text isEqualToString:@"34401199090"] ||
               [_lblData03.text isEqualToString:@"34401093320"] ||
               [_lblData03.text isEqualToString:@"34401197940"] ||
               [_lblData03.text isEqualToString:@"38301000178"] ||
               [_lblData03.text isEqualToString:@"34401198298"] ||
               [_lblData03.text isEqualToString:@"36101100263"] ||
               [_lblData03.text isEqualToString:@"36101102088"] ||
               [_lblData03.text isEqualToString:@"36101103459"] ||
               [_lblData03.text isEqualToString:@"31801093322"] ||
               [_lblData03.text isEqualToString:@"30601236928"] ||
               [_lblData03.text isEqualToString:@"34401197933"] ||
               [_lblData03.text isEqualToString:@"36107101326"] ||
               [_lblData03.text isEqualToString:@"100018666254"] ||
               [_lblData03.text isEqualToString:@"100007460611"] ||
               [_lblData03.text isEqualToString:@"100014301031"] ||
               [_lblData03.text isEqualToString:@"100001298169"] ||
               [_lblData03.text isEqualToString:@"100014159385"] ||
               [_lblData03.text isEqualToString:@"100002114914"] ||
               [_lblData03.text isEqualToString:@"100014199383"] ||
               [_lblData03.text isEqualToString:@"100014283415"] ||
               [_lblData03.text isEqualToString:@"100014868899"] ||
               [_lblData03.text isEqualToString:@"100016904551"] ||
               [_lblData03.text isEqualToString:@"100011897988"] ||
               [_lblData03.text isEqualToString:@"100013946245"] ||
               [_lblData03.text isEqualToString:@"100014159378"] ||
               [_lblData03.text isEqualToString:@"150000497880"] )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"증권사계좌번호는 계좌등록할 수 없습니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                return;
            }
            
            int processFlag;
            NSString *strOutAccNo = [_lblData01.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strBankName = _lblData02.text;
            NSString *strInAccNo = [_lblData03.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
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
            
            SHBDataSet *aDataSet = [[SHBDataSet alloc] initWithDictionary:@{
                                    @"입금은행코드" : AppInfo.codeList.bankCode[strBankName],
                                    @"입금계좌번호" : strInAccNo,
                                    @"입금계좌메모" : _lblData04.text,
                                    }];
            
            switch (processFlag) 
            {
                case 2:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2233" viewController:self] autorelease];
                    aDataSet[@"출금계좌번호"] = strOutAccNo;
                    break;
                case 3:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2235" viewController:self] autorelease];
                    aDataSet[@"출금계좌번호"] = strOutAccNo;
                    break;
                default:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2231" viewController:self] autorelease];
                    break;
            }
            
            self.service.requestData = aDataSet;
            
            [self.service start];
            [aDataSet release];
        }
            break;
        case 200:   // 스피드이체등록
        {
            NSDictionary *dic = @{
            @"입금계좌별명" : _lblData04.text,
            @"출금계좌번호" : _lblData01.text,
            @"입금은행" : _lblData02.text,
            @"입금은행코드" : AppInfo.codeList.bankCode[_lblData02.text],
            @"입금계좌번호" : _lblData03.text,
            @"입금자명" : _lblData04.text,
            @"이체금액" : [_lblData05.text stringByReplacingOccurrencesOfString:@"원" withString:@""],
            @"받는분통장메모" : _lblData07.text == nil ? @"" : _lblData07.text,
            @"보내는분통장메모" : _lblData08.text == nil ? @"" : _lblData08.text,
            };
            
            SHBFreqTransferRegComfirm2ViewController *nextViewController = [[[SHBFreqTransferRegComfirm2ViewController alloc] initWithNibName:@"SHBFreqTransferRegComfirm2ViewController" bundle:nil] autorelease];
            nextViewController.data = dic;
            nextViewController.pViewController = self;
            nextViewController.pSelector = @selector(regFreqTransfer);
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 300:   // SMS 통지
        {
            if(AppInfo.commonDic[@"SignDataArray"])
            {
                NSDictionary *dic = @{
                @"입금자성명" : AppInfo.commonDic[@"SignDataArray"][selectIndex][@"SignData"][@"입금자성명"],
                @"수취인성명" : _lblData04.text,
                @"입금계좌번호" : _lblData03.text,
                @"이체금액" : _lblData05.text,
                @"입금은행" : _lblData02.text,
                };

                SHBSMSInfoViewController *nextViewController = [[[SHBSMSInfoViewController alloc] initWithNibName:@"SHBSMSInfoViewController" bundle:nil] autorelease];
                nextViewController.data = dic;
                nextViewController.pViewController = self;
                nextViewController.pSelector = @selector(sendedSMS);
                [self.navigationController pushFadeViewController:nextViewController];
            }
            else
            {
                SHBSMSInfoViewController *nextViewController = [[[SHBSMSInfoViewController alloc] initWithNibName:@"SHBSMSInfoViewController" bundle:nil] autorelease];
                nextViewController.pViewController = self;
                nextViewController.pSelector = @selector(sendedSMS);
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 400:   // 카카오톡
        {
            //2.0 방식
//            if (![SHBKakao canOpenKakaoLink])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:[NSString stringWithFormat:@"카카오톡이 설치되어 있지 않아 입금내역을 전송할 수 없습니다.\n카카오톡 설치 후 이용하여 주시기 바랍니다."]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"확인"
//                                                      otherButtonTitles:nil];
//                /* iOS7에서 죽는 현상 발생하여 수정
//                UILabel *label_alert = (UILabel*)[[alert subviews] objectAtIndex:1];
//                
//                if(label_alert != nil && [label_alert isKindOfClass:[UILabel class]])
//                {
//                    [label_alert setTextAlignment:UITextAlignmentLeft];
//                }
//                */
//                [alert show];
//                [alert release];
//                
//                return;
//            }
//            
//            NSMutableArray *metaInfoArray = [NSMutableArray array];
//            
//            // !!! 신한S뱅크의 App 관련 정보를 설정해야 한다!
//            NSDictionary *metaInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      @"ios", @"os",
//                                      @"phone", @"devicetype",
//                                      @"http://itunes.apple.com/kr/app/id357484932?mt=8", @"installurl",
//                                      @"iphoneSbank://com.shinhan.sbank", @"executeurl",
//                                      nil];
//            
//            [metaInfoArray addObject:metaInfo];
//            
//            NSString *strMessage = @"";
//            
//            if(AppInfo.commonDic[@"SignDataArray"])
//            {
//                strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
//                              AppInfo.commonDic[@"SignDataArray"][selectIndex][@"SignData"][@"입금자성명"],
//                              _lblData04.text,
//                              _lblData02.text,
//                              [_lblData03.text stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
//                              _lblData05.text];
//            }
//            else
//            {
//                strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
//                              AppInfo.commonDic[@"입금자성명"],
//                              AppInfo.commonDic[@"수취인성명"],
//                              AppInfo.commonDic[@"입금은행"],
//                              [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
//                              AppInfo.commonDic[@"이체금액"]];
//            }
//            
//            [SHBKakao openKakaoAppLinkWithMessage:strMessage
//                                              URL:@"http://itunes.apple.com/kr/app/id357484932?mt=8"
//                                      appBundleID:[[NSBundle mainBundle] bundleIdentifier]
//                                       appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//                                          appName:@"신한S뱅크"
//                                    metaInfoArray:metaInfoArray];
            
            //3.5 방식
            /*
            if( [KOAppCall canOpenKakaoTalkAppLink])
            {
                
                NSString *strMessage = @"";
                
                if(AppInfo.commonDic[@"SignDataArray"])
                {
                    strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
                                  AppInfo.commonDic[@"SignDataArray"][selectIndex][@"SignData"][@"입금자성명"],
                                  _lblData04.text,
                                  _lblData02.text,
                                  [_lblData03.text stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
                                  _lblData05.text];
                }
                else
                {
                    strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
                                  AppInfo.commonDic[@"입금자성명"],
                                  AppInfo.commonDic[@"수취인성명"],
                                  AppInfo.commonDic[@"입금은행"],
                                  [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
                                  AppInfo.commonDic[@"이체금액"]];
                }
                
                [KOAppCall openKakaoTalkAppLink:[_kakaoTalkLinkObjects allValues]];
                
                KakaoTalkLinkAction *androidAppAction
                = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid
                                            devicetype:KakaoTalkLinkActionDeviceTypePhone
                                             execparam:nil];
                
                KakaoTalkLinkAction *iphoneAppAction
                = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                            devicetype:KakaoTalkLinkActionDeviceTypePhone
                                             execparam:nil];
                
                KakaoTalkLinkObject *button
                = [KakaoTalkLinkObject createAppButton:@"앱으로 연결"
                                               actions:@[androidAppAction, iphoneAppAction]];
                
                NSString* key = @"label";
                KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:strMessage];
                [_kakaoTalkLinkObjects setObject:label forKey:key];
                [KOAppCall openKakaoTalkAppLink:@[label, button]];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"카카오톡이 설치되어 있지 않아 입금내역을 전송할 수 없습니다.\n카카오톡 설치 후 이용하여 주시기 바랍니다."]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
            }
             */
        }
            break;
        case 500:   // 확인
        {
            NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
            if([strController isEqualToString:@"SHBAccountMenuListViewController"]
               || [strController isEqualToString:@"SHBAccountListViewController"])
            {
                [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self.navigationController fadePopToRootViewController];
            }
        }
            break;
        case 600:   // 가계부로 전송
        {
            // 머니멘토로 내역 전송하지 않았을 경우, 머니멘토 가입여부 확인
            if (!_isMoneyMentoSend) {
                
                self.service = nil;
                self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_MONEYMENTO_SELECT viewController:self] autorelease];
                [self.service start];
            }
            // 머니멘토로 내역 전송하였을 경우(5. 이미 가계부로 전송 후, 다시 해당버튼 tap시) 
            else {
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"이미 가계부로 저장 하였습니다."];
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark -
#pragma mark Network Methods

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    // 머니멘토 가입여부 확인 전문 응답 일 경우
    if (self.service.serviceId == FREQ_MONEYMENTO_SELECT) {
        
        // 머니멘토 회원 가입자인 경우, 머니멘토 ID 저장
        if ([aDataSet[@"CUSTOMER_ID"] length] > 0) {
            
            _moneyMentoID = aDataSet[@"CUSTOMER_ID"];
        }
        // 머니멘토 회원 미 가입자인 경우, 공백으로 처리
        else {
            
            _moneyMentoID = @"";
        }
        
        // 머니멘토 앱 설치여부 확인
        _isMoneyMentoApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEMA_URL_MONEYMENTO]];
        
        // 머니멘토 조건 비교
        // 1A. 머니멘토 app 기 가입자 & app 기 설치자 일 경우, 머니멘토로 지출내역 전송요청
        // 2A. 머니멘토 app 기 가입자 & app 미 설치자 일 경우, 머니멘토로 지출내역 전송요청
        if ([_moneyMentoID length] > 0) {
            
            [self moneyMentoSendRequest];
        }
        // 3. 머니멘토 app 미 가입자 & app 기 설치자 일 경우
        else if ([_moneyMentoID length] == 0 && _isMoneyMentoApp == YES) {
            
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1002 title:@"" message:@"현재 고객님은 가계부 서비스인 머니멘토의 미이용 고객이십니다. 지금 바로 머니멘토에 가입하시겠습니까?"];
        }
        // 4. 머니멘토 app 미 가입자 & app 미 설치자 일 경우
        else if ([_moneyMentoID length] == 0 && _isMoneyMentoApp == NO) {
            
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1003 title:@"" message:@"현재 고객님은 가계부 서비스인 머니멘토의 미이용 고객이십니다. 지금 바로 머니멘토에 가입하시겠습니까?"];
        }
        
        return NO;
    }
    // 머니멘토 지출내역(가계부로 전송) 전문 응답 일 경우
    else if (self.service.serviceId == FREQ_MONEYMENTO_INSERT) {
        
        // 6. 1,2번의 경우 가계부로 전송이 실패했을 경우 알럿 후 가계부로 전송 버튼 다시 tap시 다시 전송
        if (AppInfo.errorType) {
            
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"가계부로 전송 실패하였습니다. 다시 시도하여 주시기 바랍니다."];
        }
        else {
            
            _isMoneyMentoSend = YES;
            
            // 1B. 머니멘토 app 기 가입자 & app 기 설치자 일 경우
            if ([_moneyMentoID length] > 0 && _isMoneyMentoApp == YES) {
                
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1000 title:@"" message:@"가계부로 전송되었습니다. 머니멘토 가계부 내역을 보시겠습니까?"];
            }
            // 2B. 머니멘토 app 기 가입자 & app 미 설치자 일 경우
            else if ([_moneyMentoID length] > 0 && _isMoneyMentoApp == NO) {
                
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1001 title:@"" message:@"가계부로 전송되었습니다. 머니멘토 가계부 내역을 보시겠습니까?"];
            }
        }
        
        return NO;
    }
    
    // 기존 전문 응답에 대한 처리 부분
    if(serviceType == 0)
    {
        isRegAccNo[selectIndex] = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"자주쓰는 입금계좌에 등록되었습니다."]
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    return NO;
}


#pragma mark -
#pragma mark Private Methods

- (void)moneyMentoSendRequest
{
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_MONEYMENTO_INSERT viewController:self] autorelease];
    
    NSString *stringTemp = [_lblData05.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                            TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                            TASK_ACTION_KEY : @"setOutgoingInfoTabApp",
                            @"CUSTOMER_ID" : _moneyMentoID,
                            @"OUTGOINGS_DT" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"OUTGOINGS_DESC" : [_lblData01.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                            @"CASH_AMT" : [stringTemp stringByReplacingOccurrencesOfString:@"원" withString:@""],
                            @"CARD_AMT" : @"0",
                            @"CATEGORY_CD" : @"CAT0000063",
                            @"CONSUME_TYPE" : @"2",
                            @"DEVICE_TYPE" : @"M",
                            @"CREATE_ID" : _moneyMentoID,
                            @"UPDATE_ID" : _moneyMentoID,
                            }];
    
    self.service.requestData = aDataSet;
    
    [self.service start];
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // SSO 머니멘토>나의지출메인 이동 (M3001 : 머니멘토 - 나의 지출 화면)
    if (alertView.tag == 1000 && buttonIndex == 0) {
        
        [[SHBPushInfo instance] requestOpenURL:[NSString stringWithFormat:@"%@M3001", SCHEMA_URL_MONEYMENTO] Parm:nil];
    }
    // 머니멘토 설치페이지로 이동
    else if (alertView.tag == 1001 && buttonIndex == 0) {
        
        [[SHBPushInfo instance] requestOpenURL:SCHEMA_URL_MONEYMENTO Parm:nil];
    }
    // 머니멘토 회원가입화면으로 이동
    else if (alertView.tag == 1002 && buttonIndex == 0) {
        
        [[SHBPushInfo instance] requestOpenURL:SCHEMA_URL_MONEYMENTO Parm:nil];
    }
    // 머니멘토 설치페이지로 이동
    else if (alertView.tag == 1003 && buttonIndex == 0) {
        
        [[SHBPushInfo instance] requestOpenURL:SCHEMA_URL_MONEYMENTO Parm:nil];
    }
}

- (void)sendedSMS
{
    isSendSMS[selectIndex] = YES;
    _btnSendSMS.enabled = NO;
}

- (void)regFreqTransfer
{
    isRegFreqTransfer[selectIndex] = YES;
    _btnRegTransfer.enabled = NO;
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
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이체 완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
   
    
    selectIndex = 0;
    
    if(AppInfo.commonDic[@"SignDataArray"])
    {
        // 추가이체의 경우 가계부로 전송 버튼 숨김
        _btnSendGagebu.hidden = YES;
        
        _lineView.backgroundColor = [UIColor clearColor];
        
        NSArray *dataArray = AppInfo.commonDic[@"SignDataArray"];
        
        NSDictionary *dic = dataArray[selectIndex][@"SignData"];
        
        //가상계좌이체의 경우 거래후 잔액에 ,가 빠져있다.
        NSString *strBal = @"";
        
        strBal = self.dataList[selectIndex][@"거래후잔액"];
        strBal = [SHBUtility normalStringTocommaString:strBal];
        
        _lblData01.text = dic[@"출금계좌번호표시용"];
        _lblData02.text = dic[@"입금은행"];
        _lblData03.text = dic[@"입금계좌번호"];
        _lblData04.text = dic[@"수취인성명"];
        _lblData05.text = dic[@"이체금액"];
        _lblData06.text = dic[@"수수료"];
        
        if ([self.dataList[selectIndex][@"입금은행코드"] integerValue] == 88 ||
            [self.dataList[selectIndex][@"입금은행코드"] integerValue] == 21 ||
            [self.dataList[selectIndex][@"입금은행코드"] integerValue] == 26) {
            
            // 당행
            
            _lblData07.text = self.dataList[selectIndex][@"입금계좌통장메모"];
        }
        else {
            
            // 타행 (입금계좌통장메모가 내려오지 않고 출금계좌성명으로 내려옴)
            
            _lblData07.text = self.dataList[selectIndex][@"출금계좌성명"];
        }
        
        _lblData08.text = self.dataList[selectIndex][@"출금계좌통장메모"];
        _lblData09.text = dic[@"CMS코드"];

        if(strBal == nil)
        {
            _lblData10.text = self.dataList[selectIndex][@"ERR_USER_MSG1"];
            _lblData12.text = @"오류내용";
            _lblTranResultState.text = @"오류";
            _btnRegAccNo.enabled = NO;
            _btnRegTransfer.enabled = NO;
            _btnSendSMS.enabled = NO;
            _btnSendKakao.enabled = NO;
            _btnSendGagebu.enabled = NO;
        }
        else
        {
            _lblData10.text = [NSString stringWithFormat:@"%@원", strBal];
            _lblData12.text = @"이체후잔액";
            _lblTranResultState.text = @"정상";
        }
        
        [_dataView removeFromSuperview];
        [_buttonView removeFromSuperview];
        
        _dataView.frame = CGRectMake(0, 60, 317, 261);
        [_multiView addSubview:_dataView];
        _buttonView.frame = CGRectMake(0, 326, 317, 69);
        [_multiView addSubview:_buttonView];
        _multiView.frame = CGRectMake(0, 10, 317, 498);
        [self.contentScrollView addSubview:_multiView];
        
        
        _comfirmView.frame = CGRectMake(0, 508, 317, 39);
        _tickerView.frame = CGRectMake(15, 540, 216, 38);
        
        
        
        self.contentScrollView.contentSize = CGSizeMake(317, 600);
        
        _lblTotCnt.text = [NSString stringWithFormat:@"%d건", [dataArray count]];
        
        int totAmt = 0;
        int totInterest = 0;
        
        for(NSDictionary *dic in dataArray)
        {
            totAmt += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"이체금액"]] intValue];
            totInterest += [[SHBUtility commaStringToNormalString:dic[@"SignData"][@"수수료"]] intValue];
        }
        
        _lblTotAmt.text = [NSString stringWithFormat:@"%@(%@)원",
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totAmt]],
                           [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d", totInterest]]];
        
        for(int i = 0; i < 5; i ++)
        {
            if(i < [dataArray count])
            {
                [_multiView viewWithTag:10 + i].hidden = NO;
            }
            else
            {
                [_multiView viewWithTag:10 + i].hidden = YES;
            }
        }
    }
    else
    {
        
         [self startTicker];
        
        
        // 즉시이체의 경우 가계부로 전송 버튼 보임
        _btnSendGagebu.hidden = NO;
        
        //가상계좌이체의 경우 거래후 잔액에 ,가 빠져있다.
        NSString *strBal = self.data[@"거래후잔액"];
        strBal = [SHBUtility normalStringTocommaString:strBal];
        
        _lblData01.text = AppInfo.commonDic[@"출금계좌번호표시용"];
        _lblData02.text = AppInfo.commonDic[@"입금은행"];
        _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
        _lblData04.text = AppInfo.commonDic[@"수취인성명"];
        _lblData05.text = AppInfo.commonDic[@"이체금액"];
        _lblData06.text = AppInfo.commonDic[@"수수료"];
        _lblData07.text = self.data[@"입금계좌통장메모"];
        _lblData08.text = self.data[@"출금계좌통장메모"];
        _lblData09.text = AppInfo.commonDic[@"CMS코드"];
        
        if(strBal == nil)
        {
            _lblData10.text = self.data[@"ERR_DEFAULT_MSG1"];
            _lblData12.text = @"오류내용";
            _btnRegAccNo.enabled = NO;
            _btnRegTransfer.enabled = NO;
            _btnSendSMS.enabled = NO;
            _btnSendKakao.enabled = NO;
            _btnSendGagebu.enabled = NO;
        }
        else
        {
            _lblData10.text = [NSString stringWithFormat:@"%@원", strBal];
            _lblData12.text = @"이체후잔액";
        }
        
        if([AppInfo.commonDic[@"수수료우대내역"] isEqualToString:@""])
        {
            _feeView.hidden = YES;
        }
        else
        {
            _feeView.hidden = NO;
            _lblData11.text = AppInfo.commonDic[@"수수료우대내역"];
            _buttonView.frame = CGRectMake(0, 335, 317, 69);
            _comfirmView.frame = CGRectMake(0, 414, 317, 39);
            _tickerView.frame = CGRectMake(33, 463, 261, 38);
        }
        
        
        self.contentScrollView.contentSize = CGSizeMake(317, _tickerView.frame.origin.y + _tickerView.frame.size.height + 10);
    }
    
    
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    
    //self.kakaoTalkLinkObjects = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_moneyMentoID release]; _moneyMentoID = nil;
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    [_lblData06 release];
    [_lblData07 release];
    [_lblData08 release];
    [_lblData09 release];
    [_lblData10 release];
    [_lblData11 release];
    [_lblData12 release];
    [_feeView release];
    [_comfirmView release];
    [_dataView release];
    [_multiView release];
    [_lineView release];
    [_lblTotCnt release];
    [_lblTotAmt release];
    [_btnRegTransfer release];
    [_btnSendSMS release];
    [_lblTranResultTitle release];
    [_lblTranResultState release];
    [_buttonView release];
    [_btnRegAccNo release];
    [_btnSendKakao release];
    [_btnSendGagebu release];
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
    [self setLblData10:nil];
    [self setLblData11:nil];
    [self setLblData12:nil];
    [self setFeeView:nil];
    [self setComfirmView:nil];
    [self setDataView:nil];
    [self setMultiView:nil];
    [self setLineView:nil];
    [self setLblTotCnt:nil];
    [self setLblTotAmt:nil];
    [self setBtnRegTransfer:nil];
    [self setBtnSendSMS:nil];
    [self setLblTranResultTitle:nil];
    [self setLblTranResultState:nil];
    [self setButtonView:nil];
    [self setBtnRegAccNo:nil];
    [self setBtnSendKakao:nil];
    [self setBtnSendGagebu:nil];
    [super viewDidUnload];
}
@end
