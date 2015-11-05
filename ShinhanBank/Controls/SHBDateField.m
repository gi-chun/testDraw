//
//  SHBDateField.m
//
//  Created by ZZooN on 11. 3. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SHBDateField.h"
#import "SHBTextField.h"

#define _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT	216.0f
#define _SHBDATEFIELD_PICKER_LANDSCAPE_HEIGHT	180.0f
#define _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT		 40.0f

#define _TAG_SHBDATEFIELD_PICKER_DONE_BUTTON		0xf002

static NSString*			SHBDateFieldToolBarDoneImage	= nil;
static NSString*			SHBDateFieldToolBarCancelImage	= nil;
static NSMutableDictionary*	SHBDateFieldEnabledInterfaceOrientation	= nil;

@interface SHBDateField (Private)

- (void)selectionProcessingWithDate:(NSDate*)date action:(BOOL)action;

@end

@implementation SHBDateField

@synthesize delegate		= _delegate;
@synthesize textField		= _textField;
@synthesize editable		= _editable;
@synthesize enabled			= _enabled;
@synthesize date			= _date;
@synthesize format			= _format;
@synthesize history			= _history;

#pragma mark -

+ (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation enabled:(BOOL)enabled {
	if( SHBDateFieldEnabledInterfaceOrientation == nil ) {
		SHBDateFieldEnabledInterfaceOrientation = [[NSMutableDictionary alloc] init];
		[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:YES] forKey:@"UIInterfaceOrientationPortrait"];
		[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:YES] forKey:@"UIInterfaceOrientationPortraitUpsideDown"];
		[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:YES] forKey:@"UIInterfaceOrientationLandscapeLeft"];
		[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:YES] forKey:@"UIInterfaceOrientationLandscapeRight"];
	}
	
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortrait          	: {
			[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:enabled] forKey:@"UIInterfaceOrientationPortrait"];
		}break;
			
		case UIInterfaceOrientationPortraitUpsideDown	: {
			[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:enabled] forKey:@"UIInterfaceOrientationPortraitUpsideDown"];
		}break;
			
		case UIInterfaceOrientationLandscapeLeft     	: {
			[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:enabled] forKey:@"UIInterfaceOrientationLandscapeLeft"];
		}break;
			
		case UIInterfaceOrientationLandscapeRight    	: {
			[SHBDateFieldEnabledInterfaceOrientation setObject:[NSNumber numberWithBool:enabled] forKey:@"UIInterfaceOrientationLandscapeRight"];
		}break;
	}
}

+ (void)setHistoryToolBarDoneImage:(NSString*)imageName {
	[SHBDateFieldToolBarDoneImage release];
	SHBDateFieldToolBarDoneImage = [imageName retain];
}

+ (void)setHistoryToolBarCancelImage:(NSString*)imageName {
	[SHBDateFieldToolBarCancelImage release];
	SHBDateFieldToolBarCancelImage = [imageName retain];
}

- (id)initWithFrame:(CGRect)frame {
    if ( ( self = [super initWithFrame:frame] ) ) {
		[self initFrame:frame];
    }
    return self;
}

- (void)dealloc {
	[_pickerView removeFromSuperview];
	
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_dummyField release];
	[_textField			release];
	[_backButton		release];
	[_pickerView		release];
	[_datePicker		release];
	[_pickerToolbar		release];
    
	[_dateFormatter		release];
	[_date				release];
	[_format			release];
	
    [super dealloc];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	//_textField.frame		= CGRectMake(5.0f, 0.0f, self.frame.size.width - 10.0f, self.frame.size.height);
}

