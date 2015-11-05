//
//  SHBSearchZipViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBSearchZipViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIButton		*oldButton;
	IBOutlet UIButton		*newButton;
	IBOutlet SHBTextField	*oldAddrTextField;
	IBOutlet SHBTextField	*newAddr1TextField;
	IBOutlet SHBTextField	*newAddr2TextField;
	IBOutlet UITableView	*listTableView;
	
	BOOL	isOldAddress;
	int		indexCurrentTextField;
	
	NSMutableArray	*postDataArray;
}

@property (nonatomic, retain) UIViewController *rtnViewController;

- (void)executeWithTitle:(NSString*)aTitle ReturnViewController:(UIViewController*)viewController;
- (IBAction)buttonPressed:(UIButton*)sender;

@end
