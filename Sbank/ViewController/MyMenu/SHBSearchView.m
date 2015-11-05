//
//  SHBSearchView.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSearchView.h"
#import "SHBMainViewController.h"
#import "SHBSearchResultViewController.h"
#import "SHBMyMenuSetupListViewController.h"
#import "SHBMyMenuListCell2.h"
@implementation SHBSearchView
@synthesize navi;
@synthesize txtSearch;
@synthesize tableView1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)settingPressed:(id)sender
{
    UIDevice *curDevice = [UIDevice currentDevice];
    curDevice.proximityMonitoringEnabled = YES;
    
    AppInfo.isShowSearchView = NO;
    
    [navi popToRootViewControllerAnimated:NO];
    
    // 스마트금융 별도 화면 오픈
    SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSearchPopupSettingViewController") class] alloc] initWithNibName:@"SHBSearchPopupSettingViewController" bundle:nil];
    
    viewController.needsCert = NO;
    viewController.needsLogin = NO;
    [[[navi viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:NO];
    [viewController release];
    
    [self removeFromSuperview];
}

- (IBAction)closeThisView:(id)sender
{
    UIDevice *curDevice = [UIDevice currentDevice];
    curDevice.proximityMonitoringEnabled = YES;
    
    AppInfo.isShowSearchView = NO;
    [self removeFromSuperview];
}

- (IBAction)micBtnAction:(id)sender
{
    [txtSearch becomeFirstResponder];
}

- (IBAction)searchBtnAction:(id)sender
{
    [txtSearch resignFirstResponder];

    txtSearch.text = [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(txtSearch.text == nil || [txtSearch.text length] < 2)
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"검색어를 2자이상 입력바랍니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
	}
    
    SHBSearchResultViewController *nextViewController = [[[SHBSearchResultViewController alloc] initWithNibName:@"SHBSearchResultViewController" bundle:nil] autorelease];
    nextViewController.data = @{@"SRC_WORD" : txtSearch.text};
    [navi pushSlideUpViewController:nextViewController];
    
    AppInfo.isShowSearchView = NO;
    [self removeFromSuperview];
}

- (IBAction)settingBtnAction:(id)sender
{
    SHBMyMenuSetupListViewController *nextViewController = [[[SHBMyMenuSetupListViewController alloc] initWithNibName:@"SHBMyMenuSetupListViewController" bundle:nil] autorelease];
    [navi pushSlideUpViewController:nextViewController];
    
    AppInfo.isShowSearchView = NO;
    [self removeFromSuperview];
}

- (void) initPlistFile {
    // 전통적인 물리적 저장방법
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    NSArray *Data;
    
    //    Data = [NSArray arrayWithContentsOfFile:filePath];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"계좌조회",@"title",@"SHBAccountMenuListViewController",@"controller",@"1",@"needsLogin", nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"즉시이체/예금입금",@"title",@"SHBAccountListViewController",@"controller",@"2",@"needsLogin", nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"동영상상품관",@"title",@"",@"controller",@"0",@"needsLogin", [NSString stringWithFormat:@"%@%@", URL_M, @"/pages/financialInfo/Video/video_Prdt_list.jsp"], @"webAddress", nil];
    //    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:
    //                          @"위치기반 영업점/ATM 찾기",@"title",@"SHBFindBranchesMapViewController",@"controller",@"0",@"needsLogin", nil];
    // 2013.01.30 추가됨
    // 이전에 이렇게 추가되어서 같은 형태로 추가
    NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"ATM 긴급출금등록",@"title",@"SHBUrgencyInputInfoViewController",@"controller",@"2",@"needsLogin", nil];
    
    Data = [NSArray arrayWithObjects:dic1, dic2, dic3, dic5, nil];
    
    // 데이터 파일로 쓰기
    [Data writeToFile:filePath atomically:YES];
}

- (BOOL)plistFileSearch {
    NSError *error = nil;
    
    // 전통적인 물리적 저장방법
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: filePath]) //4
    {
        [fileManager copyItemAtPath:filePath toPath: documentsDirectory error:&error]; //6
    }
    
    if (error) {
        return NO;
    } else {
        return YES;
    }
}

- (void)refresh
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 메뉴의 초기화를 할 필요가 있을 경우 MYMENU_VERSION을 변경하여 초기화 해준다.
    if (![self plistFileSearch] || ![defaults myMenuVersion] || [[defaults myMenuVersion] floatValue] < [MYMENU_VERSION floatValue]) {
        [self initPlistFile];
        
        [defaults setMyMenuVersion:MYMENU_VERSION];
        [defaults synchronize];
    }
    
    if (self.totalSubMenuArray != nil) {
        self.totalSubMenuArray = nil;
        //        [_tableView1 reloadData];
    } else {
        self.totalSubMenuArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    }
    
    // 선택된 메뉴 아이콘의 원 태그 정보 가져오기
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    // 파일로부터 읽어오기.
    self.totalSubMenuArray = [NSArray arrayWithContentsOfFile:filePath];
    [tableView1 reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.totalSubMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBMyMenuListCell2 *cell = (SHBMyMenuListCell2 *)[tableView dequeueReusableCellWithIdentifier:@"SHBMyMenuListCell2"];
    
    if (!cell) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBMyMenuListCell2"
                                                       owner:self options:nil];
		cell = (SHBMyMenuListCell2 *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    cell.label1.text = self.totalSubMenuArray[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *nDic = [self.totalSubMenuArray objectAtIndex:indexPath.row];
    
    // 선택된 메뉴에서 별도로 처리가 필요한 항목들
    if ([[nDic objectForKey:@"title"] isEqualToString:@"스마트금융"]) {
        [navi popToRootViewControllerAnimated:NO];
        
        // 스마트금융 별도 화면 오픈
        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSmartBankViewController") class] alloc] initWithNibName:@"SHBSmartBankViewController" bundle:nil];
        
        viewController.needsCert = NO;
        viewController.needsLogin = NO;
        [[[navi viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:NO];
        [viewController release];
    }
    else {
        AppInfo.isSettingServiceView = YES;
        [navi popToRootViewControllerAnimated:NO];
        [(SHBMainViewController*)[[navi viewControllers] objectAtIndex:0] pushMenuViewController:nDic];
    }
    
    UIDevice *curDevice = [UIDevice currentDevice];
    curDevice.proximityMonitoringEnabled = YES;
    
    AppInfo.isShowSearchView = NO;
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

#pragma mark - SHBTextField

- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    [textField enableAccButtons:NO Next:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tmpStr = [string stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    if (tmpStr == nil) {
        
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == txtSearch) {
        
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()-_=+{}|[]\\;:\'\"<>?,./`~";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 ) {
            
			return NO;
		}
        
		//한글 20자 제한(영문 40자)
		if (dataLength + dataLength2 > 40) {
            
			return NO;
		}
	}
	
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtSearch resignFirstResponder];
    [self searchBtnAction:nil];
    return YES;
}

- (void)didCompleteButtonTouch
{
    [txtSearch resignFirstResponder];
}

@end
