//
//  SHBBranchesListViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBranchesListViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesCell.h"
#import "SHBBranchesLocationMapViewController.h"

@interface SHBBranchesListViewController ()

@end

@implementation SHBBranchesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setTableView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"영업점/ATM찾기"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"위치기반 영업점/ATM 찾기" maxStep:0 focusStepNumber:0]autorelease]];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	if (selectedIndexPath) {
		[self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBBranchesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBBranchesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	NSDictionary *dicData = [self.dataList objectAtIndex:indexPath.row];
	
	[cell set3Line:YES];
	[cell.lblBranch setText:[dicData objectForKey:@"지점명"]];
	[cell.lblAddress setText:[dicData objectForKey:@"지점주소"]];
	[cell.lblTel setText:[dicData objectForKey:@"지점대표전화번호"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	NSDictionary *dic = [self.dataList objectAtIndex:row];
	
	ViewType type = [[dic objectForKey:@"구분"]isEqualToString:@"1"] ? ViewTypeBranch : ViewTypeATM;
	
	SHBBranchesLocationMapViewController *viewController = [[[SHBBranchesLocationMapViewController alloc]initWithNibName:@"SHBBranchesLocationMapViewController" bundle:nil]autorelease];
	viewController.dicSelectedData = dic;
	viewController.viewType = type;
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 68;
}

@end
