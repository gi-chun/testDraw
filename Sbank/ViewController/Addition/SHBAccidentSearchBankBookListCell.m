//
//  SHBAccidentSearchBankBookListCell.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchBankBookListCell.h"

@implementation SHBAccidentSearchBankBookListCell

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
	[_lblName release];
	[_lblAccountNum release];
	[_lblAmount release];
	[_lblStartDate release];
	[_lblEndDate release];
	[_lblStore release];
	[_lblBankBook release];
	[_lblStamp release];
	[_lblBankBookData release];
	[_lblStampData release];

	[super dealloc];
}
@end
