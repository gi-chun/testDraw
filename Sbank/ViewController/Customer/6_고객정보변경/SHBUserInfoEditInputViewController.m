//
//  SHBUserInfoEditInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserInfoEditInputViewController.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBUtility.h" // 유틸
#import "SHBGoodsSubTitleView.h" // 서브타이틀

#import "SHBSearchZipViewController.h" // 주소찾기
#import "SHBUserInfoEditCompleteViewController.h" // 고객정보변경 완료

@interface SHBUserInfoEditInputViewController ()
{
    BOOL _isOfficeSearch; // YES : 직장주소, NO : 자택주소
}

@property (retain, nonatomic) NSArray *textFieldList;

@end

@implementation SHBUserInfoEditInputViewController

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
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        [self setTitle:@"본인정보 이용제공 조회시스템"];
        
        SHBGoodsSubTitleView *titleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"고객정보 조회/변경" maxStep:2 focusStepNumber:1] autorelease];
        FrameReposition(titleView, 0, 0);
        
        [_mainView addSubview:titleView];
    }
    else {
        
        [self setTitle:@"고객정보변경"];
        
        SHBGoodsSubTitleView *titleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"고객정보변경" maxStep:6 focusStepNumber:5] autorelease];
        FrameReposition(titleView, 0, 0);
        
        [_mainView addSubview:titleView];
    }
    
    [self navigationBackButtonHidden];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    _isOfficeSearch = NO;
    
    self.textFieldList = @[ _homeZipCode1, _homeZipCode2, _homeAddress1, _homeAddress2,
                            _homeNumber1, _homeNumber2, _homeNumber3,
                            _homeFaxNumber1, _homeFaxNumber2, _homeFaxNumber3,
                            _officeZipCode1, _officeZipCode2, _officeAddress1, _officeAddress2,
                            _officeNumber1, _officeNumber2, _officeNumber3,
                            _officeFaxNumber1, _officeFaxNumber2, _officeFaxNumber3,
                            _officeName, _dept,
                            _email, _phoneNumber1, _phoneNumber2, _phoneNumber3 ];
    
    [self setTextFieldTagOrder:_textFieldList];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_C2310
                                                     viewController:self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.textFieldList = nil;
    
    [_homeZipCode1 release];
    [_homeZipCode2 release];
    [_homeAddress1 release];
    [_homeAddress2 release];
    [_homeNumber1 release];
    [_homeNumber2 release];
    [_homeNumber3 release];
    [_homeFaxNumber1 release];
    [_homeFaxNumber2 release];
    [_homeFaxNumber3 release];
    [_officeZipCode1 release];
    [_officeZipCode2 release];
    [_officeAddress1 release];
    [_officeAddress2 release];
    [_officeNumber1 release];
    [_officeNumber2 release];
    [_officeNumber3 release];
    [_officeFaxNumber1 release];
    [_officeFaxNumber2 release];
    [_officeFaxNumber3 release];
    [_officeName release];
    [_dept release];
    [_email release];
    [_phoneNumber1 release];
    [_phoneNumber2 release];
    [_phoneNumber3 release];
    [_mainView release];
    [_noHomeNumber release];
    [_noOffice release];
    [_noHomeFaxNumber release];
    [_noOfficeFaxNumber release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setHomeZipCode1:nil];
    [self setHomeZipCode2:nil];
    [self setHomeAddress1:nil];
    [self setHomeAddress2:nil];
    [self setHomeNumber1:nil];
    [self setHomeNumber2:nil];
    [self setHomeNumber3:nil];
    [self setOfficeZipCode1:nil];
    [self setOfficeZipCode2:nil];
    [self setOfficeAddress1:nil];
    [self setOfficeAddress2:nil];
    [self setOfficeNumber1:nil];
    [self setOfficeNumber2:nil];
    [self setOfficeNumber3:nil];
    [self setOfficeName:nil];
    [self setDept:nil];
    [self setEmail:nil];
    [self setPhoneNumber1:nil];
    [self setPhoneNumber2:nil]; 
    [self setPhoneNumber3:nil];
    [self setMainView:nil];
    [self setNoHomeNumber:nil];
    [self setNoOffice:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        NSString *homeNumber = @" ";
        NSString *homeFAX = @" ";
        NSString *officeAddress = @" ";
        NSString *officeNumber = @" ";
        NSString *officeFAX = @" ";
        
        if (![_noHomeNumber isSelected]) {
            homeNumber = [NSString stringWithFormat:@"%@-%@-%@",
                          _homeNumber1.text, _homeNumber2.text, _homeNumber3.text];
        }
        
        if (![_noHomeFaxNumber isSelected]) {
            homeFAX = [NSString stringWithFormat:@"%@-%@-%@",
                          _homeFaxNumber1.text, _homeFaxNumber2.text, _homeFaxNumber3.text];
        }
        
        if (![_noOffice isSelected]) {
            officeAddress = [NSString stringWithFormat:@"%@-%@ %@ %@",
                             _officeZipCode1.text, _officeZipCode2.text, _officeAddress1.text, _officeAddress2.text];
            officeNumber = [NSString stringWithFormat:@"%@-%@-%@",
                            _officeNumber1.text, _officeNumber2.text, _officeNumber3.text];
            
            if (![_noOfficeFaxNumber isSelected]) {
                officeFAX = [NSString stringWithFormat:@"%@-%@-%@",
                             _officeFaxNumber1.text, _officeFaxNumber2.text, _officeFaxNumber3.text];
            }
        }
        
        AppInfo.commonDic = @{
                            @"_고객성명" : [SHBUtility nilToString:AppInfo.commonDic[@"고객명"]],
                            //@"_주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [SHBUtility nilToString:AppInfo.commonDic[@"_실명번호"]] : @"",
                            @"_주민등록번호" : [SHBUtility nilToString:AppInfo.commonDic[@"_실명번호"]],
                            @"_고객번호" : [SHBUtility nilToString:AppInfo.commonDic[@"고객번호"]],
                            @"_부기명" : [SHBUtility nilToString:AppInfo.commonDic[@"부기고객명"]],
                            @"_생년월일" : [SHBUtility nilToString:AppInfo.commonDic[@"_생년월일"]],
                            @"_생일구분" : [SHBUtility nilToString:AppInfo.commonDic[@"_생일구분"]],
                            @"_여권번호" : [SHBUtility nilToString:AppInfo.commonDic[@"여권번호"]],
                            @"_국적" : [SHBUtility nilToString:AppInfo.commonDic[@"국적국가명"]],
                            @"_영문고객명" : [SHBUtility nilToString:AppInfo.commonDic[@"영문고객명"]],
                            @"_성별" : [SHBUtility nilToString:AppInfo.commonDic[@"_성별"]],
                            @"_자택주소" : [NSString stringWithFormat:@"%@-%@ %@ %@",
                                        _homeZipCode1.text, _homeZipCode2.text, _homeAddress1.text, _homeAddress2.text],
                            @"_자택전화번호" : homeNumber,
                            @"_자택FAX번호" : homeFAX,
                            @"_직장주소" : officeAddress,
                            @"_직장전화번호" : officeNumber,
                            @"_직장FAX번호" : officeFAX,
                            @"_직장명" : _officeName.text,
                            @"_부서명" : _dept.text,
                            @"_이메일" : _email.text,
                            @"_이전휴대폰번호" : [NSString stringWithFormat:@"%@-%@-%@",
                                           AppInfo.commonDic[@"휴대폰지역번호"],
                                           AppInfo.commonDic[@"휴대폰국번호"],
                                           AppInfo.commonDic[@"휴대폰통신일련번호"]],
                            @"_휴대폰번호" : [NSString stringWithFormat:@"%@-%@-%@",
                                         _phoneNumber1.text, _phoneNumber2.text, _phoneNumber3.text],
                            };
        
        SHBUserInfoEditCompleteViewController *viewController = [[[SHBUserInfoEditCompleteViewController alloc] initWithNibName:@"SHBUserInfoEditCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    NSString *className = @"";
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        className = @"SHBUserInfoEditInputViewController";
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        className = @"SHBIdentity1ViewController";
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

#pragma mark - Button

/// 자택 주소찾기
- (IBAction)homeAddressSearchBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    _isOfficeSearch = NO;
    
    SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc] initWithNibName:@"SHBSearchZipViewController" bundle:nil] autorelease];
    [viewController executeWithTitle:@"고객정보변경" ReturnViewController:self];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 자택전화번호 없음
