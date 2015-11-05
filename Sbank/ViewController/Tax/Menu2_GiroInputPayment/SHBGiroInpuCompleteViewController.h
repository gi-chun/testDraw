//
//  SHBGiroInpuCompleteViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBGiroInpuCompleteViewController : SHBBaseViewController
{
    IBOutlet UILabel        *labelChanged;  // 고객조회,납부자확인 변경
    
    IBOutlet UILabel        *label1;        // 지로번호
    IBOutlet UILabel        *label2;        // 청구기관명
    IBOutlet UILabel        *label3;        // 고객조회번호(납부자확인번호)
    IBOutlet UILabel        *label4;        // 납부금액
    IBOutlet UILabel        *label5;        // 납부연월
    IBOutlet UILabel        *label6;        // 금액검증번호
    IBOutlet UILabel        *label7;        // 출금계좌번호
    IBOutlet UILabel        *label8;        // 납부자명
    IBOutlet UILabel        *label9;        // 전화번호
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;

@end
