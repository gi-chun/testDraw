//
//  SHBTelephoneConsultationRequestViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 10. 21..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBTelephoneConsultationRequestViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBELD_WebViewController.h"
#import "SHBUtility.h"

#import "SHBProductService.h"

#define TOOLBARVIEW_HEIGHT 40   // 툴바 뷰 높이
#define KEYPAD_HEIGHT 216       // 키패드 높이

@interface SHBTelephoneConsultationRequestViewController ()

- (BOOL)inputValuesCheck; // 입력값 체크
- (NSTextCheckingResult *)isPhoneNumberValidation:(NSString *)aPhoneNumber; // 전화번호 첫번째 자리(국번) 유효성 체크

@end

@implementation SHBTelephoneConsultationRequestViewController

#pragma mark -
#pragma mark Dummy Method

- (void)dummyMethod
{
    // Pargma Mark 버그에 대한 더미 메소드
}


#pragma mark -
#pragma mark Network Methods

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (!AppInfo.errorType) {
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1000 title:@"" message:@"상품 상담 신청이 성공적으로 접수 되었습니다. 신속하게 연락 드리겠습니다. 고맙습니다."];
	}
	
	return NO;
}


#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    // 보기 버튼
    if ([sender tag] == 0) {
        
        _isReadStipulation = !_isReadStipulation;
        
        // 개인정보 수집, 이용 동의서 화면으로 이동
        NSString *url = nil;
        
        if ([[[NSUserDefaults standardUserDefaults] typeOfLoginCert] isEqualToString:@"testCert"]) {
            
            url = @"http://imgdev.shinhan.com/sbank/yak/pci_lending_02.html";
        }
        else {
            
            url = @"http://img.shinhan.com/sbank/yak/pci_lending_02.html";
        }
        
        SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
        viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                         @"TITLE" : @"전화상담요청",
                                         @"SUBTITLE" : @"약관보기",
                                         @"URL" : url,
                                         @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    // 확인 버튼
    else if ([sender tag] == 1) {
        
        // 입력값 체크
        if ([self inputValuesCheck]) {
            
            // 전문 요청
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                    TASK_ACTION_KEY : @"insertPhb",
                                    //@"주민번호" : [AppInfo getPersonalPK],
                                    @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    @"고객번호" : AppInfo.customerNo,
                                    @"전화번호" : [NSString stringWithFormat:@"%@%@%@", self.textField1.text, self.textField2.text, self.textField3.text],
                                    @"콜백서비스" : AppInfo.commonDic[@"콜백서비스"],
                                    @"상담요청시간" : [AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""],
                                    @"페이지정보" : AppInfo.commonDic[@"페이지정보"],
                                    @"접수내용" : [NSString stringWithFormat:@"%@%@%@", @"[신한S뱅크]", AppInfo.commonDic[@"상품코드"], self.textView1.text],
                                    @"고객명" : AppInfo.userInfo[@"고객성명"],
//                                    @"COM_SUBCHN_KBN" : @"02", // 자동으로 들어가서, 주석처리함
                                    }];
            
            self.service = [[[SHBProductService alloc] initWithServiceId:XDA_InsertPhb viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
    }
    // 취소 버튼
    else if ([sender tag] == 2) {
        
        // 이전 화면으로 이동
        [self.navigationController fadePopViewController];
    }
    // 라디오 버튼 - 선택/해제
    else {
        
        NSUInteger index = ([sender tag] / 10) - 10;
        
        for (UIButton *buttonTemp in _collections[index]) {
            
            buttonTemp.selected = NO;
        }
        
        UIButton *buttonTemp = (UIButton *)sender;
        buttonTemp.selected = YES;
    }
}

- (IBAction)toolBarViewButtonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
            // 툴바 뷰 - 이전 버튼
            [self.textField4 becomeFirstResponder];
            [super didPrevButtonTouch];
            break;
        case 1:
            // 툴바 뷰 - 다음 버튼
            break;
        case 2:
            // 툴바 뷰 - 완료 버튼
            [self.textView1 resignFirstResponder];
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Public Methods

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


#pragma mark -
#pragma mark Private Methods

- (BOOL)inputValuesCheck
{
    // 개인정보 동의서 보기 유/무 체크
    if (!_isReadStipulation) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"개인정보 조회,수집,이용 및 제공(비여신 금융거래) 동의서 보기를 선택하여 확인하시기 바랍니다."];
        return NO;
    }
    
    UIButton *buttonTemp = nil;
    
    // 1번 필수적 정보 동의 유/무 체크
    buttonTemp = (UIButton*)[self.view viewWithTag:100];
    
    if (!buttonTemp.selected) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"1번 필수적정보는 반드시 동의하셔야 합니다."];
        return NO;
    }
    
    // 2번 고유식별정보 동의 유/무 체크
    buttonTemp = (UIButton*)[self.view viewWithTag:120];
    
    if (!buttonTemp.selected) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."];
        return NO;
    }
    
    // 연락전화번호 입력 유/무 체크 및 유효성 검사
    if ([self.textField1.text isEqualToString:@""] && [self.textField2.text isEqualToString:@""] && [self.textField3.text isEqualToString:@""]) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호를 입력하여 주십시오."];
        return NO;
    }
    
    if ([self.textField1.text length] < 2) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
        return NO;
    }
    
    if ([self.textField2.text length] < 3) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
        return NO;
    }
    
    if ([self.textField3.text length] < 4) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"연락전화번호 세번째 입력칸은 4자리 이상 입력하여 주십시오."];
        return NO;
    }
    
    // 전화번호 첫번째 자리(국번) 유효성 체크
    if (![self isPhoneNumberValidation:self.textField1.text]) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"잘못된 전화번호 형식입니다. 확인 후 다시 입력하여 주십시오."];
        return NO;
    }
    
    // 문의내용 입력 유/무 체크
    if ([self.textView1.text isEqualToString:@""] || [self.textView1.text isEqualToString:@"간단한 문의내용을 적어주시면 상담시 도움이 될수 있습니다."]) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"문의내용을 1자 이상 입력하여 주십시오."];
        return NO;
    }
    
    NSString *tmpStr = [self.textView1.text stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    if (!tmpStr) {
        
        [UIAlertView showAlertCustome:nil type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:nil message:@"지원하지 않는 문자가 있습니다.\n다시 입력해 주세요."];
        return NO;
    }
    
    return YES;
}

