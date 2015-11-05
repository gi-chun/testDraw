//
//  SHBCelebrationTransferCompleteViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCelebrationTransferCompleteViewController.h"
#import "SHBAccountService.h"
#import "SHBSMSInfoViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBKakao.h"
//#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface SHBCelebrationTransferCompleteViewController ()
{
    BOOL isRegAccNo;
}

//@property (nonatomic, retain) NSMutableDictionary* kakaoTalkLinkObjects;
@end

@implementation SHBCelebrationTransferCompleteViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 100:   // 자주쓰는 계좌등록
        {
            if(isRegAccNo)
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
            NSString *strBankName = _lblData02.text;
            NSString *strInAccNo = _lblData03.text;
            
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
                    aDataSet[@"출금계좌번호"] = _lblData01.text;
                    break;
                case 3:
                    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2235" viewController:self] autorelease];
                    aDataSet[@"출금계좌번호"] = _lblData01.text;
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
        case 200:   // SMS 통지
        {
            SHBSMSInfoViewController *nextViewController = [[[SHBSMSInfoViewController alloc] initWithNibName:@"SHBSMSInfoViewController" bundle:nil] autorelease];
            nextViewController.pViewController = self;
            nextViewController.pSelector = @selector(sendedSMS);
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 300:   // 카카오톡
        {
            //2.0 방식
//            if (![SHBKakao canOpenKakaoLink])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:[NSString stringWithFormat:@"카카오톡이 설치되어 있지 않아 입금내역을 전송할 수 없습니다. \n카카오톡 설치 후 이용하여 주시기 바랍니다."]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"확인"
//                                                      otherButtonTitles:nil];
//                
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
//            NSString *strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
//                                    AppInfo.commonDic[@"입금자성명"],
//                                    AppInfo.commonDic[@"수취인성명"],
//                                    AppInfo.commonDic[@"입금은행"],
//                                    [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
//                                    AppInfo.commonDic[@"이체금액"]];
//            
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
                
                NSString *strMessage = [NSString stringWithFormat:@"%@님이 %@님 %@ %@ 계좌로  %@ 입금.",
                                        AppInfo.commonDic[@"입금자성명"],
                                        AppInfo.commonDic[@"수취인성명"],
                                        AppInfo.commonDic[@"입금은행"],
                                        [AppInfo.commonDic[@"입금계좌번호"] stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"],
                                        AppInfo.commonDic[@"이체금액"]];
                
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
        case 400:   // 확인
        {
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    isRegAccNo = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[NSString stringWithFormat:@"자주쓰는 입금계좌에 등록되었습니다."]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
    return NO;
}

- (void)sendedSMS
{
    _btnSendSMS.enabled = NO;
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

    self.title = @"기타이체";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"경조금 이체완료" maxStep:3 focusStepNumber:3] autorelease]];
    
    [self navigationBackButtonHidden];
    
    _lblData01.text = AppInfo.commonDic[@"출금계좌번호"];
    _lblData02.text = AppInfo.commonDic[@"입금은행"];
    _lblData03.text = AppInfo.commonDic[@"입금계좌번호"];
    _lblData04.text = AppInfo.commonDic[@"수취인성명"];
    _lblData05.text = AppInfo.commonDic[@"이체금액"];
    _lblData06.text = AppInfo.commonDic[@"수수료"];
    
    _lblData07.text = AppInfo.commonDic[@"경조문구"];
    _lblData08.text = self.data[@"입금계좌통장메모"];
    _lblData09.text = self.data[@"출금계좌통장메모"];

    _lblData10.text = [NSString stringWithFormat:@"%@원", self.data[@"거래후잔액"]];
    
    isRegAccNo = NO;
    
    //self.kakaoTalkLinkObjects = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
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
    [_btnSendSMS release];
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
    [self setBtnSendSMS:nil];
    [super viewDidUnload];
}
@end
