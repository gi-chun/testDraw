//
//  SHBSmithingDeviceQueryDelViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSmithingDeviceQueryDelViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UIView* subContentsView;
@property(nonatomic, retain) IBOutlet UIView* device1View;
@property(nonatomic, retain) IBOutlet UIView* device2View;
@property(nonatomic, retain) IBOutlet UIView* device3View;
@property(nonatomic, retain) IBOutlet UIView* device4View;
@property(nonatomic, retain) IBOutlet UIView* device5View;

@property(nonatomic, retain) IBOutlet UILabel* device1askDate;
@property(nonatomic, retain) IBOutlet UILabel* device1phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* device1phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* device1askType;

@property(nonatomic, retain) IBOutlet UILabel* device2askDate;
@property(nonatomic, retain) IBOutlet UILabel* device2phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* device2phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* device2askType;

@property(nonatomic, retain) IBOutlet UILabel* device3askDate;
@property(nonatomic, retain) IBOutlet UILabel* device3phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* device3phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* device3askType;

@property(nonatomic, retain) IBOutlet UILabel* device4askDate;
@property(nonatomic, retain) IBOutlet UILabel* device4phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* device4phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* device4askType;

@property(nonatomic, retain) IBOutlet UILabel* device5askDate;
@property(nonatomic, retain) IBOutlet UILabel* device5phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* device5phoneModel;
@property(nonatomic, retain) IBOutlet UILabel* device5askType;

- (IBAction)buttonTouched:(id)sender;
- (void)refreshDevice;
@end
