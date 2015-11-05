//
//  SHBNotiChangeViewControllerForDB.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBNotiChangeViewControllerForDB.h"
#import "SHBPopupView.h"                // 팝업 view
#import "SHBPentionService.h"           // 퇴직연금 서비스


@interface SHBNotiChangeViewControllerForDB ()

@end

@implementation SHBNotiChangeViewControllerForDB

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;


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
            
            if ( ((UIButton*)[self.view viewWithTag:1001]).selected == YES || ((UIButton*)[self.view viewWithTag:1002]).selected == YES )
            {
                if ( ((UIButton*)[self.view viewWithTag:4001]).selected == NO )         // 하나라도 선택된 경우 동의 필요
                {
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"E-mail 수신동의 여부를 선택하십시오."];
                    return;
                }
            }
            
            // 이메일 선택 여부
            NSString *strEmailAgree = ((UIButton*)[self.view viewWithTag:4001]).selected ? @"1" : @"0";
            // 가입교육자료 선택 여부
            NSString *strEducationAgree = ((UIButton*)[self.view viewWithTag:1001]).selected ? @"1" : @"0";
            // 신한경제브리프 선택 여부
            NSString *strBriefAgree = ((UIButton*)[self.view viewWithTag:1002]).selected ? @"1" : @"0";
            
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
                                    @"운용현황통보주기" : @"12",
                                    @"운용현황" : @"0",
                                    @"가입자교육자료" : strEducationAgree,
                                    @"펀드운용보고서" : @"0",
                                    @"월간펀드리포트" : @"0",
                                    @"신한경제브리프" : strBriefAgree,
                                    @"sms수신여부" : @"1",
                                    @"운용수익률통보주기" : @"1",
                                    @"운용수익률" : @"1",
                                    @"부담금납부현황" : @"1",
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

- (IBAction)checkButtonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 1001:
        case 1002:
        case 4001:      // 이메일 수신 동의
        {
            if ( ((UIButton*)[self.view viewWithTag:[sender tag]]).selected == YES )
            {
                [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:NO];
            }
            else
            {
                [((UIButton*)[self.view viewWithTag:[sender tag]]) setSelected:YES];
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
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E3949"] )
    {
        if ( [aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"] )            // 저장 후 통신 성공 시
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
    
    // 초기값 설정 필요
    if ( [self.dicDataDictionary[@"가입자교육자료"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:1001]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:1001]) setSelected:NO];
    }
    
    if ( [self.dicDataDictionary[@"신한경제브리프"] isEqualToString:@"1"] )
    {
        [((UIButton*)[self.view viewWithTag:1002]) setSelected:YES];
    }
    else
    {
        [((UIButton*)[self.view viewWithTag:1002]) setSelected:NO];
    }
    
    [scrollView1 setContentSize:CGSizeMake(0, viewPopDetailView.frame.size.height)];
    
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
