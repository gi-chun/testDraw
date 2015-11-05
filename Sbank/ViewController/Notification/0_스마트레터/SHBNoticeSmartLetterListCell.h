//
//  SHBNoticeSmartLetterListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 알림
 스마트레터 목록 화면 cell
 */

@interface SHBNoticeSmartLetterListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *subject; // 제목
@property (retain, nonatomic) IBOutlet UILabel *branch; // 등록지점 및 날짜
@property (retain, nonatomic) IBOutlet UIImageView *readImage;
@property (retain, nonatomic) IBOutlet UIImageView *arrow;
@property (retain, nonatomic) IBOutlet UIButton *edit;
@property (retain, nonatomic) IBOutlet UIView *dataView;
@end
