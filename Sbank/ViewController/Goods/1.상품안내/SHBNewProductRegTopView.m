//
//  SHBNewProductRegTopView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductRegTopView.h"


@implementation SHBNewProductRegTopView

- (id)initWithFrame:(CGRect)frame parentViewController:(SHBBaseViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setBackgroundColor:RGB(241, 229, 213)];
		
        

        if ([viewController isKindOfClass:[SHBNewProductRegViewController class]]) {	// 상품가입 입력화면
            self.regViewController = (SHBNewProductRegViewController *)viewController;
            NSDictionary *dicData = self.regViewController.dicSelectedData;
            NSDictionary *dicSmartNewData = self.regViewController.dicSmartNewData;
            
            if ([[dicData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])
            {

                if([[dicData objectForKey:@"상품코드"] isEqualToString:@"200009201"] ||  //민트(영업점용)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200009301"] ||  //신한그린애
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200009206"] || //민트 온라인
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200009207"] || //민트(온라인 560)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200009208"] ||  //민트(온라인 561)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013601"] ||  //s드림 정기예금(영업점용)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013606"] ||  //s드림 정기예금(고객산출,비대면일반)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013607"] ||  //s드림(비대면 560)
                   [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013608"] )  //s드림(비대면 561)
                {
                    
                    
                    UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 76-8, 34)]autorelease];
                    [lblTitle1 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle1 setTextColor:RGB(74, 74, 74)];
                    [lblTitle1 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle1 setText:@"적립방식"];
                    [self addSubview:lblTitle1];
                    
                    UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 210, 34)]autorelease];
                    [lblBody1 setBackgroundColor:[UIColor clearColor]];
                    [lblBody1 setTextColor:RGB(44, 44, 44)];
                    [lblBody1 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody1 setTextAlignment:NSTextAlignmentRight];
                    [lblBody1 setText:@"정기예금"];
                    [self addSubview:lblBody1];
                    
                    
                    UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28, 100, 34)]autorelease];
                    [lblTitle2 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle2 setTextColor:RGB(74, 74, 74)];
                    [lblTitle2 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle2 setText:@"이자지급방법"];
                    [self addSubview:lblTitle2];
                    
                    UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28, 210, 28)]autorelease];
                    [lblBody2 setBackgroundColor:[UIColor clearColor]];
                    [lblBody2 setTextColor:RGB(44, 44, 44)];
                    [lblBody2 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody2 setTextAlignment:NSTextAlignmentRight];
                    [lblBody2 setText:[dicData objectForKey:@"이자지급방법문구"]];
                    [self addSubview:lblBody2];
                    
                    UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28, 76-8, 28)]autorelease];
                    [lblTitle3 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle3 setTextColor:RGB(74, 74, 74)];
                    [lblTitle3 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle3 setText:@"지급주기"];
                    [self addSubview:lblTitle3];
                    
                    
                    UILabel *lblBody3 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28, 210, 28)]autorelease];
                    [lblBody3 setBackgroundColor:[UIColor clearColor]];
                    [lblBody3 setTextColor:RGB(44, 44, 44)];
                    [lblBody3 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody3 setTextAlignment:NSTextAlignmentRight];
                    
                    NSString *tmp = [dicData objectForKey:@"이자지급주기"];
                    if ([tmp isEqualToString:@"0"])
                    {
                        [lblBody3 setText:@""];
                    }
                    else{
                        [lblBody3 setText:[dicData objectForKey:@"이자지급주기"]];
                    }
                    
                    [self addSubview:lblBody3];
                    
                    UILabel *lblTitle4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28, 76-8, 28)]autorelease];
                    [lblTitle4 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle4 setTextColor:RGB(74, 74, 74)];
                    [lblTitle4 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle4 setText:@"계약기간"];
                    [self addSubview:lblTitle4];
                    
                    UILabel *lblBody4 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28, 210, 28)]autorelease];
                    [lblBody4 setBackgroundColor:[UIColor clearColor]];
                    [lblBody4 setTextColor:RGB(44, 44, 44)];
                    [lblBody4 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody4 setTextAlignment:NSTextAlignmentRight];
                    [lblBody4 setText:[dicData objectForKey:@"가입기간문구"]];   //지수연동예금 2013.5.30 추가
                    [self addSubview:lblBody4];
                    
                    
                    UILabel *lblTitle5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28, 76-8, 28)]autorelease];
                    [lblTitle5 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle5 setTextColor:RGB(74, 74, 74)];
                    [lblTitle5 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle5 setText:@"신규금액"];
                    [self addSubview:lblTitle5];
                    
                    UILabel *lblBody5 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28, 210, 28)]autorelease];
                    [lblBody5 setBackgroundColor:[UIColor clearColor]];
                    [lblBody5 setTextColor:RGB(44, 44, 44)];
                    [lblBody5 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody5 setTextAlignment:NSTextAlignmentRight];
                    [lblBody5 setText:[NSString stringWithFormat:@"%@원",[dicData objectForKey:@"신청금액"]]];
                    [self addSubview:lblBody5];
                    
                    
                    UILabel *lblTitle6 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28+28, 76-8, 28)]autorelease];
                    [lblTitle6 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle6 setTextColor:RGB(74, 74, 74)];
                    [lblTitle6 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle6 setText:@"적용금리"];
                    [self addSubview:lblTitle6];
                    
                    UILabel *lblBody6 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28+28, 210, 28)]autorelease];
                    [lblBody6 setBackgroundColor:[UIColor clearColor]];
                    [lblBody6 setTextColor:RGB(44, 44, 44)];
                    [lblBody6 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody6 setTextAlignment:NSTextAlignmentRight];
                    [lblBody6 setText:[NSString stringWithFormat:@"%@%%",[dicData objectForKey:@"적용금리"]]];
                    [self addSubview:lblBody6];
                    
                    
                    UILabel *lblTitle7 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28+28+28, 100, 28)]autorelease];
                    [lblTitle7 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle7 setTextColor:RGB(74, 74, 74)];
                    [lblTitle7 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle7 setText:@"권유직원번호"];
                    [self addSubview:lblTitle7];
                    
                    UILabel *lblBody7 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28+28+28, 210, 28)]autorelease];
                    [lblBody7 setBackgroundColor:[UIColor clearColor]];
                    [lblBody7 setTextColor:RGB(44, 44, 44)];
                    [lblBody7 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody7 setTextAlignment:NSTextAlignmentRight];
                    [lblBody7 setText:[dicData objectForKey:@"승인신청행원번호"]];
                    [self addSubview:lblBody7];
                    
                    
                    
                }
                
                else if([[dicData objectForKey:@"상품코드"] isEqualToString:@"200003401"] ||  //top회전정기
                        [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013403"] ||
                        [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013410"] ||
                        [[dicData objectForKey:@"상품코드"] isEqualToString:@"200013411"] )   //u드림 회전정기)
                {
                    
                    
                    UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 76-8, 34)]autorelease];
                    [lblTitle1 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle1 setTextColor:RGB(74, 74, 74)];
                    [lblTitle1 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle1 setText:@"적립방식"];
                    [self addSubview:lblTitle1];
                    
                    UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 210, 34)]autorelease];
                    [lblBody1 setBackgroundColor:[UIColor clearColor]];
                    [lblBody1 setTextColor:RGB(44, 44, 44)];
                    [lblBody1 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody1 setTextAlignment:NSTextAlignmentRight];
                    [lblBody1 setText:@"정기예금"];
                    [self addSubview:lblBody1];
                    
                    
                    UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28, 100, 34)]autorelease];
                    [lblTitle2 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle2 setTextColor:RGB(74, 74, 74)];
                    [lblTitle2 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle2 setText:@"이자지급방법"];
                    [self addSubview:lblTitle2];
                    
                    UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28, 210, 28)]autorelease];
                    [lblBody2 setBackgroundColor:[UIColor clearColor]];
                    [lblBody2 setTextColor:RGB(44, 44, 44)];
                    [lblBody2 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody2 setTextAlignment:NSTextAlignmentRight];
                    [lblBody2 setText:[dicData objectForKey:@"이자지급방법문구"]];
                    [self addSubview:lblBody2];
                    
                    UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28, 76-8, 28)]autorelease];
                    [lblTitle3 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle3 setTextColor:RGB(74, 74, 74)];
                    [lblTitle3 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle3 setText:@"지급주기"];
                    [self addSubview:lblTitle3];
                    
                    UILabel *lblBody3 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28, 210, 28)]autorelease];
                    [lblBody3 setBackgroundColor:[UIColor clearColor]];
                    [lblBody3 setTextColor:RGB(44, 44, 44)];
                    [lblBody3 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody3 setTextAlignment:NSTextAlignmentRight];
                    [lblBody3 setText:[NSString stringWithFormat:@"%@개월",[dicData objectForKey:@"이자지급주기"]]];
                    [self addSubview:lblBody3];
                    
                    UILabel *lblTitle4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28, 76-8, 28)]autorelease];
                    [lblTitle4 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle4 setTextColor:RGB(74, 74, 74)];
                    [lblTitle4 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle4 setText:@"회전기간"];
                    [self addSubview:lblTitle4];
                    
                    UILabel *lblBody4 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28, 210, 28)]autorelease];
                    [lblBody4 setBackgroundColor:[UIColor clearColor]];
                    [lblBody4 setTextColor:RGB(44, 44, 44)];
                    [lblBody4 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody4 setTextAlignment:NSTextAlignmentRight];
                    [lblBody4 setText:[NSString stringWithFormat:@"%@개월",[dicData objectForKey:@"회전주기"]]];
                    [self addSubview:lblBody4];
                    
                    
                    UILabel *lblTitle5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28, 76-8, 28)]autorelease];
                    [lblTitle5 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle5 setTextColor:RGB(74, 74, 74)];
                    [lblTitle5 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle5 setText:@"계약기간"];
                    [self addSubview:lblTitle5];
                    
                    UILabel *lblBody5 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28, 210, 28)]autorelease];
                    [lblBody5 setBackgroundColor:[UIColor clearColor]];
                    [lblBody5 setTextColor:RGB(44, 44, 44)];
                    [lblBody5 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody5 setTextAlignment:NSTextAlignmentRight];
                    [lblBody5 setText:[dicData objectForKey:@"가입기간문구"]];   //지수연동예금 2013.5.30 추가
                    [self addSubview:lblBody5];
                    
                    
                    UILabel *lblTitle6 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28+28, 76-8, 28)]autorelease];
                    [lblTitle6 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle6 setTextColor:RGB(74, 74, 74)];
                    [lblTitle6 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle6 setText:@"신규금액"];
                    [self addSubview:lblTitle6];
                    
                    UILabel *lblBody6 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28+28, 210, 28)]autorelease];
                    [lblBody6 setBackgroundColor:[UIColor clearColor]];
                    [lblBody6 setTextColor:RGB(44, 44, 44)];
                    [lblBody6 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody6 setTextAlignment:NSTextAlignmentRight];
                    [lblBody6 setText:[NSString stringWithFormat:@"%@원",[dicData objectForKey:@"신청금액"]]];
                    [self addSubview:lblBody6];
                    
                    
                    UILabel *lblTitle7 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28+28+28, 76-8, 28)]autorelease];
                    [lblTitle7 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle7 setTextColor:RGB(74, 74, 74)];
                    [lblTitle7 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle7 setText:@"적용금리"];
                    [self addSubview:lblTitle7];
                    
                    UILabel *lblBody7 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28+28+28, 210, 28)]autorelease];
                    [lblBody7 setBackgroundColor:[UIColor clearColor]];
                    [lblBody7 setTextColor:RGB(44, 44, 44)];
                    [lblBody7 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody7 setTextAlignment:NSTextAlignmentRight];
                    [lblBody7 setText:[NSString stringWithFormat:@"%@%%",[dicData objectForKey:@"적용금리"]]];
                    [self addSubview:lblBody7];
                    
                    UILabel *lblTitle8 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28+28+28+28+28+28, 100, 28)]autorelease];
                    [lblTitle8 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle8 setTextColor:RGB(74, 74, 74)];
                    [lblTitle8 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle8 setText:@"권유직원번호"];
                    [self addSubview:lblTitle8];
                    
                    UILabel *lblBody8 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28+28+28+28+28+28, 210, 28)]autorelease];
                    [lblBody8 setBackgroundColor:[UIColor clearColor]];
                    [lblBody8 setTextColor:RGB(44, 44, 44)];
                    [lblBody8 setFont:[UIFont systemFontOfSize:15]];
                    [lblBody8 setTextAlignment:NSTextAlignmentRight];
                    [lblBody8 setText:[dicData objectForKey:@"승인신청행원번호"]];   //지수연동예금 2013.5.30 추가
                    [self addSubview:lblBody8];
                    
                }
                
            }

            else
            {
                
                
                
                UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 76-8, 34)]autorelease];
                [lblTitle1 setBackgroundColor:[UIColor clearColor]];
                [lblTitle1 setTextColor:RGB(74, 74, 74)];
                [lblTitle1 setFont:[UIFont systemFontOfSize:15]];
                [lblTitle1 setText:@"적립방식"];
                [self addSubview:lblTitle1];
                
                UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 34)]autorelease];
                [lblBody1 setBackgroundColor:[UIColor clearColor]];
                [lblBody1 setTextColor:RGB(44, 44, 44)];
                [lblBody1 setFont:[UIFont systemFontOfSize:15]];
                [lblBody1 setTextAlignment:NSTextAlignmentRight];
                [self addSubview:lblBody1];
                
                if ([[dicData objectForKey:@"적립방식_자유적립식여부"]isEqualToString:@"1"] && ![[dicData objectForKey:@"적립방식_정기적립식여부"]isEqualToString:@"1"]) {
                    [lblBody1 setText:@"자유적립식"];
                }
                else if ([[dicData objectForKey:@"적립방식_정기적립식여부"]isEqualToString:@"1"] && ![[dicData objectForKey:@"적립방식_자유적립식여부"]   isEqualToString:@"1"]) {
                    [lblBody1 setText:@"정기적립식"];
                }
                // 정기적립식과 자유적립식 둘다 1일 경우 라디오버튼으로 구성해 선택할 수 있도록 함.
                else if ([[dicData objectForKey:@"적립방식_정기적립식여부"]isEqualToString:@"1"] && [[dicData objectForKey:@"적립방식_자유적립식여부"]isEqualToString:@"1"]) {
                    
                    [lblBody1 setHidden:YES];
                    
                    self.regViewController.marrAccumulateRadioBtns = [NSMutableArray array];
                    self.regViewController.strProductCode1 = [self.regViewController.dicSelectedData objectForKey:@"상품코드"];
                    self.regViewController.strProductCode2 = [self.regViewController.dicSelectedData objectForKey:@"자유적립식_상품코드"];
                    
                    for (int nIdx = 0; nIdx < 2; nIdx++) {
                        UIView *bgView = [[[UIView alloc]initWithFrame:CGRectMake(99+(nIdx*112), 0, 112, 34)]autorelease];
                        [self addSubview:bgView];
                        
                        UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btnRadio setFrame:CGRectMake(0, 6, 21, 21)];
                        [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                        [btnRadio addTarget:self.regViewController action:@selector(selectedAccumulateRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [bgView addSubview:btnRadio];
                        [btnRadio setTag:nIdx];
                        
                        UILabel *lblOption = [[[UILabel alloc]initWithFrame:CGRectMake(26, 0, 100, 34)]autorelease];
                        [lblOption setBackgroundColor:[UIColor clearColor]];
                        [lblOption setTextColor:RGB(44, 44, 44)];
                        [lblOption setFont:[UIFont systemFontOfSize:14]];
                        [bgView addSubview:lblOption];
                        
                        if (nIdx == 0) {
                            [btnRadio setSelected:YES];
                            [lblOption setText:@"정기적립식"];
                            [btnRadio setDataKey:@"정기적립식"];
                        }
                        else if (nIdx == 1) {
                            [lblOption setText:@"자유적립식"];
                            [btnRadio setDataKey:@"자유적립식"];
                        }
                        
                        [self.regViewController.marrAccumulateRadioBtns addObject:btnRadio];
                    }
                    
                    if (dicSmartNewData) { // 스마트신규인 경우
                        
                        if ([dicSmartNewData[@"상품코드"] isEqualToString:self.regViewController.dicSelectedData[@"자유적립식_상품코드"]]) {
                            
                            [self.regViewController.marrAccumulateRadioBtns[0] setSelected:NO];
                            [self.regViewController.marrAccumulateRadioBtns[1] setSelected:YES];
                        }
                    }
                }
                else if ([[dicData objectForKey:@"적립방식_정기예금여부"]isEqualToString:@"1"]) {
                    [lblBody1 setText:@"정기예금"];
                }
                
                CGFloat heightY = 34; // 계약기간을 2줄로 표시하는 경우 때문에 만듬
                
                if (![self.regViewController isSubscription])
                {		// 청약이 아니면 2번째라인까지 그려준다.
                    UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, heightY, 76-8, 34)]autorelease];
                    [lblTitle2 setBackgroundColor:[UIColor clearColor]];
                    [lblTitle2 setTextColor:RGB(74, 74, 74)];
                    [lblTitle2 setFont:[UIFont systemFontOfSize:15]];
                    [lblTitle2 setText:@"계약기간"];
                    [self addSubview:lblTitle2];
                    
                    if ([[dicData objectForKey:@"계약기간_고정여부"]isEqualToString:@"1"])
                    {
                        UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, heightY, 210, 34)]autorelease];
                        [lblBody2 setBackgroundColor:[UIColor clearColor]];
                        [lblBody2 setTextColor:RGB(44, 44, 44)];
                        [lblBody2 setFont:[UIFont systemFontOfSize:15]];
                        [lblBody2 setTextAlignment:NSTextAlignmentRight];
                        [self addSubview:lblBody2];
                        
                        if ([[dicData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                            [[dicData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
                        {
                            if (dicSmartNewData) { // 스마트신규인 경우
                                [lblBody2 setText:[NSString stringWithFormat:@"7년(%@개월)", dicSmartNewData[@"계약기간"]]];
                            }
                            else {
                                [lblBody2 setText:[NSString stringWithFormat:@"7년(%@개월)", [dicData objectForKey:@"계약기간_고정_기간"]]];
                            }
                        }
                        else{
                            if (dicSmartNewData) { // 스마트신규인 경우
                                [lblBody2 setText:[NSString stringWithFormat:@"%@ 개월", dicSmartNewData[@"계약기간"]]];
                            }
                            else {
                                [lblBody2 setText:[NSString stringWithFormat:@"%@ 개월", [dicData objectForKey:@"계약기간_고정_기간"]]];
                            }
                        }
                    }
                    else if ([[dicData objectForKey:@"계약기간_자유여부"]isEqualToString:@"1"])
                    {
                        
                        SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, heightY+2, 210, 30)]autorelease];
                        [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                        [tf setFont:[UIFont systemFontOfSize:15]];
                        [tf setDelegate:self.regViewController];
                        [tf setAccDelegate:self.regViewController];
                        [tf setKeyboardType:UIKeyboardTypeNumberPad];
                        [self addSubview:tf];
                        
                        self.regViewController.tfPeriod = tf;
                        
                        if (dicSmartNewData) {  // 스마트신규인 경우 계약기간을 세팅
                            [tf setText:dicSmartNewData[@"계약기간"]];
                        }
                        
                        @try {
                            [[dicData objectForKey:@"계약기간_자유_최소기간"] intValue];
                            NSString *strPlaceHolder = [NSString stringWithFormat:@"%@ ~ %@개월 이내 월 단위", [dicData objectForKey:@"계약기간_자유_최소기간"], [dicData objectForKey:@"계약기간_자유_최대기간"]];
                            [tf setPlaceholder:strPlaceHolder];
                            self.regViewController.exceptionVal = NO;
                        }
                        @catch (NSException * e) {
                            //                  NSLog(@"계약기간에 년 포함됨......");
                            self.regViewController.mini = [ [[dicData objectForKey:@"계약기간_자유_최소기간"] substringWithRange:NSMakeRange(0,[[dicData objectForKey:@"계약기간_자유_최소기간"] length]-1 ) ] intValue] * 12;
                            self.regViewController.max =  [ [[dicData objectForKey:@"계약기간_자유_최소기간"] substringWithRange:NSMakeRange(0,[[dicData objectForKey:@"계약기간_자유_최대기간"] length]-1 ) ] intValue] * 12;
                            
                            NSString *strPlaceHolder = [NSString stringWithFormat:@"%d ~ %d개월 이내 월 단위",self.regViewController.mini,self.regViewController.max];
                            [tf setPlaceholder:strPlaceHolder];
                            
                            self.regViewController.exceptionVal = YES;
                        }
                        @finally
                        {
                            
                        }
                        
                        
                    }
                    else if ([[dicData objectForKey:@"계약기간_선택여부"]isEqualToString:@"1"])
                    {
                        
                        self.regViewController.marrPeriodRadioBtns = [NSMutableArray array];
                        
                        int num;
                        
                        if ([[dicData objectForKey:@"계약기간_선택3"]isEqualToString:@"0"] ||
                            [[dicData objectForKey:@"계약기간_선택3"]isEqualToString:@""] ||
                            [dicData objectForKey:@"계약기간_선택3"] == nil)
                        {
                            num = 2;
                        }
                        else if ([[dicData objectForKey:@"계약기간_선택4"]isEqualToString:@"0"] ||
                                 [[dicData objectForKey:@"계약기간_선택4"]isEqualToString:@""] ||
                                 [dicData objectForKey:@"계약기간_선택4"] == nil)
                        {
                            num = 3;
                        }
                        else if ([[dicData objectForKey:@"계약기간_선택5"]isEqualToString:@"0"] ||
                                 [[dicData objectForKey:@"계약기간_선택5"]isEqualToString:@""] ||
                                 [dicData objectForKey:@"계약기간_선택5"] == nil)
                        {
                            num = 4;
                        }
                        else
                        {
                            num = 5;
                        }
                        
                        for (int nIdx = 0; nIdx < num; nIdx++)
                        {
                            CGFloat x = 76;
                            CGFloat width = 86;
                            
                            if (num > 3) {
                                
                                x = 8;
                                width = (320 - 16 - 3) / num;
                                
                                heightY = 34 * 2;
                            }
                            else if (num == 2) {
                                
                                x = 99;
                                width = (320 - 99 - 8) / num;
                            }
                            
                            UIView *bgView = [[[UIView alloc]initWithFrame:CGRectMake(x+(nIdx * width), heightY, width, 34)]autorelease];
                            [self addSubview:bgView];
                            
                            UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnRadio setFrame:CGRectMake(0, 6, 21, 21)];
                            [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                            [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                            [btnRadio addTarget:self.regViewController action:@selector(selectedPeriodRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                            [bgView addSubview:btnRadio];
                            [btnRadio setTag:nIdx];
                            
                            UILabel *lblOption = [[[UILabel alloc]initWithFrame:CGRectMake(26, 0, 80, 34)]autorelease];
                            [lblOption setBackgroundColor:[UIColor clearColor]];
                            [lblOption setTextColor:RGB(114, 114, 114)];
                            [lblOption setFont:[UIFont systemFontOfSize:12]];
                            [bgView addSubview:lblOption];
                            
                            
                            NSString *strKey = [NSString stringWithFormat:@"계약기간_선택%d", nIdx+1];
                            [lblOption setText:[NSString stringWithFormat:@"%@개월", [dicData objectForKey:strKey]]];
                            
                            if (dicSmartNewData) {  // 스마트신규인 경우 계약기간을 세팅
                                if ([dicData[strKey] isEqualToString:dicSmartNewData[@"계약기간"]]) {
                                    [btnRadio setSelected:YES];
                                }
                            }
                            else {
                                if (nIdx == 0)
                                {
                                    [btnRadio setSelected:YES];
                                }
                            }
                            
                            [self.regViewController.marrPeriodRadioBtns addObject:btnRadio];
                        }
                        
                        if (dicSmartNewData) {  // 스마트신규인 경우 계약기간을 세팅
                            BOOL isSelect = NO;
                            for (UIButton *btn in self.regViewController.marrPeriodRadioBtns) {
                                if ([btn isSelected]) {
                                    isSelect = YES;
                                    
                                    break;
                                }
                            }
                            
                            if (!isSelect) {
                                [self.regViewController.marrPeriodRadioBtns[0] setSelected:YES];
                            }
                        }
                    }
                }
                
                heightY += 34;
                
                if (![self.regViewController isSubscription])
                {
                    if ([[dicData objectForKey:@"회전주기_선택비트"]isEqualToString:@"136"])
                    {
                        self.regViewController.marrTurnRadioBtns = [NSMutableArray array];
                        UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, heightY, 76-8, 34)]autorelease];
                        [lblTitle3 setBackgroundColor:[UIColor clearColor]];
                        [lblTitle3 setTextColor:RGB(74, 74, 74)];
                        [lblTitle3 setFont:[UIFont systemFontOfSize:15]];
                        [lblTitle3 setText:@"회전기간"];
                        [self addSubview:lblTitle3];
                        
                        
                        int num;
                        num =3;
                        
                        
                        
                        for (int nIdx = 0; nIdx < num; nIdx++)
                        {
                            
                            UIView *bgView_1 = [[[UIView alloc]initWithFrame:CGRectMake(76+(nIdx*86), heightY, 86, 34)]autorelease];
                            [self addSubview:bgView_1];
                            
                            UIButton *btnRadio_2 = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnRadio_2 setFrame:CGRectMake(0, 6, 21, 21)];
                            [btnRadio_2 setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                            [btnRadio_2 setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                            [btnRadio_2 addTarget:self.regViewController action:@selector(selectedTurnRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                            [bgView_1 addSubview:btnRadio_2];
                            [btnRadio_2 setTag:nIdx];
                            
                            UILabel *lblOption_2 = [[[UILabel alloc]initWithFrame:CGRectMake(26, 0, 80, 34)]autorelease];
                            [lblOption_2 setBackgroundColor:[UIColor clearColor]];
                            [lblOption_2 setTextColor:RGB(114, 114, 114)];
                            [lblOption_2 setFont:[UIFont systemFontOfSize:12]];
                            [bgView_1 addSubview:lblOption_2];
                            
                            if (nIdx == 0)
                            {
                                [lblOption_2 setText:[NSString stringWithFormat:@"1개월"]];
                                
                                if (!dicSmartNewData) {
                                    
                                    [btnRadio_2 setSelected:YES];
                                }
                            }
                            
                            else if(nIdx == 1)
                            {
                                [lblOption_2 setText:[NSString stringWithFormat:@"3개월"]];
                            }
                            else if(nIdx == 2)
                            {
                                [lblOption_2 setText:[NSString stringWithFormat:@"6개월"]];
                            }
                            
                            if (dicSmartNewData) {  // 스마트신규인 경우 회전주기 세팅
                                
                                BOOL isSelect = NO;
                                
                                if ([lblOption_2.text length] > 0) {
                                    
                                    if ([[lblOption_2.text substringToIndex:1] isEqualToString:dicSmartNewData[@"회전주기"]]) {
                                        
                                        isSelect = YES;
                                        [btnRadio_2 setSelected:YES];
                                    }
                                }
                                
                                if (!isSelect) {
                                    [self.regViewController.marrTurnRadioBtns[0] setSelected:YES];
                                }
                            }
                            
                            [self.regViewController.marrTurnRadioBtns addObject:btnRadio_2];
                        }
                    }
                }
                else
                {
                    // TODO: 모두다 0일 경우의 예외처리
                    
                }
            }
            
		}
        
        
        
        else if ([viewController isKindOfClass:[SHB_GoldTech_InputViewcontroller class]]) {	// 골드상품 입력화면
			self.gold_inputViewController = (SHB_GoldTech_InputViewcontroller *)viewController;
            NSDictionary *dicData = self.gold_inputViewController.dicSelectedData;
            

            
            if ([[dicData objectForKey:@"상품코드"] isEqualToString:@"187000101"])   // 골드테크
            {
            UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 76-8, 34)]autorelease];
            [lblTitle1 setBackgroundColor:[UIColor clearColor]];
            [lblTitle1 setTextColor:RGB(74, 74, 74)];
            [lblTitle1 setFont:[UIFont systemFontOfSize:15]];
            [lblTitle1 setText:@"상품명"];
            [self addSubview:lblTitle1];
            
            UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 210, 34)]autorelease];
            [lblBody1 setBackgroundColor:[UIColor clearColor]];
            [lblBody1 setTextColor:RGB(44, 44, 44)];
            [lblBody1 setFont:[UIFont systemFontOfSize:15]];
            [lblBody1 setTextAlignment:NSTextAlignmentRight];
            [lblBody1 setText:[dicData objectForKey:@"상품명"]];
            [self addSubview:lblBody1];
            
            
            UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28, 100, 34)]autorelease];
            [lblTitle2 setBackgroundColor:[UIColor clearColor]];
            [lblTitle2 setTextColor:RGB(74, 74, 74)];
            [lblTitle2 setFont:[UIFont systemFontOfSize:15]];
            [lblTitle2 setText:@"위험등급"];
            [self addSubview:lblTitle2];
            
            UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28, 210, 28)]autorelease];
            [lblBody2 setBackgroundColor:[UIColor clearColor]];
            [lblBody2 setTextColor:RGB(44, 44, 44)];
            [lblBody2 setFont:[UIFont systemFontOfSize:15]];
            [lblBody2 setTextAlignment:NSTextAlignmentRight];
            [lblBody2 setText:[dicData objectForKey:@"_위험등급"]];
            [self addSubview:lblBody2];
            
            UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28+28, 100, 28)]autorelease];
            [lblTitle3 setBackgroundColor:[UIColor clearColor]];
            [lblTitle3 setTextColor:RGB(74, 74, 74)];
            [lblTitle3 setFont:[UIFont systemFontOfSize:15]];
            [lblTitle3 setText:@"고객투자성향"];
            [self addSubview:lblTitle3];
            
            UILabel *lblBody3 = [[[UILabel alloc]initWithFrame:CGRectMake(100, 28+28, 210, 28)]autorelease];
            [lblBody3 setBackgroundColor:[UIColor clearColor]];
            [lblBody3 setTextColor:RGB(44, 44, 44)];
            [lblBody3 setFont:[UIFont systemFontOfSize:15]];
            [lblBody3 setTextAlignment:NSTextAlignmentRight];
            [lblBody3 setText:[dicData objectForKey:@"_고객투자성향"]];
            [self addSubview:lblBody3];
            
            
            }

        }
        
        
        else if ([viewController isKindOfClass:[SHBELD_BA17_12_inputViewcontroller class]]) {	// 상품가입 입력화면
			self.eld_inputViewController = (SHBELD_BA17_12_inputViewcontroller *)viewController;
            NSDictionary *dicData = self.eld_inputViewController.dicSelectedData;
            
            
            UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 76-8, 34)]autorelease];
			[lblTitle1 setBackgroundColor:[UIColor clearColor]];
			[lblTitle1 setTextColor:RGB(74, 74, 74)];
			[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
			[lblTitle1 setText:@"적립방식"];
			[self addSubview:lblTitle1];
			
			UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 34)]autorelease];
			[lblBody1 setBackgroundColor:[UIColor clearColor]];
			[lblBody1 setTextColor:RGB(44, 44, 44)];
			[lblBody1 setFont:[UIFont systemFontOfSize:15]];
			[lblBody1 setTextAlignment:NSTextAlignmentRight];
            [lblBody1 setText:@"지수연동예금"];   //지수연동예금 2013.5.30 추가
			[self addSubview:lblBody1];
            
            
            UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 34, 76-8, 34)]autorelease];
            [lblTitle3 setBackgroundColor:[UIColor clearColor]];
            [lblTitle3 setTextColor:RGB(74, 74, 74)];
            [lblTitle3 setFont:[UIFont systemFontOfSize:15]];
            [lblTitle3 setText:@"예금시작일"];
            [self addSubview:lblTitle3];
            
            UILabel *lblBody3 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3+34, 34, 210, 34)]autorelease];
            [lblBody3 setBackgroundColor:[UIColor clearColor]];
            [lblBody3 setTextColor:RGB(44, 44, 44)];
            [lblBody3 setFont:[UIFont systemFontOfSize:15]];
            [lblBody3 setTextAlignment:NSTextAlignmentRight];
            [lblBody3 setText:[NSString stringWithFormat:@"%@ 개월", [dicData objectForKey:@"예금시작일자"]]];   //지수연동예금 2013.5.30 추가
            [self addSubview:lblBody3];
            
            UILabel *lblTitle4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 34+34, 76-8, 34)]autorelease];
            [lblTitle4 setBackgroundColor:[UIColor clearColor]];
            [lblTitle4 setTextColor:RGB(74, 74, 74)];
            [lblTitle4 setFont:[UIFont systemFontOfSize:15]];
            [lblTitle4 setText:@"예금만기일"];
            [self addSubview:lblTitle4];
            
            UILabel *lblBody4 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3+34, 34+34, 210, 34)]autorelease];
            [lblBody4 setBackgroundColor:[UIColor clearColor]];
            [lblBody4 setTextColor:RGB(44, 44, 44)];
            [lblBody4 setFont:[UIFont systemFontOfSize:15]];
            [lblBody4 setTextAlignment:NSTextAlignmentRight];
            [lblBody4 setText:[NSString stringWithFormat:@"%@ 개월", [dicData objectForKey:@"예금만기일자"]]];   //지수연동예금 2013.5.30 추가
            [self addSubview:lblBody4];
            
            
        }
        
        
        
        else if ([viewController isKindOfClass:[SHBELD_BA17_13_TaxBreakViewController class]]) {	// 세금우대 입력화면
			self.eld_taxBreakViewController = (SHBELD_BA17_13_TaxBreakViewController *)viewController;
			
			UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 160/*122-8*/, 34)]autorelease];
			[lblTitle1 setBackgroundColor:[UIColor clearColor]];
			[lblTitle1 setTextColor:RGB(74, 74, 74)];
			[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
			[lblTitle1 setText:@"세금우대가입총액"];
			[self addSubview:lblTitle1];
			self.eld_taxBreakViewController.lblTopRow1Title = lblTitle1;
			
			UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 34, 160/*122-8*/, 34)]autorelease];
			[lblTitle2 setBackgroundColor:[UIColor clearColor]];
			[lblTitle2 setTextColor:RGB(74, 74, 74)];
			[lblTitle2 setFont:[UIFont systemFontOfSize:15]];
			[lblTitle2 setText:@"세금우대한도잔여"];
			[self addSubview:lblTitle2];
			self.eld_taxBreakViewController.lblTopRow2Title = lblTitle2;
			
			UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 34)]autorelease];
			[lblBody1 setBackgroundColor:[UIColor clearColor]];
			[lblBody1 setTextColor:RGB(44, 44, 44)];
			[lblBody1 setFont:[UIFont systemFontOfSize:15]];
			[lblBody1 setText:@"0원"];
			[lblBody1 setTextAlignment:NSTextAlignmentRight];
			[self addSubview:lblBody1];
			self.eld_taxBreakViewController.lblTopRow1Value = lblBody1;
			
			UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 34, 210, 34)]autorelease];
			[lblBody2 setBackgroundColor:[UIColor clearColor]];
			[lblBody2 setTextColor:RGB(44, 44, 44)];
			[lblBody2 setFont:[UIFont systemFontOfSize:15]];
			[lblBody2 setText:@"0원"];
			[lblBody2 setTextAlignment:NSTextAlignmentRight];
			[self addSubview:lblBody2];
			self.eld_taxBreakViewController.lblTopRow2Value = lblBody2;
			
			if (self.eld_taxBreakViewController.D4220) {
				[lblBody1 setText:[NSString stringWithFormat:@"%@원", [self.eld_taxBreakViewController.D4220 objectForKey:@"세금우대가입총액"]]];
				[lblBody2 setText:[NSString stringWithFormat:@"%@원", [self.eld_taxBreakViewController.D4220 objectForKey:@"세금우대한도잔액"]]];
			}
		}
        
        
		else if ([viewController isKindOfClass:[SHBNewProductTaxBreakViewController class]]) {	// 세금우대 입력화면
			self.taxBreakViewController = (SHBNewProductTaxBreakViewController *)viewController;
			
			UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 160/*122-8*/, 34)]autorelease];
			[lblTitle1 setBackgroundColor:[UIColor clearColor]];
			[lblTitle1 setTextColor:RGB(74, 74, 74)];
			[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
			[lblTitle1 setText:@"세금우대가입총액"];
			[self addSubview:lblTitle1];
			self.taxBreakViewController.lblTopRow1Title = lblTitle1;
			
			UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 34, 160/*122-8*/, 34)]autorelease];
			[lblTitle2 setBackgroundColor:[UIColor clearColor]];
			[lblTitle2 setTextColor:RGB(74, 74, 74)];
			[lblTitle2 setFont:[UIFont systemFontOfSize:15]];
			[lblTitle2 setText:@"세금우대한도잔여"];
			[self addSubview:lblTitle2];
			self.taxBreakViewController.lblTopRow2Title = lblTitle2;
			
			UILabel *lblBody1 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 34)]autorelease];
			[lblBody1 setBackgroundColor:[UIColor clearColor]];
			[lblBody1 setTextColor:RGB(44, 44, 44)];
			[lblBody1 setFont:[UIFont systemFontOfSize:15]];
			[lblBody1 setText:@"0원"];
			[lblBody1 setTextAlignment:NSTextAlignmentRight];
			[self addSubview:lblBody1];
			self.taxBreakViewController.lblTopRow1Value = lblBody1;
			
			UILabel *lblBody2 = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 34, 210, 34)]autorelease];
			[lblBody2 setBackgroundColor:[UIColor clearColor]];
			[lblBody2 setTextColor:RGB(44, 44, 44)];
			[lblBody2 setFont:[UIFont systemFontOfSize:15]];
			[lblBody2 setText:@"0원"];
			[lblBody2 setTextAlignment:NSTextAlignmentRight];
			[self addSubview:lblBody2];
			self.taxBreakViewController.lblTopRow2Value = lblBody2;
			
			if (self.taxBreakViewController.D4220) {
				[lblBody1 setText:[NSString stringWithFormat:@"%@원", [self.taxBreakViewController.D4220 objectForKey:@"세금우대가입총액"]]];
				[lblBody2 setText:[NSString stringWithFormat:@"%@원", [self.taxBreakViewController.D4220 objectForKey:@"세금우대한도잔액"]]];
			}
		}
    }
	
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 209/255.0, 209/255.0, 209/255.0, 1);
	CGContextSetLineWidth(context, 1);
	
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, 320, 0);
	CGContextStrokePath(context);
	
    //	if (self.regViewController) {
    //		if ([self.regViewController isSubscription]) {
    //			CGContextMoveToPoint(context, 0, 34);
    //			CGContextAddLineToPoint(context, 320, 34);
    //			CGContextStrokePath(context);
    //		}
    //		else
    //		{
    //			CGContextMoveToPoint(context, 0, 34*2);
    //			CGContextAddLineToPoint(context, 320, 34*2);
    //			CGContextStrokePath(context);
    //		}
    //	}
    //	else
    //	{
    //		CGContextMoveToPoint(context, 0, 34*2);
    //		CGContextAddLineToPoint(context, 320, 34*2);
    //		CGContextStrokePath(context);
    //	}
	
	CGContextMoveToPoint(context, 0, self.frame.size.height);
	CGContextAddLineToPoint(context, 320, self.frame.size.height);
	CGContextStrokePath(context);
}


@end
