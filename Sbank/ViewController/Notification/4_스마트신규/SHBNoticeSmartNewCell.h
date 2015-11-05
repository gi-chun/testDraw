//
//  SHBNoticeSmartNewCell.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBNoticeSmartNewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *noticeTitle;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *noticeMessage;
@property (retain, nonatomic) IBOutlet SHBButton *arrowBtn;

@end
