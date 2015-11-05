//
//  SHBNotiListViewCell.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNotiListViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 소식
@property (nonatomic, retain) NSString *noti_seq;
@property (nonatomic, retain) IBOutlet UIView *lineView;
@end