- (IBAction)noHomeNumberBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        [_homeNumber1 setText:@""];
        [_homeNumber2 setText:@""];
        [_homeNumber3 setText:@""];
        
        [_homeNumber1 setEnabled:NO];
        [_homeNumber2 setEnabled:NO];
        [_homeNumber3 setEnabled:NO];
    }
    else {
        [_homeNumber1 setEnabled:YES];
        [_homeNumber2 setEnabled:YES];
        [_homeNumber3 setEnabled:YES];
    }
    
    [self setTextFieldTagOrder:_textFieldList];
}

/// 자택FAX번호 없음
- (IBAction)noHomeFaxNumberBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        
        [_homeFaxNumber1 setText:@""];
        [_homeFaxNumber2 setText:@""];
        [_homeFaxNumber3 setText:@""];
        
        [_homeFaxNumber1 setEnabled:NO];
        [_homeFaxNumber2 setEnabled:NO];
        [_homeFaxNumber3 setEnabled:NO];
    }
    else {
        [_homeFaxNumber1 setEnabled:YES];
        [_homeFaxNumber2 setEnabled:YES];
        [_homeFaxNumber3 setEnabled:YES];
    }
    
    [self setTextFieldTagOrder:_textFieldList];
}

/// 직장 없음
- (IBAction)noOfficeBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        [_officeZipCode1 setText:@""];
        [_officeZipCode2 setText:@""];
        [_officeAddress1 setText:@""];
        [_officeAddress2 setText:@""];
        [_officeNumber1 setText:@""];
        [_officeNumber2 setText:@""];
        [_officeNumber3 setText:@""];
        [_officeFaxNumber1 setText:@""];
        [_officeFaxNumber2 setText:@""];
        [_officeFaxNumber3 setText:@""];
        [_officeName setText:@""];
        [_dept setText:@""];
        
        [_officeZipCode1 setEnabled:NO];
        [_officeZipCode2 setEnabled:NO];
        [_officeAddress1 setEnabled:NO];
        [_officeAddress2 setEnabled:NO];
        [_officeNumber1 setEnabled:NO];
        [_officeNumber2 setEnabled:NO];
        [_officeNumber3 setEnabled:NO];
        [_officeFaxNumber1 setEnabled:NO];
        [_officeFaxNumber2 setEnabled:NO];
        [_officeFaxNumber3 setEnabled:NO];
        [_officeName setEnabled:NO];
        [_dept setEnabled:NO];
        
        [_noOfficeFaxNumber setSelected:YES];
        [_noOfficeFaxNumber setEnabled:NO];
    }
    else {
        [_officeZipCode1 setEnabled:YES];
        [_officeZipCode2 setEnabled:YES];
        [_officeAddress1 setEnabled:YES];
        [_officeAddress2 setEnabled:YES];
        [_officeNumber1 setEnabled:YES];
        [_officeNumber2 setEnabled:YES];
        [_officeNumber3 setEnabled:YES];
        [_officeFaxNumber1 setEnabled:YES];
        [_officeFaxNumber2 setEnabled:YES];
        [_officeFaxNumber3 setEnabled:YES];
        [_officeName setEnabled:YES];
        [_dept setEnabled:YES];
        
        [_noOfficeFaxNumber setSelected:NO];
        [_noOfficeFaxNumber setEnabled:YES];
    }
    
    [self setTextFieldTagOrder:_textFieldList];
}

