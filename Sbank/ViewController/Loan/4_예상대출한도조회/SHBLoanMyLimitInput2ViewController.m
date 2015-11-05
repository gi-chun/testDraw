//
//  SHBLoanMyLimitInput2ViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 5. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanMyLimitInput2ViewController.h"
#import "SHBLoanService.h" // 서비스

#import "SHBLoanMyLimitResultViewController.h" // 예상 대출 한도 조회 - 조회결과

@interface SHBLoanMyLimitInput2ViewController ()

@end

@implementation SHBLoanMyLimitInput2ViewController

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
    
    [self setTitle:@"예상 대출 한도 조회"];
    self.strBackButtonTitle = @"예상 대출 한도 조회 2단계";
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 30300;
    endTextFieldTag = 30307;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_textField1 release];
    [_textField2 release];
    [_textField3 release];
    [_textField4 release];
    [_textField5 release];
    [_textField6 release];
    [_textField7 release];
    [_textField8 release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTextField1:nil];
    [self setTextField2:nil];
    [self setTextField3:nil];
    [self setTextField4:nil];
    [self setTextField5:nil];
    [self setTextField6:nil];
    [self setTextField7:nil];
    [self setTextField8:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}

#pragma mark - Method

/// 100만으로 변환
- (NSString *)addMillion:(NSString *)str
{
    if ([str length] == 0 || [str isEqualToString:@"0"]) {
        
        return @"0";
    }
    
    return [NSString stringWithFormat:@"%@,000,000", str];
}

