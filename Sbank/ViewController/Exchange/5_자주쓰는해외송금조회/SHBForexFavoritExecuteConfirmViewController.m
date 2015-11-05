//
//  SHBForexFavoritExecuteConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritExecuteConfirmViewController.h"
#import "SHBUtility.h" // 유틸
#import "SHBExchangeService.h" // 서비스

#import "SHBForexFavoritExecuteInputViewController.h" // 자주쓰는 해외송금 정보입력
#import "SHBForexFavoritExecuteCompleteViewController.h" // 자주쓰는 해외송금 완료
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBForexFavoritExecuteConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBForexFavoritExecuteConfirmViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 서버통신 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverError)
                                                 name:@"notiServerError"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverError)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverError)
                                                 name:@"eSignCancel"
                                               object:nil];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    
    [self.contentScrollView addSubview:_mainView];
    
    [self.binder bind:self dataSet:_detailData];
    
    // 가변 길이 설정
    CGFloat yy = _name.frame.origin.y;
    
    [self adjustToView:_name originX:_name.frame.origin.x originY:yy text:_name.text];
    
    yy += _name.frame.size.height + 9;
    
    [self adjustToView:_phoneNumberLabel originX:_phoneNumberLabel.frame.origin.x originY:yy text:_phoneNumberLabel.text];
    [self adjustToView:_phoneNumber originX:_phoneNumber.frame.origin.x originY:yy text:_phoneNumber.text];
    
    yy += _phoneNumber.frame.size.height + 9;
    
    [self adjustToView:_juminLabel originX:_juminLabel.frame.origin.x originY:yy text:_juminLabel.text];
    [self adjustToView:_jumin originX:_jumin.frame.origin.x originY:yy text:_jumin.text];
    
    yy += _jumin.frame.size.height + 9;
    
    [self adjustToView:_addressLabel originX:_addressLabel.frame.origin.x originY:yy text:_addressLabel.text];
    [self adjustToView:_address originX:_address.frame.origin.x originY:yy text:_address.text];
    
    yy += _address.frame.size.height + 9;
    
    [self adjustToView:_bankNameLabel originX:_bankNameLabel.frame.origin.x originY:yy text:_bankNameLabel.text];
    [self adjustToView:_bankName originX:_bankName.frame.origin.x originY:yy text:_bankName.text];
    
    yy += _bankName.frame.size.height + 9;
    
    [self adjustToView:_branchNameLabel originX:_branchNameLabel.frame.origin.x originY:yy text:_branchNameLabel.text];
    [self adjustToView:_branchName originX:_branchName.frame.origin.x originY:yy text:_branchName.text];
    
    yy += _branchName.frame.size.height + 9;
    
    [self adjustToView:_bankAddressLabel originX:_bankAddressLabel.frame.origin.x originY:yy text:_bankAddressLabel.text];
    [self adjustToView:_bankAddress originX:_bankAddress.frame.origin.x originY:yy text:_bankAddress.text];
    
    yy += _bankAddress.frame.size.height + 9;
    
    [_addressBottomView setFrame:CGRectMake(_addressBottomView.frame.origin.x,
                                            yy,
                                            _addressBottomView.frame.size.width,
                                            _addressBottomView.frame.size.height)];
    
    [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                   37,
                                   _infoView.frame.size.width,
                                   _addressBottomView.frame.origin.y + _addressBottomView.frame.size.height)];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        _secretOTPViewController.nextSVC = EXCHANGE_F2028;
        
        [_securityView setFrame:CGRectMake(0,
                                           37 + _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           _secretOTPViewController.view.bounds.size.height + 1)];
        [_secretOTPViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretOTPViewController.view];
        
        [_secretOTPViewController.view setFrame:CGRectMake(0,
                                                           1,
                                                           _secretOTPViewController.view.bounds.size.width,
                                                           _secretOTPViewController.view.bounds.size.height)];
    }
    else {
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        _secretCardViewController.nextSVC = EXCHANGE_F2028;
        
        [_securityView setFrame:CGRectMake(0,
                                           37 + _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           _secretCardViewController.view.bounds.size.height + 1)];
        [_secretCardViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        [_secretCardViewController.view setFrame:CGRectMake(0,
                                                            1,
                                                            _secretCardViewController.view.bounds.size.width,
                                                            _secretCardViewController.view.bounds.size.height)];
    }
    
    [_securityView bringSubviewToFront:_lineView];
    
    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   37 + _infoView.frame.size.height + _securityView.frame.size.height)];
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.detailData = nil;
    
    [_mainView release];
    [_infoView release];
    [_securityView release];
    [_name release];
    [_phoneNumberLabel release];
    [_phoneNumber release];
    [_juminLabel release];
    [_jumin release];
    [_addressLabel release];
    [_address release];
    [_bankNameLabel release];
    [_bankName release];
    [_branchNameLabel release];
    [_branchName release];
    [_bankAddressLabel release];
    [_bankAddress release];
    [_addressBottomView release];
    [_lineView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setInfoView:nil];
    [self setSecurityView:nil];
    [self setName:nil];
    [self setPhoneNumberLabel:nil];
    [self setPhoneNumber:nil];
    [self setJuminLabel:nil];
    [self setJumin:nil];
    [self setAddressLabel:nil];
    [self setAddress:nil];
    [self setBankNameLabel:nil];
    [self setBankName:nil];
    [self setBranchNameLabel:nil];
    [self setBranchName:nil];
    [self setBankAddressLabel:nil];
    [self setBankAddress:nil];
    [self setAddressBottomView:nil];
    [self setLineView:nil];
	[super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBForexFavoritInfoViewController") class]] ||
            [viewController isKindOfClass:[NSClassFromString(@"SHBForexFavoritExecuteInputViewController") class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
        }
    }
    
    if (!AppInfo.errorType) {
        AppInfo.commonDic = [NSMutableDictionary dictionaryWithDictionary:_detailData];
        
        SHBForexFavoritExecuteCompleteViewController *viewController = [[[SHBForexFavoritExecuteCompleteViewController alloc] initWithNibName:@"SHBForexFavoritExecuteCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)serverError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (SHBForexFavoritExecuteInputViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[SHBForexFavoritExecuteInputViewController class]]) {
            [viewController serverError];
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    if (labelSize.height > 36) {
        labelSize.height = 36;
    }
    else {
        labelSize.height = 16;
    }
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"자주쓰는 해외송금/조회";
        
        AppInfo.electronicSignCode = EXCHANGE_F2028;
        AppInfo.electronicSignTitle = @"해외송금";
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)송금구분: %@", _detailData[@"_송금구분"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)통화구분: %@", _detailData[@"_통화구분"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)전체송금액(외화): %@", _detailData[@"_환전금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)유학생주민등록번호: %@", _detailData[@"_주민등록번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)해외수수료부담자: %@", _detailData[@"_해외수수료부담자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)해외수수료: %@", _detailData[@"_해외수수료"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)외화출금계좌번호: %@", _detailData[@"_외화출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)외화계좌인출금액: %@", _detailData[@"_외화계좌인출금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)원화출금계좌번호: %@", _detailData[@"_원화출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)원화계좌인출금액: %@", _detailData[@"_원화계좌인출금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(13)송금수수료(원): %@", _detailData[@"수수료금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(14)전신료(원): %@", _detailData[@"전신료금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(15)외화인출합계금액: %@",
                                    [SHBUtility nilToString:_detailData[@"_외화계좌인출금액"]]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(16)원화인출합계금액(원): %@", _detailData[@"원화환산합계"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(17)적용환율: %@", _detailData[@"_적용환율"]]];
        [AppInfo addElectronicSign:@"(18)서비스명: 해외송금"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(19)재산반출 내역: %@", _detailData[@"_송금사유"]]];
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"외화지급계좌번호" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2027][@"외화지급계좌번호"]],
                               @"의뢰인" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"의뢰인정보내용1"]],
                               @"의뢰인전화번호" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금의뢰인전화번호"]],
                               @"의뢰인주소1" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"의뢰인정보내용2"]],
                               @"의뢰인주소2" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"의뢰인정보내용3"]],
                               @"의뢰인이메일주소" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"의뢰인이메일주소"]],
                               @"수취인" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인정보내용1"]],
                               @"수취인주소1" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인정보내용2"]],
                               @"수취인주소2" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인정보내용3"]],
                               @"수취인전화번호" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금수취인전화번호"]],
                               @"수취인계좌번호" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인계좌번호"]],
                               @"수취인은행명" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인은행정보1"]],
                               @"수취인은행지점명" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인은행정보2"]],
                               @"수취인은행주소1" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인은행정보3"]],
                               @"수취인이메일주소" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인이메일주소"]],
                               @"수취인특기사항1" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금인메시지내용1"]],
                               @"수취인특기사항2" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금인메시지내용2"]],
                               @"수취인특기사항3" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금인메시지내용3"]],
                               @"수취인특기사항4" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"송금인메시지내용4"]],
                               @"해외은행구분" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"해외결제전산망_CODE"]],
                               @"해외은행번호" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"은행CODE"]],
                               @"SWIFT코드" : [SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"SWIFT코드"]]
                               }];
        
        if ([[SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"수취인이메일주소"]] length] > 1) {
            [dataSet insertObject:@"1"
                           forKey:@"수취인이메일통보여부"
                          atIndex:0];
        }
        else {
            [dataSet insertObject:@"0"
                           forKey:@"수취인이메일통보여부"
                          atIndex:0];
        }
        
        if ([[SHBUtility nilToString:AppInfo.commonDic[EXCHANGE_F2035][@"의뢰인이메일주소"]] length] > 1) {
            [dataSet insertObject:@"1"
                           forKey:@"이메일통보여부"
                          atIndex:0];
        }
        else {
            [dataSet insertObject:@"0"
                           forKey:@"이메일통보여부"
                          atIndex:0];
        }
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F2028_SERVICE
                                                       viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
        
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SHBForexFavoritInfoViewController")]) {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
