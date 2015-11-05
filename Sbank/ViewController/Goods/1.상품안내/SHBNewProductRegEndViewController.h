//
//  SHBNewProductRegEndViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 상품안내 상세 > 가입 > 약관 > 가입입력 > 세금우대 > 가입확인 > 가입완료
 */

#import "SHBBaseViewController.h"
#import "SHBTickerView.h"
#import "SHBAttentionLabel.h"


@interface SHBNewProductRegEndViewController : SHBBaseViewController
{
    NSArray  *tickArray;
    IBOutlet SHBTickerView	*_tickerView;
    IBOutlet UIButton *_bannerMainBtn1;
   // IBOutlet UIButton *_bannerMainBtn2;
    
    IBOutlet UIView *_bannerView;
    IBOutlet UIButton *_bannerListBtn;
   // IBOutlet UIView *_bannerScrollContentsView;
   // IBOutlet UIScrollView *_bannerScrollView;
   // IBOutlet UIButton *_bannerScrollBtn1;
   // IBOutlet UIButton *_bannerScrollBtn2;

    
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

/**
 가입완료 후 받아온 데이터 (D3604)
 */
@property (nonatomic, retain) NSMutableDictionary *completeData;


//재형저축 안내문구
@property (retain, nonatomic) IBOutlet UIView     *viewTaxBreak;


//올레티커 안내문구
@property (retain, nonatomic) IBOutlet UIView     *viewTicker;

//티커정보
@property (nonatomic, retain) OFDataSet *xda_Ticker;

// 스마트이체 안내 화면
@property (retain, nonatomic) IBOutlet UIView *smartTransferView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *smartTransferInfo;

/**
 확인 버튼을 감싸는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *bottomBackView;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
