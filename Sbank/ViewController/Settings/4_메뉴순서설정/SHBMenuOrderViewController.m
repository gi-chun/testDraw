//
//  SHBMenuOrderViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMenuOrderViewController.h"
#import "SHBMainViewController.h"

@interface SHBMenuOrderViewController ()

@property (nonatomic, retain) NSMutableArray *marrOrderList;

@end

@implementation SHBMenuOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_marrOrderList release];
	[_tableView release];
	[_headerView release];
	[_footerView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setTableView:nil];
	[self setHeaderView:nil];
	[self setFooterView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"메뉴순서 설정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tableView setBackgroundColor:RGB(244, 239, 233)];
	[self.view viewWithTag:NAVI_BACK_BTN_TAG].accessibilityLabel = [NSString stringWithFormat:@"%@ 뒤로이동", @"환경설정"];
//	[self.tableView setTableHeaderView:self.headerView];
//	[self.tableView setTableFooterView:self.footerView];
	FrameReposition(self.footerView, 0, height(self.headerView)+height(self.tableView));
	
	self.marrOrderList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]mainMenuOrderList]];
	Debug(@"%@", self.marrOrderList);
	
	// Gesture Remove
	[self.view removeGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
	
	[self.tableView setEditing:YES animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.marrOrderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		[cell.textLabel setFont:[UIFont systemFontOfSize:15]];
		[cell.textLabel setTextColor:RGB(74, 74, 74)];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	NSInteger row = indexPath.row;
	NSString *strName = [[self.marrOrderList objectAtIndex:row]objectForKey:@"menu.name"];
	[cell.textLabel setText:strName];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	NSInteger sourceRow = sourceIndexPath.row;
	NSInteger destinationRow = destinationIndexPath.row;
	
	NSDictionary *dicSource = [NSDictionary dictionaryWithDictionary:[self.marrOrderList objectAtIndex:sourceIndexPath.row]];
	[self.marrOrderList removeObjectAtIndex:sourceRow];
	[self.marrOrderList insertObject:dicSource atIndex:destinationRow];
	
	Debug(@"%@", self.marrOrderList);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[[NSUserDefaults standardUserDefaults]setMainMenuOrderList:self.marrOrderList];
	[(SHBMainViewController*)[[AppDelegate.navigationController viewControllers] objectAtIndex:0] closeFolderMenu];
	[(SHBMainViewController*)[[AppDelegate.navigationController viewControllers] objectAtIndex:0] setMenuIcon];
	
	[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:22 title:@"" message:@"메뉴순서 설정이 변경되었습니다."];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 22) {
		AppInfo.indexQuickMenu = 0;
		[self.navigationController fadePopToRootViewController];
	}
}

@end