- (void)initFrame:(CGRect)frame
{
    _editable	= NO;
    _enabled	= YES;
    _history	= NO;
    isDropDownStyle = NO;
    
    //if (!UIAccessibilityIsVoiceOverRunning())
    //{
    self.format	= @"yyyy.MM.dd";
    //}
    
    //[self setIsAccessibilityElement:NO];
    float viewHeight;
    if (AppInfo.isiPhoneFive)
        viewHeight = 548;
    else
        viewHeight = 460;
    
    
    //_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    _textField = [[SHBTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    [_textField setBorderStyle:UITextBorderStyleNone];
    _textField.placeholder              = @"";
    _textField.autocorrectionType       = UITextAutocorrectionTypeNo;
    _textField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.returnKeyType            = UIReturnKeyDefault;
    _textField.delegate                 = self;
    _textField.keyboardType             = UIKeyboardTypeDefault;
    _textField.textAlignment			= UITextAlignmentCenter;
    _textField.background               = [[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    _textField.disabledBackground       = [[UIImage imageNamed:@"textfeld_dim.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    //UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)] autorelease];
    //_textField.leftView = paddingView;
    //_textField.leftViewMode = UITextFieldViewModeAlways;
    //[paddingView setIsAccessibilityElement:NO];
    
    [self addSubview:_textField];
    //[_textField setIsAccessibilityElement:NO];
    
    // 버튼모양 생성
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    [_backButton setHidden:YES];
    [_backButton setBackgroundImage:[[UIImage imageNamed:@"btn_ctype3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    //[_backButton setIsAccessibilityElement:NO];
    
    float totalHeight = ( _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
    _pickerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, viewHeight, 320.0f, viewHeight )];
    
    _bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width, _pickerView.frame.size.height)] autorelease];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [_bgView setAlpha:0.5];
    [_pickerView addSubview:_bgView];
    
    _datePicker	= [[UIDatePicker alloc] initWithFrame:CGRectMake( 0.0f, viewHeight - totalHeight + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT, 320.0f, _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT )];
    
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:withEvent:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //ios7 + xcode5 대응
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    [_pickerView addSubview:_datePicker];
    
    _pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, viewHeight - totalHeight, _pickerView.frame.size.width, _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT)];
    _pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [_pickerView addSubview:_pickerToolbar];
    
    // 셋팅(설정)버튼 생성
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 5, 50, 29)];
    completeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [completeButton setTitle:@"확인" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setTag:30];
    completeButton.accessibilityHint = @"데이트피커입니다. 편집하시려면 초점을 이동 하십시요";
    //[completeButton setIsAccessibilityElement:NO];
    
    // Image with without cap insets
    [completeButton setBackgroundImage:[[UIImage imageNamed:@"btn_ctype3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    
    [completeButton addTarget:self action:@selector(toolbarItemWasTouchUpInside:) forControlEvents: UIControlEventTouchUpInside];
    
    [_pickerToolbar addSubview:completeButton];
    
    [completeButton release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillShowWithNotification:)
                                                 name:SHBPickerWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeWithNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
}
- (void)logoutClose
{
    [self hide];
}

- (void)setEnabled:(BOOL)enabled {
	_enabled = enabled;
	_textField.enabled = _enabled;
	
}

- (void)setDate:(NSDate *)date {
    if (date) {
        _datePicker.date = date;
        [self selectionProcessingWithDate:_datePicker.date action:NO];
    }
}

- (void)setFormat:(NSString *)format {
	[_format release];
	_format = [format retain];
	
	[_dateFormatter	release];
	_dateFormatter = nil;
	
	if( _format != nil ) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateFormat:_format];
	}
}

- (UIDatePickerMode)pickerMode {
	return _datePicker.datePickerMode;
}

- (void)setPickerMode:(UIDatePickerMode)pickerMode {
	_datePicker.datePickerMode = pickerMode;
}

- (void)setmaximumDate:(NSDate *) date {
    
	_datePicker.maximumDate = date;
    
}
- (void)setminimumDate:(NSDate *) date {
	_datePicker.minimumDate = date;
    
}

- (void)setminuteInterval:(NSInteger) minuteInterval{
    _datePicker.minuteInterval = minuteInterval;
    
}

- (UIView*)frontView {
	return [self.window.subviews lastObject];
}

- (void)keyboardWillShowWithNotification:(NSNotification*)notification {
	if( _pickerView.superview != nil ) [self hide];
}

