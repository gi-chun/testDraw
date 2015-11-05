//
//  SHBSignupViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSignupViewController : SHBBaseViewController  {
    IBOutlet UIImageView	*boxImageView;
	IBOutlet UIView			*topView;
	IBOutlet UIView			*btmView;
}

- (IBAction)buttonPressed:(UIButton*)sender;

@end
