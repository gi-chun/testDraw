//
//  SHBPeriodPopupView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPeriodPopupView.h"

@implementation SHBPeriodPopupView

#pragma mark - Initialize
- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height{
	[super initWithTitle:aTitle SubViewHeight:height];
	
	// 설정버튼
	UIButton	*settingButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 104, 4, 45, 29)];
    if (UIAccessibilityIsVoiceOverRunning())
    {
        [settingButton setFrame:CGRectMake(settingButton.frame.origin.x - 4, settingButton.frame.origin.y, settingButton.frame.size.width, settingButton.frame.size.height)];
    }
	settingButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	[settingButton setTitle:@"조회" forState:UIControlStateNormal];
	[settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[settingButton setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateNormal];
	[settingButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	
	UIView *popView = (UIView*)[self viewWithTag:8888];
	popView.frame = CGRectMake(popView.frame.origin.x, popView.frame.origin.y - 100, popView.frame.size.width, popView.frame.size.height);
	[popView addSubview:settingButton];
	
	UILabel *frLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 20)];
	frLabel.text = @"조회시작일";
	frLabel.font = [UIFont systemFontOfSize:14];
	frLabel.textColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
	frLabel.backgroundColor = [UIColor clearColor];
	frLabel.textAlignment = UITextAlignmentCenter;
    [frLabel setIsAccessibilityElement:NO];
    
	UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 110, 20)];
	toLabel.text = @"조회종료일";
	toLabel.font = [UIFont systemFontOfSize:14];
	toLabel.textColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
	toLabel.backgroundColor = [UIColor clearColor];
	toLabel.textAlignment = UITextAlignmentCenter;
    [toLabel setIsAccessibilityElement:NO];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 15, 30)];
	label.text = @"~";
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:14];
	label.textColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
	label.backgroundColor = [UIColor clearColor];
	[label setIsAccessibilityElement:NO];
    
	// SHBDateField Initialize
	frDateField = [[SHBDateField alloc] initWithFrame:CGRectMake(5, 30, 110, 30)];
	frDateField.textField.font = [UIFont fontWithName:@"Helvetica" size:15];
    frDateField.textField.textAlignment = UITextAlignmentCenter;
    frDateField.delegate = self;
    [frDateField selectDate:[NSDate date] animated:NO];
    NSLog(@"frDateField:%@",frDateField.accessibilityLabel);
    frDateField.textField.accessibilityLabel = [NSString stringWithFormat:@"조회시작일 선택"];
    [frDateField setIsAccessibilityElement:NO];
    
	toDateField = [[SHBDateField alloc] initWithFrame:CGRectMake(140, 30, 110, 30)];
	toDateField.textField.font = [UIFont fontWithName:@"Helvetica" size:15];
    toDateField.textField.textAlignment = UITextAlignmentCenter;
    toDateField.delegate = self;
    [toDateField selectDate:[NSDate date] animated:NO];
    [toDateField setIsAccessibilityElement:NO];
    NSLog(@"toDateField:%@",toDateField.accessibilityLabel);
    toDateField.textField.accessibilityLabel = [NSString stringWithFormat:@"조회종료일 선택"];
	
	// SHBMonthField Initialize
	frMonthField = [[SHBMonthField alloc] initWithFrame:CGRectMake(5, 30, 90, 30)];
	frMonthField.textField.font = [UIFont fontWithName:@"Helvetica" size:15];
    frMonthField.textField.textAlignment = UITextAlignmentCenter;
    frMonthField.delegate = self;
    [frMonthField selectDate:[NSDate date] animated:NO];
    frMonthField.textField.accessibilityLabel = [NSString stringWithFormat:@"조회시작월 선택"];
    [frMonthField setIsAccessibilityElement:YES];
    
	toMonthField = [[SHBMonthField alloc] initWithFrame:CGRectMake(140, 30, 90, 30)];
	toMonthField.textField.font = [UIFont fontWithName:@"Helvetica" size:15];
    toMonthField.textField.textAlignment = UITextAlignmentCenter;
    toMonthField.delegate = self;
    [toMonthField selectDate:[NSDate date] animated:NO];
    toMonthField.textField.accessibilityLabel = [NSString stringWithFormat:@"조회종료월 선택"];
    [toMonthField setIsAccessibilityElement:YES];
    
	// AddView to MainView
	[mainView addSubview:frLabel];
	[mainView addSubview:toLabel];
	[mainView addSubview:label];
	[mainView addSubview:frDateField];
	[mainView addSubview:toDateField];
	[mainView addSubview:frMonthField];
	[mainView addSubview:toMonthField];
	
	[frLabel release];
	[toLabel release];
	[label release];
	
	
	periodDic = [[NSMutableDictionary alloc] initWithCapacity:0];
	
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
	return self;
}
- (void)logoutClose
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self fadeOut];
}

