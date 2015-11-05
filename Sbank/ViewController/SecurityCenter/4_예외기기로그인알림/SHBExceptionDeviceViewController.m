//
//  SHBExceptionDeviceViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 2. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBExceptionDeviceViewController.h"
#import "SHBMobileCertificateService.h" // 서비스
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBUtility.h"

#import "SHBMobileCertificateViewController.h" // SMS인증

@interface SHBExceptionDeviceViewController () <SHBMobileCertificateDelegate>

- (void)request;
- (void)setLayout:(BOOL)isJoin;

@end

@implementation SHBExceptionDeviceViewController

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
    
    [self setTitle:@"예외 기기 로그인 알림"];
    self.strBackButtonTitle = @"예외 기기 로그인 알림";
    
    [_infoLabel1 initFrame:_infoLabel1.frame];
    [_infoLabel1 setText:@"<midGray_13>본 서비스를</midGray_13><midLightBlue_13> 해지하시려면 영업점을 방문</midLightBlue_13><midGray_13>하시어 본인 확인 절차를 거치셔야 합니다.</midGray_13>"];
    
    [_infoLabel2 initFrame:_infoLabel2.frame];
    [_infoLabel2 setText:@"<midGray_13>PC나 스마트기기 식별 시 기기 고유정보를 확인함으로,</midGray_13><midLightBlue_13> PC나 스마트기기를 새로 교체하셨거나 공공장소의 PC나 스마트기기를 이용하시는 경우</midLightBlue_13><midGray_13> SMS가 발송 됩니다.</midGray_13>"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainSV release];
    [_bottomView1 release];
    [_bottomView2 release];
    [_infoLabel1 release];
    [_infoLabel2 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainSV:nil];
    [self setBottomView1:nil];
    [self setBottomView2:nil];
    [self setInfoLabel1:nil];
    [self setInfoLabel2:nil];
    [super viewDidUnload];
}

#pragma mark - 

- (void)request
{
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3020_SERVICE
                                                         viewController:self] autorelease];
    [self.service start];
}

- (void)setLayout:(BOOL)isJoin
{
    [_bottomView1 removeFromSuperview];
    [_bottomView2 removeFromSuperview];
    
    UIView *bottomView = nil;
    
    if (isJoin)
    {
        // 가입한 경우
        bottomView = _bottomView1;
    }
    else
    {
        // 가입 안한 경우
        bottomView = _bottomView2;
    }
    
    [bottomView setFrame:CGRectMake(0, 375, bottomView.frame.size.width, bottomView.frame.size.height)];
    
    [_mainSV addSubview:bottomView];
    [_mainSV setContentSize:CGSizeMake(_mainSV.frame.size.width,
                                       bottomView.frame.origin.y + bottomView.frame.size.height)];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag])
    {
        case 100: // 서비스 신청
        {
            self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114
                                                                    viewController:self] autorelease];
            [self.service start];
        }
            break;
            
        case 200: // 확인
        {
            [self.navigationController fadePopViewController];
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
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (self.service.serviceId == SECURITY_E3020_SERVICE)
    {
        // 예외PC알림 (1 : 가입, 9 : 미가입)
        if ([aDataSet[@"예외PC알림"] isEqualToString:@"1"])
        {
            [self setLayout:YES];
        }
        else
        {
            [self setLayout:NO];
        }
    }
    else if (self.service.serviceId == MOBILE_CERT_E2114)
    {
        if ([aDataSet[@"휴대폰상이"] isEqualToString:@"1"] ||
            [aDataSet[@"휴대폰번호"] length] == 0)
        {
            // 휴대폰 번호 없음
            
            AppInfo.commonDic = @{ @"휴대폰번호" : @"", @"휴대폰번호표시용" : @"" };
        }
        else
        {
            NSString *phoneNumber = [SHBUtility nilToString:aDataSet[@"휴대폰번호"]];
            
            if ([phoneNumber length] > 4) {
                NSString *number = [phoneNumber substringWithRange:NSMakeRange(0, [phoneNumber length] - 4)];
                
                AppInfo.commonDic = @{ @"휴대폰번호" : phoneNumber, @"휴대폰번호표시용" : [NSString stringWithFormat:@"%@****", number] };
            }
            else {
                AppInfo.commonDic = @{ @"휴대폰번호" : phoneNumber, @"휴대폰번호표시용" : phoneNumber };
            }
        }
        
        AppInfo.transferDic = @{ @"서비스코드" : @"E3021" };
        
        SHBMobileCertificateViewController *viewController = [[[SHBMobileCertificateViewController alloc] initWithNibName:@"SHBMobileCertificateViewController" bundle:nil] autorelease];
        
        [viewController setNeedsLogin:YES];
        [viewController setServiceSeq:SERVICE_EXCEPTION_DEVICE];
        [viewController setDelegate:self];
        [viewController setData:aDataSet];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        [viewController executeWithTitle:@"예외 기기 로그인 알림"
                                subTitle:@"휴대폰 인증"
                                    step:1
                               stepCount:4
                           infoViewCount:MOBILE_INFOVIEW_1
                      nextViewController:@"SHBExceptionDeviceConfirmViewController"];
    }
    
    return YES;
}

#pragma mark - SHBMobileCertificate Delegate

- (void)mobileCertificateCancel
{
    
}

@end
