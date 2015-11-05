//
//  SHBNoticeCuponEndViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 14..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBNoticeCuponEndViewController : SHBBaseViewController
{
    
    // type A
    IBOutlet UILabel        *L_name;        // 상품명
    IBOutlet UILabel        *L_money;        // 금액
    IBOutlet UILabel        *L_month;        // 기간
    IBOutlet UILabel        *L_online;        // 온라인금리
    IBOutlet UILabel        *L_date;        // 날짜
    IBOutlet UILabel        *L_note;        // 재예치불가 문구
    
    
    //type B
    IBOutlet UILabel        *B_turn;        //  회전기간
    IBOutlet UILabel        *B_online;        // 온라인금리
    IBOutlet UILabel        *B_date;        // 날짜

    
}
@property (retain, nonatomic) NSMutableDictionary *selectCouponDic; // 선택한 쿠폰
@property (nonatomic, retain) IBOutlet UIView *contentsView;                     // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UIView *view1;                            // 계약기간 
@property (nonatomic, retain) IBOutlet UIView *view2;                            // 회전기간
@property (nonatomic, assign) BOOL isTypeB;                                      // view1 or view2 뷰 표시 여부 플래그 (NO:view1, YES:view2) - 중요!!
// view1 = Type A (신한그린애너지, Mint(온라인전용) 정기예금 금리우대 쿠폰)
// view2 = Type B (Tops회전, U드림회전 정기예끔 금리우대 쿠폰)


- (IBAction)buttonDidPush:(id)sender;
@end