- (void)pickerWillShowWithNotification:(NSNotification*)notification {
	if( [notification object] != self ) {
		if( _pickerView.superview != nil ) [self hide];
	}
}

- (void)deviceOrientationDidChangeWithNotification:(NSNotification *)notification {
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait          	: {
			if( ![[SHBDateFieldEnabledInterfaceOrientation objectForKey:@"UIInterfaceOrientationPortrait"] boolValue] ) return;
		}break;
			
		case UIInterfaceOrientationPortraitUpsideDown	: {
			if( ![[SHBDateFieldEnabledInterfaceOrientation objectForKey:@"UIInterfaceOrientationPortraitUpsideDown"] boolValue] ) return;
		}break;
			
		case UIInterfaceOrientationLandscapeLeft     	: {
			if( ![[SHBDateFieldEnabledInterfaceOrientation objectForKey:@"UIInterfaceOrientationLandscapeLeft"] boolValue] ) return;
		}break;
			
		case UIInterfaceOrientationLandscapeRight    	: {
			if( ![[SHBDateFieldEnabledInterfaceOrientation objectForKey:@"UIInterfaceOrientationLandscapeRight"] boolValue] ) return;
		}break;
	}
	
	CGRect rect;
	float viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 568;
	else
		viewHeight = 480;
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait				:
		case UIInterfaceOrientationPortraitUpsideDown	: {
			float totalHeight = ( _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
			
			if( _history ) rect = CGRectMake(   0, viewHeight - totalHeight, 320, totalHeight );
			else		   rect = CGRectMake(   0, 				 viewHeight, 320, totalHeight );
		}break;
			
		case UIInterfaceOrientationLandscapeLeft		:
		case UIInterfaceOrientationLandscapeRight		: {
			float totalHeight = ( _SHBDATEFIELD_PICKER_LANDSCAPE_HEIGHT + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
			
			if( _history ) rect = CGRectMake(   0, 320 - totalHeight, viewHeight, totalHeight );
			else		   rect = CGRectMake(   0, 				 320, viewHeight, totalHeight );
		}break;
	}
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait				:
		case UIInterfaceOrientationPortraitUpsideDown	:
		case UIInterfaceOrientationLandscapeLeft		:
		case UIInterfaceOrientationLandscapeRight		: {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationStop)];
			
			_pickerView.frame		= rect;
			_pickerToolbar.frame	= CGRectMake( 0, 0, rect.size.width, _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
			_datePicker.frame		= CGRectMake( 0, _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT, rect.size.width, rect.size.height - _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
			
			[UIView commitAnimations];
		}break;
	}
}

