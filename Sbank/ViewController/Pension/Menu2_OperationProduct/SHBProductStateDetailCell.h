//
//  SHBProductStateDetailCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBProductStateDetailCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 상품명
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 수익률
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 운용상품평가금액
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 원금
@property (nonatomic, retain) IBOutlet UILabel      *label5;            // 평가손익

@end
