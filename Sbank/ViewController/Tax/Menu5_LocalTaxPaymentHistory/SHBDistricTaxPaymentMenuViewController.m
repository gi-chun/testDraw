//
//  SHBDistricTaxPaymentMenuViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBDistricTaxPaymentMenuViewController.h"
#import "SHBDistricTaxPaymentListViewController.h"      // 지방세 납부내역 목록


@interface SHBDistricTaxPaymentMenuViewController ()

@end

@implementation SHBDistricTaxPaymentMenuViewController
@synthesize outAccInfoDic;

#pragma mark -
#pragma mark Button Action

- (IBAction)buttonDidPush:(id)sender
{
    // 조회구분선택에 따른 분기 필요
    NSMutableDictionary     *dicSelectedDistric = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString    *strSelectedDistric = @"NEW";
    
    switch ([sender tag])
    {
        case 112100:    // 계좌번호
        {
            serviceType = 0;
            
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountList];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"해당 계좌가 없습니다.\n다시 확인해 주세요."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"계좌번호선택" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 11:
        {
            NSMutableArray *tableDataArray = [self outAccountList];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"해당 계좌가 없습니다.\n다시 확인해 주세요."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            // 조회구분에 따른 분기 필요
            if(((UIButton*)[self.view viewWithTag:12]).selected == YES)
            {
                strSelectedDistric = @"BEFORE";
            }
             NSString *strOutAccNo = [_btnAccountNo.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [dicSelectedDistric setObject:strSelectedDistric forKey:@"조회구분선택"];
            
            SHBDistricTaxPaymentListViewController  *viewController = [[SHBDistricTaxPaymentListViewController alloc] initWithNibName:@"SHBDistricTaxPaymentListViewController" bundle:nil];
            
            [dicSelectedDistric setObject:strOutAccNo forKey:@"계좌번호"];
            [viewController setData:dicSelectedDistric];
            
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
            

            
        default:
            break;
    }
    
    [dicSelectedDistric release];
}

- (IBAction)checkButtonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 11:
        {
            ((UIButton*)[self.view viewWithTag:11]).selected = YES;
            ((UIButton*)[self.view viewWithTag:12]).selected = NO;
        }
            break;
            
        case 12:
        {
            ((UIButton*)[self.view viewWithTag:11]).selected = NO;
            ((UIButton*)[self.view viewWithTag:12]).selected = YES;
        }
            break;
            
        default:
            break;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"지방세납부내역조회";
    self.strBackButtonTitle = @"지방세 납부내역 조회 메인";
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
       // _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
       // _btnAccountNo.accessibilityHint = @"계좌번호를 바꾸시려면 이중탭 하십시오";
    }
    else
    {
        [_btnAccountNo setTitle:@"계좌정보가 없습니다." forState:UIControlStateNormal];
        _btnAccountNo.enabled = NO;
    }
    
}


#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    switch (serviceType) {
        case 0:
        {
            _btnAccountNo.selected = NO;
            self.outAccInfoDic = self.dataList[anIndex];
            [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
            //_btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 출금계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
           // _btnAccountNo.accessibilityHint = @"출금계좌번호를 바꾸시려면 이중탭 하십시오";
            
            
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.btnAccountNo);
        }
            break;
            
            
        default:
            break;
    }
}
            
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
