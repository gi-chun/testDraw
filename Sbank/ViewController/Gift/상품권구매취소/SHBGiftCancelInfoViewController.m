//
//  SHBGiftCancelInfoViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelInfoViewController.h"
#import "SHBGiftService.h" // 서비스
#import "SHBGiftCancelListCell.h" // cell
#import "SHBListPopupView.h" // list popup

#import "SHBGiftCancelListViewController.h" // 상품권 목록
#import "SHBGiftCancelSearchViewController.h" // 건별 조회

@interface SHBGiftCancelInfoViewController () <SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *accountList; // 입금계좌번호
@property (retain, nonatomic) NSMutableDictionary *selectAccountDic; // 선택한 입금계좌번호

@end

@implementation SHBGiftCancelInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"모바일상품권 구매취소"];
    self.strBackButtonTitle = @"모바일상품권 구매취소 취소할 상품권 안내";
    
    self.accountList = [self outAccountList];
    
    if ([_accountList count] == 0) {
        
        [_accountBtn setEnabled:NO];
        [_accountBtn setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        [_accountBtn setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateHighlighted];
        [_accountBtn setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateSelected];
        [_accountBtn setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountList = nil;
    self.selectAccountDic = nil;
    
    [_accountBtn release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAccountBtn:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 건별조회
            
            SHBGiftCancelSearchViewController *viewController = [[[SHBGiftCancelSearchViewController alloc] initWithNibName:@"SHBGiftCancelSearchViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 200: {
            
            // 계좌번호
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"본인계좌"
                                                                          options:_accountList
                                                                          CellNib:@"SHBAccountListPopupCell"
                                                                            CellH:50
                                                                      CellDispCnt:5
                                                                       CellOptCnt:4];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 300: {
            
            // 확인
            
            if (!_selectAccountDic ||
                [_accountBtn.titleLabel.text length] == 0 ||
                [_accountBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"조회할 출금계좌번호를 선택해 주세요."];
                return;
            }
            
            SHBGiftCancelListViewController *viewController = [[[SHBGiftCancelListViewController alloc] initWithNibName:@"SHBGiftCancelListViewController" bundle:nil] autorelease];
            
            viewController.selectAccountDic = _selectAccountDic;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectAccountDic = _accountList[anIndex];
    
    [_accountBtn setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
    [_accountBtn setTitle:_selectAccountDic[@"2"] forState:UIControlStateHighlighted];
    [_accountBtn setTitle:_selectAccountDic[@"2"] forState:UIControlStateSelected];
    [_accountBtn setTitle:_selectAccountDic[@"2"] forState:UIControlStateDisabled];
}

@end
