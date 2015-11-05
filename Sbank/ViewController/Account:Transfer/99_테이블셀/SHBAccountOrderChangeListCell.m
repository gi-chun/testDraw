//
//  SHBAccountOrderChangeListCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 5..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountOrderChangeListCell.h"

@implementation SHBAccountOrderChangeListCell

#pragma mark -
#pragma mark Synthesize

@synthesize label1;
@synthesize label2;


#pragma mark -
#pragma mark Xcode Generate

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

- (void)dealloc
{
    self.label1 = nil;
    self.label2 = nil;
    
    [super dealloc];
}
@end
