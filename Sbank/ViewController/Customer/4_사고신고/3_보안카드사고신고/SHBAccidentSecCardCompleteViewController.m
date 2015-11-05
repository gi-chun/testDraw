//
//  SHBAccidentSecCardCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSecCardCompleteViewController.h"

@interface SHBAccidentSecCardCompleteViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBAccidentSecCardCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"사고신고"];
    [self navigationBackButtonHidden];
    
    CGFloat y = _info.frame.origin.y;
    
    [self adjustToView:_info originX:_info.frame.origin.x originY:y text:_info.text];
    
    y += _info.frame.size.height + 5;
    
    [_bgBox setFrame:CGRectMake(_bgBox.frame.origin.x,
                                _bgBox.frame.origin.y,
                                _bgBox.frame.size.width,
                                y - _bgBox.frame.origin.y)];
    
    [_ok setFrame:CGRectMake(_ok.frame.origin.x,
                             _bgBox.frame.origin.y + _bgBox.frame.size.height + 10,
                             _ok.frame.size.width,
                             _ok.frame.size.height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_info release];
    [_bgBox release];
    [_ok release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfo:nil];
    [self setBgBox:nil];
    [self setOk:nil];
    [super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:13]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
