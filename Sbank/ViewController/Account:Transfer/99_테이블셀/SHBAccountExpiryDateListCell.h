//
//  SHBAccountExpiryDateListCell.h
//  ShinhanBank
//
//  Created by Joon on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBAccountExpiryDateListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet SHBScrollLabel *accountName;
@property (retain, nonatomic) IBOutlet UILabel *accountNo;
@property (retain, nonatomic) IBOutlet UILabel *expiryDate;
@end
