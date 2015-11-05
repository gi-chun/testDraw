//
//  SHBSmartBankViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSmartBankViewController : SHBBaseViewController <UIScrollViewDelegate>{
	IBOutlet UIImageView	*boxImageView;
	IBOutlet UIScrollView	*appScrollView;
	
	NSMutableArray	*listArray;
}

- (IBAction)buttonPressed:(UIButton*)sender;

@end
