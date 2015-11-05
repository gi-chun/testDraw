//
//  SHBSettingsViewController.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSettingsViewController.h"
#import "SHBVersionViewController.h"				// 버전 확인
#import "SHBWallPaperViewController.h"				// 배경화면 설정
#import "SHBLoginSettingViewController.h"			// 로그인 설정
#import "SHBMenuOrderViewController.h"				// 메뉴순서 설정
#import "SHBEasyInquiryViewController.h"			// 간편조회 설정
#import "SHBNotificationSettingViewController.h"	// 알림설정
#import "SHBSearchPopupSettingViewController.h"     // 검색팝업(근접센서) 설정
#import "SHBSecureKeyPadSettingViewController.h"    // 보안키패드 *설정 여부
#import "SHBSettingsCell.h"
//#import "SHBFishingDefenceSettingViewController.h"  // 피싱방지보안설정

@interface SHBSettingsViewController ()

@end

@implementation SHBSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[_menuTable release];
	[super dealloc];
}

- (void)viewDidUnload {
	[self setMenuTable:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.menuTable setBackgroundColor:RGB(244, 239, 233)];
    self.strBackButtonTitle = @"환경설정";
	[self navigationViewHidden];
	[self setBottomMenuView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSIndexPath *selectedIndexPath = [self.menuTable indexPathForSelectedRow];
	if (selectedIndexPath) {
		[self.menuTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.menuTable flashScrollIndicators];
}

#pragma mark - Action

- (IBAction)closeBtnAction:(UIButton *)sender
{
    AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBSettingsCell *cell = (SHBSettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSettingsCell"];
	if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSettingsCell"
                                                       owner:self options:nil];
		cell = (SHBSettingsCell *)array[0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
	
	switch (indexPath.row) {
		case 0:
			[cell.subject setText:@"버전 확인"];
            
            NSString *tmpStr = [AppInfo.versionInfo objectForKey:@"최신버전"];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([tmpStr intValue] > [versionNumber intValue]) {
                [cell.versionLabel setHidden:NO];
                [cell.update setHidden:NO];
                
                [cell.versionLabel setText:[NSString stringWithFormat:@"Ver %@",[AppInfo.versionInfo objectForKey:@"최신버전"]]];
            }
            
			break;
		case 1:
			[cell.subject setText:@"배경화면 설정"];
			break;
		case 2:
			[cell.subject setText:@"로그인 설정"];
			break;
		case 3:
			[cell.subject setText:@"메뉴순서 설정"];
			break;
		case 4:
			[cell.subject setText:@"간편조회 설정"];
			break;
		case 5:
			[cell.subject setText:@"알림 설정"];
			break;
		case 6:
			[cell.subject setText:@"검색팝업(근접센서) 설정"];
			break;
        case 7:
			[cell.subject setText:@"보안키패드(*표시) 설정"];
			break;
		default:
			break;
	}
    cell.accessibilityLabel = [NSString stringWithFormat:@"%@ 화면 이동 버튼",cell.subject.text];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SHBBaseViewController *viewController = nil;
	
	switch (indexPath.row) {
		case 0:
			viewController = [[SHBVersionViewController alloc] initWithNibName:@"SHBVersionViewController" bundle:nil];
			break;
		case 1:
			viewController = [[SHBWallPaperViewController alloc] initWithNibName:@"SHBWallPaperViewController" bundle:nil];
			break;
		case 2:
			viewController = [[SHBLoginSettingViewController alloc] initWithNibName:@"SHBLoginSettingViewController" bundle:nil];
			break;
		case 3:
			viewController = [[SHBMenuOrderViewController alloc] initWithNibName:@"SHBMenuOrderViewController" bundle:nil];
			break;
		case 4:
            AppInfo.isSettingServiceView = YES;
			viewController = [[SHBEasyInquiryViewController alloc] initWithNibName:@"SHBEasyInquiryViewController" bundle:nil];
			viewController.needsLogin = YES;
			break;
		case 5:
            AppInfo.isSettingServiceView = YES;
			viewController = [[SHBNotificationSettingViewController alloc] initWithNibName:@"SHBNotificationSettingViewController" bundle:nil];
			viewController.needsLogin = YES;
			break;
        case 6:
			viewController = [[SHBSearchPopupSettingViewController alloc] initWithNibName:@"SHBSearchPopupSettingViewController" bundle:nil];
            break;
        case 7:
            viewController = [[SHBSecureKeyPadSettingViewController alloc] initWithNibName:@"SHBSecureKeyPadSettingViewController" bundle:nil];
            break;
		default:
			break;
	}
	
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

@end
