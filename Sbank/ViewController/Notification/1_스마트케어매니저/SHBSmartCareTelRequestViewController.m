//
//  SHBSmartCareTelRequestViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartCareTelRequestViewController.h"
#import "SHBProductService.h"

#define TOOLBARVIEW_HEIGHT 40   // 툴바 뷰 높이
#define KEYPAD_HEIGHT 216       // 키패드 높이

@interface SHBSmartCareTelRequestViewController ()

- (BOOL)isTelephoneConsultationRequest;
- (NSTextCheckingResult *)isPhoneNumberValidation:(NSString *)aPhoneNumber;

@end

@implementation SHBSmartCareTelRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewHidden];
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [_mainSV addSubview:_mainView];
    [_mainSV setContentSize:_mainView.frame.size];
    
    startTextFieldTag = 200;
    endTextFieldTag = 203;
    contentViewHeight = _mainSV.frame.size.height;
    
    [_nameLabel setText:AppInfo.userInfo[@"고객성명"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainSV release];
    [_mainView release];
    [_textField1 release];
    [_textField2 release];
    [_textField3 release];
    [_textField4 release];
    [_contentTV release];
    [_toolBarView release];
    [_nameLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainSV:nil];
    [self setMainView:nil];
    [self setTextField1:nil];
    [self setTextField2:nil];
    [self setTextField3:nil];
    [self setTextField4:nil];
    [self setContentTV:nil];
    [self setToolBarView:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}

#pragma mark - 

- (BOOL)isTelephoneConsultationRequest
{
    // 전화상담 요청 시간 확인
    NSString *tDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger tTime = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    if (![SHBUtility isOPDate:tDate] || tTime < 90000 || tTime > 173000) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"전화상담요청은 상담시간내에만 이용이 가능합니다. [상담시간 : 평일 09:00~17:30(은행휴무일제외)]"];
        return NO;
    }
    
    return YES;
}