- (void)dealloc{
	[frDateField release];
	[toDateField release];
	[frMonthField release];
	[toMonthField release];
	[periodDic release];
	
	[super dealloc];
}

#pragma mark - IBAction & Method
- (void)settingButtonPressed:(UIButton*)sender{
	// Picker가 보여져 있는 상태면 리턴
	if (frDateField.history || toDateField.history || frMonthField.history || toMonthField.history) return;
	
	int frDate = [[periodDic objectForKey:@"from"] intValue];
	int toDate = [[periodDic objectForKey:@"to"] intValue];
	if (frDate > toDate){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"'조회종료일'이 '조회시작일'보다 빠를 수 없습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return;
	}
	
	// tell the delegate the selection
	if (self.delegate && [self.delegate respondsToSelector:@selector(popupView:didSelectedData:)]) {
		[self.delegate popupView:self didSelectedData:periodDic];
	}
	
	[self fadeOut];
}

- (void)periodModeForDate:(BOOL)flag{
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	
	if (flag){
		[formatter setDateFormat:@"yyyyMMdd"];
		[periodDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"from"];
		[periodDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"to"];
		frMonthField.hidden = YES;
		toMonthField.hidden = YES;
	}else{
		[formatter setDateFormat:@"yyyyMM"];
		[periodDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"from"];
		[periodDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"to"];
		frDateField.hidden = YES;
		toDateField.hidden = YES;
	}
    
    [formatter release];
}

- (void)setMaxDate:(NSDate*)date{
	[frDateField setmaximumDate:date];
	[toDateField setmaximumDate:date];
}

- (void)setMinDate:(NSDate*)date{
	[frDateField setminimumDate:date];
	[toDateField setminimumDate:date];
}

- (void)setDefaultFrDate:(NSDate*)date{
	[frDateField setDate:date];
}

- (void)setDefaultToDate:(NSDate*)date{
	[toDateField setDate:date];
}


- (void)closePopupViewWithButton:(UIButton*)sender{
	
	// Picker가 보여져 있는 상태면 리턴
	if (frDateField.history || toDateField.history || frMonthField.history || toMonthField.history) return;
	
	[super closePopupViewWithButton:sender];
}


#pragma mark - Delegate : SHBDateFieldDelegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date{
	NSLog(@"=====>>>>>>> [10] DatePicker 완료버튼 터치시 ");
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyyMMdd"];
	
	if (dateField == frDateField){
		[periodDic setObject:[formatter stringFromDate:date] forKey:@"from"];
	}else if (dateField == toDateField){
		[periodDic setObject:[formatter stringFromDate:date] forKey:@"to"];
	}
	
	[formatter release];
}


#pragma mark - Delegate : SHBMonthFieldDelegate
- (void)monthField:(SHBMonthField*)monthField didConfirmWithMonth:(NSString*)month{
	NSLog(@"=====>>>>>>> [10] MonthPicker 완료버튼 터치시 : [%@]",month);
	if (monthField == frMonthField){
		[periodDic setObject:month forKey:@"from"];
	}else if (monthField == toMonthField){
		[periodDic setObject:month forKey:@"to"];
	}
}

@end
