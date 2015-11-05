//
//  SHBAccidentSelfCheckCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 고객센터 - 사고신고
 자기앞수표 사고신고 완료 화면
 */

@interface SHBAccidentSelfCheckCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel1;
@property (retain, nonatomic) IBOutlet UIImageView *infoImage2;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel2;
@property (retain, nonatomic) IBOutlet UIImageView *infoImage3;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel3;
@property (retain, nonatomic) IBOutlet UIImageView *bgBox;
@property (retain, nonatomic) IBOutlet SHBButton *ok; // 확인

@end
