//
//  SHBRetirementReceipDetailCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReceipDetailCell.h"

@implementation SHBRetirementReceipDetailCell

#pragma mark -
#pragma mark Synthesize

@synthesize label1;            // 입금일자
@synthesize label2;            // 사용자부담금
@synthesize label3;            // 가입자부담금
@synthesize label4;            // 부담금합계


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
    self.label3 = nil;
    self.label4 = nil;
    
    [super dealloc];
}

@end
