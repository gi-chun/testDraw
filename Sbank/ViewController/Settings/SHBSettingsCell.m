//
//  SHBSettingsCell.m
//  ShinhanBank
//
//  Created by Joon on 13. 2. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSettingsCell.h"

@implementation SHBSettingsCell

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
    
    [_subject setHighlighted:highlighted];
    [_arrow setHighlighted:highlighted];
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
    [_subject release];
    [_arrow release];
    [_versionLabel release];
    [_update release];
    [super dealloc];
}
@end
