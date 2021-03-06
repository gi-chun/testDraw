//
//  SHBAccidentCardCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentCardCompleteViewController.h"

@interface SHBAccidentCardCompleteViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBAccidentCardCompleteViewController

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
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    CGFloat y = _infoLabel1.frame.origin.y;
    
    [self adjustToView:_infoLabel1 originX:_infoLabel1.frame.origin.x originY:y text:_infoLabel1.text];
    
    y += _infoLabel1.frame.size.height + 10;
    
    [self adjustToView:_infoLabel2 originX:_infoLabel2.frame.origin.x originY:y text:_infoLabel2.text];
    
    [_infoImage2 setFrame:CGRectMake(_infoImage2.frame.origin.x,
                                     y + 6,
                                     _infoImage2.frame.size.width,
                                     _infoImage2.frame.size.height)];
    
    y += _infoLabel2.frame.size.height + 10;
    
    [self adjustToView:_infoLabel3 originX:_infoLabel3.frame.origin.x originY:y text:_infoLabel3.text];
    
    [_infoImage3 setFrame:CGRectMake(_infoImage3.frame.origin.x,
                                     y + 6,
                                     _infoImage3.frame.size.width,
                                     _infoImage3.frame.size.height)];
    
    y += _infoLabel3.frame.size.height + 10;
    
    [self adjustToView:_infoLabel4 originX:_infoLabel4.frame.origin.x originY:y text:_infoLabel4.text];
    
    [_infoImage4 setFrame:CGRectMake(_infoImage4.frame.origin.x,
                                     y + 6,
                                     _infoImage4.frame.size.width,
                                     _infoImage4.frame.size.height)];
    
    y += _infoLabel4.frame.size.height + 5;

    
    
    
    
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
    [_infoLabel1 release];
    [_infoImage2 release];
    [_infoLabel2 release];
    [_infoImage3 release];
    [_infoLabel3 release];
    [_infoImage4 release];
    [_infoLabel4 release];
    [_bgBox release];
    [_ok release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoLabel1:nil];
    [self setInfoImage2:nil];
    [self setInfoLabel2:nil];
    [self setInfoImage3:nil];
    [self setInfoLabel3:nil];
    [self setInfoImage4:nil];
    [self setInfoLabel4:nil];
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
                              labelSize.height + 4)];
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
