//
//  SHBSimpleDistricTaxCompleteViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 21..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSimpleDistricTaxCompleteViewController : SHBBaseViewController
{
    IBOutlet UIView             *view1;             // 납기내 금액 BG
    IBOutlet UIView             *view2;             // 납기후 금액 BG
    
    IBOutlet UILabel        *label1;        // 납부자 정보
    IBOutlet UILabel        *label2;        // 세목명
    IBOutlet UILabel        *label3;        // 전자납부번호
//    IBOutlet UILabel        *label4;        // 과세표준금액
//    IBOutlet UILabel        *label5;        // 과세대상
    IBOutlet UILabel        *label6;        // 납기내날짜
    IBOutlet UILabel        *label7;        // 납기후날짜
    IBOutlet UILabel        *label8;        // 납부금액
    IBOutlet UILabel        *label9;        // 출금계좌번호
    IBOutlet UILabel        *label10;        // 납부일
}

// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


- (IBAction)buttonDidPush:(id)sender;


@end
