//
//  SHBCertElectronicSignViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"

@interface SHBCertElectronicSignViewController : SHBBaseViewController <SHBSecureDelegate,UITableViewDataSource, UITableViewDelegate, SHBListPopupViewDelegate>

@property (nonatomic, retain) IBOutlet SHBSecureTextField *certPWTextField;
@property (retain, nonatomic) IBOutlet UITableView *electronicsignTable;
@property (retain, nonatomic) IBOutlet UILabel *electronicsignTitle;
@property (retain, nonatomic) IBOutlet NSString *httpBody;
@property (retain, nonatomic) IBOutlet NSString *serviceUrl;

@property (nonatomic, retain) IBOutlet SHBButton *confirmBtn;
@property (nonatomic, retain) IBOutlet SHBButton *cancelBtn;
@property (nonatomic, retain) NSMutableArray *mycertList;

- (IBAction)registerEletronicSign:(id)sender;
- (IBAction)cancelEletronicSign:(id)sender;

@end
