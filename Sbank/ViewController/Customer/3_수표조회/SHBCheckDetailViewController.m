//
//  SHBCheckDetailViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 01. 17..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBCheckDetailViewController.h"

@interface SHBCheckDetailViewController ()

@end

@implementation SHBCheckDetailViewController


@synthesize strMenuTitle;


#pragma mark -
#pragma mark Private Method

- (NSString *) getAccidentCode:(NSString *)code
{
	int t = [code intValue];
    NSString *strString = @"";
    
	switch (t)
    {
		case 1:
			strString = @"분실,도난";
			break;
		case 2:
			strString = @"위조,변조";
			break;
		case 3:
			strString = @"피사취";
			break;
		case 4:
			strString = @"법적제한";
			break;
		case 5:
			strString = @"계약불이행";
			break;
		case 11:
			strString = @"서손처리";
			break;
		default:
			strString = @"기타";
			break;
	}
    
    return strString;
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    [self.navigationController fadePopToRootViewController];
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
    
    if ([self.strMenuTitle isEqualToString:@"수표조회"])
    {
        self.title = @"수표조회";
        labelSubTitle.text = @"수표조회 완료";
    }
    else
    {
        self.title = @"사고신고 조회 완료";
        labelSubTitle.text = @"수표 사고신고 조회 완료";
    }
    
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ 상세", self.title];
    
    int ContentFlag = [AppInfo.commonDic[@"CHECK-CONTENTS"] intValue];

    if ([AppInfo.commonDic[@"당행여부"] isEqualToString:@"0"])
    {
        if ([AppInfo.commonDic[@"사고여부"] isEqualToString:@"1"])
        {
            // 예외 view
            label5_6.text = [NSString stringWithFormat:@"%@(%@)", AppInfo.commonDic[@"사고등록일자"], AppInfo.commonDic[@"사고등록시간"]];
            label5_7.text = [self getAccidentCode:AppInfo.commonDic[@"사고사유코드"]];
            
            // 사고 view
            label2_6.text = [NSString stringWithFormat:@"%@(%@)", AppInfo.commonDic[@"사고등록일자"], AppInfo.commonDic[@"사고등록시간"]];
            label2_7.text = [self getAccidentCode:AppInfo.commonDic[@"사고사유코드"]];
        }
        
        UIView      *viewSelected = nil;
        
        switch (ContentFlag)
        {
            case 0:     // 정상
            {
                viewSelected = view1;
                
                label1_1.text = AppInfo.commonDic[@"수표번호"];
                label1_2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"수표금액"]];
                label1_3.text = AppInfo.commonDic[@"발행점지로코드"];
                label1_4.text = AppInfo.commonDic[@"발행일"];
                label1_5.text = AppInfo.commonDic[@"발행점->display"];
            }
                break;
                
            case -1:        // 예외
            {
                viewSelected = view5;
                
                label5_1.text = AppInfo.commonDic[@"수표번호"];
                label5_2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"수표금액"]];
                label5_3.text = AppInfo.commonDic[@"발행점지로코드"];
                label5_4.text = AppInfo.commonDic[@"발행일"];
                label5_5.text = AppInfo.commonDic[@"발행점->display"];
                
                labelContents.text = AppInfo.commonDic[@"응답내용"];
            }
                break;
                
            case 1:         // 당행 사고 수표
            {
                viewSelected = view2;
                
                label2_1.text = AppInfo.commonDic[@"수표번호"];
                label2_2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"수표금액"]];
                label2_3.text = AppInfo.commonDic[@"발행점지로코드"];
                label2_4.text = AppInfo.commonDic[@"발행일"];
                label2_5.text = AppInfo.commonDic[@"발행점->display"];
            }
                
                break;
                
            case 2:         // 당행 지급된 수표
            {
                viewSelected = view3;
                
                label3_1.text = AppInfo.commonDic[@"수표번호"];
                label3_2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"수표금액"]];
                label3_3.text = AppInfo.commonDic[@"발행점지로코드"];
                label3_4.text = AppInfo.commonDic[@"발행일"];
                label3_5.text = AppInfo.commonDic[@"발행점->display"];
                
            }
                break;
                
            case 3:         // 당행 사용불가 수표
            {
                viewSelected = view4;
                
                label4_1.text = AppInfo.commonDic[@"수표번호"];
                label4_2.text = [NSString stringWithFormat:@"%@원", AppInfo.commonDic[@"수표금액"]];
                label4_3.text = AppInfo.commonDic[@"발행점지로코드"];
                label4_4.text = AppInfo.commonDic[@"발행일"];
                label4_5.text = AppInfo.commonDic[@"발행점->display"];
                
            }
                break;
            default:
                break;
        }

        [realView addSubview:viewSelected];
    }
    else            // 타행의 경우
    {
        UIView      *viewSelected = nil;
        
        switch (ContentFlag)
        {   // 2011.01.10  멘트 수정
            case 0:
            {
                viewSelected = view6;
                    
                label6_0.text = AppInfo.commonDic[@"발행은행"];
                label6_1.text = AppInfo.commonDic[@"수표번호"];
                label6_2.text = AppInfo.commonDic[@"수표금액"];
                label6_3.text = AppInfo.commonDic[@"수표발행일자"];
                
            }
                break;
                
            case -1:        // 타행 정상 아닐 시
            {
                viewSelected = view7;
                
                label7_0.text = AppInfo.commonDic[@"발행은행"];
                label7_1.text = AppInfo.commonDic[@"수표번호"];
                label7_2.text = AppInfo.commonDic[@"수표금액"];
                label7_3.text = AppInfo.commonDic[@"수표발행일자"];
                
                labelContents2.text = AppInfo.commonDic[@"응답내용"];
            }
                break;
                
            default:
            {
                viewSelected = view7;
                labelContents2.text = @"조회 중 오류가 발생하였습니다.";
            }
                break;
        }
        
        [realView addSubview:viewSelected];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    self.strMenuTitle = nil;
}

@end
