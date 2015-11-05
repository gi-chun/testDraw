//
//  SHBLoanRequestViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 5. 6..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBLoanRequestViewController.h"

#import "SHBNewProductListCell.h"

@interface SHBLoanRequestViewController ()

@end

@implementation SHBLoanRequestViewController

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
    
    [self setTitle:@"신용대출 신청/실행"];
    self.strBackButtonTitle = @"신용대출 신청/실행";
    
    self.dataList = @[ @{@"title" : @"군인행복대출",} ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *viewSection = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 317, 34)] autorelease];
	[viewSection setBackgroundColor:RGB(235, 217, 195)];
	
	UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 34, 317, 1)] autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[viewSection addSubview:lineView];
	
	UIImageView *ivBullet = [[[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 13, 13)] autorelease];
	[ivBullet setImage:[UIImage imageNamed:@"bullet_1.png"]];
	[viewSection addSubview:ivBullet];
	
    UILabel *lblSectionTitle = [[[UILabel alloc] initWithFrame:CGRectMake(27, 0, 280, 34)] autorelease];
    [lblSectionTitle setBackgroundColor:[UIColor clearColor]];
    [lblSectionTitle setTextColor:RGB(40, 91, 142)];
    [lblSectionTitle setFont:[UIFont systemFontOfSize:15]];
    [lblSectionTitle setText:@"대출"];
    [viewSection addSubview:lblSectionTitle];
    
	return viewSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBNewProductListCell *cell = (SHBNewProductListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBNewProductListCell"];
	if (cell == nil) {
		cell = [[[SHBNewProductListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"SHBNewProductListCell"] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    [cell.lblProductName setText:self.dataList[indexPath.row][@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *URL = @"";
    
    if (!AppInfo.realServer) {
        URL = [NSString stringWithFormat:@"%@/bank/mloan/mloan_info.jsp", URL_M_TEST];
    }
    else {
        URL = [NSString stringWithFormat:@"%@/bank/mloan/mloan_info.jsp", URL_M];
    }
    
    [[SHBPushInfo instance] requestOpenURL:URL SSO:YES];
}

@end
