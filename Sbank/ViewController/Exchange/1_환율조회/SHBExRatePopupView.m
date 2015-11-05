//
//  SHBExRatePopupView.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExRatePopupView.h"

@implementation SHBExRatePopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height
{
    self = [super initWithSortTitle:aTitle SubViewHeight:height - 6];
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
- (void)sortBtn:(UIButton *)sender
{
    NSLog(@"sort BTN !!!!!!!!!!!!!!");
    [sender setSelected:![sender isSelected]];

    if ([sender isSelected])
    {

        //sender.accessibilityLabel = @"현재 오름차순정렬입니다 내림차순으로 정렬하시려면 이중탭하십시요";
        sender.accessibilityLabel = @"회차정렬 오름차순";
    }else
    {
        //sender.accessibilityLabel = @"현재 내림차순정렬입니다 오름차순으로 정렬하시려면 이중탭하십시요";
        sender.accessibilityLabel = @"회차정렬 내림차순";
    }
    if ([_sorTDelegate respondsToSelector:@selector(sortProcess)])
    {
        [_sorTDelegate sortProcess];
    }
}

- (void)close
{
    [self closePopupViewWithButton:nil];
}

@end
