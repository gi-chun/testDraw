//
//  SHBCancelCompleteViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCancelCompleteViewController : SHBBaseViewController
{
    IBOutlet UILabel        *label1;        // 납부일
    IBOutlet UILabel        *label2;        // 출금계좌번호
    IBOutlet UILabel        *label3;        // 청구기관명
    IBOutlet UILabel        *label4;        // 지로번호
    IBOutlet UILabel        *label5;        // 납부금액
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;

@end
