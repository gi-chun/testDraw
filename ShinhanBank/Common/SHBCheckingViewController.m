//
//  SHBCheckingViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCheckingViewController.h"
#import "SHBCardAgreeViewController.h" // 신한카드 이용동의 화면
#import "SHBCardService.h" // 신한카드 서비스
#import "SHBPentionService.h"               // 퇴직연금 서비스
#import "SHBSettingsService.h" // 간편조회 서비스
#import "SHBMobileCertificateService.h" // 모바일인증 서비스
#import "SHBVersionService.h" //신한카드 SSO 이용동의 여부 및  sso
#import "SHBLoanService.h" // 예적금담보대출 서비스
#import "SHBLoanStipulationViewController.h" // 예적금담보대출 약관
#import "SHBAccountService.h"

@interface SHBCheckingViewController ()
@property(nonatomic, retain) NSString *vcName;
@end

@implementation SHBCheckingViewController
@synthesize vcName;

#pragma mark -
#pragma mark onPase & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E3925"] )
    {
        // 가입한 퇴직연금이 없는 경우
        if ( nil == aDataSet[@"반복횟수"] || [aDataSet[@"반복횟수"] intValue] < 1 )
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"신한은행 퇴직연금 가입자 전용 메뉴입니다. 가입 후 이용해 주시기 바랍니다."];
            
            return NO;
        }
        
        // 가입한 퇴직연금이 있는 경우
        // 동의 여부
        OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                @{
                                @"고객번호" : AppInfo.customerNo,
                                @"reservationField1" : @"퇴직연금"
                                }] autorelease];
        self.service = nil;
        self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_AGREE viewController: self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    }
    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2315"] )      // 퇴직연금 동의 여부
    {
        NSString *strClassName = @"SHBRetirementReserveListViewController";
        
        BOOL isMarketingAgree = NO;
        BOOL isEssentialAgree = NO;
        
        if ([aDataSet[@"마케팅활용동의여부"] isEqualToString:@"1"] ||
            [aDataSet[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
            
			isMarketingAgree = YES;
		}
		else {
            
			isMarketingAgree = NO;
		}
		
		if ([aDataSet[@"필수정보동의여부"] isEqualToString:@"1"]) {
            
			isEssentialAgree = YES;
		}
		else {
            
			isEssentialAgree = NO;
		}
        
        if (!isMarketingAgree || !isEssentialAgree) {
            
            strClassName = @"SHBRetirementConfirmViewController";
        }
        else {
            
            strClassName = NSStringFromClass([AppInfo.lastViewController class]);
        }
        
        SHBBaseViewController *viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
        
        if (!isMarketingAgree || !isEssentialAgree) {
            
            viewController.data = aDataSet;
        }
        
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    else if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E2114"]) {
        if ([aDataSet[@"사기예방SMS통지여부"] isEqualToString:@"Y"]) {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"사기예방 SMS 통지 서비스 해제 후 이용기기 등록 서비스 신청이 가능합니다."];
            
            return NO;//
        }
        
        if ([aDataSet[@"안심거래서비스가입여부"] isEqualToString:@"Y"]) {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"안심거래 서비스 신청 고객님은 이용기기 등록 서비스 가입이 불가합니다."];
            
            return NO;
        }
        
        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBDeviceRegistServiceViewController") alloc] initWithNibName:@"SHBDeviceRegistServiceViewController" bundle:nil] autorelease];
        [AppDelegate.navigationController pushFadeViewController:viewController];
    }
    
    // 간편조회
    if (self.service.serviceId == EASY_INQUIRY_SELECT)
    {
        AppInfo.isEasyInquiry = NO;
        
        //for (NSDictionary *dic in [AppInfo.userInfo arrayWithForKey:@"예금계좌"])
        for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"])
        {
            NSString *strAccountNoSub = [dic[@"계좌번호"]substringToIndex:3];
            NSInteger nAccountNoSub = [strAccountNoSub integerValue];
            
            NSString *accountNm = @"";
            
            if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                accountNm = [dic[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            else {
                accountNm = [dic[@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            
            if ((nAccountNoSub >= 100 && nAccountNoSub <= 149)
                || (nAccountNoSub >= 150 && nAccountNoSub <= 159)) {
                
                if ([aDataSet[@"메인계좌번호"] isEqualToString:accountNm]) {
                    NSDictionary *dicData = @{
                    @"1" : ([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"],
                    @"2" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"],
                    };
                    
                    AppInfo.commonDic = dicData;

                    SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBAccountInqueryViewController") class] alloc] initWithNibName:@"SHBAccountInqueryViewController" bundle:nil];
                    
                    [AppDelegate.navigationController pushFadeViewController:viewController];
                    [viewController release];
                    
                    break;
                }
            }
        }
    }else if (self.service.serviceId == CARD_SSO_GROUP)
    {
        //신한카드 sso 분기
        
        NSLog(@"aDataSet:%@",aDataSet);
        if ([aDataSet[@"result"] isEqualToString:@"1"])
        {
            //sync 테스트
            //NSString *passScheme = [NSString stringWithFormat:@"iphoneSbank://?grssoTicket=%@",aDataSet[@"ticket"]];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:passScheme]];
            
            //이용약관동의 화면 이동
            //SHBBaseViewController *viewController = [[[NSClassFromString(self.vcName) alloc] initWithNibName:self.vcName bundle:nil] autorelease];
            //[AppDelegate.navigationController pushFadeViewController:viewController];
            
            //정상로직
            //가입동의 및 정상 신한카드앱 연동 요청
            if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartshinhan://"]])
            {
                
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1563 title:nil message:@"스마트카드 앱이 존재하지 않습니다\n설치페이지로 이동합니다."];
                return NO;
            }
            NSString *passScheme = [NSString stringWithFormat:@"smartshinhan://?grssoTicket=%@",aDataSet[@"ticket"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:passScheme]];
            
        }else if ([aDataSet[@"result"] isEqualToString:@"2"])
        {
            if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"smartshinhan://"]])
            {
                
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1563 title:nil message:@"스마트카드 앱이 존재하지 않습니다\n설치페이지로 이동합니다."];
                return NO;
            }
            NSString *passScheme = [NSString stringWithFormat:@"smartshinhan://?grssoTicket=%@",@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:passScheme]];
            
        }else if ([aDataSet[@"result"] isEqualToString:@"3"])
        {
            //동의 미가입
            SHBBaseViewController *viewController = [[[NSClassFromString(self.vcName) alloc] initWithNibName:self.vcName bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
        }else if ([aDataSet[@"result"] isEqualToString:@"4"])
        {
            //타그룹미가입
        }
    }
    else if (self.service.serviceId == LOAN_4DAYS_CHECK) {
        
        // 예적금담보대출의 신청버튼을 누른 경우 4영업일 이내 가입인지 체크
        
        if ([aDataSet[@"정상여부"] isEqualToString:@"1"]) {
            
            SHBLoanStipulationViewController *viewController = [[[SHBLoanStipulationViewController alloc]initWithNibName:@"SHBLoanStipulationViewController" bundle:nil] autorelease];
            
            viewController.Loantype = AppInfo.commonDic[@"_대출타입"];
            
            [AppDelegate.navigationController pushFadeViewController:viewController];
        }
    }
    else if ([self.service.strServiceCode isEqualToString:@"D0011"]) {
        
        // 적금가입여부 확인
        
        BOOL isFind = NO;
        
        for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
            
            if ([dic[@"상품코드"] isEqualToString:@"230011831"]) {
                
                isFind = YES;
                break;
            }
        }
        
        if (isFind) {
            
            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSmartTransferAddInputViewController") alloc] initWithNibName:@"SHBSmartTransferAddInputViewController" bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
        }
        else {
            
            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSmartTransferInfoViewController") alloc] initWithNibName:@"SHBSmartTransferInfoViewController" bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
        }
    }
    
    return NO;
}

#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet
{	
	return NO;
}


#pragma mark -
#pragma mark Xcode Generate

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
	
	[self navigationViewHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)requestCheckWithController:(NSString *)ctrlName
{
    // 신한카드
	if ([ctrlName hasPrefix:@"SHBCard"])
    {
        if ([ctrlName hasPrefix:@"SHBCardAgree"]) {
            SHBBaseViewController *viewController = [[[NSClassFromString(ctrlName) alloc] initWithNibName:ctrlName bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            
            return;
        }
        
        if ([ctrlName hasPrefix:@"SHBCardSSOAgreeContentsViewController"])
        {
            self.vcName = @"SHBCardSSOAgreeContentsViewController";
            
            SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                        @{
                                                               TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKSsoService",
                                                             TASK_ACTION_KEY : @"",
                                        @"deviceId" : [AppDelegate getSSODeviceID],
                                        @"appStatus" : @"MAKE",
                                        @"GROUP_CODE" : @"S012",
                                        //@"COM_SUBCHN_KBN" :@"02",
                                        }] autorelease];
            
            self.service = nil;
            self.service = [[[SHBVersionService alloc] initWithServiceId:CARD_SSO_GROUP viewController:self] autorelease];
            self.service.previousData = forwardData;
            [self.service start];
            
            return;
        }
        
        if ([ctrlName hasPrefix:@"SHBCardSSO"])
        {
            SHBBaseViewController *viewController = [[[NSClassFromString(ctrlName) alloc] initWithNibName:ctrlName bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            return;
        }
        
		if (!AppInfo.isCardAgree)
        {
            SHBCardAgreeViewController *viewController = [[[SHBCardAgreeViewController alloc] initWithNibName:@"SHBCardAgreeViewController" bundle:nil] autorelease];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            
            return;
        }
        else
        {
            SHBCardService *service = [[[SHBCardService alloc] initWithServiceCode:CARD_E2911
                                                                    viewController:self] autorelease];
            
            if ([AppInfo.codeList.cardList count] == 0) {
                [service start];
            }
            else {
                [service cardErrorCheck];
            }
        }
	}
    // 보안센터 이용기기등록서비스 선택시
    else if ([ctrlName isEqualToString:@"SHBDeviceRegistServiceViewController"])
    {
        self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114 viewController:self] autorelease];
        [self.service start];
    }
    // 지로 지방세의 경우
    else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBGiroTax"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBDistricTaxMenu"])
    {
        
        int intEarlyTime    = 3000;
        int intEndTime      = 213000;
        int intTime = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
        
        NSString *strMessage = @"평일/토요일/휴일 00:30~21:30 까지만 이용가능한 서비스입니다.";
        
        // 지방세의 경우 시간과 메세지가 다르다
        if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBDistricTaxMenu"] )
        {
            intEndTime = 220000;
            strMessage = @"평일/토요일/휴일 오전 0시 30분 ~ 오후 10시 (부산시 : 오전7시~오후10시)까지만 이용가능한 서비스입니다.";
        }
        // 서비스 시간이 아닌경우
        if ( intTime < intEarlyTime || intTime > intEndTime )
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strMessage];
            return;
        }
        else
        {
            NSString *strClassName = NSStringFromClass([AppInfo.lastViewController class]);
            
            SHBBaseViewController *viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
    // 퇴직연금의 경우
    else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReserve"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBProductState"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBSurcharge"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReceip"]|| [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBESNoti"] )
    {
        // 가입 유무 판단
        OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                @{
                                @"서비스ID" : @"SRPW767010Q0",
                                @"고객구분" : @"3",
                                @"플랜번호" : @"",
                                @"가입자번호" : @"",
                                @"제도구분" : @"",
                                @"페이지인덱스" : @"1",
                                @"전체조회건수" : @"0",
                                @"페이지패치건수" : @"500",
                                @"예비필드" : @"",
                                @"적립금조회" : @"",
                                //@"주민사업자번호" : AppInfo.ssn
                                //@"주민사업자번호" : [AppInfo getPersonalPK],
                                @"주민사업자번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                }] autorelease];
        self.service = nil;
        self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_JOIN_JUDGE viewController: self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
    }
    
    // 간편조회 
    else if (AppInfo.isEasyInquiry && [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBAccountInqueryViewController"]) {
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                TASK_ACTION_KEY : @"Main_Select",
                                @"고객번호" : AppInfo.customerNo,
                                }];
        self.service = nil;
        self.service = [[[SHBSettingsService alloc] initWithServiceId:EASY_INQUIRY_SELECT viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
    
    // 예적금담보대출의 신청버튼을 누른 경우 4영업일 이내 가입인지 체크
    else if ([ctrlName isEqualToString:@"SHBLoanStipulationViewController"]) {
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                  TASK_ACTION_KEY : @"masReqDateChk",
                                  }];
        self.service = nil;
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_4DAYS_CHECK viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
    
    // 스마트 이체 조회/등록/변경
    else if ([ctrlName isEqualToString:@"SHBSmartTransferAddInputViewController"]) {
        
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
        self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
        [self.service start];
    }
}

@end
