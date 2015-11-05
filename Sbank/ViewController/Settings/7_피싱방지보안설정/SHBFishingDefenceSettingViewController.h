//
//  SHBFishingDefenceSettingViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 4. 1..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBFishingDefenceSettingViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UITextField *fishingTextField;
@property (nonatomic, retain) IBOutlet UIScrollView *fishingScrollView;
@property (nonatomic, retain) IBOutlet UIView *registerView;
@property (nonatomic, retain) IBOutlet UIView *changeView;
@property (nonatomic, retain) IBOutlet UIView *image1View;
@property (nonatomic, retain) IBOutlet UIView *image2View;
@property (nonatomic, retain) IBOutlet UIView *image3View;

@property (nonatomic, retain) IBOutlet UIImageView *page1ImageView;
@property (nonatomic, retain) IBOutlet UIImageView *page2ImageView;
@property (nonatomic, retain) IBOutlet UIImageView *page3ImageView;
@property (nonatomic, retain) IBOutlet UIImageView *myFishingImageView;

@property (nonatomic, retain) IBOutlet UIImageView *myFishingImageBgView;
@property (nonatomic, retain) IBOutlet UIImageView *mySelectImageBgView;

- (IBAction)buttonTouched:(id)sender;
- (IBAction)iconTouched:(id)sender;
@end
