//
//  SHBNoticeCouponListViewCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 28..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNoticeCouponListViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 제목
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 환전우대율
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 유효기간
@property (nonatomic, retain) IBOutlet UIImageView  *imageView1;        // new icon

@end