/// 직장 주소찾기
- (IBAction)officeAddressSearchBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if (![_noOffice isSelected]) {
        _isOfficeSearch = YES;
        
        SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc] initWithNibName:@"SHBSearchZipViewController" bundle:nil] autorelease];
        [viewController executeWithTitle:@"고객정보변경" ReturnViewController:self];
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

/// 직장FAX번호 없음
- (IBAction)noOfficeFaxNumberBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        
        [_officeFaxNumber1 setText:@""];
        [_officeFaxNumber2 setText:@""];
        [_officeFaxNumber3 setText:@""];
        
        [_officeFaxNumber1 setEnabled:NO];
        [_officeFaxNumber2 setEnabled:NO];
        [_officeFaxNumber3 setEnabled:NO];
    }
    else {
        [_officeFaxNumber1 setEnabled:YES];
        [_officeFaxNumber2 setEnabled:YES];
        [_officeFaxNumber3 setEnabled:YES];
    }
    
    [self setTextFieldTagOrder:_textFieldList];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_homeAddress2.text length] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"자택주소의 상세주소를 입력하여 주십시오."];
        return;
    }
    
    if (![_noHomeNumber isSelected]) {
        
        if ([_homeNumber1.text length] == 0 && [_homeNumber2.text length] == 0 && [_homeNumber3.text length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택전화번호를 입력하여 주십시오."];
            return;
        }
        
        if ([_homeNumber1.text length] < 2) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택전화번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_homeNumber2.text length] < 3) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택전화번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_homeNumber3.text length] < 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택전화번호 세번째 입력칸은 4자리를 입력하여 주십시오."];
            return;
        }
    }
    
    if (![_noHomeFaxNumber isSelected]) {
        
        if ([_homeFaxNumber1.text length] < 2) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택FAX번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_homeFaxNumber2.text length] < 3) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택FAX번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_homeFaxNumber3.text length] < 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"자택FAX번호 세번째 입력칸은 4자리 이상 입력하여 주십시오."];
            return;
        }
    }
    
    if (![_noOffice isSelected]) {
        
        if ([_officeZipCode1.text length] == 0 && [_officeZipCode2.text length] == 0 &&
            [_officeAddress1.text length] == 0 && [_officeAddress2.text length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장주소를 입력하여 주십시오."];
            return;
        }
        
        if ([_officeNumber1.text length] == 0 && [_officeNumber2.text length] == 0 && [_officeNumber3.text length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장전화번호를 입력하여 주십시오."];
            return;
        }
        
        if ([_officeNumber1.text length] < 2) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장전화번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_officeNumber2.text length] < 3) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장전화번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_officeNumber3.text length] < 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장전화번호 세번째 입력칸은 4자리를 입력하여 주십시오."];
            return;
        }
        
        if ([_officeName.text length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장명을 입력하여 주십시오."];
            return;
        }
        
        if ([_dept.text length] == 0) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"부서명을 입력하여 주십시오."];
            return;
        }
    }
    
    if (![_noOfficeFaxNumber isSelected]) {
        
        if ([_officeFaxNumber1.text length] < 2) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장FAX번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_officeFaxNumber2.text length] < 3) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장FAX번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
            return;
        }
        
        if ([_officeFaxNumber3.text length] < 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"직장FAX번호 세번째 입력칸은 4자리 이상 입력하여 주십시오."];
            return;
        }
    }
    
    if ([_email.text length] == 0) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이메일 주소를 입력하여 주십시오."];
        return;
    }
    
    if (![SHBUtility emailVaildCheck:_email.text]) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이메일 주소가 올바르지 않습니다. 다시한번 확인하시고 입력하시길 바랍니다."];
        return;
    }
    
