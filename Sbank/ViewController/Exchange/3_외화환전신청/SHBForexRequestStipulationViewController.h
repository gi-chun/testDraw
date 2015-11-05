//
//  SHBForexRequestStipulationViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 10. 28..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 외환/골드 - 외화환전신청
 외화환전신청 약관동의 화면
 */

@interface SHBForexRequestStipulationViewController : SHBBaseViewController

@property (retain, nonatomic) NSMutableDictionary *selectCouponDic; // 선택한 쿠폰

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIButton *agree1; // 외횐거래 기본약관 (예, 동의합니다.)
@property (retain, nonatomic) IBOutlet UIButton *agree2; // 유의사항 안내 및 동의 (예, 동의합니다.)
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useEssentialCollection; // 1. 필수적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useSelectCollection; // 1. 선택적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useInherentCollection; // 2. 고유식별정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *provideEssentialCollection; // 3. 필수적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *provideSelectCollection; // 3. 선택적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *provideInherentCollection; // 4. 고유식별정보


@end
