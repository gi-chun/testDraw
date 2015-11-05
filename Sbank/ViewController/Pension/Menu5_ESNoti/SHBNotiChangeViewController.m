//
//  SHBNotiChangeViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBNotiChangeViewController.h"
#import "SHBPopupView.h"                // 팝업 view
#import "SHBPentionService.h"           // 퇴직연금 서비스


@interface SHBNotiChangeViewController ()

@end

@implementation SHBNotiChangeViewController


#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Private Method

- (void)setDataDisplay
{
    // 가입자교육자료 체크
    if ( [self.dicDataDictionary[@"가입자교육자료"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:1001]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:1001]) setSelected:NO];
    }
    
    // 운용현황통지 체크
    if ( [self.dicDataDictionary[@"운용현황"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:1002]) setSelected:YES];
    }
    else
    {
        // 운용현황통지가 비활성의 경우 통보주기를 비활성화
        [((UIButton*)[self.view viewWithTag:1002]) setSelected:NO];
        
        [self setRadioButtonEnable:NO aTag:101];
    }
    
    // 운용현황통지주기 라디오 버튼
    int intPeriod = [self.dicDataDictionary[@"운용현황통보주기"] intValue];
    int intTag = 0;
    
    switch (intPeriod) {
            
        case 1:
        {
            intTag = 101;
        }
            break;
            
        case 3:
        {
            intTag = 102;
        }
            break;
            
        case 6:
        {
            intTag = 103;
        }
            break;
            
        case 0:
        case 12:
        {
            intTag = 104;
        }
            break;
            
        default:
            break;
    }
    
    UIButton *trickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trickButton.tag = intTag;
    
    [self radioButtonDidPush:trickButton];
    
    
    // 펀드운용보고서 체크
    if ( [self.dicDataDictionary[@"펀드운용보고서"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:2001]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:2001]) setSelected:NO];
    }
    
    // 월간펀드리포트 체크
    if ( [self.dicDataDictionary[@"월간펀드리포트"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:2002]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:2002]) setSelected:NO];
    }
    
    // 신한경제브리프 체크
    if ( [self.dicDataDictionary[@"신한경제브리프"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:2003]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:2003]) setSelected:NO];
    }
    
    // SMS
    // 부담금납부현황 체크
    if ( [self.dicDataDictionary[@"부담금납부현황"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:3001]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:3001]) setSelected:NO];
    }
    
    // 운용수익률 체크
    if ( [self.dicDataDictionary[@"운용수익률"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:3002]) setSelected:YES];
    }
    else
    {
        // 운용수익률통보가 비활성의 경우 통보주기를 비활성화
        [((UIButton*)[self.view viewWithTag:3002]) setSelected:NO];
        
        [self setRadioButtonEnable:NO aTag:201];
    }
    
    // 운용수익률통보주기 라디오 버튼
    intPeriod = [self.dicDataDictionary[@"운용수익률통보주기"] intValue];
    intTag = 0;
    
    switch (intPeriod) {
            
        case 1:
        {
            intTag = 201;
        }
            break;
            
        case 3:
        {
            intTag = 202;
        }
            break;
            
        case 6:
        {
            intTag = 203;
        }
            break;
            
        case 0:
        case 12:
        {
            intTag = 204;
        }
            break;
            
        default:
            break;
    }
    
    UIButton *trickButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    trickButton2.tag = intTag;
    
    [self radioButtonDidPush:trickButton2];
}


// 태그값은 101, 201로 들어온다
// isEnable로 활성 비활성 처리
- (void)setRadioButtonEnable:(BOOL)isEnable aTag:(int)aValue
{
    for ( int i = aValue ; i < aValue + 4 ; i++ )
    {
        [((UIButton*)[self.view viewWithTag:i]) setEnabled:isEnable];
    }
    
    // 비활성의 경우 라디오 버튼 값 초기화
    if ( isEnable == NO )
    {
        if (aValue == 101)
        {
            strRadioButton1 = @"0";
        }
        else
        {
            strRadioButton2 = @"0";
        }
    }
}


