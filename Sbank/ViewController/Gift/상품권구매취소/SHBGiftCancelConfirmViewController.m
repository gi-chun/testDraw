//
//  SHBGiftCancelConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelConfirmViewController.h"
#import "SHBGiftService.h" // service

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

#import "SHBGiftCancelDetailViewController.h" // 상품권 취소
#import "SHBGiftCancelCompleteViewController.h" // 상품권 구매 취소 완료

@interface SHBGiftCancelConfirmViewController () <SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBGiftCancelConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self initNotification];
    
    [super viewDidLoad];
    
    [self setTitle:@"모바일상품권 구매취소"];
    self.strBackButtonTitle = @"모바일상품권 구매취소 상품권 취소 정보확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        _secretOTPViewController.nextSVC = @"E1740";
        
        FrameResize(_securityView, _securityView.frame.size.width, _secretOTPViewController.view.bounds.size.height + 1);
        
        [_secretOTPViewController setSelfPosY:_securityView.frame.origin.y + 37 + 1];
        
        [_securityView addSubview:_secretOTPViewController.view];
        
        FrameReposition(_secretOTPViewController.view, 0, 1);
        FrameResize(_secretOTPViewController.view, _secretOTPViewController.view.bounds.size.width, _secretOTPViewController.view.bounds.size.height);
    }
    else {
        
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        _secretCardViewController.nextSVC = @"E1740";
        
        FrameResize(_securityView, _securityView.frame.size.width, _secretCardViewController.view.bounds.size.height + 1);
        
        [_secretCardViewController setSelfPosY:_securityView.frame.origin.y + 37 + 1];
        
        [_securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        
        FrameReposition(_secretCardViewController.view, 0, 1);
        FrameResize(_secretCardViewController.view, _secretCardViewController.view.bounds.size.width, _secretCardViewController.view.bounds.size.height);
    }
    
    [_securityView bringSubviewToFront:_lineView];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    CGSize labelSize = [_messageView.text sizeWithFont:_messageView.font
                                     constrainedToSize:CGSizeMake(_messageView.frame.size.width, 999)
                                         lineBreakMode:_messageView.lineBreakMode];
    
    if (labelSize.height > 20) {
        
        FrameResize(_messageView, _messageView.frame.size.width, labelSize.height + 2);
    }
    else {
        
        FrameResize(_messageView, _messageView.frame.size.width, labelSize.height);
    }
    
    FrameReposition(_securityView, 0, _messageView.frame.origin.y + _messageView.frame.size.height + 10);
    
    FrameResize(_mainView, _mainView.frame.size.width, _securityView.frame.origin.y + _securityView.frame.size.height);
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_mainView release];
    [_securityView release];
    [_lineView release];
    [_messageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setSecurityView:nil];
    [self setLineView:nil];
    [self setMessageView:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SHBGiftCancelCompleteViewController *viewController = [[[SHBGiftCancelCompleteViewController alloc] initWithNibName:@"SHBGiftCancelCompleteViewController" bundle:nil] autorelease];
    
    viewController.data = [notification userInfo];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (SHBGiftCancelDetailViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[SHBGiftCancelDetailViewController class]]) {
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

#pragma mark - Method

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"모바일상품권 구매취소";
        
        AppInfo.electronicSignCode = @"E1740";
        AppInfo.electronicSignTitle = @"상품권 구매 취소";
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)상품권 종류: %@", self.data[@"_상품권명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)계좌번호: %@", self.data[@"_계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)구매금액: %@", self.data[@"_구매금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)환급금액: %@", self.data[@"_환급금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)보내는분 성명: %@", self.data[@"구매자성명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)받는분 성명: %@", self.data[@"받는분성명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)받는분 휴대폰번호: %@", self.data[@"받는분휴대폰"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)보내는분 휴대폰번호: %@", self.data[@"구매자휴대폰"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)전달내용: %@", self.data[@"전달메세지"]]];
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  @"거래구분" : @"4",
                                  @"업무유형" : @"1",
                                  @"기관코드" : self.data[@"상품권명"],
                                  @"판매금액" : self.data[@"구매금액"],
                                  @"계좌구분" : self.data[@"_계좌구분"],
                                  @"지급계좌번호" : self.data[@"_계좌번호"],
                                  @"계좌비밀번호" : @"",
                                  @"센터처리번호" : @"",
                                  @"구매자휴대폰" : self.data[@"구매자휴대폰"],
                                  @"받는분휴대폰" : self.data[@"받는분휴대폰"],
                                  @"구매자성명" : self.data[@"구매자성명"],
                                  @"받는분성명" : self.data[@"받는분성명"],
                                  @"전달메세지" : [SHBUtility nilToString:self.data[@"전달메세지"]],
                                  @"취소시구매일자" : self.data[@"판매일자"],
                                  @"취소시구매승인번호" : self.data[@"승인번호"]
                                  }];
        
        self.service = nil;
        self.service = [[[SHBGiftService alloc] initWithServiceId:GIFT_E1740 viewController:self] autorelease];
        
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [self getElectronicSignCancel];
}

@end
