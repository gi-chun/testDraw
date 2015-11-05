//
//  SHBLoanAccountListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanAccountListViewController.h"
#import "SHBLoanTransLimitedListViewController.h"
#import "SHBLoanCommonViewController.h"
#import "SHBInterestInqueryViewController.h"
#import "SHBLoanCommonInterestViewController.h"
#import "SHBLoanRePayInqueryViewController.h"
#import "SHBLoanCancelViewController.h"
#import "SHBAccountListCell.h"

@interface SHBLoanAccountListViewController ()
{
    int openedRow;
    NSString *strLoanAccNo;
}
@end

@implementation SHBLoanAccountListViewController
@synthesize tableView1;

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.dataList = [aDataSet arrayWithForKey:@"대출계좌목록"];
    
    if([self.dataList count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"대출 계좌가 없습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        [alert release];
        
        return NO;
    }
    _lblData01.text = [NSString stringWithFormat:@"%@원", aDataSet[@"대출총금액"]];
    [tableView1 setTableFooterView:_tableFooterView];
    [tableView1 reloadData];
    
    self.service = nil;
    
    if(self.isPushAndScheme && ![strLoanAccNo isEqualToString:@""])
    {
        for(NSDictionary *dictionary in self.dataList)
        {
            if([[dictionary[@"대출계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strLoanAccNo] ||
               [[dictionary[@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:strLoanAccNo])
            {
                self.isPushAndScheme = NO;
                if ([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
                {
                    SHBLoanCommonInterestViewController *nextViewController = [[[SHBLoanCommonInterestViewController alloc] initWithNibName:@"SHBLoanCommonInterestViewController" bundle:nil] autorelease];
                    nextViewController.accountInfo = dictionary;
                    [self.navigationController pushFadeViewController:nextViewController];
                }
                else
                {
                    SHBInterestInqueryViewController *nextViewController = [[[SHBInterestInqueryViewController alloc] initWithNibName:@"SHBInterestInqueryViewController" bundle:nil] autorelease];
                    nextViewController.accountInfo = dictionary;
                    [self.navigationController pushFadeViewController:nextViewController];
                }
                
            }
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
	if (alertView.tag == 100 && buttonIndex == 0) {
        [self.navigationController fadePopViewController];
	}
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(openedRow == indexPath.row){
        return 124;
    }
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBAccountListCell *cell = (SHBAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAccountListCell *)currentObject;
                break;
            }
        }
        
        cell.btnOpen.frame = CGRectMake(275, 9, 42, 42);
        cell.amount.frame =  CGRectMake(8, 58, 301, 19);
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

    }
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];
    
    cell.accountName.text = [dictionary[@"대출상품명"] isEqualToString:@""] ? dictionary[@"대출과목명"] : dictionary[@"대출상품명"];
    cell.accountNo.text = [dictionary[@"신계좌변환여부"] isEqualToString:@"1"] ? dictionary[@"대출계좌번호"] : dictionary[@"구계좌번호"];
    cell.amount.text = [NSString stringWithFormat:@"%@원", dictionary[@"대출잔액"]];
    cell.amount.textColor = RGB(44, 44, 44);
    cell.row = indexPath.row;
    cell.target = self;
    cell.pSelector = @selector(cellButtonClick:);
    
    if(openedRow == indexPath.row){
        cell.bgView.backgroundColor = RGB(244, 244, 244);
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기 닫기";
        cell.btnLeft.hidden = NO;
        [cell.btnLeft setTitle:@"조회" forState:UIControlStateNormal];
        cell.btnCenter.hidden = NO;
        [cell.btnCenter setTitle:@"이자납입" forState:UIControlStateNormal];
        
        if([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
        {
            cell.btnRight.hidden = NO;
            [cell.btnRight setTitle:@"상환" forState:UIControlStateNormal];
        }
        else if([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] < 150)
        {
            cell.btnRight.hidden = NO;
            [cell.btnRight setTitle:@"한도해지" forState:UIControlStateNormal];
        }
        else
        {
            cell.btnRight.hidden = YES;
        }
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, cell.btnLeft);
        }
    }else{
        cell.bgView.backgroundColor = [UIColor clearColor];
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기 열기";
        cell.btnLeft.hidden = YES;
        cell.btnCenter.hidden = YES;
        cell.btnRight.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    if(!(indexPath.row == openedRow))
    {
        openedRow = -1;
    }
    [tableView1 reloadData];
    
    NSLog(@"%d", [[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue]);
    
    if ([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
    {
        SHBLoanCommonViewController *nextViewController = [[[SHBLoanCommonViewController alloc] initWithNibName:@"SHBLoanCommonViewController" bundle:nil] autorelease];
        nextViewController.accountInfo = dictionary;
        [self.navigationController pushFadeViewController:nextViewController];
    }
    else
    {
        SHBLoanTransLimitedListViewController *nextViewController = [[[SHBLoanTransLimitedListViewController alloc] initWithNibName:@"SHBLoanTransLimitedListViewController" bundle:nil] autorelease];
        nextViewController.accountInfo = dictionary;
        [self.navigationController pushFadeViewController:nextViewController];
    }
}

- (void)cellButtonClick:(NSDictionary *)dic
{
    int row = [dic[@"Index"] intValue];
    
    NSDictionary *dictionary = self.dataList[row];
    
    switch ([dic[@"Button"] tag]) {
        case 2000:
        {
            if(openedRow == row)
            {
                openedRow = -1;
            }
            else
            {
                openedRow = row;
            }
            [tableView1 reloadData];
        }
            break;
        case 2001:  // 조회
        {
            if ([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
            {
                SHBLoanCommonViewController *nextViewController = [[[SHBLoanCommonViewController alloc] initWithNibName:@"SHBLoanCommonViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                [self.navigationController pushFadeViewController:nextViewController];
            }
            else
            {
                SHBLoanTransLimitedListViewController *nextViewController = [[[SHBLoanTransLimitedListViewController alloc] initWithNibName:@"SHBLoanTransLimitedListViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 2002:  // 이자
        {
            if ([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
            {
                SHBLoanCommonInterestViewController *nextViewController = [[[SHBLoanCommonInterestViewController alloc] initWithNibName:@"SHBLoanCommonInterestViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                [self.navigationController pushFadeViewController:nextViewController];
            }
            else
            {
                SHBInterestInqueryViewController *nextViewController = [[[SHBInterestInqueryViewController alloc] initWithNibName:@"SHBInterestInqueryViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                [self.navigationController pushFadeViewController:nextViewController];
            }
        }
            break;
        case 2003:  // 상환  // 150미만은 한도해지
        {
            if ([[dictionary[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] < 150)
            {
                
                SHBLoanCancelViewController *nextViewController = [[[SHBLoanCancelViewController alloc] initWithNibName:@"SHBLoanCancelViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                nextViewController.needsCert = YES;
                [self checkLoginBeforePushViewController:nextViewController animated:YES];

            }
            
            else
            {
                SHBLoanRePayInqueryViewController *nextViewController = [[[SHBLoanRePayInqueryViewController alloc] initWithNibName:@"SHBLoanRePayInqueryViewController" bundle:nil] autorelease];
                nextViewController.accountInfo = dictionary;
                nextViewController.needsCert = YES;
                [self checkLoginBeforePushViewController:nextViewController animated:YES];
            }

            
        }
            break;
            
        default:
            break;
    }
}

- (void)refresh
{
    openedRow = -1;
    
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L0010" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
}

#pragma mark - Push
- (void)executeWithDic:(NSMutableDictionary *)mDic	// 푸쉬로 왔으면
{
	[super executeWithDic:mDic];
	if (mDic) {
        strLoanAccNo = mDic[@"loanAccNo"] == nil ? @"" : [mDic[@"loanAccNo"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
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

    self.title = @"대출조회납입상환";
    self.strBackButtonTitle = @"대출계좌조회";

    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tableView1 release];
    [_tableFooterView release];
    [_lblData01 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView1:nil];
    [self setTableFooterView:nil];
    [self setLblData01:nil];
    [super viewDidUnload];
}
@end
