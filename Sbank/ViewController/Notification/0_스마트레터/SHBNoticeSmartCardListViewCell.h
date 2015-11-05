//
//  SHBNoticeSmartCardListViewCell.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNoticeSmartCardListViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 직원명
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 유효기간
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 지점명
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 대화명
@property (nonatomic, retain) IBOutlet UILabel      *label5;            // 대화명
@property (nonatomic, retain) IBOutlet UIImageView  *imageView1;        // new icon

@end

