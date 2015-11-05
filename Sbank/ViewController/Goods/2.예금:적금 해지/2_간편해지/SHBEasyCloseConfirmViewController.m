//
//  SHBEasyCloseConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseConfirmViewController.h"
#import "SHBProductService.h" // service
#import "SHBListPopupView.h" // list popup

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

#import "SHBEasyCloseViewController.h" // 신한e-간편해지 서비스 신청
#import "SHBEasyCloseCompleteViewController.h" // 신한e-간편해지 완료

@interface SHBEasyCloseConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate, SHBListPopupViewDelegate>

@property (retain, nonatomic) NSString *encriptedPassword; // 계좌비밀번호
@property (retain, nonatomic) NSMutableArray *accountList; // 입금계좌번호
@property (retain, nonatomic) NSMutableDictionary *selectAccountDic; // 선택한 입금계좌번호

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBEasyCloseConfirmViewController

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
    
    [self setTitle:@"신한e-간편해지"];
    self.strBackButtonTitle = @"신한e-간편해지 계좌 확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        _secretOTPViewController.nextSVC = @"D3287";
        _secretOTPViewController.prevTF = _secureTF;
        
        FrameResize(_securityView, _securityView.frame.size.width, _secretOTPViewController.view.bounds.size.height);
        
        [_secretOTPViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretOTPViewController.view];
        
        startTextFieldTag = 9;
        endTextFieldTag = 11;
    }
    else {
        
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        _secretCardViewController.nextSVC = @"D3287";
        _secretCardViewController.prevTF = _secureTF;
        
        FrameResize(_securityView, _securityView.frame.size.width, _secretCardViewController.view.bounds.size.height);
        
        [_secretCardViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        
        startTextFieldTag = 9;
        endTextFieldTag = 12;
    }
    
    FrameResize(_mainView, _mainView.frame.size.width, _securityView.frame.origin.y + _securityView.frame.size.height);
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;
    
    self.encriptedPassword = @"";
    self.accountList = [NSMutableArray array];
    self.selectAccountDic = [NSMutableDictionary dictionary];
    
    // 계좌비밀번호
    [_secureTF showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.smartNewDic = nil;
    
    self.encriptedPassword = nil;
    self.accountList = nil;
    self.selectAccountDic = nil;
    
    [_secureTF release];
    [_accountNumber release];
    [_securityView release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSecureTF:nil];
    [self setAccountNumber:nil];
    [self setSecurityView:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SHBEasyCloseCompleteViewController *viewController = [[[SHBEasyCloseCompleteViewController alloc] initWithNibName:@"SHBEasyCloseCompleteViewController" bundle:nil] autorelease];
    
    if (_smartNewDic) {
        
        viewController.smartNewDic = _smartNewDic;
    }
    
    viewController.data = [notification userInfo];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        
        if (_smartNewDic) {
            
            BOOL isFind = NO;
            
            for (SHBBaseViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:NSClassFromString(@"SHBSmartNewListViewController")]) {
                    
                    isFind = YES;
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
            
            if (!isFind) {
                
                NSInteger count = [self.navigationController.viewControllers count];
                
                if ([self.navigationController.visibleViewController isKindOfClass:[self class]]) {
                    
                    count -= 3;
                }
                else {
                    
                    count -= 4;
                }
                
                UIViewController *viewController = self.navigationController.viewControllers[count];
                
                [self.navigationController fadePopToViewController:viewController];
            }
        }
        else {
            
            for (SHBEasyCloseViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBEasyCloseViewController class]]) {
                    
                    [viewController resetUI];
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
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

#pragma mark - Button

/// 계좌비밀번호
- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_secureTF becomeFirstResponder];
}

/// 입금계좌번호
- (IBAction)buttonPressed:(id)sender
{
    [_secureTF resignFirstResponder];
    
    self.accountList = [NSMutableArray array];
    
    // 계좌이체의 본인계좌 버튼과 동일
    
    for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
        
        if ([dic[@"입금가능여부"] isEqualToString:@"1"] && [dic[@"예금종류"] isEqualToString:@"1"]) {
            
            // 입금가능계좌이며 유동성 계좌인 경우
            
            [_accountList addObject:@{
                                      @"1" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                                      @"2" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                      @"은행구분" : ([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : [dic objectForKey:@"은행코드"],
                                      @"계좌번호" : dic[@"계좌번호"]
                                      }];
        }
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"본인계좌"
                                                                   options:_accountList
                                                                   CellNib:@"SHBAccountListPopupCell"
                                                                     CellH:50
                                                               CellDispCnt:5
                                                                CellOptCnt:4] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        
        if ([_accountNumber.titleLabel.text length] == 0 ||
            [_accountNumber.titleLabel.text isEqualToString:@"선택하세요"]) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"입금계좌번호를 선택해 주세요."];
            return;
        }
        
        if ([_encriptedPassword length] == 0 || [_secureTF.text length] != 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"계좌비밀번호를 입력해 주세요."];
            return;
        }
        
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"신한e-간편해지";
        
        AppInfo.electronicSignCode = @"D3287";
        AppInfo.electronicSignTitle = @"신한e-간편해지 신청";
        
        [AppInfo addElectronicSign:@"1.신청내용"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)예금명: %@", self.data[@"_과목명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)예금계좌번호: %@", self.data[@"_계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)입금계좌번호: %@", _accountNumber.titleLabel.text]];
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                  @"거래구분" : @"신한e-간편 해지",
                                  @"계좌번호" : self.data[@"계좌번호"],
                                  @"은행구분" : @"1",
                                  @"거래점용계좌번호" : self.data[@"계좌번호"],
                                  @"거래점용은행구분" : @"1",
                                  @"비밀번호2" : _encriptedPassword,
                                  @"해지거래구분" : @"1",
                                  @"해지조회" : @"0", // 해지거래 : 0, 해지예상조회 : 2
                                  @"전액구분" : @"2",
                                  @"계산서생략" : @"1",
                                  @"입금계좌번호" : _selectAccountDic[@"계좌번호"],
                                  @"입금은행구분" : @"1"
                                  }];
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:kD3287Id
                                                       viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [self getElectronicSignCancel];
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    self.encriptedPassword = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectAccountDic = _accountList[anIndex];
    
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateHighlighted];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateSelected];
    [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateDisabled];
}

@end
