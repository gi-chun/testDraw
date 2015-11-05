//
//  SHBReservRegListViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBReservRegListViewController.h"
#import "SHBReservRegDetailViewController.h"
#import "SHBReservRegCancelComfirmViewController.h"
#import "SHBReservRegCell.h"

@interface SHBReservRegListViewController ()

@end

@implementation SHBReservRegListViewController
@synthesize tableView1;

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    self.dataList = [aDataSet arrayWithForKey:@"이체내역"];

    if([self.dataList count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"예약이체 등록내역이 없습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        return NO;
    }

    [tableView1 reloadData];
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
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
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBReservRegCell *cell = (SHBReservRegCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBReservRegCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBReservRegCell *)currentObject;
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];
    
    cell.lblData01.text = [NSString stringWithFormat:@"%@ %@", dictionary[@"예약처리일자"], dictionary[@"예약처리시간"]];
    cell.lblData02.text = [AppInfo.codeList bankNameFromCode:dictionary[@"입금은행코드"]];
    
    if([cell.lblData02.text isEqualToString: @"한미은행"])
    {
        cell.lblData02.text = @"씨티은행";
    }
    cell.lblData03.text = dictionary[@"입금계좌번호"];
    cell.lblData04.text = dictionary[@"입금계좌성명"];
    cell.lblData05.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    SHBReservRegDetailViewController *nextViewController = [[[SHBReservRegDetailViewController alloc] initWithNibName:@"SHBReservRegDetailViewController" bundle:nil] autorelease];
    nextViewController.infoDic = dictionary;
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void)refresh
{
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2110" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{
                                 @"조회시작일" : AppInfo.tran_Date,
                                 @"조회종료일" : [SHBUtility dateStringToMonth:6 toDay:0],
                                 @"조회결과순서" : @"1",
                                 }] autorelease];
    [self.service start];
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

    self.title = @"기타이체";
    self.strBackButtonTitle = @"예약이체 조회";
    
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
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView1:nil];
    [super viewDidUnload];
}
@end
