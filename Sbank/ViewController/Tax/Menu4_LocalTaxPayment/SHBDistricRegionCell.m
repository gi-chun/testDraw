//
//  SHBDistricRegionCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 1..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBDistricRegionCell.h"

@implementation SHBDistricRegionCell

@synthesize labelRegion;


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
    self.labelRegion = nil;
    
    [super dealloc];
}

@end
