//
//  SHBNotiChangeViewControllerForDB.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBNotiChangeViewControllerForDB : SHBBaseViewController
{
    IBOutlet UIView             *viewPopupView;         // popupview
    IBOutlet UIScrollView       *scrollView1;           // popup의 scrollView
    IBOutlet UIView             *viewPopDetailView;     // popup안의 scroll되는 view
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;
- (IBAction)checkButtonDidPush:(id)sender;


@end
