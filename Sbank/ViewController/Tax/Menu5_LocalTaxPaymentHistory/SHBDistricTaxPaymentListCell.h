//
//  SHBDistricTaxPaymentListCell.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 19..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBDistricTaxPaymentListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 납부일자
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 청구기관
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 세목명
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 납부기간
@property (nonatomic, retain) IBOutlet UILabel      *label5;            // 납부은행

@end
