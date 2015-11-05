//
//  SHBMyMenuViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 5..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBMyMenuViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBButton *btnSave;
@property (nonatomic, retain) IBOutlet UILabel   *lblMessage;
@property (nonatomic, retain) IBOutlet UIView    *viewMessage;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIImageView *imageView1;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSearch;

@end
