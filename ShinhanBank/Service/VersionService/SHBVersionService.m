//
//  SHBVersionService.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBVersionService.h"
#import "SHBMainViewController.h"

@implementation SHBVersionService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
        
		initialized = YES;
        
        NSDictionary *info = VERSION_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    
    if (self.serviceId == VERSION_INFO)
    {
        AppInfo.serviceCode = @"버젼정보";
        processStep = 1;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
        
    }else if (self.serviceId == XDA_S00001 || self.serviceId == ACCOUNT_RESET)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
        
    }else if (self.serviceId == NAME_VERIFY) {
        
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    } else if (self.serviceId == TASK_APP_LIST || self.serviceId == BANK_CD_INFO) {
        
        processStep = 0;
		SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
	} else if (self.serviceId == TASK_INS_PUSH){
        processStep = 0;
		SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        [self requestDataSet:aDataSet];
	} else if (self.serviceId == PHONE_INFO)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }else if (self.serviceId == VERSION_INFO2)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }else if (self.serviceId == SMSDEVICE_INFO)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }else if (self.serviceId == CARD_SSO_AGREE)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }else if (self.serviceId == CARD_SSO_GROUP)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }else if (self.serviceId == CARD_SSO_SEARCH)
    {
        processStep = 0;
        SHBDataSet *aDataSet = (SHBDataSet *)self.previousData;
        
        [self requestDataSet:aDataSet];
    }
}

- (BOOL) onParse: (OFDataSet*) aDataSet string: (NSData*) aContent
{
    if (processStep == 1)
    {
        AppInfo.isGetVersionInfo = 1; //성공상태
        
        //테스트
        //aDataSet[@"공지사항URL"] = @"https://dev-m.shinhan.com/images/sbank_notice/popup_notice20140120.html";
        
        AppInfo.versionInfo = aDataSet;
        
        if (aDataSet[@"ARS_CERT_TIME"])
        {
            AppInfo.arsLimtTime = [aDataSet[@"ARS_CERT_TIME"] doubleValue];
        }
        
        NSString *strMessage;
        
        //강제 업데이트 여부 확인
        if ([aDataSet[@"강제업데이트여부"] isEqualToString:@"Y"])
        {
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:aDataSet[@"업데이트메시지"]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"확인",nil];
            
            alert.tag =777;
            [alert show];
            [alert release];
             */
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:777 title:nil buttonTitle:@"확인" message:aDataSet[@"업데이트메시지"]];
            return YES;
        }
        //[(SHBMainViewController*)(AppDelegate.navigationController.viewControllers[0]) performSelector:@selector(noticeWebViewDidLoaded) withObject:nil afterDelay:0.1f];
        //return NO;
        
        //테스트
        //aDataSet[@"공지사항여부"] = @"Y";
        
        
        //공지 사항 알림 처리
        if ([aDataSet[@"공지사항여부"] isEqualToString:@"Y"])
        {
            
            if ([[aDataSet objectForKey:@"공지후강제종료여부"] isEqualToString:@"Y"])
            {
                strMessage = [aDataSet[@"공지사항여부"] isEqualToString:@"Y"] ? aDataSet[@"공지사항"] : [NSString stringWithFormat:@"S뱅크를 종료합니다."];
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:strMessage
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인",nil];
                
                alert.tag =779;
                [alert show];
                [alert release];
                */
                
                [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:779 title:nil buttonTitle:@"확인" message:strMessage];
                
            } else
            {
                
                if ([AppInfo.versionInfo[@"공지사항URL"] length] == 0)
                {
                    
                    //강제 종료가 아니고 공지 url이 없는경우
                    strMessage = [aDataSet[@"공지사항여부"] isEqualToString:@"Y"] ? aDataSet[@"공지사항"] : [NSString stringWithFormat:@"공지 사항이 있습니다."];
                    /*
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:strMessage
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"확인",nil];
                    
                    alert.tag =0;
                    [alert show];
                    [alert release];
                     */
                    
                    //공지사항 저장
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    //이전 공지사항과 같은지 비교
                    NSString *preNotiSeq = [defaults objectForKey:@"NotiKey"];
                    
                    NSString *notiType;
                    if ([[defaults objectForKey:@"NotiType"] length] > 0)
                    {
                        notiType = [[defaults objectForKey:@"NotiType"] substringToIndex:1];
                    }else
                    {
                        notiType = @"0";
                    }
                    NSString *serverNotiType = [AppInfo.versionInfo[@"공지사항TYPE"] substringToIndex:1];
                    if (![notiType isEqualToString:serverNotiType])
                    {
                        notiType = serverNotiType;
                    }
                    BOOL isShow = YES;
                    
//                    NSLog(@"aaaa:%@",AppInfo.versionInfo[@"공지사항SEQ"]);
//                    NSLog(@"bbbb:%@",preNotiSeq);
//                    NSLog(@"cccc:%@",[defaults objectForKey:@"NotiType"]);
//                    NSLog(@"dddd:%@",[defaults objectForKey:@"NotiDate"]);
                    
                    if ([AppInfo.versionInfo[@"공지사항SEQ"] isEqualToString:preNotiSeq] && [[defaults objectForKey:@"NotiType"] length] > 0)
                    {
                        
                        if ([notiType isEqualToString:@"0"])
                        {   //조건 없이 보여주기
                            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
                        }else if ([notiType isEqualToString:@"1"])
                        {
                            //다시보지 않기
                            isShow = NO;
                            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
                            
                        }else if ([notiType isEqualToString:@"2"])
                        {
                            //7일간 보지 않기
                            [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
                            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
                            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
                            //NSLog(@"aaaa:%@",[defaults objectForKey:@"NotiDate"]);
                            NSDate *sdate = [outputFormatter dateFromString:[defaults objectForKey:@"NotiDate"]];
                            
                            NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
                            //currentDate = @"2014-04-22";
                            NSDate *edate = [outputFormatter dateFromString:currentDate];
                            
                            NSDateComponents *dcom = [[NSCalendar currentCalendar]components: NSDayCalendarUnit
                                                                                    fromDate:sdate toDate:edate options:0];
                            
                            int dDay = [dcom day] + 1;
                            
                            
                            if (dDay >=0 && dDay < 8)
                            {
                                //아무것도 안함
                                isShow = NO;
                            }
                        }
                    }else
                    {
                        //seq가 틀리거나 저장된게 없으면
                        [defaults setObject:AppInfo.versionInfo[@"공지사항SEQ"] forKey:@"NotiKey"];
                        [defaults setObject:@"" forKey:@"NotiType"];
                        [defaults setObject:@"" forKey:@"NotiDate"];
                        
                    }
                    //공지사항보기옵션
                    [defaults synchronize];
                    AppInfo.commonNotiOption = [notiType intValue];
                    
                    //임시로......
                    //AppInfo.commonNotiOption = -1;
                    if (isShow)
                    {
                       [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:@"확인" message:strMessage];
                    }else
                    {
                        AppInfo.commonNotiOption = -1;
                    }
                    
                }else
                {
                   
                    //강제 종료가 아니고 공지 url이 있는경우
                    [(SHBMainViewController*)(AppDelegate.navigationController.viewControllers[0]) performSelector:@selector(noticeWebViewDidLoaded) withObject:nil afterDelay:0.1f];
                }
                
            }
            //return YES;
        }
        
        //일반 업데이트 알림
        //[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:2];
        NSString *tmpStr = [aDataSet objectForKey:@"최신버전"];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];

        //NSLog(@"aaaa:%@, %@",tmpStr,versionNumber);
        if ([tmpStr intValue] > [versionNumber intValue])
        {
            AppInfo.noticeState = 1;
            //업데이트 알림
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:1];
            tmpStr = aDataSet[@"업데이트메시지"];
            if ([tmpStr length] > 0)
            {
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:aDataSet[@"업데이트메시지"]
                                                               delegate:self
                                                      cancelButtonTitle:@"업데이트"
                                                      otherButtonTitles:@"취소",nil];
                
                alert.tag =775;
                [alert show];
                [alert release];
                */
                [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:775 title:nil buttonTitle:@"확인" message:aDataSet[@"업데이트메시지"]];
            }
            
        } else
        {
            //AppInfo.noticeState = 0;
        }
       
    }
    
    #ifdef DEVELOPER_MODE
        //AppInfo.noticeState = 2;
    #endif
    
    //이체 및 로그아웃 배너이미지를 미리 다운받는다
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelectorInBackground:@selector(getBannerImage) withObject:nil];
    [pool release];
    
    return YES;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    return YES;
}

