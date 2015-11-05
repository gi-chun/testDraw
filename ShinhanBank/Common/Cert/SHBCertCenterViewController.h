//
//  SHBCertCenterViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCertCenterViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *certCenterTable;
@property (retain, nonatomic) NSArray *certCenterMenus;
@property (retain, nonatomic) NSArray *certCenterViewControllers;

@end
