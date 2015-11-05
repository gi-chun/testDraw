//
//  SHBFindBranchesLocationViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > 위치기반 영업점/ATM 찾기 > 영업점/ATM 검색
 영업점/ATM > 대기고객 조회
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBPopupView.h"
#import "SHBBranchesWaitingPeopleViewController.h"

@interface SHBFindBranchesLocationViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate, SHBPopupViewDelegate, FavoriteBranchesProtocol>
{
    BOOL _isFavoriteBranchShow; // 자주찾는등록지점 리스트를 보여주는지 여부
    SHBPopupView *_popupView;   // 자주찾는지점안내 팝업
}

/**
 영업점/ATM 검색 or 대기고객조회
 */
@property (nonatomic, retain) NSString *strMenuTitle;

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *bodyView;

@property (retain, nonatomic) IBOutlet SHBTextField *tfSearchWord;
@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UIButton *button1;           // 자주 찾는 지점 버튼
@property (nonatomic, retain) IBOutlet UIView *view1;               // 자주 찾는 지점 안내 팝업

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)searchBtnAction:(UIButton *)sender;
- (IBAction)buttonDidPush:(id)sender;               // 자주 찾는 지점 버튼 액션 이벤트 처리


@end
