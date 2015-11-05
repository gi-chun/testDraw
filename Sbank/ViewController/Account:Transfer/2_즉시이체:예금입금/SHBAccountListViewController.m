//
//  SHBAccountListViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccountListViewController.h"
#import "SHBAccountListCell.h"
#import "SHBTransferInfoInputViewController.h"
#import "SHBDepositInfoInputViewController.h"
#import "SHBPrimiumInfoViewController.h"
#import "SHBPushInfo.h"

@interface SHBAccountListViewController ()
{
    NSMutableArray *tableDataArray;
}
@property (nonatomic, retain) NSMutableArray *tableDataArray;
@end

@implementation SHBAccountListViewController

@synthesize tableView1;
@synthesize tableDataArray;

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{

    self.dataList = [self.service accountListInfo:0][@"계좌리스트"];
    self.tableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"2222:%@",self.dataList);
    
    if([self.dataList[0][@"계좌번호"] isEqualToString:@""])
    {
        [self.tableDataArray addObject:self.dataList[0]];
    }
    else
    {
        for(NSDictionary *dic in self.dataList)
        {
            if(![dic[@"화면이동2"] isEqualToString:@""])
            {
                [self.tableDataArray addObject:dic];
            }
        }
    }
    
    if([self.dataList count] == 1 && [self.dataList[0][@"계좌번호"] isEqualToString:@""])
    {
        tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    [tableView1 reloadData];
    
    self.service = nil;
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"로그인 속도 계산"];
    #endif
    return NO;
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.imgDetail.hidden = NO;
        cell.btnOpen.hidden = YES;
        cell.selectionStyle	= UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.tableDataArray objectAtIndex:indexPath.row];
    cell.bgView.backgroundColor = [UIColor clearColor];
    
    if (dictionary[@"계좌명"])
    {
        cell.accountName.text = dictionary[@"계좌명"];
        
    }else
    {
        cell.accountName.text = dictionary[@"과목명"];
    }
    
    cell.accountNo.text = dictionary[@"계좌번호"];
    cell.amount.text = dictionary[@"잔액"];
    cell.amount.frame = CGRectMake(cell.amount.frame.origin.x + 31, cell.amount.frame.origin.y, cell.amount.frame.size.width, cell.amount.frame.size.height);

    if([dictionary[@"계좌번호"] isEqualToString:@""])
    {
        cell.imgDetail.hidden = YES;
        cell.accountName.frame = CGRectMake(8, 8, 301, 19);
        cell.accountName.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.tableDataArray objectAtIndex:indexPath.row];
    
    if([dictionary[@"계좌번호"] isEqualToString:@""]) return;
    
    if([dictionary[@"계좌번호"] hasPrefix:@"299"])
    {
        SHBPrimiumInfoViewController *nextViewController = [[[SHBPrimiumInfoViewController alloc] initWithNibName:@"SHBPrimiumInfoViewController" bundle:nil] autorelease];
        nextViewController.accInfoDic = dictionary;
        [self.navigationController pushFadeViewController:nextViewController];
        
        return;
    }
    
    if([dictionary[@"화면이동2"] isEqualToString:@"이체"])
    {  // 이체화면이동
        SHBTransferInfoInputViewController *nextViewController = [[[SHBTransferInfoInputViewController alloc] initWithNibName:@"SHBTransferInfoInputViewController" bundle:nil] autorelease];
        nextViewController.outAccInfoDic = dictionary;
        [self.navigationController pushFadeViewController:nextViewController];
    }
    else
    {  // 입금화면이동
        if([dictionary[@"계좌정보상세"][@"상품코드"] isEqualToString:@"110004601"])
        {
            SHBPushInfo *pushInfo = [SHBPushInfo instance];
            [pushInfo requestOpenURL:@"asset://M7002" Parm:nil];
            
            return;
        }
        
        SHBDepositInfoInputViewController *nextViewController = [[[SHBDepositInfoInputViewController alloc] initWithNibName:@"SHBDepositInfoInputViewController" bundle:nil] autorelease];
        nextViewController.inAccInfoDic = dictionary;
        [self.navigationController pushFadeViewController:nextViewController];
    }
}

- (void)refresh
{
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"즉시이체/예금입금";
    self.strBackButtonTitle = @"입출금 계좌조회";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    if (AppInfo.isD0011Start)
    {
        NSLog(@"D0011 태움");
        [self refresh];
    }else
    {
        NSLog(@"D0011 태우지 않음");
        
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
        self.service.responseData = AppInfo.accountD0011;
        
        //self.dataList = [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"];
        self.dataList = [self.service accountListInfo:0][@"계좌리스트"];
        self.tableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if([self.dataList[0][@"계좌번호"] isEqualToString:@""])
        {
            [self.tableDataArray addObject:self.dataList[0]];
        }
        else
        {
            
            for(NSDictionary *dic in self.dataList)
            {
                if(![dic[@"화면이동2"] isEqualToString:@""])
                {
                    [self.tableDataArray addObject:dic];
                }
            }
        }
        
        if([self.dataList count] == 1 && [self.dataList[0][@"계좌번호"] isEqualToString:@""])
        {
            tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else
        {
            tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        
        [tableView1 reloadData];
        #ifdef DEVELOPER_MODE
        [LPStopwatch stop:@"로그인 속도 계산"];
        #endif
        AppInfo.isD0011Start = YES;
    }
    
}

- (void)dealloc
{
    [tableView1 release], tableView1 = nil;
    [tableDataArray release];
    
    [super dealloc];
}

@end
