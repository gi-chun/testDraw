//
//  SHBDateField.h
//
//  Created by ZZooN on 11. 3. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBPicker.h"

@protocol SHBDateFieldDelegate;

@interface SHBDateField : UIView <UITextFieldDelegate> {
	id<SHBDateFieldDelegate>	_delegate;
    //UITextField*			_textField;
    SHBTextField*			_textField;
    //UITextField*			_dummyField;
    SHBTextField*			_dummyField;
	UIButton*				_backButton;
	UIView*					_pickerView;
	UIDatePicker*			_datePicker;
	UIToolbar*				_pickerToolbar;
    UIView*                 _bgView;
	
	BOOL					_history;
	BOOL					_editable;
	BOOL					_enabled;
	
	NSDateFormatter*		_dateFormatter;
	NSDate*					_date;
	NSString*				_format;
	
	BOOL	isDropDownStyle;
}

@property (assign  ,nonatomic) id<SHBDateFieldDelegate>	delegate;
@property (readonly,nonatomic) UITextField*				textField;

@property (         nonatomic) BOOL						editable;
@property (         nonatomic) BOOL						enabled;
@property (         nonatomic) BOOL						history;
@property (retain  ,nonatomic) NSDate*					date;
@property (retain  ,nonatomic) NSString*				format;
@property (         nonatomic) UIDatePickerMode			pickerMode;

+ (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation enabled:(BOOL)enabled;

+ (void)setHistoryToolBarDoneImage:(NSString*)imageName;
+ (void)setHistoryToolBarCancelImage:(NSString*)imageName;

- (void)initFrame:(CGRect)frame;

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next;
- (void)toggle;
- (void)show;
- (void)hide;

- (void)unselection;

- (void)selectDate:(NSDate*)date;
- (void)setmaximumDate:(NSDate*)date;
- (void)setminimumDate:(NSDate*)date;
- (void)setminuteInterval:(NSInteger) minuteInterval;

- (void)selectDate:(NSDate*)date animated:(BOOL)animated;
- (void)dropDownStyle:(BOOL)flag;
- (void)setButtonStyle:(NSString*)btnTitle;


@end

@protocol SHBDateFieldDelegate <NSObject>

@optional

- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date;
- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date;
- (void)currentDateField:(SHBDateField*)dateField;					// 현재픽커

@end