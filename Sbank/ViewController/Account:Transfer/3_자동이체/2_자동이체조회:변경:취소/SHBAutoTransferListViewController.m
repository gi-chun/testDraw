//
//  SHBAutoTransferListViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferListViewController.h"
#import "SHBAutoTransferDetailViewController.h"
#import "SHBAutoTransferEditViewController.h"
#import "SHBAutoTransferCancelComfirmViewController.h"

#import "SHBAutoTransferListCell.h"

@interface SHBAutoTransferListViewController ()
{
    int openedRow;
}
@end

@implementation SHBAutoTransferListViewController
@synthesize nType;

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(openedRow == indexPath.row){
        return 183;
    }
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBAutoTransferListCell *cell = (SHBAutoTransferListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAutoTransferListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAutoTransferListCell *)currentObject;
                break;
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    cell.lblData01.text = [AppInfo.codeList bankNameFromCode:dictionary[@"입금은행코드"]];
    
    [cell.lblData02 initFrame:cell.lblData02.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
    [cell.lblData02 setCaptionText:dictionary[@"입금계좌번호표시용"]];
    
    cell.lblData03.text = dictionary[@"입금계좌성명"];
    cell.lblData04.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
    cell.lblData05.text = [NSString stringWithFormat:@"%@", dictionary[@"입금계좌상품명"]];
    
    
    cell.bgView.backgroundColor = [UIColor clearColor];
    
    
    if(nType == 9 || [dictionary[@"이체금액"] isEqualToString:@"0"])
    {
        cell.btnOpen.hidden = YES;
        
        return cell;
    }
    
    cell.row = indexPath.row;
    cell.target = self;
    cell.pSelector = @selector(cellButtonClick:);
    
    if(openedRow == indexPath.row){
        cell.bgView.backgroundColor = RGB(244, 244, 244);
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기 닫기";
        cell.btnLeft.hidden = NO;
        cell.btnCenter.hidden = NO;
        cell.btnRight.hidden = NO;
    }else{
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
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.dataList[indexPath.row]];
    
    [dictionary setObject:self.data[@"_신계좌번호"] forKey:@"_신계좌번호"];
    dictionary[@"출금계좌번호"] = self.data[@"_출금계좌번호"];
    
    if(!(indexPath.row == openedRow))
    {
        openedRow = -1;
    }
    [_tableView1 reloadData];
    
    SHBAutoTransferDetailViewController *nextViewController = [[[SHBAutoTransferDetailViewController alloc] initWithNibName:@"SHBAutoTransferDetailViewController" bundle:nil] autorelease];
    nextViewController.data = dictionary;
    nextViewController.nType = nType;
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void)cellButtonClick:(NSDictionary *)dic
{
    int row = [dic[@"Index"] intValue];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.dataList[row]];
    
    [dictionary setObject:self.data[@"_신계좌번호"] forKey:@"_신계좌번호"];
    dictionary[@"출금계좌번호"] = self.data[@"_출금계좌번호"];
    
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
            [_tableView1 reloadData];
        }
            break;
        case 2001:  // 자세히
        {
            SHBAutoTransferDetailViewController *nextViewController = [[[SHBAutoTransferDetailViewController alloc] initWithNibName:@"SHBAutoTransferDetailViewController" bundle:nil] autorelease];
            nextViewController.data = dictionary;
            nextViewController.nType = nType;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 2002:  // 자동이체변경
        {
            SHBAutoTransferEditViewController *nextViewController = [[[SHBAutoTransferEditViewController alloc] initWithNibName:@"SHBAutoTransferEditViewController" bundle:nil] autorelease];
            nextViewController.data = dictionary;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        case 2003:  // 자동이체취소
        {
            SHBAutoTransferCancelComfirmViewController *nextViewController = [[[SHBAutoTransferCancelComfirmViewController alloc] initWithNibName:@"SHBAutoTransferCancelComfirmViewController" bundle:nil] autorelease];
            nextViewController.data = dictionary;
            [self.navigationController pushFadeViewController:nextViewController];
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
    
    self.title = @"자동이체";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    openedRow = -1;
    
    if(nType == 0)
    {
        _lblTitle.text = @"정상분 목록";
        self.strBackButtonTitle = @"자동이체 조회/변경/취소";
    }
    else
    {
        _lblTitle.text = @"해지된 목록";
        self.strBackButtonTitle = @"자동이체 조회";
    }
    
    self.dataList = [self.data arrayWithForKey:@"이체내역"];
    
    for (NSMutableDictionary *dic in self.dataList) {
        if ([SHBUtility isFindString:[AppInfo.codeList bankNameFromCode:dic[@"입금은행코드"]] find:@"신한은행"]) {
            NSString *str = [SHBUtility setAccountNumberMinus:dic[@"입금계좌번호"]];
            if ([dic[@"구입금계좌번호"] length] > 0)
            {
                [dic setObject:[NSString stringWithFormat:@"%@(구)%@", str, dic[@"구입금계좌번호"]] forKey:@"입금계좌번호표시용"];
            }
            else
            {
                [dic setObject:str forKey:@"입금계좌번호표시용"];
            }
            
            [dic setObject:str forKey:@"_입금계좌번호"];
        }
        else {
            [dic setObject:dic[@"입금계좌번호"] forKey:@"입금계좌번호표시용"];
            [dic setObject:dic[@"입금계좌번호"] forKey:@"_입금계좌번호"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView1 release];
    [_lblTitle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView1:nil];
    [self setLblTitle:nil];
    [super viewDidUnload];
}
@end