/// 전화번호 첫번째 자리(국번) 유효성 체크
- (NSTextCheckingResult *)isPhoneNumberValidation:(NSString *)aPhoneNumber
{
    // <유효성 데이타 범위>
    // 지역번호 : 02, 031, 032, 033, 041, 042, 043, 044, 051, 052, 053, 054, 055, 061, 062, 063, 064
    // 핸드폰번호 : 010, 011, 016, 017, 018, 019
    // 인터넷전화번호 : 070
    
    NSString *expTemp = @"^0[1-7]((?<=1)[016789]$|(?<=2)$|(?<=3)[1-3]$|(?<=4)[1-4]$|(?<=5)[1-5]$|(?<=6)[1-4]$|(?<=7)0$)";
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:expTemp options:0 error:&error];
    
    return [regexp firstMatchInString:aPhoneNumber options:0 range:NSMakeRange(0, [aPhoneNumber length])];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag])
    {
        case 10:
        {
            if ([_delegate respondsToSelector:@selector(smartCareTelRequestBack)]) {
                [_delegate smartCareTelRequestBack];
            }
        }
            break;
        case 100:
        {
            if ([self isTelephoneConsultationRequest])
            {
                if ([_textField1.text length] == 0 && [_textField2.text length] == 0 && [_textField3.text length] == 0)
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호를 입력하여 주십시오."];
                    return;
                }
                
                if ([_textField1.text length] < 2)
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
                    return;
                }
                
                if ([_textField2.text length] < 3)
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
                    return;
                }
                
                if ([_textField3.text length] < 4)
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 세번째 입력칸은 4자리 이상 입력하여 주십시오."];
                    return;
                }
                
                if (![self isPhoneNumberValidation:self.textField1.text])
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"잘못된 전화번호 형식입니다. 확인 후 다시 입력하여 주십시오."];
                    return;
                }
                
                if ([_contentTV.text length] == 0 || [_contentTV.text isEqualToString:@"간단한 문의내용을 적어주시면 상담시 도움이 될수 있습니다."])
                {
                    [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"문의내용을 1자 이상 입력하여 주십시오."];
                    return;
                }
                
                NSString *tmpStr = [_contentTV.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
                
                if (!tmpStr) {
                    
                    [UIAlertView showAlertCustome:nil type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:nil message:@"지원하지 않는 문자가 있습니다.\n다시 입력해 주세요."];
					return;
                }
                
                SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                              TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                                              TASK_ACTION_KEY : @"insertPhb",
                                                                              @"고객번호" : AppInfo.customerNo,
                                                                              @"전화번호" : [NSString stringWithFormat:@"%@%@%@", _textField1.text, _textField2.text, _textField3.text],
                                                                              @"콜백서비스" : @"50", // 50:비대면전담고객 상담
                                                                              @"상담요청시간" : [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""],
                                                                              @"페이지정보" : @"P45000",
                                                                              @"접수내용" : [NSString stringWithFormat:@"[신한S뱅크]%@", _contentTV.text],
                                                                              @"고객명" : AppInfo.userInfo[@"고객성명"],
                                                                              }];
                
                self.service = [[[SHBProductService alloc] initWithServiceId:XDA_InsertPhb viewController:self] autorelease];
                self.service.requestData = aDataSet;
                [self.service start];
            }
        }
            break;
        case 200:
        {
            if ([_delegate respondsToSelector:@selector(smartCareTelRequestSuccess)]) {
                [_delegate smartCareTelRequestSuccess];
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)toolBarViewButtonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
            // 툴바 뷰 - 이전 버튼
            [_textField3 becomeFirstResponder];
            break;
        case 1:
            // 툴바 뷰 - 다음 버튼
            break;
        case 2:
            // 툴바 뷰 - 완료 버튼
            [_contentTV resignFirstResponder];
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType)
    {
        return NO;
	}
    
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1000 title:@"" message:@"상품 상담 신청이 성공적으로 접수 되었습니다. 신속하게 연락 드리겠습니다. 고맙습니다."];
	
	return NO;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textField4) {
        
        [_contentTV performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    }
    else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainSV.contentOffset = CGPointMake(0, textField.superview.frame.origin.y - 26);
        }];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    // 숫자인지 확인
    NSCharacterSet *characterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    BOOL isNumber = [string isEqualToString:[[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""]];
    
    if (!isNumber) { // 숫자만 입력 가능
        
        return NO;
    }
    
    // 자리수 확인
    NSInteger textLength = [textField.text length] + [string length];
    
    if (textLength > 4) { // 최대 4자리까지 입력제한
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // TextView PlaceHolder 초기화
    if ([textView.text isEqualToString:@"간단한 문의내용을 적어주시면 상담시 도움이 될수 있습니다."]) {
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    // 스크롤 뷰 사이즈 늘려줌
    CGRect rectTemp = _mainView.frame;
    rectTemp.size.height += _contentTV.superview.frame.size.height + TOOLBARVIEW_HEIGHT;
    _mainSV.contentSize = rectTemp.size;
    
    // 툴바 추가 및 위치 초기화
    rectTemp = _toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    _toolBarView.frame = rectTemp;
    
    [AppDelegate.window addSubview:_toolBarView];
    
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height - TOOLBARVIEW_HEIGHT - KEYPAD_HEIGHT;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _toolBarView.frame = rectTemp;
        _mainSV.contentOffset = CGPointMake(0, _contentTV.superview.frame.origin.y);
    }];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    // TextView PlaceHolder 초기화
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"간단한 문의내용을 적어주시면 상담시 도움이 될수 있습니다.";
        textView.textColor = [UIColor lightGrayColor];
    }
    else {
        
        textView.textColor = [UIColor blackColor];
    }
    
    // 스크롤 뷰 사이즈 초기화
    CGRect rectTemp = _toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _toolBarView.frame = rectTemp;
        _mainSV.contentSize = _mainView.frame.size;
        
    } completion:^(BOOL finished){
        
        [_toolBarView removeFromSuperview];
    }];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 입력이 불가능한 특수문자인지 확인
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"$₩€£¥•"] invertedSet];
    BOOL isSpecialCharacters = [text isEqualToString:[[text componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""]];
    
    if (isSpecialCharacters && ![text isEqualToString:@""]) { // 입력 가능한 문자만 입력 가능
        
        return NO;
    }
    
    // 자리수 확인
    NSInteger textLength = [textView.text length] + [text length];
    
    if (textLength > 100) { // 최대 100자리까지 입력제한
        
        return NO;
    }
    
    return YES;
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        
        if ([_delegate respondsToSelector:@selector(smartCareTelRequestSuccess)]) {
            [_delegate smartCareTelRequestSuccess];
        }
    }
}

@end