- (SInt64)removeCommaValue:(NSString *)str
{
    return [[str stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 100: {
            
            // 조회
            
            /*
             textField1 : 연 소득금액
             textField2 : 신한은행 총 대출금액
             textField3 : 신한은행 총 담보대출 금액
             */
            
            // 연 소득금액에 값이 없거나 0인 경우
            if (!_textField1.text || [_textField1.text length] == 0 || [_textField1.text isEqualToString:@"0"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"연 소득금액을 입력해 주세요."];
                return;
            }
            
            // 총 담보대출 금액에 값이 있고, 0보다 큰 경우
            if ([_textField3.text length] > 0 && ![_textField3.text isEqualToString:@"0"]) {
                
                // 총 대출금액에 값이 없거나 0인 경우
                if (!_textField2.text || [_textField2.text length] == 0 || [_textField2.text isEqualToString:@"0"]) {
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"총 대출금액을 입력해 주세요."];
                    return;
                }
                else {
                    
                    // 총 담보대출 금액 > 총 대출금액
                    if ([self removeCommaValue:_textField3.text] > [self removeCommaValue:_textField2.text]) {
                        
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"입력하신 담보대출금액이 총 대출금액보다 큽니다. 확인 후 거래하시기 바랍니다."];
                        return;
                    }
                }
            }
            
            /*
             textField4 : 타기관 대출신고건수
             textField5 : 타기관 대출신고금액
             textField6 : 타기관 담보대출금액
             textField7 : 타기관 신용대출 상환금액
             textField8 : 타기관 담보대출 상환금액
             */
            
            // 타기관 대출신고건수에 값이 있고, 0보다 큰 경우
            if ([_textField4.text length] > 0 && ![_textField4.text isEqualToString:@"0"]) {
                
                // 타기관 담보대출금액에 값이 있고, 0보다 큰 경우
                if ([_textField6.text length] > 0 && ![_textField6.text isEqualToString:@"0"]) {
                    
                    // 타기관 담보대출금액 > 타기관 대출신고금액
                    if ([self removeCommaValue:_textField6.text] > [self removeCommaValue:_textField5.text]) {
                        
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"입력하신 타기관 담보대출금액이 타기관 대출신고금액보다 큽니다. 확인 후 거래하시기 바랍니다."];
                        return;
                    }
                }
                
                // 타기관 담보대출 상환금액에 값이 있고, 0보다 큰 경우
                if ([_textField8.text length] > 0 && ![_textField8.text isEqualToString:@"0"]) {
                    
                    // 타기관 담보대출금액에 값이 없거나 0인 경우
                    if (!_textField6.text || [_textField6.text length] == 0 || [_textField6.text isEqualToString:@"0"]) {
                        
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"입력하신 타기관 담보대출금액이 없습니다. 확인 후 거래하시기 바랍니다."];
                        return;
                    }
                    
                    // 타기관 담보대출 상환금액 > 타기관 담보대출금액
                    if ([self removeCommaValue:_textField8.text] > [self removeCommaValue:_textField6.text]) {
                        
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"입력하신 타기관 담보대출 상환금액이 타기관 담보대출금액보다 큽니다. 확인 후 거래하시기 바랍니다."];
                        return;
                    }
                }
                
                // 타기관 신용대출 상환금액에 값이 있고, 0보다 큰 경우
                if ([_textField7.text length] > 0 && ![_textField7.text isEqualToString:@"0"]) {
                    
                    // 타기관 대출신고금액에 값이 없거나 0인 경우
                    if (!_textField5.text || [_textField5.text length] == 0 || [_textField5.text isEqualToString:@"0"]) {
                        
                        [UIAlertView showAlert:nil
                                          type:ONFAlertTypeOneButton
                                           tag:0
                                         title:@""
                                       message:@"타기관 대출신고금액을 입력해 주세요."];
                        return;
                    }
                    else {
                        
                        // 타기관 신용대출 상환금액 > 타기관 대출신고금액
                        if ([self removeCommaValue:_textField7.text] > [self removeCommaValue:_textField5.text]) {
                            
                            [UIAlertView showAlert:nil
                                              type:ONFAlertTypeOneButton
                                               tag:0
                                             title:@""
                                           message:@"입력하신 타기관 신용대출 상환금액이 예상 상환금액(대출신고금액-담보대출금액)보다 큽니다. 확인 후 거래하시기 바랍니다."];
                            return;
                        }
                    }
                }
                
                // 타기관 대출신고금액, 타기관 신용대출 상환금액, 타기관 담보대출금액, 타기관 담보대출 상환금액 모두 값이 없거나 0인 경우
                if ((!_textField5.text || [_textField5.text length] == 0 || [_textField5.text isEqualToString:@"0"]) &&
                    (!_textField6.text || [_textField6.text length] == 0 || [_textField6.text isEqualToString:@"0"]) &&
                    (!_textField7.text || [_textField7.text length] == 0 || [_textField7.text isEqualToString:@"0"]) &&
                    (!_textField8.text || [_textField8.text length] == 0 || [_textField8.text isEqualToString:@"0"])) {
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"타기관 대출신고금액을 입력해 주세요."];
                    return;
                }
            }
            else {
                
                // 타기관 대출신고금액, 타기관 신용대출 상환금액, 타기관 담보대출금액, 타기관 담보대출 상환금액 하나라도 값이 있고, 0인 경우
                if (([_textField5.text length] > 0 && ![_textField5.text isEqualToString:@"0"]) ||
                    ([_textField6.text length] > 0 && ![_textField6.text isEqualToString:@"0"]) ||
                    ([_textField7.text length] > 0 && ![_textField7.text isEqualToString:@"0"]) ||
                    ([_textField8.text length] > 0 && ![_textField8.text isEqualToString:@"0"])) {
                    
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"타기관 대출신고 건수를 입력해 주세요."];
                    return;
                }
            }
            
            /*
             
             운용구분
             1: 건별, 3: 한도
             
             고용형태구분
             1: 정규직, 3: 기타직
             
             주거소유CODE (입력 받지는 않지만 참고)
             0: 무응답, 1: 자택(본인소유), 2: 자택(배우자소유), 3: 자택(공동소유), 4: 자택(가족소유), 5: 전세, 6: 월세, 8: 기타(기숙사, 하숙 등)
             
             주거종류 (입력 받지는 않지만 참고)
             1: 아파트, 2: 단독, 3: 빌라/연립/다세대, 4: 오피스텔/원룸, 9: 기타
             
             */
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"고객번호" : @"",
                                      @"주민번호" : @"1111111111111", // 고정값
                                      @"거래구분" : @"4",
                                      @"운용구분" : @"3",
                                      @"직업CODE" : self.data[@"_직업"],
                                      @"직위CODE" : self.data[@"_직위"],
                                      @"고용형태구분" : self.data[@"_직종"],
                                      @"직장사업자번호" : self.data[@"_사업자등록번호"],
                                      @"입사일자" : self.data[@"_입사일자"],
                                      @"직무CODE" : self.data[@"_직무"],
                                      @"연소득금액" : [self addMillion:_textField1.text],
                                      @"주거소유CODE" : @"",
                                      @"주거종류" : @"",
                                      @"총대출금액" : [self addMillion:_textField2.text],
                                      @"총담보대출금액" : [self addMillion:_textField3.text],
                                      @"타기관대출신고금액" : [self addMillion:_textField5.text],
                                      @"타기관담보대출금액" : [self addMillion:_textField6.text],
                                      @"타행담보대출상환금액" : [self addMillion:_textField8.text],
                                      @"타행신용대출상환금액" : [self addMillion:_textField7.text],
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L3660" viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 200: {
            
            // 취소
            
            if ([_delegate respondsToSelector:@selector(loanMyLimitInput2Cancel)]) {
                
                [_delegate loanMyLimitInput2Cancel];
            }
            
            [self.navigationController fadePopViewController];
        }
            
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
    
    SInt64 tmpValue = 0;
    
    NSArray *array = [aDataSet arrayWithForKeyPath:@"상품정보LIST"];
    
    if ([array count] > 0) {
        
        if ([array[0] isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in array[0]) {
                
                if ([self removeCommaValue:dic[@"대출한도시산금액"]] > tmpValue) {
                    
                    tmpValue = [self removeCommaValue:dic[@"대출한도시산금액"]];
                }
            }
        }
        else if ([array[0] isKindOfClass:[NSDictionary class]]) {
            
            if ([self removeCommaValue:array[0][@"대출한도시산금액"]] > tmpValue) {
                
                tmpValue = [self removeCommaValue:array[0][@"대출한도시산금액"]];
            }
        }
    }
    
    SInt64 max = 0;
    
    BOOL check = NO;
    
    if (tmpValue == 0) {
        
        check = YES;
        
        // 연 소득금액 - (총 대출금액 + 총 담보대출 금액 + (타기관 대출신고금액 - 타기관 신용대출 상환금액) + (타기관 담보대출금액 - 타기관 담보대출 상환금액))
        max = [self removeCommaValue:[self addMillion:_textField1.text]]
                - ([self removeCommaValue:[self addMillion:_textField2.text]] + [self removeCommaValue:[self addMillion:_textField3.text]]
                   + ([self removeCommaValue:[self addMillion:_textField5.text]] - [self removeCommaValue:[self addMillion:_textField7.text]])
                   + ([self removeCommaValue:[self addMillion:_textField6.text]] - [self removeCommaValue:[self addMillion:_textField8.text]]));
    }
    else {
        
        max = tmpValue;
    }
    
    if (max < 0) {
        
        max = 0;
    }
    else {
        
        if (check) {
            
            // 입력한 금액대비 대출금액 계산 결과 값이 5천만원 초과시 최대 대출금은 5천만원으로 제한
            if (max > 50000000) {
                
                max = 50000000;
            }
        }
    }
    
    SHBLoanMyLimitResultViewController *viewController = [[[SHBLoanMyLimitResultViewController alloc] initWithNibName:@"SHBLoanMyLimitResultViewController" bundle:nil] autorelease];
    
    viewController.data = @{ @"_대출한도" : [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%lld", max]] };
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger maxLength = 4;
    
    if (textField == _textField4) {
        
        maxLength = 3;
    }
    
    if ([number length] <= maxLength) {
        
        number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        [textField setText:[SHBUtility normalStringTocommaString:number]];
    }
    
    return NO;
}

@end
