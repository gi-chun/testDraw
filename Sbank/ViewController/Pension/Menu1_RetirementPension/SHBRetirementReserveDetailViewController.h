//
//  SHBRetirementReserveDetailViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 13..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBRetirementReserveDetailViewController : SHBBaseViewController
{
    IBOutlet UIScrollView       *scrollView1;
    IBOutlet UIView             *viewRealView;
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

- (IBAction)buttonDidPush:(id)sender;

@end
