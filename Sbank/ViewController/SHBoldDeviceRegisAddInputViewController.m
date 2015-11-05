//
//  SHBoldDeviceRegisAddInputViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 9. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBoldDeviceRegisAddInputViewController.h"
#import "SHBSecurityCenterService.h" // 서비스
#import "SHBUtilFile.h" // 유틸
#import "SHBOldSecurityEndViewController.h"

@interface SHBoldDeviceRegisAddInputViewController ()
{
    BOOL _isNickNameCheck;
}
@end

@implementation SHBoldDeviceRegisAddInputViewController

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
    
    [self setTitle:@"구 이용PC 사전등록 변경"];
    self.strBackButtonTitle = @"이용기기 별명 지정";
    [self initNotification];
    
    
    startTextFieldTag = 0;
    endTextFieldTag = 0;
    contentViewHeight = self.contentScrollView.contentSize.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_nickName release];
    [_buttonView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setNickName:nil];
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
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"구 이용PC 사전등록 변경";
    
    AppInfo.electronicSignCode = @"E3026";
    AppInfo.electronicSignTitle = @"구 이용PC 사전등록 서비스를 변경합니다.";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"신청내용"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)등록일시: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)내용: 구 이용PC 사전등록 서비스 변경(이용기기 등록 서비스 변경 가입)"]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)이용기기 별명: %@[모바일]", _nickName.text]];
    
    NSString *hdd1 = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    
    if ([hdd1 length] > 20) {
        hdd1 = [hdd1 substringToIndex:20];
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"등록해지상태" : @"1",
                            @"PC별명" : [NSString stringWithFormat:@"%@[모바일]", _nickName.text],
                            @"업무구분" : @"01",
                            @"MACADDRESS1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                            @"HDD1" : hdd1,
                            }];
    
    self.service = nil;
    self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3026_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
    
}

- (IBAction)cancelBtn:(UIButton *)sender   //취소버튼
{
    [self.navigationController fadePopViewController]; 
}


#pragma mark - SHBSecretMedia

- (void)cancelSecretMedia          //인증서화면 취소버튼
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oldpcSignCancel"
                                                        object:nil];
}


#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        SHBOldSecurityEndViewController *viewController = [[[SHBOldSecurityEndViewController alloc] initWithNibName:@"SHBOldSecurityEndViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        AppInfo.isOldPCRegister = YES;
    }
}




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
                                             selector:@selector(cancelSecretMedia)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelSecretMedia)
                                                 name:@"eSignCancel"
                                               object:nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
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
