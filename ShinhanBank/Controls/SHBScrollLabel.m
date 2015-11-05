//
//  SHBScrollLabel.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBScrollLabel.h"

@implementation SHBScrollLabel
@synthesize movingSpeed;
@synthesize caption1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initFrame:frame];
    }
    return self;
}

- (void)initFrame:(CGRect)frame
{
    self.clipsToBounds = YES;
    frameWidth = frame.size.width;
    self.caption1 = [[[UILabel alloc] initWithFrame:frame] autorelease];
    caption1.backgroundColor = [UIColor clearColor];
    caption1.font = [UIFont systemFontOfSize:15];
    caption1.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    [self addSubview:caption1];
    
    movingSpeed = 1;
}

- (void)initFrame:(CGRect)frame colorType:(UIColor *)colorType fontSize:(int)fontSize textAlign:(int)textAlign
{
    self.clipsToBounds = YES;
    frameWidth = frame.size.width;
    self.caption1 = [[[UILabel alloc] initWithFrame:frame] autorelease];
    caption1.backgroundColor = [UIColor clearColor];
    caption1.font = [UIFont systemFontOfSize:fontSize];
    caption1.textColor = colorType;
    
    // Text Alignment
    if (textAlign == 0)
        [caption1 setTextAlignment:UITextAlignmentLeft];
    else if (textAlign == 1) {
        [caption1 setTextAlignment:UITextAlignmentCenter];
    } else {
        [caption1 setTextAlignment:UITextAlignmentRight];
    }
    [self addSubview:caption1];
    
    movingSpeed = 1;
}

- (void)setCaptionText:(NSString *)str
{
    caption1.text = str;
    
	CGSize textLabelSize = [str sizeWithFont:caption1.font];
    labelWidth = textLabelSize.width;
    
	if(labelWidth > frameWidth)
    {
        caption1.frame = CGRectMake(0, 0, labelWidth, self.frame.size.height);
        
        self.timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(moveLabel) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
        caption1.frame = CGRectMake(0, 0, frameWidth, self.frame.size.height);
    }
}

- (void)setCaptionTextColor:(UIColor *)textColor
{
    caption1.textColor = textColor;
}

- (void)moveLabel
{
    CGRect labelFrame = caption1.frame;
    if(labelFrame.origin.x < -labelWidth + 10)
    {
        labelFrame.origin.x = frameWidth - 10;
    }
    else
    {
        labelFrame.origin.x -= movingSpeed;
    }
    
    caption1.frame = labelFrame;
}

- (void)dealloc
{
    if ([_timer isValid]) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
    
    [caption1 release];
    
    [super dealloc];
}

@end
