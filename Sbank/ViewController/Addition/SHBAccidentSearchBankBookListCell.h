//
//  SHBAccidentSearchBankBookListCell.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBAccidentSearchBankBookListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UILabel *lblAccountNum;
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblStartDate;
@property (retain, nonatomic) IBOutlet UILabel *lblEndDate;
@property (retain, nonatomic) IBOutlet UILabel *lblStore;
@property (retain, nonatomic) IBOutlet UILabel *lblBankBook;
@property (retain, nonatomic) IBOutlet UILabel *lblStamp;
@property (retain, nonatomic) IBOutlet UILabel *lblBankBookData;
@property (retain, nonatomic) IBOutlet UILabel *lblStampData;

//@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
//@property (retain, nonatomic) IBOutlet UILabel *lblAccountNo;
//@property (retain, nonatomic) IBOutlet UILabel *lblAmountValue;

@end
