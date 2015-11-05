//
//  SHBNewProductWABSListCell.h
//  ShinhanBank
//
//  Created by Joon on 13. 2. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNewProductWABSListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *productClassLabel;
@property (retain, nonatomic) IBOutlet UILabel *productClass;

@property (retain, nonatomic) IBOutlet UILabel *productLabel;
@property (retain, nonatomic) IBOutlet UILabel *product;

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UILabel *number;
@property (retain, nonatomic) IBOutlet UILabel *accountStateLabel;
@property (retain, nonatomic) IBOutlet UILabel *accountState;
@property (retain, nonatomic) IBOutlet UIImageView *arrow;
@end
