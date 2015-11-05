//
//  SHBScrollLabel.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBScrollLabel : UIView
{
    float movingSpeed;
    
    float frameWidth;
    float labelWidth;
}

@property (nonatomic) float movingSpeed;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UILabel *caption1;

- (void)initFrame:(CGRect)frame;
- (void)initFrame:(CGRect)frame colorType:(UIColor *)colorType fontSize:(int)fontSize textAlign:(int)textAlign;
- (void)setCaptionText:(NSString *)str;
- (void)setCaptionTextColor:(UIColor *)textColor;
@end
