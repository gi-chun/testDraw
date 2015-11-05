//
//  SHBSurchargeSecurityViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 19..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"


@interface SHBSurchargeSecurityViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    IBOutlet UIView             *realView;          // 실제 view
    IBOutlet UIView             *secretView;        // 보안관련 view
    
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
    
    IBOutlet UILabel        *label1;            // 플랜명
    IBOutlet UILabel        *label2;            // 퇴직연금계좌번호
    IBOutlet UILabel        *label3;            // 출금계좌번호
    IBOutlet UILabel        *label4;            // 이체금액
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

@end
