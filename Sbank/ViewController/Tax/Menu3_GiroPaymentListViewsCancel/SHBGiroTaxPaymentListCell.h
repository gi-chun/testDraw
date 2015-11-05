//
//  SHBGiroTaxPaymentListCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 18..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBGiroTaxPaymentListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 납부일자
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 납부금액
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 수납기관명

@end
