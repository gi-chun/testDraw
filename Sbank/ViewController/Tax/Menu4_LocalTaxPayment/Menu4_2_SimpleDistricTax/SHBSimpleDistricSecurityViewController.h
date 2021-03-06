//
//  SHBSimpleDistricSecurityViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 21..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"


@interface SHBSimpleDistricSecurityViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretcardView;
    SHBSecretOTPViewController *secretotpView;
    
    IBOutlet UIScrollView       *scrollView1;
    
    IBOutlet UIView             *realView;          // 실제 view
    IBOutlet UIView             *infoView;          // 정보 view
    IBOutlet UIView             *secretView;        // 보안관련 view
    
    IBOutlet UIView             *view1;             // 납기내 금액 BG
    IBOutlet UIView             *view2;             // 납기후 금액 BG
    
    IBOutlet UILabel        *label1;        // 납부자 정보
    IBOutlet UILabel        *label2;        // 세목명
    IBOutlet UILabel        *label3;        // 전자납부번호
    IBOutlet UILabel        *label4;        // 납기내납기일
    IBOutlet UILabel        *label5;        // 납기후납기일
    IBOutlet UILabel        *label6;        // 납부금액
}


// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


@end
