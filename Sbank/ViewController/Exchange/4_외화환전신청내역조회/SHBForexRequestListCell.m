//
//  SHBForexRequestListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestListCell.h"

@implementation SHBForexRequestListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    [_arrow setHighlighted:highlighted];
    [_requestDateLabel setHighlighted:highlighted];
    [_requestDate setHighlighted:highlighted];
    [_receiveDateLabel setHighlighted:highlighted];
    [_receiveDate setHighlighted:highlighted];
    [_receiveBranchLabel setHighlighted:highlighted];
    [_receiveBranch setHighlighted:highlighted];
    [_receiveCheckLabel setHighlighted:highlighted];
    [_receiveCheck setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)dealloc {
    [_arrow release];
    [_requestDateLabel release];
    [_requestDate release];
    [_receiveDateLabel release];
    [_receiveDate release];
    [_receiveBranchLabel release];
    [_receiveBranch release];
    [_receiveCheckLabel release];
    [_receiveCheck release];
    [super dealloc];
}
@end
