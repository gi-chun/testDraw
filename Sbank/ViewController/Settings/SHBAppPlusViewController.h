//
//  SHBAppPlusViewController.h
//  ShinhanBank
//
//  Created by 인성 여 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 앱더보기 화면
 */

#import "SHBBaseViewController.h"



@interface SHBAppPlusViewController : SHBBaseViewController{
    
    UIButton *btn_plus1;
    UIButton *btn_plus2;
    UIButton *btn_plus3;
    UIButton *btn_plus4;

    UIScrollView    *sv_main;
    NSArray         *catBtnArr;     //카테고리 버튼 저장(selected상태변경용)
    NSMutableArray  *categoryArr;   //카테고리 정보 저장
    NSMutableArray  *appListArr;    //카테고리순서별 어플 정보 정리
    NSMutableArray  *ListArr;    //카테고리순서별 어플 정보 정리
    NSMutableDictionary *iconImageDic;  //아이콘 이미지 저장(app_id, image)
    NSMutableDictionary *ListDic;
    NSInteger           selectedCatNum;
    NSInteger           selectedNoticeNum;
    
    NSString *apptitle;

    IBOutlet UIView			*btmView;
}

@property (retain, nonatomic) IBOutlet UIButton *btn_plus1;
@property (retain, nonatomic) IBOutlet UIButton *btn_plus2;
@property (retain, nonatomic) IBOutlet UIButton *btn_plus3;
@property (retain, nonatomic) IBOutlet UIButton *btn_plus4;
@property (retain, nonatomic) IBOutlet UIScrollView *sv_main;

/**
 닫기 버튼 액션
 */
- (IBAction)closeBtnAction:(UIButton *)sender;



- (IBAction)buttonTouchUpInside:(id)sender;
//- (void) btnGroupSelect:(NSInteger)num;
- (void)requestAppList;



//- (void) setCartegoryView;
//- (void) setCartegoryList;

- (void) scrollViewDraw:(NSString *)title;

- (void) cleanScrollView;
//- (void) setCurrentPageIndicate:(NSInteger)currentPage;

@end

