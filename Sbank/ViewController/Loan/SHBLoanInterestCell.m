//
//  SHBLoanInterestCell.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 28.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanInterestCell.h"

@implementation SHBLoanInterestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    if(selected)
//    {
//        [self.contentView setBackgroundColor:RGB(244, 244, 244)];
//    }
//    else
//    {
//        [self.contentView setBackgroundColor:RGB(244, 239, 234)];
//    }
//}
//
- (void)dealloc {
    
    [_lblData01 release];
    [_lblData02 release];
    [_lblData03 release];
    [_lblData04 release];
    [_lblData05 release];
    
    [super dealloc];
}

@end
