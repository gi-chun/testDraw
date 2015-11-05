//
//  SHBSimpleLoanInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanInputViewController.h"
#import "SHBLoanService.h" // service

#import "SHBSimpleLoanStipulationViewController.h" // 약정업체 간편대출 약관동의
#import "SHBSimpleLoanInput2ViewController.h" // 약정업체 간편대출 - 정보입력(2)
#import "SHBSearchZipViewController.h" // 우편번호 검색

@interface SHBSimpleLoanInputViewController ()
{
    BOOL _isOldAddress;
}

@end

@implementation SHBSimpleLoanInputViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 정보입력(1)";
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 3330;
    endTextFieldTag = 3337;
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"거래구분" : @"3",
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3210_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainView release];
    [_zipCode1 release];
    [_zipCode2 release];
    [_address1 release];
    [_address2 release];
    [_homeBtn release];
    [_officeBtn release];
    [_noSendBtn release];
    [_number1 release];
    [_number2 release];
    [_number3 release];
    [_phone1 release];
    [_phone2 release];
    [_phone3 release];
    [_email release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setZipCode1:nil];
    [self setZipCode2:nil];
    [self setAddress1:nil];
    [self setAddress2:nil];
    [self setHomeBtn:nil];
    [self setOfficeBtn:nil];
    [self setNoSendBtn:nil];
    [self setNumber1:nil];
    [self setNumber2:nil];
    [self setNumber3:nil];
    [self setPhone1:nil];
    [self setPhone2:nil];
    [self setPhone3:nil];
    [self setEmail:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (NSString *)getErrorMessage
{
    if ([_zipCode1.text length] != 3 && [_zipCode2.text length] != 3) {
        
        return @"우편번호를 입력해 주세요.";
    }
    
    if ([_address1.text length] == 0 || [_address2.text length] == 0) {
        
        return @"주소를 입력해 주세요.";
    }
    
    if ([_number1.text length] < 2 || [_number2.text length] < 3 || [_number3.text length] < 4) {
        
        return @"전화번호를 입력해 주세요.";
    }
    
    if ([_phone1.text length] < 3 || [_phone2.text length] < 3 || [_phone3.text length] < 4) {
        
        return @"휴대 전화번호를 입력해 주세요.";
    }
    
    if ([_email.text length] == 0 || ![SHBUtility emailVaildCheck:_email.text]) {
        
        return @"이메일 주소를 입력해 주세요.";
    }
    
    return @"";
}
#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 10: {
            
            // 우편번호 검색
            
            [self.curTextField resignFirstResponder];
            
            SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc] initWithNibName:@"SHBSearchZipViewController" bundle:nil] autorelease];
            
            [viewController executeWithTitle:@"약정업체 간편대출" ReturnViewController:self];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 21: // 자택
        case 22: // 직장
        case 23: // 발송안함
        {
            [_homeBtn setSelected:NO];
            [_officeBtn setSelected:NO];
            [_noSendBtn setSelected:NO];
            
            [sender setSelected:YES];
        }
            break;
            
        case 30: {
            
            // 다음
            
            NSString *message = [self getErrorMessage];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:message];
                return;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                       @"_자택우편번호1" : [SHBUtility nilToString:_zipCode1.text],
                                                                                       @"_자택우편번호2" : [SHBUtility nilToString:_zipCode2.text],
                                                                                       @"_자택동주소명" : [SHBUtility nilToString:_address1.text],
                                                                                       @"_자택동미만주소" : [SHBUtility nilToString:_address2.text],
                                                                                       @"_자택전화지역번호" : [SHBUtility nilToString:_number1.text],
                                                                                       @"_자택전화국번호" : [SHBUtility nilToString:_number2.text],
                                                                                       @"_자택전화통신일련번호" : [SHBUtility nilToString:_number3.text],
                                                                                       @"_이동통신번호통신회사" : [SHBUtility nilToString:_phone1.text],
                                                                                       @"_이동통신번호국" : [SHBUtility nilToString:_phone2.text],
                                                                                       @"_이동통신번호일련번호" : [SHBUtility nilToString:_phone3.text],
                                                                                       @"_이메일주소" : [SHBUtility nilToString:_email.text],
                                                                                       @"_자택주소종류" : _isOldAddress ? @"1" : @"2",
                                                                                       }];
            
            if ([_homeBtn isSelected]) {
                
                [dic setObject:@"1" forKey:@"_우편물송달장소"];
            }
            else if ([_officeBtn isSelected]) {
                
                [dic setObject:@"2" forKey:@"_우편물송달장소"];
            }
            else if ([_noSendBtn isSelected]) {
                
                [dic setObject:@"9" forKey:@"_우편물송달장소"];
            }
            else {
                
                [dic setObject:@"0" forKey:@"_우편물송달장소"];
            }
            
            SHBSimpleLoanInput2ViewController *viewController = [[[SHBSimpleLoanInput2ViewController alloc] initWithNibName:@"SHBSimpleLoanInput2ViewController" bundle:nil] autorelease];
            
            viewController.data = self.data;
            viewController.inputData = dic;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 40: {
            
            // 취소
            
            for (SHBSimpleLoanStipulationViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBSimpleLoanStipulationViewController class]]) {
                    
                    [viewController clearViewData];
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
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
    
    self.data = [NSDictionary dictionaryWithDictionary:aDataSet];
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    [_zipCode1 setText:[SHBUtility nilToString:self.data[@"자택우편번호1"]]];
    [_zipCode2 setText:[SHBUtility nilToString:self.data[@"자택우편번호2"]]];
    
    [_address1 setText:[SHBUtility nilToString:self.data[@"자택동주소명"]]];
    [_address2 setText:[SHBUtility nilToString:self.data[@"자택동미만주소"]]];
    
    [_homeBtn setSelected:YES];
    [_officeBtn setSelected:NO];
    [_noSendBtn setSelected:NO];
    
    [_number1 setText:[SHBUtility nilToString:self.data[@"자택전화지역번호"]]];
    [_number2 setText:[SHBUtility nilToString:self.data[@"자택전화국번호"]]];
    [_number3 setText:[SHBUtility nilToString:self.data[@"자택전화통신일련번호"]]];
    
    [_phone1 setText:[SHBUtility nilToString:self.data[@"이동통신번호통신회사"]]];
    [_phone2 setText:[SHBUtility nilToString:self.data[@"이동통신번호국"]]];
    [_phone3 setText:[SHBUtility nilToString:self.data[@"이동통신번호일련번호"]]];
    
    [_email setText:[SHBUtility nilToString:self.data[@"이메일주소"]]];
    
    if ([self.data[@"고객_자택주소종류"] isEqualToString:@"2"]) {
        
        _isOldAddress = NO;
    }
    else {
        
        _isOldAddress = YES;
    }
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
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
    
    if (textField == _number1 || textField == _number2 || textField == _number3) {
        
        if ([textField.text length] >= 4 && range.length == 0) {
            
            return NO;
        }
    }
    else if (textField == _address2) {
        
        if (basicTest && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 45) {
            
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
    else if (textField == _phone1) {
        
        if ([textField.text length] >= 2 && range.length == 0) {
            
            if ([textString length] <= 3) {
                
                [_phone1 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == _phone2) {
        
        if ([textField.text length] >= 3 && range.length == 0) {
            
            if ([textString length] <= 4) {
                
                [_phone2 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == _phone3) {
        
        if ([textField.text length] >= 4 && range.length == 0) {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - SHBSearchZipViewController

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    [_zipCode1 setText:mDic[@"POST1"]];
    [_zipCode2 setText:mDic[@"POST2"]];
    
    [_address1 setText:[NSString stringWithFormat:@"%@ %@", mDic[@"ADDR1"], mDic[@"ADDR2"]]];
    [_address2 setText:@""];
    
    [_address2 becomeFirstResponder];
    
    if ([mDic[@"주소종류"] isEqualToString:@"지번주소"]) {
        
        _isOldAddress = YES;
    }
    else {
        
        _isOldAddress = NO;
    }
}

@end
