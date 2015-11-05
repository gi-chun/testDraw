//
//  SHBDeviceRegistServiceAddInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceAddInputViewController.h"
#import "SHBMobileCertificateService.h" // 서비스

#import "SHBMobileCertificateViewController.h" // SMS 인증
#import "SHBARSCertificateViewController.h" // ARS 인증
#import "SHBDisposableCertificateViewController.h" // 1회용 인증번호
#import "SHBDeviceRegistServiceAddInfoViewController.h" // 이용기기 등록 주의사항

@interface SHBDeviceRegistServiceAddInputViewController ()
<SHBMobileCertificateDelegate, SHBARSCertificateDelegate, SHBDisposableCertificateDelegate>
{
    BOOL _isNickNameCheck;
}

@end

@implementation SHBDeviceRegistServiceAddInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.smsBtn.hidden = YES;
    
    [self.arsBtn setSelected:YES];
    [self.disposableBtn setSelected:NO];
    [self.smsBtn setSelected:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
    [self setTitle:@"이용기기 등록 서비스"];
    self.strBackButtonTitle = @"이용기기 등록 1단계";
    
    startTextFieldTag = 0;
    endTextFieldTag = 0;
    contentViewHeight = self.contentScrollView.contentSize.height;
    
    //보안강화로 SMS인증은 뺀다
    self.smsBtn.hidden = YES;
    
    [self.disposableBtn setFrame:CGRectMake(self.arsBtn.frame.origin.x, self.arsBtn.frame.origin.y, self.disposableBtn.frame.size.width, self.disposableBtn.frame.size.height)];
    [self.arsBtn setFrame:CGRectMake(self.smsBtn.frame.origin.x, self.smsBtn.frame.origin.y, self.arsBtn.frame.size.width, self.arsBtn.frame.size.height)];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:MOBILE_CERT_E2114
                                                            viewController:self] autorelease];
    
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_nickName release];
    [_smsBtn release];
    [_arsBtn release];
    [_disposableBtn release];
    [_buttonView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setNickName:nil];
    [self setSmsBtn:nil];
    [self setArsBtn:nil];
    [self setDisposableBtn:nil];
    [self setButtonView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)checkBtn:(id)sender
{
    if ([_nickName.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이용기기 별명을 1자 이상 입력하여 주십시오."];
        return;
    }
    
    [self.curTextField resignFirstResponder];
    
    BOOL isEqual = NO;
    
    for (NSDictionary *dic in AppInfo.commonDic[@"data"]) {
        NSArray *array = [dic[@"PC별명"] componentsSeparatedByString:@"["];
        
        if ([array count] == 2) {
            if ([array[0] isEqualToString:_nickName.text]) {
                isEqual = YES;
                
                break;
            }
        }
        else {
            if ([dic[@"PC별명"] isEqualToString:_nickName.text]) {
                isEqual = YES;
                
                break;
            }
        }
    }
    
    if (isEqual) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"중복된 별명입니다. 다른 별명을 입력하여 주십시오."];
        return;
    }
    
    _isNickNameCheck = YES;
    
    [UIAlertView showAlert:nil
                      type:ONFAlertTypeOneButton
                       tag:0
                     title:@""
                   message:@"사용 가능한 별명입니다."];
}

- (IBAction)choiceBtn:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    [_smsBtn setSelected:NO];
    [_arsBtn setSelected:NO];
    [_disposableBtn setSelected:NO];
    
    [sender setSelected:YES];
}

- (IBAction)okBtn:(UIButton *)sender
{
    if ([_nickName.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"이용기기 별명을 1자 이상 입력하여 주십시오."];
        return;
    }
    
    [self.curTextField resignFirstResponder];
    
    if (!_isNickNameCheck) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"'중복확인' 버튼을 선택하여 이용기기 별명 중복여부를 확인하여 주십시오."];
        return;
    }
    
    AppInfo.commonDic = @{
                          @"data" : AppInfo.commonDic[@"data"],
                          @"_이용기기별명" : [NSString stringWithFormat:@"%@[모바일]", _nickName.text],
                          };
    
    AppInfo.transferDic = @{ @"서비스코드" : @"E3012" };
    
    if ([_smsBtn isSelected]) {
        // 휴대폰 SMS 인증
        
        SHBMobileCertificateViewController *viewController = [[[SHBMobileCertificateViewController alloc] initWithNibName:@"SHBMobileCertificateViewController" bundle:nil] autorelease];
        
        [viewController setNeedsLogin:YES];
        [viewController setServiceSeq:SERVICE_DEVICE_REGIST];
        [viewController setDelegate:self];
        [viewController setData:self.data];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        [viewController executeWithTitle:@"이용기기 등록 서비스"
                                subTitle:@"추가인증 (SMS 인증)"
                                    step:3
                               stepCount:6
                           infoViewCount:MOBILE_INFOVIEW_1
                      nextViewController:@"SHBDeviceRegistServiceAddConfirmViewController"];
    }
    else if ([_arsBtn isSelected]) {
        // 유선전화 ARS 인증
        
        SHBARSCertificateViewController *viewController = [[[SHBARSCertificateViewController alloc] initWithNibName:@"SHBARSCertificateViewController" bundle:nil] autorelease];
        
        [viewController setNeedsLogin:YES];
        [viewController setServiceSeq:SERVICE_DEVICE_REGIST];
        [viewController setDelegate:self];
        [viewController setData:self.data];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        [viewController executeWithTitle:@"이용기기 등록 서비스"
                                subTitle:@"추가인증 (ARS 인증)"
                                    step:3
                               stepCount:6
                           infoViewCount:ARS_INFOVIEW_1
                      nextViewController:@"SHBDeviceRegistServiceAddConfirmViewController"];
    }
    else if ([_disposableBtn isSelected]) {
        // 1회용 인증번호 (영업점 발급)
        
        SHBDisposableCertificateViewController *viewController = [[[SHBDisposableCertificateViewController alloc] initWithNibName:@"SHBDisposableCertificateViewController" bundle:nil] autorelease];
        
        [viewController setNeedsLogin:YES];
        [viewController setDelegate:self];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        [viewController executeWithTitle:@"이용기기 등록 서비스"
                                subTitle:@"추가인증 (1회용 인증번호)"
                                    step:4
                               stepCount:6
                      nextViewController:@"SHBDeviceRegistServiceAddConfirmViewController"];
    }
}

- (IBAction)cancelBtn:(UIButton *)sender
{
    for (SHBDeviceRegistServiceAddInfoViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBDeviceRegistServiceAddInfoViewController") class]]) {
            [viewController.checkBtn setSelected:NO];
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
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
    self.data = aDataSet;
    
    return YES;
}

#pragma mark - SHBMobileCertificate Delegate

- (void)mobileCertificateCancel
{
    [_nickName setText:@""];
    
    _isNickNameCheck = NO;
    
    [self choiceBtn:_smsBtn];
}

#pragma mark - SHBARSCertificate Delegate

- (void)ARSCertificateCancel
{
    [_nickName setText:@""];
    
    _isNickNameCheck = NO;
    
    [self choiceBtn:_smsBtn];
}

#pragma mark - SHBDisposableCertificate delegate

- (void)disposableCertificateCancel
{
    [_nickName setText:@""];
    
    _isNickNameCheck = NO;
    
    [self choiceBtn:_smsBtn];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    _isNickNameCheck = NO;
    
    int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
    //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
    NSString *SPECIAL_CHAR = @"$₩€£¥•";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (basicTest && [string length] > 0 ) {
        return NO;
    }
    
    if (dataLength + dataLength2 > 32) {
        return NO;
    }
    
    return YES;
}

@end
