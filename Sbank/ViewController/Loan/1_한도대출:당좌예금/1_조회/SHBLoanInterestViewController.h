//
//  SHBLoanInterestViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 18..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBLoanService.h"

@interface SHBLoanInterestViewController : SHBBaseViewController
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblAccNo;
@property (retain, nonatomic) IBOutlet UILabel *lblTerm;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