- (void)getBannerImage
{
    //메인리스트
    NSArray *tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M001List.vector.data"];
    if ([tickArray count] > 0)
    {
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
            NSString *fileName = [paths objectAtIndex:[paths count]-1];
            NSString *cachePath = [NSString stringWithFormat:@"%@/main/",[SHBUtility getCachesDirectory]];
            NSString *filePath = [cachePath stringByAppendingString:fileName];
            //NSLog(@"aaaa:%@",fileName);
            //NSLog(@"bbbb:%@",cachePath);
            //NSLog(@"cccc:%@",filePath);
            if (![manager fileExistsAtPath:cachePath])
            {
                [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (NO==[manager createFileAtPath:filePath contents:imgData attributes:nil])
            {
                NSLog(@"fail");
            }
            
        }
    }
    //이체 완료
    tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M002List.vector.data"];
    if ([tickArray count] > 0)
    {
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
            //NSLog(@"아이콘Url:%@",[nDic objectForKey:@"아이콘Url"]);
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
            NSString *fileName = [paths objectAtIndex:[paths count]-1];
            NSString *cachePath = [NSString stringWithFormat:@"%@/eche/",[SHBUtility getCachesDirectory]];
            NSString *filePath = [cachePath stringByAppendingString:fileName];
            
            if (![manager fileExistsAtPath:cachePath])
            {
                [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            if (NO==[manager createFileAtPath:filePath contents:imgData attributes:nil])
            {
                
            }
            
        }
    }
    //로그아웃
    tickArray = [AppInfo.versionInfo arrayWithForKeyPath:@"M003List.vector.data"];
    if ([tickArray count] > 0)
    {
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
            //NSLog(@"아이콘Url:%@",[nDic objectForKey:@"아이콘Url"]);
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *paths = [[imgURL path] componentsSeparatedByString:@"/"];
            NSString *fileName = [paths objectAtIndex:[paths count]-1];
            NSString *cachePath = [NSString stringWithFormat:@"%@/out/",[SHBUtility getCachesDirectory]];
            NSString *filePath = [cachePath stringByAppendingString:fileName];
            
            if (![manager fileExistsAtPath:cachePath])
            {
                [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            if (NO==[manager createFileAtPath:filePath contents:imgData attributes:nil])
            {
                
            }
            
        }
    }
}
#pragma mark -
#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) //강제 업데이트
	{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
        exit(1);   //2011.11.7 앱스토어 업그레이트)
    }else if (alertView.tag == 779) //공지후 강제 종료
    {
        exit(1);
    }else if (alertView.tag == 775) //일반 업데이트
    {
        
        if (buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
            exit(1); 
        }
    }
}
@end
