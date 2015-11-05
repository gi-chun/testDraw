//
//  SHBNotiChangeViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBNotiChangeViewController : SHBBaseViewController
{
    IBOutlet UIScrollView       *scrollView1;           // view의 scrollView
    IBOutlet UIView             *viewRealView;          // 실제 view
    
    IBOutlet UIView             *viewPopupView;         // popupview
    IBOutlet UIScrollView       *scrollView2;           // popup의 scrollView
    IBOutlet UIView             *viewPopDetailView;     // popup안의 scroll되는 view
    
    NSString                    *strRadioButton1;       // 첫번째 라디오 값
    NSString                    *strRadioButton2;       // 두번째 라디오 값
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;
- (IBAction)checkButtonDidPush:(id)sender;
- (IBAction)radioButtonDidPush:(id)sender;


@end
