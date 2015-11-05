//
//  SHBAskStaffViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBAskStaffViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBTextFieldDelegate> {
	
	IBOutlet UITableView	*listTable;
	IBOutlet UIButton		*staffButton;
	IBOutlet UIButton		*bankButton;
	IBOutlet SHBTextField	*searchTextField;
	
}

@property (nonatomic, retain) UIViewController *rtnViewController;

- (IBAction)buttonPressed:(UIButton*)sender;

- (void)executeWithTitle:(NSString*)aTitle ReturnViewController:(UIViewController*)viewController;


@end
