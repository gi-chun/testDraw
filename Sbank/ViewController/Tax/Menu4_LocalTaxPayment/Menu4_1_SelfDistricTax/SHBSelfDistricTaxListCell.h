//
//  SHBSelfDistricTaxListCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 17..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSelfDistricTaxListCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 지자체
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 세목
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 고지구분
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 납부기한
@property (nonatomic, retain) IBOutlet UILabel      *label5;            // 납부금액

@end
