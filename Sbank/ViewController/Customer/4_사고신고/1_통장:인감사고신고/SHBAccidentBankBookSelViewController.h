//
//  SHBAccidentBankBookSelViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 고객센터 - 사고신고
 통장/인감 사고신고 화면
 */

@protocol SHBAccidentBankBookSelViewControllerDelegate <NSObject>

- (void)accidentBankBookSelCancel;

@end

@interface SHBAccidentBankBookSelViewController : SHBBaseViewController

@property (assign, nonatomic) id<SHBAccidentBankBookSelViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *bankbook; // 통장
@property (retain, nonatomic) IBOutlet UIButton *seal; // 인감
@end
