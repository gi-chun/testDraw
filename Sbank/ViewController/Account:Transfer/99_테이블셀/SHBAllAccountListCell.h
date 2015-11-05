//
//  SHBAllAccountListCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBAllAccountListCell : UITableViewCell

@property (nonatomic ,retain) IBOutlet UILabel        *label1;        // 계좌이름
@property (nonatomic ,retain) IBOutlet UILabel        *label2;        // 계좌번호

@property (nonatomic ,retain) IBOutlet UILabel        *label3;        // 잔액, 신규일, 대출일자, 잔량
@property (nonatomic ,retain) IBOutlet UILabel        *label4;        // 잔액, 신규일, 대출일자, 잔량 값
@property (nonatomic ,retain) IBOutlet UILabel        *label5;        // 만기일, 대출 만기일
@property (nonatomic ,retain) IBOutlet UILabel        *label6;        // 만기일, 대출 만기일 날짜
@property (nonatomic ,retain) IBOutlet UILabel        *label7;        // 잔액, 평가금액, 대출잔액, 잔액(통화)
@property (nonatomic ,retain) IBOutlet UILabel        *label8;        // 잔액, 평가금액, 대출잔액, 잔액(통화) 값


@end
