//
//  SHBNoticeCouponDetailViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNoticeCouponDetailViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIView         *view1;         // 실제 view
    IBOutlet UIView         *view2;         // 설명 view
    
    IBOutlet UIView         *typeView1;         // 환전쿠폰 view
    IBOutlet UIView         *typeView2;         // 금리쿠폰 view
    IBOutlet UIView         *typeView3;         // 고객별 산출금리 쿠폰 view
    IBOutlet UIView         *typeView4;         // 고객별 산출금리 쿠폰 view
    IBOutlet UIView         *typeView5;         // 스마트신규 쿠폰 view
    
    IBOutlet UIScrollView   *scrollView1;
    
    IBOutlet UILabel        *label1;        // 고객성명
    IBOutlet UILabel        *label2;        // 발급점
    IBOutlet UILabel        *label3;        // 유효기간
    IBOutlet UILabel        *label4;        // 환율우대율
    
    IBOutlet UILabel        *g_label1;        // 고객성명 기존 민트쿠폰 
    IBOutlet UILabel        *g_label2;        // 발급점
    IBOutlet UILabel        *g_label3;        // 유효기간

    IBOutlet UILabel        *a_label0;        // 상품명
    IBOutlet UILabel        *a_label1;        // 고객성명  고객특별금리
    IBOutlet UILabel        *a_label2;        // 발급점
    IBOutlet UILabel        *a_label3;        // 유효기간
    
    //IBOutlet UIWebView        *webView1;       // 쿠폰금리웹
    //IBOutlet UIWebView        *webView2;       // 쿠폰금리웹
    IBOutlet SHBWebView        *webView1;       // 쿠폰금리웹
    IBOutlet SHBWebView       *webView2;       // 쿠폰금리웹
    
    IBOutlet UIButton        *btn1;       //환전신청 버튼
    IBOutlet UIButton        *btn2;       //우대금리 조회하기 버튼
    IBOutlet UIButton        *btn3;       //영업점 상담 금리승인 버튼
    
    NSString *strCoupontUrl;
    NSString *strDateResult;

    
}
// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

@end
