//
//  SHBBranchesLocationMapViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

typedef enum
{
	ViewTypeBranch,				// 영업점으로 온 경우
	ViewTypeATM,				// 위치기반 검색에서 ATM으로 온 경우
	ViewTypeATMNoMap,			// 영업점/ATM 검색에서 ATM으로 온 경우
	ViewTypeWaitingPeople,		// 대기고객조회(영업점)로 온 경우
}ViewType;						// 각각 뷰 구성을 조금씩 달리 함.

#import "SHBBaseViewController.h"
#import "KMapView.h"

@interface SHBBranchesLocationMapViewController : SHBBaseViewController <KMapViewDelegate>

@property (nonatomic, retain) NSDictionary *dicSelectedData;
@property ViewType viewType;
@property (retain, nonatomic) IBOutlet UIImageView *ivMapViewBox;
@property (retain, nonatomic) IBOutlet KMapView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *lblBranch;
@property (retain, nonatomic) IBOutlet UILabel *lblAddress;
@property (retain, nonatomic) IBOutlet UILabel *lblTel;
@property (retain, nonatomic) IBOutlet UIView *twoBtnView;
@property (retain, nonatomic) IBOutlet UIView *oneBtnView;

- (IBAction)refreshBtnAction:(UIButton *)sender;
- (IBAction)callBtnAction:(SHBButton *)sender;
- (IBAction)waitingPeopleBtnAction:(SHBButton *)sender;

@end
