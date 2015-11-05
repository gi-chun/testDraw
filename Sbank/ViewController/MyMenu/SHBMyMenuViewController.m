//
//  SHBMyMenuViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 5..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBMyMenuViewController.h"
#import "SHBMyMenuSetupListViewController.h"
#import "SHBMainViewController.h"
#import "SHBSearchResultViewController.h"

@interface SHBMyMenuViewController ()

@property (nonatomic, retain) NSMutableArray *arrayTableData;
@property (nonatomic, retain) NSMutableArray *totalSubMenuArray;

@end

@implementation SHBMyMenuViewController

#pragma mark - Action
- (IBAction)closeBtnAction:(UIButton *)sender
{
       AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

- (IBAction)setupBtnAction:(UIButton*)sender
{
    
    if ([_btnSave.titleLabel.text isEqualToString:@"완료"]) {
        [_btnSave setTitle:@"설정" forState:UIControlStateNormal];
        [_tableView1 setEditing:NO animated:YES];
        
        [_btnSave setIsAccessibilityElement:YES];
        _btnSave.accessibilityLabel = @"설정";

        _imageView1.hidden = YES;
        [_lblMessage setFrame:CGRectMake(7, 5, 288, 13)];
        _lblMessage.text = @"메뉴를 길게 눌러 순서를 변경하실 수 있습니다.";

        // 전통적인 물리적 저장방법
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
        
        // 데이터 파일로 쓰기
        [self.totalSubMenuArray writeToFile:filePath atomically:YES];
        
    } else {
        SHBMyMenuSetupListViewController *detailViewController = [[SHBMyMenuSetupListViewController alloc] initWithNibName:@"SHBMyMenuSetupListViewController" bundle:nil];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
    
}

- (IBAction)searchBtnAction
{
    [_txtSearch resignFirstResponder];
    
    _txtSearch.text = [_txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(_txtSearch.text == nil || [_txtSearch.text length] < 2)
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
    nextViewController.data = @{@"SRC_WORD" : _txtSearch.text};
    [self.navigationController pushSlideUpViewController:nextViewController];
    _txtSearch.text = @"";
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state] != UIGestureRecognizerStateBegan)
        return;
    
    [_btnSave setTitle:@"완료" forState:UIControlStateNormal];
    [_tableView1 setEditing:YES animated:YES];
    _imageView1.hidden = NO;
    [_lblMessage setFrame:CGRectMake(23, 5, 288, 13)];
    _lblMessage.text = @"버튼을 누른 상태로 상하드래그하여 주십시오.";
    
    [_btnSave setIsAccessibilityElement:YES];
    _btnSave.accessibilityLabel = @"완료";

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
    [_tableView1 reloadData];
    
    // 선택된 메뉴 아이콘의 원 태그 정보 가져오기
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    // 파일로부터 읽어오기.
    self.totalSubMenuArray = [NSArray arrayWithContentsOfFile:filePath];
    
    // 메세지 출력여부
    if ([self.totalSubMenuArray count] > 0) {
        _lblMessage.hidden = NO;
        _viewMessage.hidden = NO;
        _imageView1.hidden = YES;
        [_lblMessage setFrame:CGRectMake(7, 5, 288, 13)];
        _lblMessage.text = @"메뉴를 길게 눌러 순서를 변경하실 수 있습니다.";
    } else {
        _lblMessage.hidden = YES;
        _viewMessage.hidden = YES;
    }
    
}

- (void)reLoadView {
    [self refresh];
    [_tableView1 reloadData];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == _txtSearch) {
        
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
    [self searchBtnAction];
    return YES;
}

- (void)didCompleteButtonTouch
{
    [_txtSearch resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return [totalSubMenuArray count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.totalSubMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImage *imgLogo = [UIImage imageNamed:@"bullet_mymenu"];
    UIImageView *inLogo = [[[UIImageView alloc]initWithImage:[imgLogo stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
    UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(31, 12, 240, 19)] autorelease];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [inLogo setFrame:CGRectMake(8, 12, 18, 16)];
        //[cell addSubview:inLogo];
        [cell.contentView addSubview:inLogo];
        
        label1.backgroundColor = [UIColor colorWithRed:(244/255.0f) green:(239/255.0f) blue:(233/255.0f) alpha:1.0f];//[UIColor clearColor];
        //label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:15];
        [label1 setTextColor:RGB(74, 74, 74)];
        
        //[cell addSubview:label1];
        [cell.contentView addSubview:label1];
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //cell.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithRed:(244/255.0f) green:(239/255.0f) blue:(233/255.0f) alpha:1.0f];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    } else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [inLogo setFrame:CGRectMake(8, 12, 18, 16)];
        //[cell addSubview:inLogo];
        [cell.contentView addSubview:inLogo];
        
        label1.backgroundColor = [UIColor colorWithRed:(244/255.0f) green:(239/255.0f) blue:(233/255.0f) alpha:1.0f];//[UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:15];
        [label1 setTextColor:RGB(74, 74, 74)];
        cell.backgroundColor = [UIColor colorWithRed:(244/255.0f) green:(239/255.0f) blue:(233/255.0f) alpha:1.0f];
        //[cell addSubview:label1];
        [cell.contentView addSubview:label1];
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // Configure the cell...
	NSInteger row = indexPath.row;
    NSString *strAccountName = [[self.totalSubMenuArray objectAtIndex:row] objectForKey:@"title"];
    
    label1.text = strAccountName;
    label1.accessibilityLabel = [NSString stringWithFormat:@"%@ 이동 버튼",label1.text];
    // long press
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [longGesture setMinimumPressDuration:1.0];
    [cell addGestureRecognizer:longGesture];
    [longGesture release];
    
    [cell setShouldIndentWhileEditing:NO];
    
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
    
	NSDictionary *dicSource = [NSDictionary dictionaryWithDictionary:[self.totalSubMenuArray objectAtIndex:sourceIndexPath.row]];
    [self.totalSubMenuArray removeObjectAtIndex:sourceRow];
    [self.totalSubMenuArray insertObject:dicSource atIndex:destinationRow];
    
	Debug(@"%@", self.totalSubMenuArray);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtSearch resignFirstResponder];
    NSDictionary *nDic = [self.totalSubMenuArray objectAtIndex:indexPath.row];
    
    // 선택된 메뉴에서 별도로 처리가 필요한 항목들
    if ([[nDic objectForKey:@"title"] isEqualToString:@"스마트금융"]) {
        // 스마트금융 별도 화면 오픈
        SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBSmartBankViewController") class] alloc] initWithNibName:@"SHBSmartBankViewController" bundle:nil];
        
        viewController.needsCert = NO;
        viewController.needsLogin = NO;
        [self checkLoginBeforePushViewController:viewController animated:NO];
        [viewController release];
    }
    
//    if ([[nDic objectForKey:@"title"] isEqualToString:@"Best 펀드"] || [[nDic objectForKey:@"title"] isEqualToString:@"펀드검색"]){
//        // 임시 나중에 삭제되어야 함.
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"1월 11일 이후에 서비스 될 예정입니다."
//                                                       delegate:self
//                                              cancelButtonTitle:@"확인"
//                                              otherButtonTitles:nil];
//        //        alert.tag = 7777;
//        [alert show];
//        [alert release];
//        return;
//    }
    
    else {
        AppInfo.isSettingServiceView = YES;
        [(SHBMainViewController*)[[AppDelegate.navigationController viewControllers] objectAtIndex:0] pushMenuViewController:nDic];
    }
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
    // Do any additional setup after loading the view from its nib.
    
    //번들 경로에 있는 모든 파일을 읽어오기 방법
    //	NSString *bundlePath = [[NSBundle mainBundle]bundlePath];
    //	NSFileManager *fm;
    //	NSDirectoryEnumerator   *dirEnum;
    //	fm = [NSFileManager defaultManager];
    //	dirEnum = [ fm enumeratorAtPath: bundlePath];
    //	NSLog(@"Contents of [%@]:", bundlePath);
    //	NSString * temp ;
    //	while ((temp  = [dirEnum  nextObject]) != nil ) NSLog(@"%@", temp);
    
    self.strBackButtonTitle = @"마이메뉴";
    [self navigationViewHidden];
	[self setBottomMenuView];
    
    startTextFieldTag = 11111111;
    endTextFieldTag = 11111111;
    
    [self refresh];
    [_tableView1 reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTableView1:nil];
	[super viewDidUnload];
}

- (void)dealloc
{
    self.arrayTableData = nil;
    [_totalSubMenuArray release];
    [_arrayTableData release];
    [_btnSave release];
    [_lblMessage release];
    [_viewMessage release];
    
    [super dealloc];
}

@end
