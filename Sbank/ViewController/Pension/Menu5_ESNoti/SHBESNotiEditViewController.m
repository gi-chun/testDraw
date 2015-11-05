//
//  SHBESNotiEditViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 26..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBESNotiEditViewController.h"
#import "SHBPentionService.h"                   // 퇴직연금 서비스
#import "SHBNotiChangeViewController.h"         // 다음 view
#import "SHBSearchZipViewController.h"          // 우편번호 검색 view


@interface SHBESNotiEditViewController ()

@end

@implementation SHBESNotiEditViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


#pragma mark -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString *strErrorMessage = @"입력값을 확인해 주세요.";
    
    if ( [textFieldPhone1.text length] < 2 )
    {
        strErrorMessage = @"전화번호 앞자리를 두자리 이상 입력하여 주십시오";
        goto errorCase;
    } else if ( [textFieldPhone2.text length] < 3 )
    {
        strErrorMessage = @"전화국번호를 세자리 이상 입력하여 주십시오";
        goto errorCase;
    }
    else if ( [textFieldPhone3.text length] < 4 )
    {
        strErrorMessage = @"전화 일련번호를 네자리 입력하여 주십시오";
        goto errorCase;
    }
    else if ( nil == textFieldCellNumber1.text || [textFieldCellNumber1.text isEqualToString:@""] || nil == textFieldCellNumber2.text || [textFieldCellNumber2.text isEqualToString:@""] || nil == textFieldCellNumber3.text || [textFieldCellNumber3.text isEqualToString:@""] )
    {
        strErrorMessage = @"핸드폰 번호를 정확하게 입력하여 주십시오";
        goto errorCase;
    }
    else if ( [textFieldCellNumber1.text length] < 3 )
    {
        strErrorMessage = @"핸드폰 번호를 세자리 이상 입력하여 주십시오";
        goto errorCase;
    }
    else if ( [textFieldCellNumber2.text length] < 3 )
    {
        strErrorMessage = @"핸드폰 번호를 세자리 이상 입력하여 주십시오";
        goto errorCase;
    }
    else if ( [textFieldCellNumber3.text length] < 3 )
    {
        strErrorMessage = @"핸드폰 번호를 네자리 이상 입력하여 주십시오";
        goto errorCase;
    }
    else if ( nil == textFieldEmail.text || [textFieldEmail.text isEqualToString:@""] )
    {
        strErrorMessage = @"E-mail주소를 입력해 주십시오";
        goto errorCase;
    }
    
    return isError;
    
errorCase:
    {
        isError = YES;
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        return isError;
    }
}


- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    textFieldNumber1.text = mDic[@"POST1"];          // 우편번호1
    textFieldNumber2.text = mDic[@"POST2"];          // 우편번호2
    
    textFieldAddress1.text = mDic[@"ADDR1"];         // 주소
    textFieldAddress2.text = mDic[@"ADDR2"];         // 상세주소
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:            // 우편번호 검색 버튼
        {
            SHBSearchZipViewController *viewController = [[SHBSearchZipViewController alloc] initWithNibName:@"SHBSearchZipViewController" bundle:nil];
            [viewController executeWithTitle:@"이메일, SMS통지/정보변경" ReturnViewController:self];
            [self.navigationController pushFadeViewController:viewController];
            
            [viewController release];
            
        }
            break;
            
        case 21:            // 저장 버튼
        {
            
            if ([self checkException])          // 예외처리
            {
                return;
            }
            
            OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"서비스ID" : @"SRPW765040I0",
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
                                    @"email수신여부" : @"",
                                    @"운용현황통보주기" : @"0",
                                    @"운용현황" : @"",
                                    @"가입자교육자료" : @"",
                                    @"펀드운용보고서" : @"",
                                    @"월간펀드리포트" : @"",
                                    @"신한경제브리프" : @"",
                                    @"sms수신여부" : @"",
                                    @"운용수익률통보주기" : @"0",
                                    @"운용수익률" : @"",
                                    @"부담금납부현황" : @"",
                                    @"우편번호1" : textFieldNumber1.text,
                                    @"우편번호2" : textFieldNumber2.text,
                                    @"우편번호주소" : textFieldAddress1.text,
                                    @"상세주소" : textFieldAddress2.text,
                                    @"휴대전화번호_1" : textFieldCellNumber1.text,
                                    @"휴대전화번호_2" : textFieldCellNumber2.text,
                                    @"휴대전화번호_3" : textFieldCellNumber3.text,
                                    @"email주소" : textFieldEmail.text,
                                    @"전화번호_1" : textFieldPhone1.text,
                                    @"전화번호_2" : textFieldPhone2.text,
                                    @"전화번호_3" : textFieldPhone3.text
                                    }] autorelease];
            
            self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_ES_NOTI_EDIT_INFO_SUMMIT viewController: self] autorelease];
            self.service.previousData = aDataSet;
            [self.service start];
            
        }
            break;
            
        case 22:            //  취소 버튼
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3735"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )        // 정보를 정상적으로 받아온 경우
        {
            textFieldNumber1.text = aDataSet[@"우편번호1"];
            textFieldNumber2.text = aDataSet[@"우편번호2"];
            textFieldAddress1.text = aDataSet[@"우편번호주소"];
            textFieldAddress2.text = aDataSet[@"상세주소"];
            textFieldPhone1.text = aDataSet[@"전화번호_1"];
            textFieldPhone2.text = aDataSet[@"전화번호_2"];
            textFieldPhone3.text = aDataSet[@"전화번호_3"];
            textFieldCellNumber1.text = aDataSet[@"휴대전화번호_1"];
            textFieldCellNumber2.text = aDataSet[@"휴대전화번호_2"];
            textFieldCellNumber3.text = aDataSet[@"휴대전화번호_3"];
            textFieldEmail.text = aDataSet[@"email주소"];
            
            return NO;
        }
    }
    else if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3740"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )            // 저장 후 통신 성공 시
        {
            
            NSString *strClassName = @"SHBNotiChangeViewController";

            // 제도구분코드 1 DB
            // 제도구분코드 2 DC
            // 제도구분코드 3 기업형IRP
            // 제도구분코드 4 개인형IRP
            
            if ( [self.dicDataDictionary[@"제도구분"] isEqualToString:@"1"] )     // DB의 경우 flow가 다르다
            {
                strClassName = @"SHBNotiChangeViewControllerForDB";
            }
            
            SHBBaseViewController *viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
            
            // 정보 set           // data 전달 문제로 casting
            ((SHBNotiChangeViewController *)viewController).dicDataDictionary = aDataSet;
            [((SHBNotiChangeViewController *)viewController).dicDataDictionary setObject:self.dicDataDictionary[@"플랜번호"] forKey:@"플랜번호"];
            [((SHBNotiChangeViewController *)viewController).dicDataDictionary setObject:self.dicDataDictionary[@"가입자번호"] forKey:@"가입자번호"];
            [((SHBNotiChangeViewController *)viewController).dicDataDictionary setObject:self.dicDataDictionary[@"제도구분"] forKey:@"제도구분"];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
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
#pragma mark SHBTextField Delegate

- (void)didNextButtonTouch		// 다음버튼
{
    [super didNextButtonTouch];
}


#pragma mark -
#pragma mark TextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    int intLength = 0;
    
    if ( textField == textFieldCellNumber1 || textField == textFieldCellNumber2 || textField == textFieldCellNumber3 )
    {
        // 숫자의 경우
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
        {
            if ( textField == textFieldCellNumber1 )
            {
                intLength = 2;
            }
            else
            {
                intLength = 3;
            }
            
            if ( [textField.text length] > intLength )
            {
                [self didNextButtonTouch];
                return NO;
            }
        }
    }
    
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
    self.strBackButtonTitle = @"이메일, SMS통지/정보변경 기본정보";
    
    AppInfo.isNeedBackWhenError = YES;
    
    OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                            @{
                            @"서비스ID" : @"SRPW765040Q0",
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
                            @"email수신여부" : @"",
                            @"운용현황통보주기" : @"0",
                            @"운용현황" : @"",
                            @"가입자교육자료" : @"",
                            @"펀드운용보고서" : @"",
                            @"월간펀드리포트" : @"",
                            @"신한경제브리프" : @"",
                            @"sms수신여부" : @"",
                            @"운용수익률통보주기" : @"0",
                            @"운용수익률" : @"",
                            @"부담금납부현황" : @"",
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
    
    self.service = [[[SHBPentionService alloc] initWithServiceId: PENSION_ES_NOTI_EDIT_INFO viewController: self] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222008;
    
    textFieldNumber1.accDelegate = self;
    textFieldNumber2.accDelegate = self;
    textFieldAddress1.accDelegate = self;
    textFieldAddress2.accDelegate = self;
    textFieldPhone1.accDelegate = self;
    textFieldPhone2.accDelegate = self;
    textFieldPhone3.accDelegate = self;
    textFieldCellNumber1.accDelegate = self;
    textFieldCellNumber2.accDelegate = self;
    textFieldCellNumber3.accDelegate = self;
    textFieldEmail.accDelegate = self;
    
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
