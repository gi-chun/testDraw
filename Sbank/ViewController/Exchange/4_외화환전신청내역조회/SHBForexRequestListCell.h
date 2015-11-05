//
//  SHBForexRequestListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 외환/골드 - 환전신청내역조회
 환전신청 목록 화면 cell
 */

@interface SHBForexRequestListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *arrow;
@property (retain, nonatomic) IBOutlet UILabel *requestDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *requestDate; // 신청일
@property (retain, nonatomic) IBOutlet UILabel *receiveDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiveDate; // 수령일
@property (retain, nonatomic) IBOutlet UILabel *receiveBranchLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiveBranch; // 수령점
@property (retain, nonatomic) IBOutlet UILabel *receiveCheckLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiveCheck; // 구분

@end
