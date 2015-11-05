//
//  SHBAccidentPopupView.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentPopupView.h"

@implementation SHBAccidentPopupView

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height setContentView:(UIView *)contentView
{
    self = [super initWithTitle:aTitle SubViewHeight:height - 6];
    if (self) {
        self.scrollView = [[[UIScrollView alloc] init] autorelease];
        [_scrollView setBounces:NO];
        [_scrollView setAlwaysBounceHorizontal:NO];
        [_scrollView setAlwaysBounceVertical:NO];
        [_scrollView setFrame:CGRectMake(0,
                                         0,
                                         self.mainView.frame.size.width,
                                         self.mainView.frame.size.height)];
        [_scrollView addSubview:contentView];
        [_scrollView setContentSize:contentView.frame.size];
        
        [self.mainView addSubview:_scrollView];
    }
    
    return self;
}

- (void)dealloc
{
    self.scrollView = nil;
    
    [super dealloc];
}

@end