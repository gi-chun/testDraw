//
//  SHBELD_BA17_5ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 24..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > BA17-5-1, BA17-5-2, BA17-5-3, BA17-5-4, BA17-6-1, BA17-6-2, BA17-8-1, BA17-8-2 (공통)

#import <UIKit/UIKit.h>
#import "SHBAttentionLabel.h"

@interface SHBELD_BA17_5ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView1;           // 스크롤 뷰
@property (nonatomic, retain) IBOutlet UIView *contentView1;                // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UIView *view1;                       // 선택상품 뷰
@property (nonatomic, retain) IBOutlet UIView *view2;                       // BA17-5-1, BA17-5-2 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view3;                       // BA17-5-3 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view4;                       // BA17-5-4 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view5;                       // BA17-6-1 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view6;                       // BA17-6-2 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view7;                       // BA17-8-1 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIView *view8;                       // BA17-8-2 선택상품 설명 뷰
@property (nonatomic, retain) IBOutlet UIImageView *imageView1;             // BA17-5-3 선택상품 설명 이미지
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;             // BA17-5-4 선택상품 설명 이미지
@property (nonatomic, retain) IBOutlet UIImageView *imageView3;             // BA17-6-1 선택상품 설명 이미지
@property (nonatomic, retain) IBOutlet UIImageView *imageView4;             // BA17-6-2 선택상품 설명 이미지
@property (nonatomic, retain) IBOutlet UIImageView *imageView5;             // BA17-8-1 선택상품 설명 이미지
@property (nonatomic, retain) IBOutlet UIImageView *imageView6;             // BA17-8-2 선택상품 설명 이미지
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *itemNameLabel;    // 상품명
@property (retain, nonatomic) IBOutlet UILabel *infoLabel1;

@property (nonatomic, retain) NSMutableDictionary *viewDataSource;  // 뷰 - 데이타 소스
@property (retain, nonatomic) NSMutableDictionary *D6011Dic;

- (IBAction)buttonDidPush:(id)sender;                               // 하단 버튼 - 액션

@end
