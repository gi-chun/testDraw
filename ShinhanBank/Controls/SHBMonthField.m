//
//  SHBMonthField.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SHBMonthField.h"


#define _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT	216.0f
#define _SHBDATEFIELD_PICKER_LANDSCAPE_HEIGHT	180.0f
#define _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT		 40.0f

#define _TAG_SHBDATEFIELD_PICKER_DONE_BUTTON		0xf002

static NSString*			SHBDateFieldToolBarDoneImage	= nil;
static NSString*			SHBDateFieldToolBarCancelImage	= nil;
static NSMutableDictionary*	SHBDateFieldEnabledInterfaceOrientation	= nil;

@interface SHBMonthField (Private)

- (void)selectionProcessingWithDate:(NSDate*)date action:(BOOL)action;

@end

@implementation SHBMonthField

@synthesize delegate		= _delegate;
@synthesize textField		= _textField;
@synthesize editable		= _editable;
@synthesize enabled			= _enabled;
@synthesize history			= _history;
@synthesize pickerViewMonthArray, pickerViewYearArray;

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

//타이틀에 따른 배열상의 인덱스 반환
- (NSInteger)indexOfYear:(NSString*)title{
	
	NSInteger rtnValue = 0;
	for(NSInteger i=0; i<[pickerViewYearArray count]; i++)
	{
		NSString* tmpStr = [pickerViewYearArray objectAtIndex:i];
		if([tmpStr isEqualToString:title])
		{
			rtnValue = i;
			break;
		}
	}
	
	return rtnValue;
}
//타이틀에 따른 배열상의 인덱스 반환
- (NSInteger)indexOfMonth:(NSString*)title{
	
	NSInteger rtnValue = 0;
	for(NSInteger i=0; i<[pickerViewMonthArray count]; i++)
	{
		NSString* tmpStr = [pickerViewMonthArray objectAtIndex:i];
		if([tmpStr isEqualToString:title])
		{
			rtnValue = i;
			break;
		}
	}
	
	return rtnValue;
}


- (void)dealloc {
	[_pickerView removeFromSuperview];
	
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_textField			release];
	[_dummyField release];
	[_pickerView		release];
	[_monthPicker		release];
	[_pickerToolbar		release];
	
    [super dealloc];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	_textField.frame		= CGRectMake(5.0f, 0.0f, self.frame.size.width - 10.0f, self.frame.size.height);
}

- (void)initFrame:(CGRect)frame
{
    _editable	= NO;
    _enabled	= YES;
    _history	= NO;
    isDropDownStyle = NO;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
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
    
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)] autorelease];
    _textField.leftView = paddingView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:_textField];
    
    float viewHeight;
    if (AppInfo.isiPhoneFive)
        viewHeight = 548;
    else
        viewHeight = 460;
    
    float totalHeight = ( _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
    _pickerView  = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, viewHeight, 320.0f, viewHeight )];
    
    _bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width, _pickerView.frame.size.height)] autorelease];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [_bgView setAlpha:0.5];
    [_pickerView addSubview:_bgView];
    
    _monthPicker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0.0f, viewHeight - totalHeight + _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT, 320.0f, _SHBDATEFIELD_PICKER_PORTRAIT_HEIGHT )];
    _monthPicker.showsSelectionIndicator = YES;
    _monthPicker.delegate = self;
    _monthPicker.dataSource = self;
    
    //ios7 + xcode5 대응
    _monthPicker.backgroundColor = [UIColor whiteColor];
    
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [theFormatter setDateFormat:@"yyyy"];
    [monthFormatter setDateFormat:@"yyyyMM"];
    
    NSDate *today = [[NSDate alloc]init];
    NSString* today_str = [theFormatter stringFromDate:today];
    NSString *monthStr = [monthFormatter stringFromDate:today];
    [theFormatter release];
    [monthFormatter release];
    [today release];
    
    NSInteger startYear = 1900;
    NSInteger endYear = [today_str intValue];
    
    intYear = [[monthStr substringToIndex:4] intValue];
    intMonth = [[monthStr substringFromIndex:4] intValue];
    
    pickerViewYearArray = [[NSMutableArray alloc]init];
    pickerViewMonthArray = [[NSMutableArray alloc]init];
    for(NSInteger i=1; i<=12; i++)
    {
        [pickerViewMonthArray addObject:[NSString stringWithFormat:@"%d%@",i,@"월"]];
    }
    
    for(NSInteger i=startYear; i<=endYear; i++)
    {
        [pickerViewYearArray addObject:[NSString stringWithFormat:@"%d%@",i,@"년"]];
    }
    
    [_monthPicker selectRow:[self indexOfYear:[NSString stringWithFormat:@"%i년",intYear]] inComponent:0 animated:YES];
    [_monthPicker selectRow:[self indexOfMonth:[NSString stringWithFormat:@"%i월",intMonth]] inComponent:1 animated:YES];
    
    [_pickerView addSubview:_monthPicker];
    
    _pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, viewHeight - totalHeight, _pickerView.frame.size.width, _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT)];
    _pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [_pickerView addSubview:_pickerToolbar];
    
    // 셋팅(설정)버튼 생성
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 5, 50, 29)];
    completeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [completeButton setTitle:@"설정" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setTag:30];
    completeButton.accessibilityHint = @"데이트피커입니다. 편집하시려면 초점을 이동 하십시요";
    
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
	NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
	[monthFormatter setDateFormat:@"yyyyMM"];
	
	NSString *monthStr = [monthFormatter stringFromDate:date];
	[monthFormatter release];
	
	intYear = [[monthStr substringToIndex:4] intValue];
	intMonth = [[monthStr substringFromIndex:4] intValue];
	
	_textField.text = [NSString stringWithFormat:@"%i.%02i",intYear,intMonth];
	[_monthPicker selectRow:[self indexOfYear:[NSString stringWithFormat:@"%i년",intYear]] inComponent:0 animated:YES];
	[_monthPicker selectRow:[self indexOfMonth:[NSString stringWithFormat:@"%i월",intMonth]] inComponent:1 animated:YES];
	_textField.accessibilityLabel = [NSString stringWithFormat:@"%i년%i월",intYear,intMonth];
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

