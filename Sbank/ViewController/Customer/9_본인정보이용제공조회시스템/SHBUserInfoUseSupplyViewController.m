//
//  SHBUserInfoUseSupplyViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 29..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBUserInfoUseSupplyViewController.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBMobileCertificateService.h" // 서비스

#import "SHBARSCertificateViewController.h" // ARS인증

@interface SHBUserInfoUseSupplyViewController () <SHBARSCertificateDelegate>

@end

@implementation SHBUserInfoUseSupplyViewController

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
    
    [self setTitle:@"본인정보 이용제공 조회시스템"];
    self.strBackButtonTitle = @"본인정보 이용제공 조회시스템";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"거래구분" : @"9",
                              @"고객번호" : AppInfo.customerNo,
                              @"보안계좌" : @"2",
                              @"인터넷조회금지" : @"1"
                              }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_D1410_SERVICE viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_noAgreeView release];
    
    [_agreeView release];
    [_agreeDate release];
    [_agreeLocation release];
    [_agreeChannel release];
    
    [_bottomView release];
    [_supplyInfo release];
    
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setNoAgreeView:nil];
    [self setAgreeView:nil];
    [self setAgreeDate:nil];
    [self setAgreeLocation:nil];
    [self setAgreeChannel:nil];
    
    [self setBottomView:nil];
    [self setSupplyInfo:nil];
    
    [self setMainView:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (NSString *)getDataString:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"||" withString:@", "];
    
    NSString *tmpStr = [str substringFromIndex:[str length] - 2];
    
    if ([tmpStr isEqualToString:@", "]) {
        
        str = [str substringToIndex:[str length] - 2];
    }
    
    return str;
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 동의철회
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeTwoButton
                               tag:3313
                             title:@""
                           message:@"본인은 신한은행에\n기 동의한 마케팅 활용에\n대한 동의철회를\n신청합니다."];
        }
            break;
            
        case 200: {
            
            // 개인정보 조회/변경 바로가기
            
            self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114
                                                                    viewController:self] autorelease];
            
            [self.service start];
        }
            break;
            
        case 300: {
            
            // 확인
            
            [self.navigationController fadePopToRootViewController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    if (self.service.serviceId == CUSTOMER_D1410_SERVICE) {
        
        self.data = aDataSet;
        
        self.service = nil;
        self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_C2315_SERVICE viewController:self] autorelease];
        [self.service start];
    }
    else if (self.service.serviceId == CUSTOMER_C2315_SERVICE) {
        
        NSString *date = [self.data[@"마케팅활용_동의일자"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if ([self.data[@"마케팅활용동의_여부"] isEqualToString:@"1"] && 20141001 <= [date integerValue]) {
            
            // 2014.10.01 이후에 마케팅활용 동의한 경우
            
            [_agreeDate setText:[NSString stringWithFormat:@"동의일 : %@", [SHBUtility getDateWithDash:self.data[@"마케팅활용_동의일자"]]]];
            [_agreeLocation setText:[NSString stringWithFormat:@"동의장소 : %@", self.data[@"마케팅활용_동의장소"]]];
            [_agreeChannel setText:[NSString stringWithFormat:@"동의채널 : %@", [self getDataString:self.data[@"마케팅활용_동의내용"]]]];
            
            CGSize labelSize = [_agreeChannel.text sizeWithFont:_agreeChannel.font
                                              constrainedToSize:CGSizeMake(width(_agreeChannel), 999)
                                                  lineBreakMode:_agreeChannel.lineBreakMode];
            
            FrameResize(_agreeChannel, width(_agreeChannel), labelSize.height + 2);
            FrameResize(_agreeView, width(_agreeView), top(_agreeChannel) + height(_agreeChannel) + 71);
            
            FrameReposition(_agreeView, 0, 93);
            [self.contentScrollView addSubview:_agreeView];
            
            [_supplyInfo setText:[self getDataString:self.data[@"개인정보_제공내용"]]];
            
            labelSize = [_supplyInfo.text sizeWithFont:_supplyInfo.font
                                     constrainedToSize:CGSizeMake(width(_supplyInfo), 999)
                                         lineBreakMode:_supplyInfo.lineBreakMode];
            
            FrameResize(_supplyInfo, width(_supplyInfo), labelSize.height + 2);
            FrameResize(_bottomView, width(_bottomView), top(_supplyInfo) + height(_supplyInfo) + 40);
            
            FrameReposition(_bottomView, 0, top(_agreeView) + height(_agreeView));
            [self.contentScrollView addSubview:_bottomView];
            
            FrameResize(_mainView, width(_mainView), top(_bottomView) + height(_bottomView) + 69);
            [self.contentScrollView setContentSize:_mainView.frame.size];
        }
        else {
            
            // 2014.10.01 이전에 마케팅활용 동의하거나 마케팅활용 동의하지 않은 경우
            
            FrameReposition(_noAgreeView, 0, 93);
            [self.contentScrollView addSubview:_noAgreeView];
            
            [_supplyInfo setText:[self getDataString:self.data[@"개인정보_제공내용"]]];
            
            CGSize labelSize = [_supplyInfo.text sizeWithFont:_supplyInfo.font
                                            constrainedToSize:CGSizeMake(width(_supplyInfo), 999)
                                                lineBreakMode:_supplyInfo.lineBreakMode];
            
            FrameResize(_supplyInfo, width(_supplyInfo), labelSize.height + 2);
            FrameResize(_bottomView, width(_bottomView), top(_supplyInfo) + height(_supplyInfo) + 40);
            
            FrameReposition(_bottomView, 0, top(_noAgreeView) + height(_noAgreeView));
            [self.contentScrollView addSubview:_bottomView];
            
            FrameResize(_mainView, width(_mainView), top(_bottomView) + height(_bottomView) + 69);
            [self.contentScrollView setContentSize:_mainView.frame.size];
        }
        
        self.data = aDataSet;
    }
    else if (self.service.serviceId == CUSTOMER_C2316_SERVICE) {
        
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:3323
                         title:@""
                       message:@"마케팅 활용에 대한\n동의철회가\n완료되었습니다."];
    }
    else if (self.service.serviceId == MOBILE_CERT_E2114) {
        
        AppInfo.transferDic = @{ @"서비스코드" : @"C2310",
                                 @"본인정보이용제공조회시스템" : @"1" };
        
        SHBARSCertificateViewController *viewController = [[[SHBARSCertificateViewController alloc] initWithNibName:@"SHBARSCertificateViewController" bundle:nil] autorelease];
        [viewController setServiceSeq:SERVICE_USER_INFO_USE_SUPPLY];
        viewController.delegate = self;
        viewController.data = aDataSet;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@"SHBUserInfoEditSecurityViewController"];
        [viewController subTitle:@"추가인증 (ARS 인증)" infoViewCount:ARS_INFOVIEW_1];
    }
    
    return YES;
}

