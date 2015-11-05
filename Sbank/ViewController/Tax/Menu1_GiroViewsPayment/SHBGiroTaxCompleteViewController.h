//
//  SHBGiroTaxCompleteViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBGiroTaxCompleteViewController : SHBBaseViewController
{
    IBOutlet UILabel        *label1;        // 지로번호
    IBOutlet UILabel        *label2;        // 전자납부번호
    IBOutlet UILabel        *label3;        // 청구기관명
    IBOutlet UILabel        *label4;        // 고객조회번호
    IBOutlet UILabel        *label5;        // 납부자명
    IBOutlet UILabel        *label6;        // 납부금액
    IBOutlet UILabel        *label7;        // 고지형태
    IBOutlet UILabel        *label8;        // 부과연월
    IBOutlet UILabel        *label9;        // 납부기한
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

- (IBAction)buttonDidPush:(id)sender;

@end