// 전화번호 첫번째 자리(국번) 유효성 체크
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


#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.textField4) {
        
        [self.textView1 becomeFirstResponder];
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


#pragma mark -
#pragma mark UITextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // TextView PlaceHolder 초기화
    if ([textView.text isEqualToString:@"간단한 문의내용을 적어주시면 상담시 도움이 될수 있습니다."]) {
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    // 스크롤 뷰 사이즈 늘려줌
    CGRect rectTemp = self.contentView.frame;
    rectTemp.size.height += self.textView1.superview.frame.size.height + TOOLBARVIEW_HEIGHT;
    self.contentScrollView.contentSize = rectTemp.size;
    
    // 툴바 추가 및 위치 초기화
    rectTemp = self.toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.toolBarView.frame = rectTemp;
    
    [AppDelegate.window addSubview:self.toolBarView];
    
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height - TOOLBARVIEW_HEIGHT - KEYPAD_HEIGHT;
    
    // 스크롤 뷰 해당 컨텐츠의 오프셋 계산
    NSInteger scrollViewHeight = self.contentScrollView.frame.size.height;
    NSInteger yOffset = self.textView1.superview.frame.origin.y;
    NSInteger yPoint = scrollViewHeight * (yOffset / scrollViewHeight) + (yOffset % scrollViewHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarView.frame = rectTemp;
        self.contentScrollView.contentOffset = CGPointMake(0, yPoint);
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
    CGRect rectTemp = self.toolBarView.frame;
    rectTemp.origin.x = 0;
    rectTemp.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarView.frame = rectTemp;
        self.contentScrollView.contentSize = self.contentView.frame.size;
        
    } completion:^(BOOL finished){
        
        [self.toolBarView removeFromSuperview];
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


#pragma mark -
#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        
        // 이전 화면으로 이동
        [self.navigationController fadePopViewController];
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_collections release]; _collections = nil;
    
    self.collection1 = nil;
    self.collection2 = nil;
    self.collection3 = nil;
    self.textField1 = nil;
    self.textField2 = nil;
    self.textField3 = nil;
    self.textField4 = nil;
    self.textView1 = nil;
    self.contentView = nil;
    self.toolBarView = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"전화상담"]; // 네비게이션 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"전화상담요청" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    self.contentScrollView.contentSize = self.contentView.frame.size; // 스크롤 뷰 - 컨텐츠 사이즈 초기화
    contentViewHeight = self.contentView.frame.size.height;
    
    _collections = [[NSArray alloc] initWithObjects:self.collection1, self.collection2, self.collection3, nil]; // 컬렉션 리스트 초기화
    
    startTextFieldTag = 200; // 텍스트필드 태그번호 초기화
    endTextFieldTag = 203;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