#pragma mark - SHBARSCertificateDelegate

- (void)ARSCertificateCancel
{
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3313) {
        
        if (buttonIndex == 0) {
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"DATA존재유무" : @"",
                                                                         @"DM희망지주소구분" : self.data[@"DM희망지주소구분"],
                                                                         @"EMAIL통지요청구분" : self.data[@"EMAIL통지요청구분"],
                                                                         @"SMS통지요청구분" : self.data[@"SMS통지요청구분"],
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         @"그룹사마케팅활용동의구분" : self.data[@"그룹사마케팅활용동의구분"],
                                                                         @"마케팅민감정보동의여부" : self.data[@"마케팅민감정보동의여부"],
                                                                         @"민감정보동의여부" : self.data[@"민감정보동의여부"],
                                                                         @"선택정보동의여부" : self.data[@"선택정보동의여부"],
                                                                         @"신용정보조회동의여부" : self.data[@"신용정보조회동의여부"],
                                                                         @"신용정보활용동의여부" : self.data[@"신용정보활용동의여부"],
                                                                         @"자택TM통지요청구분" : self.data[@"자택TM통지요청구분"],
                                                                         @"직장TM통지요청구분" : self.data[@"직장TM통지요청구분"],
                                                                         @"필수정보동의여부" : self.data[@"필수정보동의여부"],
                                                                         @"휴대폰통지요청구분" : self.data[@"휴대폰통지요청구분"],
                                                                         @"마케팅활용동의여부" : @"2"
                                                                         }];
            
            self.service = nil;
            self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_C2316_SERVICE viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
    }
    else if (alertView.tag == 3323) {
        
        [_agreeView removeFromSuperview];
        [_bottomView removeFromSuperview];
        
        [self.contentScrollView setContentSize:CGSizeZero];
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
        AppInfo.isNeedBackWhenError = YES;
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  @"거래구분" : @"9",
                                  @"고객번호" : AppInfo.customerNo,
                                  @"보안계좌" : @"2",
                                  @"인터넷조회금지" : @"1"
                                  }];
        
        self.service = nil;
        self.service = [[[SHBCustomerService alloc] initWithServiceId:CUSTOMER_D1410_SERVICE viewController:self] autorelease];
        
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

@end
