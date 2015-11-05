//
//  SHBELD_BA17_7ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 28..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > BA17-7

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBELD_BA17_7ViewController : SHBBaseViewController
{
    NSArray *_collections;      // Q1~Q9 컬렉션 리스트
    BOOL _isReadStipulation;    // 개인(신용)정보 수집, 이용 동의서를 읽었는지에 대한 유/무
    BOOL _isShowStipulation;    // 개인신용정보동의 뷰 표시 유/무
    BOOL _isResult;             // 고객성향에 따른, 다음 페이지 이동에 사용하는 Flag(BA17_8-1 : NO, BA17_8-2 : YES)
    BOOL _isMarketingAgree;     // 마케팅 활용 동의 유/무
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView1;                   // 스크롤 뷰
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection1;    // Q1 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection2;    // Q2 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection3;    // Q3 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection4;    // Q4 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection5;    // Q5 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection6;    // Q6 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection7;    // Q7 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection8;    // Q8 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection9;    // Q9 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection10;   // 개인신용정보동의 필수적정보 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection11;   // 개인신용정보동의 선택적정보 컬렉션
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *collection12;   // 개인신용정보동의 고유식별정보 컬렉션
@property (nonatomic, retain) IBOutlet UIView *view1;                               // 투자성향분석 뷰
@property (nonatomic, retain) IBOutlet UIView *view2;                               // 개인신용정보동의 뷰
@property (retain, nonatomic) IBOutlet UIView *view3;                               // 골드에서 사용하는 고객권리안내문
@property (retain, nonatomic) IBOutlet UIView *part5View;
@property (retain, nonatomic) IBOutlet UILabel *part2Q3BtnLabel1;
@property (retain, nonatomic) IBOutlet UILabel *part2Q3BtnLabel2;
@property (retain, nonatomic) IBOutlet UILabel *part2Q3BtnLabel3;
@property (retain, nonatomic) IBOutlet UILabel *part2Q3BtnLabel4;
@property (retain, nonatomic) IBOutlet UILabel *part2Q3BtnLabel5;

@property (nonatomic, retain) NSMutableDictionary *viewDataSource;                  // 뷰 - 데이타 소스

- (IBAction)buttonDidPush:(id)sender;

@end
