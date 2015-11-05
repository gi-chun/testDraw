//
//  SHBFundPopupView.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundPopupView.h"

@implementation SHBFundPopupView

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height
{
    self = [super initWithTitle:aTitle SubViewHeight:height - 6];
    if (self) {
        self.tableView = [[[UITableView alloc] init] autorelease];
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_tableView setBackgroundColor:RGB(224, 227, 232)];
        
        [self insertSubview:_tableView atIndex:1];
        
        if ([self.subviews count] == 3) {
            if ([[self.subviews objectAtIndex:2] isKindOfClass:[UIView class]]) {
                UIView *view = (UIView *)[self.subviews objectAtIndex:2];
                [view setUserInteractionEnabled:NO];
                
                [_tableView setFrame:CGRectMake(30, view.frame.origin.y + 38, 260, height)];
            }
        }
        
        Debug(@"%@", self.subviews);
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
