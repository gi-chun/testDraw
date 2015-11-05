//
//  SHBSurchargeCompleteViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 23..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSurchargeCompleteViewController : SHBBaseViewController
{
    IBOutlet UILabel        *label1;        // 플랜명
    IBOutlet UILabel        *label2;        // 퇴직연금 입금계좌번호
    IBOutlet UILabel        *label3;        // 출금계좌번호
    IBOutlet UILabel        *label4;        // 이체금액
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;

@end
