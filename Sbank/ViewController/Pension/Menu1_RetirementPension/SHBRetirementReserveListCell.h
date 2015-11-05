//
//  SHBRetirementReserveListCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBCellActionProtocol.h"

@interface SHBRetirementReserveListCell : UITableViewCell
{

}

@property (nonatomic, retain) IBOutlet UIButton       *button1;             // 펼치기 버튼

@property (nonatomic, retain) IBOutlet UIButton     *button2;               // 조회 버튼
@property (nonatomic, retain) IBOutlet UIButton     *button3;               // 입금 버튼

@property (nonatomic, retain) IBOutlet UILabel        *label1;              // 플랜명
@property (nonatomic, retain) IBOutlet UILabel        *label2;              // 계좌번호
@property (nonatomic, retain) IBOutlet UILabel        *label3;              // 계약일
@property (nonatomic, retain) IBOutlet UILabel        *label4;              // 제도유형
@property (nonatomic, retain) IBOutlet UILabel        *label5;              // 예상수급액

@property (nonatomic, assign) int row;

@property (nonatomic, assign) id <SHBCellActionProtocol> cellButtonActionDelegate;         // buttonPushDelegate

@end
