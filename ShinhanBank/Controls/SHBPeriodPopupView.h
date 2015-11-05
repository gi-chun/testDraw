//
//  SHBPeriodPopupView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPopupView.h"
#import "SHBDateField.h"
#import "SHBMonthField.h"

@interface SHBPeriodPopupView : SHBPopupView <SHBDateFieldDelegate, SHBMonthFieldDelegate>
{
	SHBDateField	*frDateField;
	SHBDateField	*toDateField;
	
	SHBMonthField	*frMonthField;
	SHBMonthField	*toMonthField;
	
	NSMutableDictionary *periodDic;
}

- (void)settingButtonPressed:(UIButton*)sender;
- (void)periodModeForDate:(BOOL)flag;
- (void)setMaxDate:(NSDate*)date;
- (void)setMinDate:(NSDate*)date;
- (void)setDefaultFrDate:(NSDate*)date;
- (void)setDefaultToDate:(NSDate*)date;

@end
