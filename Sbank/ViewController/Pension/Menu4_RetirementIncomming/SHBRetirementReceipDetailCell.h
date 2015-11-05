//
//  SHBRetirementReceipDetailCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBRetirementReceipDetailCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 입금일자
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 사용자부담금
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 가입자부담금
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 부담금합계

@end