//    if ([_phoneNumber1.text length] == 0 && [_phoneNumber2.text length] == 0 && [_phoneNumber3.text length] == 0) {
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"휴대폰번호를 입력하여 주십시오."];
//        return;
//    }
//    
//    if ([_phoneNumber1.text length] < 2) {
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"휴대폰번호 첫번째 입력칸은 3자리 이상 입력하여 주십시오."];
//        return;
//    }
//    
//    if ([_phoneNumber2.text length] < 3) {
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"휴대폰번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
//        return;
//    }
//    
//    if ([_phoneNumber3.text length] < 4) {
//        [UIAlertView showAlert:nil
//                          type:ONFAlertTypeOneButton
//                           tag:0
//                         title:@""
//                       message:@"휴대폰번호 세번째 입력칸은 4자리를 입력하여 주십시오."];
//        return;
//    }
    
    AppInfo.electronicSignString = @"";
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        AppInfo.eSignNVBarTitle = @"본인정보 이용제공 조회시스템";
    }
    else {
        
        AppInfo.eSignNVBarTitle = @"고객정보변경";
    }
    
    AppInfo.electronicSignCode = @"C2311_A";
    AppInfo.electronicSignTitle = @"고객정보변경";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)자택주소: %@-%@ %@ %@",
                                _homeZipCode1.text, _homeZipCode2.text,
                                _homeAddress1.text, _homeAddress2.text]];
    
    if ([_noHomeNumber isSelected]) {
        
        [AppInfo addElectronicSign:@"(2)자택전화번호:"];
    }
    else {
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)자택전화번호: %@-%@-%@",
                                    _homeNumber1.text, _homeNumber2.text, _homeNumber3.text]];
    }
    
    if ([_noHomeFaxNumber isSelected]) {
        
        [AppInfo addElectronicSign:@"(3)자택FAX번호:"];
    }
    else {
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)자택FAX번호: %@-%@-%@",
                                    _homeFaxNumber1.text, _homeFaxNumber2.text, _homeFaxNumber3.text]];
    }
    
    if ([_noOffice isSelected]) {
        
        [AppInfo addElectronicSign:@"(4)직장주소:"];
        [AppInfo addElectronicSign:@"(5)직장전화번호:"];
        [AppInfo addElectronicSign:@"(6)직장FAX번호:"];
        [AppInfo addElectronicSign:@"(7)직장명:"];
        [AppInfo addElectronicSign:@"(8)부서명:"];
    }
    else {
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)직장주소: %@-%@ %@ %@",
                                    _officeZipCode1.text, _officeZipCode2.text,
                                    _officeAddress1.text, _officeAddress2.text]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)직장전화번호: %@-%@-%@",
                                    _officeNumber1.text, _officeNumber2.text, _officeNumber3.text]];
        
        if ([_noOfficeFaxNumber isSelected]) {
            
            [AppInfo addElectronicSign:@"(6)직장FAX번호:"];
        }
        else {
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)직장FAX번호: %@-%@-%@",
                                        _officeFaxNumber1.text, _officeFaxNumber2.text, _officeFaxNumber3.text]];
        }
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)직장명: %@", _officeName.text]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)부서명: %@", _dept.text]];
    }
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)E-mail주소: %@", _email.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)휴대폰번호: %@-%@-%@",
                                _phoneNumber1.text, _phoneNumber2.text, _phoneNumber3.text]];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"집우편번호1" : _homeZipCode1.text,
                           @"집우편번호2" : _homeZipCode2.text,
                           @"집우편번호주소" : _homeAddress1.text,
                           @"집번지" : _homeAddress2.text,
                           @"집전화지역번호" : _homeNumber1.text,
                           @"집전화국번" : _homeNumber2.text,
                           @"집전화번호" : _homeNumber3.text,
                           @"자택FAX지역번호" : _homeFaxNumber1.text,
                           @"자택FAX국번호" : _homeFaxNumber2.text,
                           @"자택FAX통신일련번호" : _homeFaxNumber3.text,
                           @"회사우편번호1" : _officeZipCode1.text,
                           @"회사우편번호2" : _officeZipCode2.text,
                           @"회사우편번호주소" : _officeAddress1.text,
                           @"회사번지" : _officeAddress2.text,
                           @"회사전화지역번호" : _officeNumber1.text,
                           @"회사전화국번" : _officeNumber2.text,
                           @"회사전화번호" : _officeNumber3.text,
                           @"직장FAX지역번호" : _officeFaxNumber1.text,
                           @"직장FAX국번호" : _officeFaxNumber2.text,
                           @"직장FAX통신일련번호" : _officeFaxNumber3.text,
                           @"직장명" : _officeName.text,
                           @"부서명" : _dept.text,
                           @"이메일" : _email.text,
                           @"휴대폰지역번호" : _phoneNumber1.text,
                           @"휴대폰국번호" : _phoneNumber2.text,
                           @"휴대폰통신일련번호" : _phoneNumber3.text,
                           }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_C2311
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            
            if ([viewController isKindOfClass:NSClassFromString(@"SHBUserInfoUseSupplyViewController")]) {
                
                [self.navigationController fadePopToViewController:viewController];
                
                break;
            }
        }
        
        return;
    }
    
    [self getElectronicSignCancel];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    if ([self.service.strServiceCode isEqualToString:CUSTOMER_C2310]) {
        
        [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", [aDataSet[@"실명번호"] substringToIndex:6]]
                        forKey:@"_실명번호"
                       atIndex:0];
        
        NSString *birth = aDataSet[@"출생일자"];
        
        if ([birth length] != 8) {
            
            birth = [SHBUtility birthYearString];
        }
        
        NSString *birthYear = [birth substringWithRange:NSMakeRange(2, 2)];
        NSString *birthMonth = [birth substringWithRange:NSMakeRange(4, 2)];
        NSString *birthDay = [birth substringWithRange:NSMakeRange(6, 2)];
        
        birth = [NSString stringWithFormat:@"%@.%@.%@", birthYear, birthMonth, birthDay];
        
        [aDataSet insertObject:birth
                        forKey:@"_생년월일"
                       atIndex:0];

        if ([aDataSet[@"생일구분"] isEqualToString:@"1"]) {
            
            [aDataSet insertObject:@"양력"
                            forKey:@"_생일구분"
                           atIndex:0];
        }
        else if ([aDataSet[@"생일구분"] isEqualToString:@"2"]) {
            
            [aDataSet insertObject:@"음력"
                            forKey:@"_생일구분"
                           atIndex:0];
        }
        else {
            
            [aDataSet insertObject:@""
                            forKey:@"_생일구분"
                           atIndex:0];
        }
        
        if ([aDataSet[@"성별구분"] isEqualToString:@"1"]) {
            
            [aDataSet insertObject:@"남자"
                            forKey:@"_성별"
                           atIndex:0];
        }
        else if ([aDataSet[@"성별구분"] isEqualToString:@"1"]) {
            
            [aDataSet insertObject:@"여자"
                            forKey:@"_성별"
                           atIndex:0];
        }
        else if ([aDataSet[@"성별구분"] isEqualToString:@"1"]) {
            
            [aDataSet insertObject:@"기타"
                            forKey:@"_성별"
                           atIndex:0];
        }
        else {
            
            [aDataSet insertObject:@""
                            forKey:@"_성별"
                           atIndex:0];
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ([self.service.strServiceCode isEqualToString:CUSTOMER_C2310]) {
        
        AppInfo.commonDic = aDataSet;
        
        self.dataList = [aDataSet arrayWithForKey:@"주소내역"];
        
        for (OFDataSet *dataSet in self.dataList) {
            
            if ([dataSet[@"주소구분"] isEqualToString:@"01"]) {
                
                // 자택
                
                [_homeZipCode1 setText:[SHBUtility nilToString:dataSet[@"우편번호1"]]];
                [_homeZipCode2 setText:[SHBUtility nilToString:dataSet[@"우편번호2"]]];
                [_homeAddress1 setText:[SHBUtility nilToString:dataSet[@"동이상주소"]]];
                [_homeAddress2 setText:[SHBUtility nilToString:dataSet[@"동미만주소"]]];
                
                NSArray *homeNumber = [dataSet[@"전화번호"] componentsSeparatedByString:@"-"];
                
                if ([homeNumber count] == 3) {
                    
                    [_homeNumber1 setText:[SHBUtility nilToString:homeNumber[0]]];
                    [_homeNumber2 setText:[SHBUtility nilToString:homeNumber[1]]];
                    [_homeNumber3 setText:[SHBUtility nilToString:homeNumber[2]]];
                }
                else {
                    
                    [self noHomeNumberBtn:_noHomeNumber];
                }
                
                NSArray *faxNumber = [dataSet[@"FAX번호"] componentsSeparatedByString:@"-"];
                
                if ([faxNumber count] == 3) {
                    
                    [_homeFaxNumber1 setText:[SHBUtility nilToString:faxNumber[0]]];
                    [_homeFaxNumber2 setText:[SHBUtility nilToString:faxNumber[1]]];
                    [_homeFaxNumber3 setText:[SHBUtility nilToString:faxNumber[2]]];
                }
                else {
                    
                    [self noHomeFaxNumberBtn:_noHomeFaxNumber];
                }
            }
            else if ([dataSet[@"주소구분"] isEqualToString:@"02"]) {
                
                // 직장
                
                [_officeZipCode1 setText:[SHBUtility nilToString:dataSet[@"우편번호1"]]];
                [_officeZipCode2 setText:[SHBUtility nilToString:dataSet[@"우편번호2"]]];
                [_officeAddress1 setText:[SHBUtility nilToString:dataSet[@"동이상주소"]]];
                [_officeAddress2 setText:[SHBUtility nilToString:dataSet[@"동미만주소"]]];
                
                NSArray *officeNumber = [dataSet[@"전화번호"] componentsSeparatedByString:@"-"];
                
                if ([officeNumber count] == 3) {
                    
                    [_officeNumber1 setText:[SHBUtility nilToString:officeNumber[0]]];
                    [_officeNumber2 setText:[SHBUtility nilToString:officeNumber[1]]];
                    [_officeNumber3 setText:[SHBUtility nilToString:officeNumber[2]]];
                }
                else {
                    
                    [_officeNumber1 setText:@""];
                    [_officeNumber2 setText:@""];
                    [_officeNumber3 setText:@""];
                }
                
                NSArray *faxNumber = [dataSet[@"FAX번호"] componentsSeparatedByString:@"-"];
                
                if ([faxNumber count] == 3) {
                    
                    [_officeFaxNumber1 setText:[SHBUtility nilToString:faxNumber[0]]];
                    [_officeFaxNumber2 setText:[SHBUtility nilToString:faxNumber[1]]];
                    [_officeFaxNumber3 setText:[SHBUtility nilToString:faxNumber[2]]];
                }
                else {
                    
                    [self noOfficeFaxNumberBtn:_noOfficeFaxNumber];
                }
                
                [_officeName setText:[SHBUtility nilToString:aDataSet[@"직장명"]]];
                [_dept setText:[SHBUtility nilToString:aDataSet[@"부서명"]]];
            }
        }
        
        if ([_officeZipCode1.text length] == 0 &&
            [_officeZipCode2.text length] == 0 &&
            [_officeAddress1.text length] == 0 &&
            [_officeAddress2.text length] == 0 &&
            [_officeNumber1.text length] == 0 &&
            [_officeNumber2.text length] == 0 &&
            [_officeNumber3.text length] == 0 &&
            [_officeName.text length] == 0 &&
            [_dept.text length] == 0) {
            [self noOfficeBtn:_noOffice];
        }
        
        [_email setText:[SHBUtility nilToString:aDataSet[@"이메일"]]];
        
        [_phoneNumber1 setText:[SHBUtility nilToString:aDataSet[@"휴대폰지역번호"]]];
        [_phoneNumber2 setText:[SHBUtility nilToString:aDataSet[@"휴대폰국번호"]]];
        [_phoneNumber3 setText:[SHBUtility nilToString:aDataSet[@"휴대폰통신일련번호"]]];
    }
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
    //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
    NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()_=+{}|[]\\;:\'\"<>?,./`~";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (textField == _homeNumber1 || textField == _homeNumber2 || textField == _homeNumber3 ||
        textField == _homeFaxNumber1 || textField == _homeFaxNumber2 || textField == _homeFaxNumber3 ||
        textField == _officeNumber1 || textField == _officeNumber2 || textField == _officeNumber3 ||
        textField == _officeFaxNumber1 || textField == _officeFaxNumber2 || textField == _officeFaxNumber3) {
        if ([textField.text length] >= 4 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _homeAddress2 || textField == _officeAddress2) {
        if (basicTest && [string length] > 0 ) {
            return NO;
        }
        
        if (dataLength + dataLength2 > 100) {
            return NO;
        }
        
        return YES;
    }
    else if (textField == _officeName || textField == _dept) {
        if (basicTest && [string length] > 0 ) {
            return NO;
        }
        
        if (dataLength + dataLength2 > 40) {
            return NO;
        }
        
        return YES;
    }
    else if (textField == _email) {
        NSString *SPECIAL_CHAR2 = @"$₩€£¥•!#$%^&*()-_=+{}|[]\\;:\'\"<>?,/`~";
        
        NSCharacterSet *cs2 = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR2] invertedSet];
        NSString *filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        BOOL basicTest2 = [string isEqualToString:filtered2];
        
        if (basicTest2 && [string length] > 0 ) {
            return NO;
        }
        
        if (dataLength + dataLength2 > 50) {
            return NO;
        }
        
        return YES;
    }
    else if (textField == _phoneNumber1) {
        if ([textField.text length] >= 2 && range.length == 0) {
            if ([textString length] <= 3) {
                [_phoneNumber1 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == _phoneNumber2) {
        if ([textField.text length] >= 3 && range.length == 0) {
            if ([textString length] <= 4) {
                [_phoneNumber2 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == _phoneNumber3) {
        if ([textField.text length] >= 4 && range.length == 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - SHBSearchZipViewController

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    if (_isOfficeSearch) {
        [self.officeZipCode1 setText:mDic[@"POST1"]];
        [self.officeZipCode2 setText:mDic[@"POST2"]];
        
        [self.officeAddress1 setText:[NSString stringWithFormat:@"%@ %@", mDic[@"ADDR1"], mDic[@"ADDR2"]]];
    }
    else {
        [self.homeZipCode1 setText:mDic[@"POST1"]];
        [self.homeZipCode2 setText:mDic[@"POST2"]];
        
        [self.homeAddress1 setText:[NSString stringWithFormat:@"%@ %@", mDic[@"ADDR1"], mDic[@"ADDR2"]]];
    }
}

@end
