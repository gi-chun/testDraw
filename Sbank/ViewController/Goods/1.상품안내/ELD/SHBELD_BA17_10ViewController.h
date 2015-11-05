//
//  SHBELD_BA17_10ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > BA17-10

#import <UIKit/UIKit.h>
#import "SHBAttentionLabel.h"

@interface SHBELD_BA17_10ViewController : SHBBaseViewController

@property (retain, nonatomic) NSMutableDictionary *viewDataSource;

@property (retain, nonatomic) IBOutlet UIButton *agree; // 예, 동의합니다.
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *contentLabel; // 내용
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *goldInfoView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *goldInfoLabel;

- (IBAction)buttonDidPush:(id)sender;   // 하단 버튼 - 액션

@end
