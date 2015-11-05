//
//  SHBAccountELDStandardIndexViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 6. 24..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBAccountELDStandardIndexViewController : SHBBaseViewController

@property (retain, nonatomic) NSDictionary *accountInfo;

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *accountName;
@property (retain, nonatomic) IBOutlet UILabel *accountNumber;
@end
