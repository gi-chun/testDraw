//
//  SHBAccountDormantCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 12. 4..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBAccountDormantCell.h"

@implementation SHBAccountDormantCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_accountName release];
    [super dealloc];
}
@end
