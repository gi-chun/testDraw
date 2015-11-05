//
//  SHBAccidentSearchCardListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBAccidentSearchCardListViewController :SHBBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) NSArray *listData;

@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UILabel *lblCustomerNo;

@end
