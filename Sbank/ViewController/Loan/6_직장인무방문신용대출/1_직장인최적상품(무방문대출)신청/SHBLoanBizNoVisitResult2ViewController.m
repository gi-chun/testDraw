//
//  SHBLoanBizNoVisitResult2ViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitResult2ViewController.h"
#import "SHBLoanService.h" // 서비스

#import "SHBNewProductSeeStipulationViewController.h" // 약관보기
#import "SHBLoanBizNoVisitCompleteViewController.h" // 직장인 최적상품(무방문대출) 신청 완료

@interface SHBLoanBizNoVisitResult2ViewController ()
{
    Boolean isSee;
    Boolean isLimit; // 한도 YES, 건별 NO
}

@end

@implementation SHBLoanBizNoVisitResult2ViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 연소득확인 안내";
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:@"직장인 최적상품(무방문대출) 신청"];
    
    [_productName initFrame:_productName.frame
                      colorType:RGB(44, 44, 44)
                       fontSize:15
                      textAlign:2];
    [_productName setCaptionText:self.data[@"_상품명"]];
    
    isSee = NO;
    
    CGFloat y = top(_interestView);
    
    if ([self.data[@"_상품코드"] length] > 5) {
        
        NSString *subStr = [self.data[@"_상품코드"] substringWithRange:NSMakeRange(4, 1)];
        
        if ([subStr isEqualToString:@"4"]) {
            
            // 한도
            
            isLimit = YES;
            
            [_interestView setHidden:YES];
        }
        else {
            
            // 건별
            
            isLimit = NO;
            
            [_interestView setHidden:NO];
            
            y += height(_interestView) + 10;
        }
    }
    
    // 원클릭급여이체스마트론, 원클릭스마트론 인 경우 추천번호 입력
    if ((([self.data[@"_상품코드"] isEqualToString:@"611111100"] || [self.data[@"_상품코드"] isEqualToString:@"611141100"]) &&
         [self.data[@"_정책코드"] isEqualToString:@"6215"]) ||
        [self.data[@"_상품코드"] isEqualToString:@"611115700"] ||
        [self.data[@"_상품코드"] isEqualToString:@"611143700"]) {
        
        [_recommendView setHidden:NO];
        
        FrameReposition(_recommendView, 0, y);
        
        y += height(_recommendView) + 10;
        
        startTextFieldTag = 33000;
        endTextFieldTag = 33002;
    }
    else {
        
        [_recommendView setHidden:YES];
        
        [_recommend setTag:0];
        
        startTextFieldTag = 33000;
        endTextFieldTag = 33001;
    }
    
    FrameResize(_contentView, width(_contentView), y + 59);
    
    [self.contentScrollView addSubview:_contentView];
    [self.contentScrollView setContentSize:_contentView.frame.size];
    
    contentViewHeight = _contentView.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.C2800Dic = nil;
    
    [_contentView release];
    [_annualIncome release];
    [_money release];
    [_agreeBtn release];
    [_productName release];
    [_subTitleView release];
    [_interestView release];
    [_recommendView release];
    [_recommend release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setAnnualIncome:nil];
    [self setMoney:nil];
    [self setAgreeBtn:nil];
    [self setProductName:nil];
    [self setSubTitleView:nil];
    [self setRecommendView:nil];
    [self setRecommend:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (NSString *)getErrorMessage
{
    if ([_annualIncome.text length] != 14) {
        
        return @"홈택스 발급번호를 입력해 주세요.";
    }
    
    SInt64 money = [[_money.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
    
    if (money < 100) {
        
        return @"신청금액은 최소 100만원부터 입니다.";
    }
    else {
        
        NSString *lastStr = [_money.text substringFromIndex:[_money.text length] - 1];
        if (![lastStr isEqualToString:@"0"]) {
            
            return @"만원 단위는 0값이 되게 신청하시기 바랍니다.";
        }
    }
    
    NSInteger eqVal = 3000;
    
    // TOPS직장인신용대출 한도 5천만원, 엘리트론TOPS공무원신용대출 한도 1억으로 향상
    if ([self.data[@"_상품코드"] isEqualToString:@"612211500"] || [self.data[@"_상품코드"] isEqualToString:@"612241500"]) {
        
        eqVal = 5000;
    }
    else if ([self.data[@"_상품코드"] isEqualToString:@"612211100"] ||
             [self.data[@"_상품코드"] isEqualToString:@"612241100"] ||
             [self.data[@"_상품코드"] isEqualToString:@"612411800"] ||
             [self.data[@"_상품코드"] isEqualToString:@"612441700"]) {
        
        eqVal = 10000;
    }
    
    if (money > eqVal) {
        
        NSString *won = [SHBUtility changeNumberStringToKoreaAmountString:[NSString stringWithFormat:@"%d0000", eqVal]];
        
        return [NSString stringWithFormat:@"신청금액은 %@원을 초과할 수 없습니다.", won];
    }
    
    SInt64 maxMoney = [[self.data[@"_산출한도"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
    
    money *= 10000;
    
    if (money > maxMoney) {
        
        return [NSString stringWithFormat:@"신청금액은 %@원을 초과할 수 없습니다.", self.data[@"_산출한도"]];
    }
    
    if (!isLimit) {
        
        if (!isSee) {
            
            return @"연체 이후 이자일부납부확인서 보기를 선택하여 확인하시기 바랍니다.";
        }
        
        if (![_agreeBtn isSelected]) {
            
            return @"연체 이후 이자일부납부확인서 확인을 선택하시기 바랍니다.";
        }
    }
    
    return @"";
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 100: {
            
            // 발급번호 안내
            
            NSString *URL = [NSString stringWithFormat:@"https://%@.shinhan.com/sbank/goldprod/sb_income_confirm.jsp", AppInfo.realServer ? @"m" : @"dev-m"];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = URL;
            viewController.strName = @"직장인 무방문 신용대출";
            viewController.strBackButtonTitle = @"소득확인방법";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 200: {
            
            // 연체 이후 이자일부납부확인서 보기
            
            isSee = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@loan_fee_date_change.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"직장인 무방문 신용대출";
            viewController.strBackButtonTitle = @"확인서 보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 300: {
            
            // 예, 동의합니다.
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 400: {
            
            // 신청
            
            NSString *message = [self getErrorMessage];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:message];
                return;
            }
            
            NSString *phoneNumber = @"";
            
            if ([_C2800Dic[@"휴대폰지역번호"] length] > 0 && [_C2800Dic[@"휴대폰지역번호"] length] > 0 && [_C2800Dic[@"휴대폰지역번호"] length] > 0) {
                
                phoneNumber = [NSString stringWithFormat:@"%@%@%@",
                               [SHBUtility nilToString:_C2800Dic[@"휴대폰지역번호"]],
                               [SHBUtility nilToString:_C2800Dic[@"휴대폰국번호"]],
                               [SHBUtility nilToString:_C2800Dic[@"휴대폰통신일련번호"]]];
            }
            
            AppInfo.serviceOption = @"직장인무방문대출";
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          @"업무구분" : @"1",
                                                                          @"신청번호" : self.data[@"_신청번호"],
                                                                          @"상품CODE" : self.data[@"_상품코드"],
                                                                          @"정책코드" : self.data[@"_정책코드"],
                                                                          @"금리구분" : self.data[@"_금리구분"],
                                                                          @"시장금리종류" : self.data[@"_시장금리종류"],
                                                                          @"시장기간물종류" : self.data[@"_시장기간물종류"],
                                                                          @"금리차등적용구분" : self.data[@"_금리차등적용구분"],
                                                                          @"여신신청정수금액" : [_money.text stringByReplacingOccurrencesOfString:@"," withString:@""],
                                                                          @"홈택스발급번호" : _annualIncome.text,
                                                                          @"받는분전화번호" : phoneNumber
                                                                          }];
            
            // 원클릭급여이체스마트론, 원클릭스마트론 인 경우 추천번호 입력
            if ((([self.data[@"_상품코드"] isEqualToString:@"611111100"] || [self.data[@"_상품코드"] isEqualToString:@"611141100"]) &&
                 [self.data[@"_정책코드"] isEqualToString:@"6215"]) ||
                [self.data[@"_상품코드"] isEqualToString:@"611115700"] ||
                [self.data[@"_상품코드"] isEqualToString:@"611143700"]) {
                
                [aDataSet insertObject:[SHBUtility nilToString:_recommend.text]
                                forKey:@"추천번호"
                               atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3662_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
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
    
    switch (self.service.serviceId) {
            
        case LOAN_L3662_SERVICE: {
            
            [aDataSet insertObject:self.data[@"_상품명"]
                            forKey:@"_상품명"
                           atIndex:0];
            
            [aDataSet insertObject:self.data[@"_상품코드"]
                            forKey:@"_상품코드"
                           atIndex:0];
            
            [aDataSet insertObject:self.data[@"_판정코드"]
                            forKey:@"_판정코드"
                           atIndex:0];
            
            [aDataSet insertObject:[NSString stringWithFormat:@"%@만원", _money.text]
                            forKey:@"_신청대출금액"
                           atIndex:0];
            
            [aDataSet insertObject:self.data[@"_금리"] forKey:@"_금리" atIndex:0];
            
            SHBLoanBizNoVisitCompleteViewController *viewController = [[[SHBLoanBizNoVisitCompleteViewController alloc] initWithNibName:@"SHBLoanBizNoVisitCompleteViewController" bundle:nil] autorelease];
            
            viewController.data = [NSDictionary dictionaryWithDictionary:aDataSet];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _annualIncome) {
        
        if ([number length] <= 14) {
            
            [textField setText:number];
        }
    }
    else if (textField == _money) {
        
        if ([number length] <= 6) { // , 포함하여 계산
            
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[SHBUtility normalStringTocommaString:number]];
        }
    }
    else if (textField == _recommend) {
        
        if ([number length] <= 10) {
            
            [textField setText:number];
        }
    }
    
    return NO;
}

@end
