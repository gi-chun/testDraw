//
//  SHBAccountMenuListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBAccountMenuListViewController : SHBBaseViewController <UIGestureRecognizerDelegate>
{
    SHBAccountService *service;
    
    IBOutlet UIView     *view1;         // 전체계좌가 나타날 view
    IBOutlet UIView     *view2;         // 전체계좌 내용이 들어갈 view
    IBOutlet UIScrollView       *scrollView1;   // 전체계좌 scrollView
    
    IBOutlet UIView     *viewTable1;            // 입/출금 view
    IBOutlet UIView     *viewTable2;            // 정기/적금/신탁 view
    IBOutlet UIView     *viewTable3;            // 펀드 view
    IBOutlet UIView     *viewTable4;            // 대출 view
    IBOutlet UIView     *viewTable5;            // 외화 view
    IBOutlet UIView     *viewTable6;            // 골드 view
    
    IBOutlet UITableView        *table1;        // 입/출금 tableView
    IBOutlet UITableView        *table2;        // 정기/적금/신탁 tableView
    IBOutlet UITableView        *table3;        // 펀드 tableView
    IBOutlet UITableView        *table4;        // 대출 tableView
    IBOutlet UITableView        *table5;        // 외화 tableView
    IBOutlet UITableView        *table6;        // 골드 tableView
    
    IBOutlet UILabel            *label1;        // 입/출금 총 금액
    IBOutlet UILabel            *label2;        // 정기/적금/신탁 총금액
    IBOutlet UILabel            *label3;        // 펀드 총금액
    IBOutlet UILabel            *label4;        // 대출 총 금액
    
    IBOutlet UILabel            *labelNoAccount;  // 전체계좌 계좌 없을 시
    IBOutlet UIView             *dormantAccountView;  // 휴면예금조회 버튼 view
    IBOutlet UIView             *dormantAccountHeaderView; // 휴면예금 탭시 상단뷰
}
@property (retain, nonatomic) SHBAccountService *service;
@property (retain, nonatomic) IBOutlet UIView *menuView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *btnMenu;
@property (retain, nonatomic) IBOutlet UIButton *btnPrevMenu;
@property (retain, nonatomic) IBOutlet UIButton *btnNextMenu;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIView *tableFooterView;

@property (nonatomic, retain) NSMutableArray   *array1;        // 입/출금
@property (nonatomic, retain) NSMutableArray   *array2;        // 정기적금신탁
@property (nonatomic, retain) NSMutableArray   *array3;        // 펀드
@property (nonatomic, retain) NSMutableArray   *array4;        // 대출
@property (nonatomic, retain) NSMutableArray   *array5;        // 외화
@property (nonatomic, retain) NSMutableArray   *array6;        // 골드

- (IBAction)changeMenu:(UIButton *)sender;
- (IBAction)selectMenu:(UIButton *)sender;

- (void)expiryPopupClose;

@end
