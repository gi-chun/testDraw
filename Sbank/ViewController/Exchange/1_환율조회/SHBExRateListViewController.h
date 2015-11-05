//
//  SHBExRateListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBExRateListViewController : SHBBaseViewController
{
//    NSMutableDictionary *inquiryList;
    NSArray *inquiryList;
}
@property (nonatomic, retain) IBOutlet UITableView *exRateListTable;
//@property (nonatomic, retain) IBOutlet NSMutableDictionary *inquiryList;
@property (nonatomic, retain) NSArray *inquiryList;
@property (retain, nonatomic) IBOutlet UILabel *lblExRate;
@property (nonatomic, retain) IBOutlet SHBButton *widgetBtn;

- (IBAction)registerWidget:(id)sender;
@end
