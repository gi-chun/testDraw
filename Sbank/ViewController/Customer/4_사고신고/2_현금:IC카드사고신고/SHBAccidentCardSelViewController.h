//
//  SHBAccidentCardSelViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 고객센터 - 사고신고
 현금/IC카드 사고신고 화면
 */

@protocol SHBAccidentCardSelViewControllerDelegate <NSObject>

- (void)accidentCardSelCancel;

@end

@interface SHBAccidentCardSelViewController : SHBBaseViewController

@property (assign, nonatomic) id<SHBAccidentCardSelViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *accident; // 사고신고

@end
