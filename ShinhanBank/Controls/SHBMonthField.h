//
//  SHBMonthField.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBPicker.h"

@protocol SHBMonthFieldDelegate;

@interface SHBMonthField : UIView <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
	id<SHBMonthFieldDelegate>	_delegate;
    UITextField*			_textField;
	UITextField*			_dummyField;
	UIToolbar*				_pickerToolbar;
    UIView*                 _bgView;
	
	BOOL					_history;
	BOOL					_editable;
	BOOL					_enabled;
	
	UIView			*_pickerView;
	UIPickerView	*_monthPicker;
	NSMutableArray	*pickerViewYearArray;
	NSMutableArray	*pickerViewMonthArray;
	
	int intYear;
	int intMonth;
	
	BOOL	isDropDownStyle;
}

@property (assign  ,nonatomic) id<SHBMonthFieldDelegate>	delegate;
@property (readonly,nonatomic) UITextField*				textField;

@property (         nonatomic) BOOL						editable;
@property (         nonatomic) BOOL						enabled;
@property (         nonatomic) BOOL						history;

@property(nonatomic,retain) NSMutableArray* pickerViewYearArray;
@property(nonatomic,retain) NSMutableArray* pickerViewMonthArray;

- (NSInteger)indexOfYear:(NSString*)title;
- (NSInteger)indexOfMonth:(NSString*)title;

+ (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation enabled:(BOOL)enabled;

+ (void)setHistoryToolBarDoneImage:(NSString*)imageName;
+ (void)setHistoryToolBarCancelImage:(NSString*)imageName;

- (void)initFrame:(CGRect)frame;

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next;
- (void)toggle;
- (void)show;
- (void)hide;
- (void)setMaximumYear:(int)maxYear;
- (void)unselection;
- (void)setDate:(NSDate *)date;
- (void)selectDate:(NSDate*)date;
- (void)selectDate:(NSDate*)date animated:(BOOL)animated;
- (void)dropDownStyle:(BOOL)flag;

@end

@protocol SHBMonthFieldDelegate <NSObject>

@optional

- (void)monthField:(SHBMonthField*)monthField didConfirmWithMonth:(NSString*)month;
- (void)currentMonthField:(SHBMonthField*)monthField;					// 현재픽커

@end