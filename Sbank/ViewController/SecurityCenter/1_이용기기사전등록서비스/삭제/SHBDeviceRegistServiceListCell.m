//
//  SHBDeviceRegistServiceListCell.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 9..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceListCell.h"

@implementation SHBDeviceRegistServiceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_deleteBtn release];
    [super dealloc];
}
@end
