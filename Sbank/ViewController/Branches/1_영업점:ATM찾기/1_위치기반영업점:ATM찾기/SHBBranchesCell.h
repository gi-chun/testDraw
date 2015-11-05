//
//  SHBBranchesCell.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBBranchesCell : UITableViewCell

@property (nonatomic, retain) UILabel *lblBranch;
@property (nonatomic, retain) UILabel *lblAddress;
@property (nonatomic, retain) UILabel *lblTel;
@property (nonatomic, retain) UIImageView *ivAcc;

- (void)set3Line:(BOOL)yesOrNo;

@end
