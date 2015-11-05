//
//  SHBCertMovePhoneViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCertMovePhoneViewController : SHBBaseViewController
{
    NSTimer *limtTimer;
    NSTimer *timer;
    //NSString *authcode;
}
@property (retain, nonatomic) NSTimer *limtTimer;
@property (retain, nonatomic) NSTimer *timer;

@property (retain, nonatomic) IBOutlet UILabel *info1Label;
@property (retain, nonatomic) IBOutlet UITextField *firstAuthCode;
@property (retain, nonatomic) IBOutlet UITextField *secondAuthCode;
@property (nonatomic, retain) NSString *authcode;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressActive;

/**
 최초 실행되어 로그인 설정 단계인지...
 */
@property (nonatomic, assign) BOOL isFirstLoginSetting;
@end
