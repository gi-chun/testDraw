//
//  SHBBranchesWaitingPeopleViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@protocol FavoriteBranchesProtocol <NSObject>

- (void)favoriteBranchesReloadData; // 자주찾는지점 등록, 삭제 시 갱신 요청

@end

@interface SHBBranchesWaitingPeopleViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    BOOL _isFavoriteBranch; // 자주찾는지점등록 여부 (NO:기본값, YES:등록)
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UILabel *lblBranchName;
@property (retain, nonatomic) IBOutlet UILabel *lblTotalWaiting;
@property BOOL showLocationBtn;
@property (retain, nonatomic) IBOutlet SHBButton *btnLocation;
@property (retain, nonatomic) IBOutlet UIImageView *ivBox;
@property (nonatomic, retain) NSDictionary *dicSelectedData;
@property (nonatomic, retain) IBOutlet UIButton *button1;               // 자주찾는지점삭제 버튼
@property (nonatomic, assign) id<FavoriteBranchesProtocol> delegate;    // 자주찾는지점 등록, 삭제 시 변경된 내용에 대한 알림용 델리게이트

- (IBAction)locationBtnAction:(SHBButton *)sender;
- (IBAction)callBtnAction:(SHBButton *)sender;
- (IBAction)buttonDidPush:(id)sender;               // 자주찾는지점등록, 삭제 버튼 액션 이벤트 처리

@end