- (void)setMaximumYear:(int)maxYear{
	NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
	[yearFormatter setDateFormat:@"yyyy"];
	
	NSDate *today = [[NSDate alloc]init];
	NSString* yearStr = [yearFormatter stringFromDate:today];
	[yearFormatter release];
	[today release];
	
	intYear = [yearStr intValue];
	
	[pickerViewYearArray removeAllObjects];
	
	for(NSInteger i=1900; i<=maxYear; i++)
	{
		[pickerViewYearArray addObject:[NSString stringWithFormat:@"%d%@",i,@"년"]];
	}
	
	[_monthPicker selectRow:[self indexOfYear:[NSString stringWithFormat:@"%i년",intYear]] inComponent:0 animated:YES];
	
	[_monthPicker reloadComponent:0];
}


#pragma mark -
#pragma mark 로우별 데이타 선택시 호출
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString* tmpStr;
	
	if(component == 0)//year
	{
		tmpStr = [self.pickerViewYearArray objectAtIndex:[_monthPicker selectedRowInComponent:0]];
		intYear = [[tmpStr substringToIndex:4] intValue];
		_textField.text	= [NSString stringWithFormat:@"%i.%02i",intYear,intMonth];
	}
	else//month
	{
		tmpStr = [self.pickerViewMonthArray objectAtIndex:[_monthPicker selectedRowInComponent:1]];
		if ([tmpStr length] > 2){
			intMonth = [[tmpStr substringToIndex:2] intValue];
		}else{
			intMonth = [[tmpStr substringToIndex:1] intValue];
		}
		
		_textField.text	= [NSString stringWithFormat:@"%i.%02i",intYear,intMonth];
	}
}
#pragma mark -
#pragma mark 피커뷰의 각 로우별 width설정
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	if(component == 0)//Year
		return 200;
	else
		return 120	;
}
#pragma mark -
#pragma mark 피커뷰의 각 로우별 height설정
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 35;
}
#pragma mark -
#pragma mark 피커뷰의 전체 열수 설정
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
#pragma mark -
#pragma mark 피커뷰의 개별 로우의 데이터 개수
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if(component == 0)
		return [pickerViewYearArray count];
	else
		return [pickerViewMonthArray count];
}
#pragma mark -
#pragma mark 피커뷰의 로우별 행의 보여지는 텍스트 이름
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
	if (component == 0){
		label.frame = CGRectMake(0,0,200,35);
		label.text = [pickerViewYearArray objectAtIndex:row];
	}else{
		label.frame = CGRectMake(0,0,120,35);
		label.text = [pickerViewMonthArray objectAtIndex:row];
	}
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label autorelease];
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	NSString* dispTitle;
	
	if(component == 0)//년도
	{
		dispTitle = [pickerViewYearArray objectAtIndex:row];
	}
	else//달
	{
		dispTitle = [pickerViewMonthArray objectAtIndex:row];
	}
	
	
    return dispTitle;
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
			_monthPicker.frame		= CGRectMake( 0, _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT, rect.size.width, rect.size.height - _SHBDATEFIELD_PICKER_TOOLBAR_HEIGHT );
			
			[UIView commitAnimations];
		}break;
	}
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
	
	[animation setValue:@"Month Picker View IN" forKey:@"animationID"];
	
	[[_pickerView layer] addAnimation:animation forKey:@"CABasicAnimation"];
    
	[UIView commitAnimations];
	
	_pickerView.center = CGPointMake(rect.size.width * 0.5f, rect.size.height - ( _pickerView.frame.size.height * 0.5f ));
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SHBPickerWillShowNotification object:self];
	
	// 현재 피커 리턴
	if (_delegate != nil && [_delegate respondsToSelector:@selector(currentMonthField:)]) {
		[_delegate currentMonthField:self];
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
	
	[animation setValue:@"Month Picker View OUT" forKey:@"animationID"];
	
	[[_pickerView layer] addAnimation:animation forKey:@"CABasicAnimation"];
    
	[UIView commitAnimations];
	
	_pickerView.center = CGPointMake(rect.size.width * 0.5f, rect.size.height + ( _pickerView.frame.size.height * 0.5f ));
}