- (void)dropDownStyle:(BOOL)flag{
	isDropDownStyle = flag;
	if (flag){
		_textField.background = [[UIImage imageNamed:@"selectbox2_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
		_textField.disabledBackground = [[UIImage imageNamed:@"selectbox2_dim.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}else{
		_textField.background = [[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
		_textField.disabledBackground = [[UIImage imageNamed:@"textfeld_dim.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}
	
}

- (void)setButtonStyle:(NSString*)btnTitle{
	_backButton.hidden = NO;
	_textField.hidden = YES;
	_backButton.titleLabel.font = _textField.font;
	[_backButton setTitleColor:_textField.textColor forState:UIControlStateNormal];
	[_backButton setTitle:btnTitle forState:UIControlStateNormal];
    
}

- (void)backButtonPressed{
	[self toggle];
}

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next{
	UIButton *prevButton = (UIButton*)[_pickerToolbar viewWithTag:10];
	UIButton *nextButton = (UIButton*)[_pickerToolbar viewWithTag:20];
	[prevButton setEnabled:prev];
	[nextButton setEnabled:next];
}

- (void)toggle {
	if( _history ) [self hide];
	else		   [self show];
}

- (void)show {
	_history = YES;
	
    
    
	if (isDropDownStyle){
		_textField.background = [[UIImage imageNamed:@"selectbox2_focus.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}else{
		_textField.background = [[UIImage imageNamed:@"textfeld_focus.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}
	
	UIInterfaceOrientation	orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGRect					rect		= CGRectZero;
	
	float viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 568;
	else
		viewHeight = 480;
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait				: rect = CGRectMake(   0, 0, 320, viewHeight ); break;
		case UIInterfaceOrientationPortraitUpsideDown	: rect = CGRectMake(   0, 0, 320, viewHeight ); break;
		case UIInterfaceOrientationLandscapeLeft		: rect = CGRectMake(   0, 0, viewHeight, 320 ); break;
		case UIInterfaceOrientationLandscapeRight		: rect = CGRectMake(   0, 0, viewHeight, 320 ); break;
	}
	
	UIView* frontView = [self frontView];
	
	[frontView addSubview:_pickerView];
	
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue			= [NSValue valueWithCGPoint:_pickerView.center];
	animation.toValue			= [NSValue valueWithCGPoint:CGPointMake(rect.size.width * 0.5f, rect.size.height - ( _pickerView.frame.size.height * 0.5f ))];
	animation.delegate			= self;
	animation.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.duration			= 0.25;
	
	[animation setValue:@"Date Picker View IN" forKey:@"animationID"];
	
	[[_pickerView layer] addAnimation:animation forKey:@"CABasicAnimation"];
    
	
	[UIView commitAnimations];
	
	_pickerView.center = CGPointMake(rect.size.width * 0.5f, rect.size.height - ( _pickerView.frame.size.height * 0.5f ));
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SHBPickerWillShowNotification object:self];
	
	// 현재 피커 리턴
	if (_delegate != nil && [_delegate respondsToSelector:@selector(currentDateField:)]) {
		[_delegate currentDateField:self];
	}
}

- (void)hide {
	_history = NO;
	
	if (isDropDownStyle){
		_textField.background = [[UIImage imageNamed:@"selectbox2_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}else{
		_textField.background = [[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	}
	
	UIInterfaceOrientation	orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGRect					rect		= CGRectZero;
	
	float viewHeight;
	if (AppInfo.isiPhoneFive)
		viewHeight = 568;
	else
		viewHeight = 480;
	
	switch (orientation) {
		case UIInterfaceOrientationPortrait				: rect = CGRectMake(   0, 0, 320, viewHeight ); break;
		case UIInterfaceOrientationPortraitUpsideDown	: rect = CGRectMake(   0, 0, 320, viewHeight ); break;
		case UIInterfaceOrientationLandscapeLeft		: rect = CGRectMake(   0, 0, viewHeight, 320 ); break;
		case UIInterfaceOrientationLandscapeRight		: rect = CGRectMake(   0, 0, viewHeight, 320 ); break;
	}
	
	UIView* frontView = [self frontView];
	
	[frontView addSubview:_pickerView];
	
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue			= [NSValue valueWithCGPoint:_pickerView.center];
	animation.toValue			= [NSValue valueWithCGPoint:CGPointMake(rect.size.width * 0.5f, rect.size.height + ( _pickerView.frame.size.height * 0.5f ))];
	animation.delegate			= self;
	animation.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.duration			= 0.25;
	
	[animation setValue:@"Date Picker View OUT" forKey:@"animationID"];
	
	[[_pickerView layer] addAnimation:animation forKey:@"CABasicAnimation"];
	
	[UIView commitAnimations];
	
	_pickerView.center = CGPointMake(rect.size.width * 0.5f, rect.size.height + ( _pickerView.frame.size.height * 0.5f ));
}

- (void)selectionProcessingWithDate:(NSDate*)date action:(BOOL)action {
    
    //    [_date release];
    [_textField setIsAccessibilityElement:YES];
	_date			= [date retain]; // 메모리 문제로 수정
    NSLog(@"date:%@",_date);
    //if (!UIAccessibilityIsVoiceOverRunning())
    //{
    _textField.text	= [_dateFormatter stringFromDate:_date];
    //}else
    //{
    //    _textField.text = [NSString stringWithFormat:@"%@",_date];
    //    _textField.text	= [NSString stringWithFormat:@"%@년%@월%@일",[_textField.text substringWithRange:NSMakeRange(0, 4)],[_textField.text substringWithRange:NSMakeRange(5, 2)],[_textField.text substringWithRange:NSMakeRange(8, 2)]];
    //    _textField.accessibilityLabel = [NSString stringWithFormat:@"%@년%@월%@일",[_textField.text substringWithRange:NSMakeRange(0, 4)],[_textField.text substringWithRange:NSMakeRange(5, 2)],[_textField.text substringWithRange:NSMakeRange(8, 2)]];
    //}
	//_textField.text	= [_dateFormatter stringFromDate:_date];
    
    _textField.accessibilityLabel = [NSString stringWithFormat:@"%@년%@월%@일",[_textField.text substringWithRange:NSMakeRange(0, 4)],[_textField.text substringWithRange:NSMakeRange(5, 2)],[_textField.text substringWithRange:NSMakeRange(8, 2)]];
    
	if( action ) {
		if( [_delegate respondsToSelector:@selector(dateField:changeDate:)] )
			[_delegate dateField:self changeDate:_datePicker.date];
	}
}

- (void)unselection {
	_textField.text  = @"";
	
}

- (void)selectDate:(NSDate*)date {
	_datePicker.date = date;
	[self selectionProcessingWithDate:_datePicker.date action:YES];
}

- (void)selectDate:(NSDate*)date animated:(BOOL)animated {
	[_datePicker setDate:date animated:animated];
	[self selectionProcessingWithDate:_datePicker.date action:YES];
}

- (void)datePickerValueChanged:(id)sender withEvent:(UIEvent*)event
{
	[self selectionProcessingWithDate:_datePicker.date action:YES];
}

- (void)toolbarItemWasTouchUpInside:(id)sender {
	switch ([sender tag]) {
		case 30:
			[self hide];
            
            if (_textField.text == nil || [_textField.text length] == 0)
            {
                
                NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc]init]autorelease];
                [outputFormatter setDateFormat:@"yyyy.MM.dd"];
                
                NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
                
                _date = [outputFormatter dateFromString:currentDate];
                _textField.text	= [outputFormatter stringFromDate:_date];
                
            }
			if(_delegate != nil && [_delegate respondsToSelector:@selector(dateField:didConfirmWithDate:)] )
				[_delegate dateField:self didConfirmWithDate:_date];
            
			break;
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if( !_enabled ) return NO;
	
	if( _editable ) {
	}
	else {
		[self toggle];
	}
	
	return _editable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	
    NSString* animationID = [theAnimation valueForKey:@"animationID"];
	
	if( [animationID isEqualToString:@"Date Picker View IN"] )
    {
                if (UIAccessibilityIsVoiceOverRunning())
                {
//                    _dummyField.hidden = NO;
//                    if (_dummyField == nil)
//                    {
//                        _dummyField = [[SHBTextField alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//                        [_datePicker addSubview:_dummyField];
//                    }
//                    [_dummyField setIsAccessibilityElement:YES];
//                    [_dummyField setAccessibilityTraits:UIAccessibilityTraitNotEnabled];
//                    //[_dummyField setAccessibilityTraits:UIAccessibilityTraitStaticText];
//                    _dummyField.accessibilityLabel = @"데이트피커입니다. 편집하시려면 초점을 이동 하십시요";
//                    
//                    [_dummyField becomeFirstResponder];
//                    [self performSelector:@selector(helpVoiceOver) withObject:nil afterDelay:0.2];
                    
                    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self viewWithTag:30]);
                }else
                {
                    _dummyField.hidden = YES;
                }
	}
	
	if( [animationID isEqualToString:@"Date Picker View OUT"] ) {
		[_pickerView removeFromSuperview];
	}
}

-(void)helpVoiceOver
{
    //[_dummyField setIsAccessibilityElement:NO];
    [_dummyField resignFirstResponder];
    //[_dummyField removeFromSuperview];
}
@end
