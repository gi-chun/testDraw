//
//  SHBAccidentSecCardCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 고객센터 - 사고신고
 보안카드 사고신고 완료 화면
 */

@interface SHBAccidentSecCardCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UILabel *info;
@property (retain, nonatomic) IBOutlet UIImageView *bgBox;
@property (retain, nonatomic) IBOutlet SHBButton *ok; // 확인
@end
