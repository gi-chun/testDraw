//
//  SHBCertCenterViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertCenterViewController.h"

@interface SHBCertCenterViewController ()

@end

@implementation SHBCertCenterViewController

@synthesize certCenterTable;
@synthesize certCenterMenus;
@synthesize certCenterViewControllers;

- (void)dealloc
{
    [certCenterTable release], certCenterTable = nil;
    [certCenterMenus release], certCenterMenus = nil;;
    [certCenterViewControllers release], certCenterViewControllers = nil;
    [super dealloc];
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
    
    self.certCenterMenus = @[
        @"인증서 발급/재발급",
        @"PC -> 스마트폰 인증서 복사",
        @"스마트폰 -> PC 인증서 복사",
        @"신한금융그룹 앱간 인증서 복사",
        @"인증서 갱신",
        @"인증서 폐기",
        @"타공인인증서 등록/해제",
        @"인증서 관리",
        @"인증서 안내" 
    ];
    
    self.certCenterViewControllers = @[
        @"SHBCertIssueViewController",
        @"SHBCertMovePhoneViewController",
        @"SHBCertMovePCViewController",
        @"SHBCertCopyViewController",
        @"SHBCertRenewViewController",
        @"SHBCertExpireViewController",
        @"SHBCertRegViewController",
        @"SHBCertManageViewController",
        @"SHBCertInfoViewController"
    ];
}

- (void)viewDidUnload
{
    [self setCertCenterTable:nil];
    [super viewDidUnload];
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.certCenterMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // Configure the cell...
    cell.textLabel.text = [self.certCenterMenus objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *target = [self.certCenterViewControllers objectAtIndex:indexPath.row];
    
    SHBBaseViewController *viewController = [[[NSClassFromString(target) class] alloc] initWithNibName:target bundle:nil];
	[self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

@end