- (BOOL)checkException
{
    BOOL isError = NO;
    NSString *strErrorMessage = @"수신 동의를 체크해 주세요.";
    
    // email 관련된 check가 있을 경우
    if ( ((UIButton*)[self.view viewWithTag:1001]).selected == YES || ((UIButton*)[self.view viewWithTag:1002]).selected == YES || ((UIButton*)[self.view viewWithTag:2001]).selected == YES || ((UIButton*)[self.view viewWithTag:2002]).selected == YES || ((UIButton*)[self.view viewWithTag:2003]).selected == YES )
    {
        if ( ((UIButton*)[self.view viewWithTag:4001]).selected == NO )
        {
            strErrorMessage = @"E-mail 수신동의 여부를 선택하십시오.";
            goto errorCase;
        }
    }
    
    if ( ((UIButton*)[self.view viewWithTag:3001]).selected == YES || ((UIButton*)[self.view viewWithTag:3002]).selected == YES )
    {
        if ( ((UIButton*)[self.view viewWithTag:4002]).selected == NO )
        {
            strErrorMessage = @"SMS 수신동의 여부를 선택하십시오.";
            goto errorCase;
        }
    }
    
    return isError;
    
errorCase:
    {
        isError = YES;
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        return isError;
    }
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:            // 보고서 설명
        {
            //팝업뷰 오픈
            SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"보고서 설명" subView:viewPopupView];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 21:            // 저장 버튼
        {
            if ( [self checkException] )
            {
                return;
            }
            
            // 이메일 선택 여부
            NSString *strEmailAgree = ((UIButton*)[self.view viewWithTag:4001]).selected ? @"1" : @"0";
            // 가입교육자료 선택 여부
            NSString *strEducationAgree = ((UIButton*)[self.view viewWithTag:1001]).selected ? @"1" : @"0";
            // 운용현황통지 선택 여부
            NSString *strStatusAgree = ((UIButton*)[self.view viewWithTag:1002]).selected ? @"1" : @"0";
            // 펀드운용보고서 선택 여부
            NSString *strFundAgree = ((UIButton*)[self.view viewWithTag:2001]).selected ? @"1" : @"0";
            // 월간펀드리포트 선택 여부
            NSString *strMonthFundAgree = ((UIButton*)[self.view viewWithTag:2002]).selected ? @"1" : @"0";
            // 신한경제브리프 선택 여부
            NSString *strBriefAgree = ((UIButton*)[self.view viewWithTag:2002]).selected ? @"1" : @"0";
            // 부담금납부현황 선택 여부
            NSString *strSurchargeStatusAgree = ((UIButton*)[self.view viewWithTag:3001]).selected ? @"1" : @"0";
            // 운용수익률 선택 여부
            NSString *strRateAgree = ((UIButton*)[self.view viewWithTag:3002]).selected ? @"1" : @"0";
            // 이메일 선택 여부
            NSString *strSMSAgree = ((UIButton*)[self.view viewWithTag:4002]).selected ? @"1" : @"0";
            
            OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"서비스ID" : @"SRPW765040I1",
                                    @"고객구분" : @"3",
                                    @"플랜번호" : self.dicDataDictionary[@"플랜번호"],
                                    @"가입자번호" : self.dicDataDictionary[@"가입자번호"],
                                    @"제도구분" : self.dicDataDictionary[@"제도구분"],
                                    @"제도구분_1" : self.dicDataDictionary[@"제도구분"],
                                    @"페이지인덱스" : @"1",
                                    @"전체조회건수" : @"0",
                                    @"페이지패치건수" : @"500",
                                    @"예비필드" : @"",
                                    @"플랜번호_1" : self.dicDataDictionary[@"플랜번호"],
                                    @"가입자번호_1" : self.dicDataDictionary[@"가입자번호"],
                                    @"고객구분_1" : @"3",
                                    @"email수신여부" : strEmailAgree,
                                    @"운용현황통보주기" : strRadioButton1,
                                    @"운용현황" : strStatusAgree,
                                    @"가입자교육자료" : strEducationAgree,
                                    @"펀드운용보고서" : strFundAgree,
                                    @"월간펀드리포트" : strMonthFundAgree,
                                    @"신한경제브리프" : strBriefAgree,
                                    @"sms수신여부" : strSMSAgree,
                                    @"운용수익률통보주기" : strRadioButton2,
                                    @"운용수익률" : strRateAgree,
                                    @"부담금납부현황" : strSurchargeStatusAgree,
                                    @"우편번호1" : @"",
                                    @"우편번호2" : @"",
                                    @"우편번호주소" : @"",
                                    @"상세주소" : @"",
                                    @"휴대전화번호_1" : @"",
                                    @"휴대전화번호_2" : @"",
                                    @"휴대전화번호_3" : @"",
                                    @"email주소" : @"",
                                    @"전화번호_1" : @"",
                                    @"전화번호_2" : @"",
                                    @"전화번호_3" : @""
                                    }] autorelease];
            
            self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT viewController: self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
        }
            break;
            
        case 22:            // 취소 버튼
        {
            [self.navigationController fadePopViewController];
            [AppDelegate.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark checkButtonDidPush

- (IBAction)checkButtonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 1001:
        case 1002:
        case 2001:
        case 2002:
        case 2003:
        case 3001:
        case 3002:
        case 4001:
        case 4002:
        {
            if ( ((UIButton*)[self.view viewWithTag:[sender tag]]).selected == YES )
            {
                // 체크 푸는 경우
                [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:NO];
                
                switch ([sender tag]) {
                        
                    case 1002:      // 운용현황 비활성화의 경우 통보주기 비활성화
                    {
                        [self setRadioButtonEnable:NO aTag:101];
                    }
                        break;
                        
                    case 3002:      // 운용수익률통보 비활성화의 경우 통보주기 비활성화
                    {
                        [self setRadioButtonEnable:NO aTag:201];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            else
            {
                // 체크하는 경우
                [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:YES];
                
                switch ([sender tag]) {
                         
                    case 1002:      // 운용현황 활성화의 경우 통보주기 활성화
                    {
                        [self setRadioButtonEnable:YES aTag:101];
                    }
                        break;
                        
                    case 3002:      // 운용수익률통보 활성화의 경우 통보주기 활성화
                    {
                        [self setRadioButtonEnable:YES aTag:201];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
            break;

        default:
            break;
    }
}


#pragma mark -
#pragma radioButtonDidPush

- (IBAction)radioButtonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 101:
        case 102:
        case 103:
        case 104:
        {
            // 라디오 버튼 변경
            for ( int i = 101 ; i < 105 ; i++ )
            {
                [((UIButton*)[self.view viewWithTag:i]) setSelected:NO];
            }
            
            [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:YES];
            
            // 전달 값 setting
            switch ([sender tag]) {
                    
                case 101:
                {
                    strRadioButton1 = @"1";
                }
                    break;
                    
                case 102:
                {
                    strRadioButton1 = @"3";
                }
                    break;
                    
                case 103:
                {
                    strRadioButton1 = @"6";
                }
                    break;
                    
                case 104:
                {
                    strRadioButton1 = @"12";
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 201:
        case 202:
        case 203:
        case 204:
        {
            // 라디오 버튼 변견
            for ( int i = 201 ; i < 205 ; i++ )
            {
                [((UIButton*)[self.view viewWithTag:i]) setSelected:NO];
            }
            
            [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:YES];
            
            // 전달 값 setting
            switch ([sender tag]) {
                    
                case 201:
                {
                    strRadioButton2 = @"1";
                }
                    break;
                    
                case 202:
                {
                    strRadioButton2 = @"3";
                }
                    break;
                    
                case 203:
                {
                    strRadioButton2 = @"6";
                }
                    break;
                    
                case 204:
                {
                    strRadioButton2 = @"12";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if ( alertView.tag == 9999 )
    {
        [self.navigationController fadePopToRootViewController];
    }
}


#pragma mark -
#pragma mark onPrase & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3949"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )        // 정보를 정상적으로 받아온 경우
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:9999 title:nil message:@"퇴직연금 이메일, SMS통지 수신 정보가 변경되었습니다."];
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}


#pragma mark -
#pragma mark Xcode Generate

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
    // Do any additional setup after loading the view from its nib.
    
    self.title  = @"이메일, SMS통지/정보변경";
    self.strBackButtonTitle = @"이메일, SMS통지/정보변경";
    
    // 초기값 설정
    [self setDataDisplay];
    
    [scrollView1 setContentSize:CGSizeMake(viewRealView.frame.size.width, viewRealView.frame.size.height)];
    [scrollView2 setContentSize:CGSizeMake(0, viewPopDetailView.frame.size.height)];
    
    // ios7상단 스크롤
    FrameResize(scrollView1, 317, height(scrollView1));
    FrameReposition(scrollView1, 0, 44);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    
    [super dealloc];
}

@end
