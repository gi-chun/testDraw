//
//  SHBFavoriteBranchCell.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 12. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBFavoriteBranchCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *label1;         // "자주 찾는" 라벨
@property (nonatomic, retain) IBOutlet UILabel *label2;         // "지정명" 라벨
@property (nonatomic, retain) IBOutlet UILabel *label3;         // "지점" 라벨
@property (nonatomic, retain) IBOutlet UIImageView *imageView1; // ">" 이미지 뷰

@end
