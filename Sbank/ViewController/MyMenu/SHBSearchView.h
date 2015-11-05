//
//  SHBSearchView.h
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

@interface SHBSearchView : UIView <SHBTextFieldDelegate, UITextFieldDelegate>
{
    UINavigationController *navi;
    SHBTextField *txtSearch;
    UITableView *tableView1;
}

@property (nonatomic, assign) UINavigationController *navi;
@property (nonatomic, retain) IBOutlet SHBTextField *txtSearch;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@property (nonatomic, retain) NSMutableArray *arrayTableData;
@property (nonatomic, retain) NSMutableArray *totalSubMenuArray;
- (void)refresh;
@end
