//
//  SHBFishingDefenceDoneViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 4. 2..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBFishingDefenceDoneViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

- (IBAction)buttonTouched:(id)sender;
- (IBAction)barcodeTouched:(id)sender;

@end
