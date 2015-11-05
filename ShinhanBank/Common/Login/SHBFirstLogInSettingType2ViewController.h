//
//  SHBFirstLogInSettingType2ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"

@interface SHBFirstLogInSettingType2ViewController : SHBBaseViewController <SHBListPopupViewDelegate>

@property (nonatomic, assign) int certIndex;
@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet NSMutableArray *certArray;

- (IBAction) confirmClick:(id)sender;
- (IBAction) cancelClick:(id)sender;

@end
