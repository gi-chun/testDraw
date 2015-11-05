//
//  SHBExchangePopupView.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExchangePopupView.h"

@implementation SHBExchangePopupView

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height
{
    self = [super initWithTitle:aTitle SubViewHeight:height - 6];
    if (self) {
        self.tableView = [[[UITableView alloc] init] autorelease];
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_tableView setBackgroundColor:RGB(224, 227, 232)];
        [_tableView setBounces:NO];
        [_tableView setAlwaysBounceHorizontal:NO];
        [_tableView setAlwaysBounceVertical:NO];
        [_tableView setFrame:CGRectMake(0,
                                        0,
                                        self.mainView.frame.size.width,
                                        self.mainView.frame.size.height)];
        
        [self.mainView addSubview:_tableView];
    }
    
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    
    [super dealloc];
}

#pragma mark - 

- (void)close
{
    [self closePopupViewWithButton:nil];
}

@end
