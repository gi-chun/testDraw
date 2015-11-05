//
//  SHBSecurityCardViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"


@interface SHBSecurityCardViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    IBOutlet UIScrollView       *scrollView1;
    IBOutlet UIView             *realView;          // 실제 view
    IBOutlet UIView             *infoView;          // 정보 view
    IBOutlet UIView             *secretView;        // 보안관련 view
    
    IBOutlet UILabel        *label1;        // 지로번호
    IBOutlet UILabel        *label2;        // 전자납부번호
    IBOutlet UILabel        *label3;        // 청구기관명
    IBOutlet UILabel        *label4;        // 고객조회번호
    IBOutlet UILabel        *label5;        // 납부자명
    IBOutlet UILabel        *label6;        // 납부금액
    IBOutlet UILabel        *label7;        // 고지형태
    IBOutlet UILabel        *label8;        // 부과연월
    IBOutlet UILabel        *label9;        // 납부기한
    IBOutlet UILabel        *label10;       // 출금계좌번호
    
    SHBSecretCardViewController     *secretcardView;
    SHBSecretOTPViewController      *secretotpView;
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


@end
