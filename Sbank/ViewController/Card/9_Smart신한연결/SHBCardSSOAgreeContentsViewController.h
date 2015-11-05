//
//  SHBCardSSOAgreeContentsViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 17..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBCardSSOAgreeViewController.h"

@interface SHBCardSSOAgreeContentsViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UIView *contentsPView;
@property(nonatomic, retain) IBOutlet UIView *contents1View;
@property(nonatomic, retain) IBOutlet UIView *contents2View;
//@property(nonatomic, retain) SHBCardSSOAgreeViewController *superViewController;

@property(nonatomic, retain) IBOutlet UIButton* useSSOAgree; // 2. 필수적 정보

@property(nonatomic, retain) IBOutlet UIButton* useEssentialCollection; // 1. 필수적 정보
@property(nonatomic, retain) IBOutlet UIButton* useEssentialCollectionNone; // 1. 필수적 정보

@property(nonatomic, retain) IBOutlet UIButton* noEssentialCollection; // 2. 선택적 정보
@property(nonatomic, retain) IBOutlet UIButton* noEssentialCollectionNone; // 2. 선택적 정보

@property(nonatomic, retain) IBOutlet UIButton* usePersonalInfoAgree; // 3. 필수적 정보
@property(nonatomic, retain) IBOutlet UIButton* usePersonalInfoAgreeNone; // 3. 필수적 정보


-(IBAction)okBtn:(id)sender;
-(IBAction)cancelBtn:(id)sender;
-(IBAction)checkBtn:(UIButton *)sender;
-(IBAction)personalAgreeInfoBtn:(id)sender;
@end