- (void)unselection {
	_textField.text  = @"";
}

- (void)selectDate:(NSDate*)date {
	NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
	[monthFormatter setDateFormat:@"yyyyMM"];
	
	NSString *monthStr = [monthFormatter stringFromDate:date];
	[monthFormatter release];
	
	intYear = [[monthStr substringToIndex:4] intValue];
	intMonth = [[monthStr substringFromIndex:4] intValue];
	
	_textField.text = [NSString stringWithFormat:@"%i.%02i",intYear,intMonth];
	
}

- (void)selectDate:(NSDate*)date animated:(BOOL)animated {
	NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
	[monthFormatter setDateFormat:@"yyyyMM"];
	
	NSString *monthStr = [monthFormatter stringFromDate:date];
	[monthFormatter release];
	
	intYear = [[monthStr substringToIndex:4] intValue];
	intMonth = [[monthStr substringFromIndex:4] intValue];
	
	_textField.text = [NSString stringWithFormat:@"%i.%02i",intYear,intMonth];
	[_monthPicker selectRow:[self indexOfYear:[NSString stringWithFormat:@"%i년",intYear]] inComponent:0 animated:YES];
	[_monthPicker selectRow:[self indexOfMonth:[NSString stringWithFormat:@"%i월",intMonth]] inComponent:1 animated:YES];
	
}


- (void)toolbarItemWasTouchUpInside:(id)sender {
	switch ([sender tag]) {
		case 30:
			[self hide];
			if(_delegate != nil && [_delegate respondsToSelector:@selector(monthField:didConfirmWithMonth:)] )
				[_delegate monthField:self didConfirmWithMonth:[NSString stringWithFormat:@"%i%02i",intYear,intMonth]];
			
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
	
	if( [animationID isEqualToString:@"Month Picker View IN"] )
    {
        if (UIAccessibilityIsVoiceOverRunning())
        {
//            _dummyField.hidden = NO;
//            if (_dummyField == nil)
//            {
//                _dummyField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//                [_monthPicker addSubview:_dummyField];
//            }
//            [_dummyField setIsAccessibilityElement:YES];
//            [_dummyField setAccessibilityTraits:UIAccessibilityTraitNotEnabled];
//            _dummyField.accessibilityLabel = @"데이트피커입니다. 편집하시려면 초점을 이동 하십시요";
//            
//            [_dummyField becomeFirstResponder];
//            [self performSelector:@selector(helpVoiceOver) withObject:nil afterDelay:0.2];
            //[self viewWithTag:30].accessibilityHint = @"데이트피커입니다. 편집하시려면 초점을 이동 하십시요";
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self viewWithTag:30]);
        }else
        {
            _dummyField.hidden = YES;
        }
	}
	
	if( [animationID isEqualToString:@"Month Picker View OUT"] ) {
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
