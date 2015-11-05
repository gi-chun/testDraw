//
//  SHBMyMenuSetupListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMyMenuSetupListViewController.h"
#import "SHBMyMenuListCell.h"

@interface SHBMyMenuSetupListViewController ()
{
    int selectedRow;
    int selectedSection;
    int selectedCount;
}

@property (nonatomic, retain) NSMutableArray *checkedIndexPaths;
@property (nonatomic, retain) NSMutableArray *selectedSubMenuArray;
@property (nonatomic, retain) NSMutableArray *selectedSectionArray;

@end

@implementation SHBMyMenuSetupListViewController
@synthesize checkedIndexPaths;
@synthesize totalSubMenuArray;
@synthesize arrayTableData;
//@synthesize selectedSubMenuArray;

#pragma mark - Action

- (void) previousViewAction {
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
    if([strController isEqualToString:@"SHBMyMenuViewController"])
    {
        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(reLoadView)];
        [self.navigationController fadePopViewController];
    }else{
        [self.navigationController fadePopViewController];
    }
    
}

- (void) addItemToCart:(int)itemId itemSection:(int)section {
    if ([self.selectedSubMenuArray count] > 0) {
        for (int i=0; i<[self.selectedSubMenuArray count]; i++) {
            if ([[[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"] isEqualToString:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:itemId] objectForKey:@"title"]]) {
                selectedCount--;
                selectedSection = section;
                selectedRow = itemId;
                [tableView1 reloadData];
                break;
            }
        }
        if ([self.selectedSubMenuArray count] > 14 && selectedCount == 15) {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:22 title:@"" message:@"마이메뉴는 15개 이상 설정하실 수 없습니다."];
        } else {
            selectedSection = section;
            selectedRow = itemId;
            
            [tableView1 reloadData];
        }
    } else {
        selectedSection = section;
        selectedRow = itemId;
        
        [tableView1 reloadData];
    }
    
}

- (IBAction)closeBtnAction:(UIButton *)sender {
	[self.navigationController fadePopViewController];
}

- (IBAction)dataSaveBtnAction:(UIButton *)sender {
    // 전통적인 물리적 저장방법
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    [self.selectedSubMenuArray writeToFile:filePath atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"마이메뉴 설정이 완료되었습니다."
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    alert.tag = 1111;
    [alert show];
    [alert release];
    
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self previousViewAction];
    //	[self.navigationController fadePopViewController];
}

#pragma mark - Menu List Setting
- (void)setMenuTitle{
	NSMutableArray *menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"조회/이체", @"menu.name",
                              @"icon_account", @"menu.image",
                              @"1", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"상품가입/해지", @"menu.name",
                              @"icon_new", @"menu.image",
                              @"2", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"펀드", @"menu.name",
                              @"icon_fund", @"menu.image",
                              @"3", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"대출", @"menu.name",
                              @"icon_loan", @"menu.image",
                              @"4", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"외환/골드", @"menu.name",
                              @"icon_exchangegold", @"menu.image",
                              @"5", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"신한카드", @"menu.name",
                              @"icon_card", @"menu.image",
                              @"6", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"자산관리", @"menu.name",
                              @"icon_assets", @"menu.image",
                              @"7", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"상품권", @"menu.name",
                              @"icon_gift", @"menu.image",
                              @"8", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"공인인증센터", @"menu.name",
                              @"icon_cc", @"menu.image",
                              @"9", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"퇴직연금", @"menu.name",
                              @"icon_retire", @"menu.image",
                              @"10", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"지로/지방세", @"menu.name",
                              @"icon_girotax", @"menu.image",
                              @"11", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"지식서재", @"menu.name",
                              @"icon_book", @"menu.image",
                              @"12", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"금융정보", @"menu.name",
                              @"icon_finance", @"menu.image",
                              @"13", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Tops Club", @"menu.name",
                              @"icon_tops", @"menu.image",
                              @"14", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"영업점/ATM", @"menu.name",
                              @"icon_atm", @"menu.image",
                              @"15", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    {
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"고객센터", @"menu.name",
                              @"icon_customer", @"menu.image",
                              @"16", @"menu.tag",
                              nil];
        [menuArray addObject:nDic];
    }
    
    self.arrayTableData = menuArray;
    [menuArray release];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (IBAction)expandCellBtnAction:(UIButton *)sender {
    selectedRow = -1;
    
    if (selectedSection == [sender tag]) {
        selectedSection = -1;
    } else {
        selectedSection = [sender tag];
    }
    
    if ([_selectedSectionArray[[sender tag]] isEqualToString:@"Y"]) {
        [_selectedSectionArray replaceObjectAtIndex:[sender tag] withObject:@"N"];
    }
    else {
        [_selectedSectionArray replaceObjectAtIndex:[sender tag] withObject:@"Y"];
    }
    
    
    [tableView1 reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.totalSubMenuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.totalSubMenuArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_selectedSectionArray[indexPath.section] isEqualToString:@"Y"]) {
        return 44;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBMyMenuListCell *cell = (SHBMyMenuListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBMyMenuListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBMyMenuListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.delegate = self;
    cell.itemId = indexPath.row;
    cell.section = indexPath.section;
    
    // Configure the cell...
	NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSString *strAccountName = [[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"];
    
    [cell.label2 setText:strAccountName];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    cell.btnOpen.accessibilityLabel = [NSString stringWithFormat:@"%@ 선택", cell.label2.text];
    //NSLog(@"cccc:%@",cell.btnOpen.imageView.image);
    
    if (selectedSection == section && selectedRow == row) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        BOOL checkInsert = TRUE;
        
        if ([self.selectedSubMenuArray count] > 0) {
            for (int i=0; i<[self.selectedSubMenuArray count]; i++) {
                if ([[[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"] isEqualToString:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"]]) {
                    [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
                    [self.selectedSubMenuArray removeObjectAtIndex:i];
                    //cell.btnOpen.accessibilityLabel = [NSString stringWithFormat:@"%@ 선택", [[[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"]objectForKey:@"title"]];
                    checkInsert = FALSE;
                    break;
                }
            }
            
            if (checkInsert) {
                if ([self.selectedSubMenuArray count] < 16) {
                    [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
                    
                    [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"] forKey:@"title"];
                    [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"controller"] forKey:@"controller"];
                    [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
                    
                    if ([[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row]objectForKey:@"webAddress"] length] > 0) {
                        [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"webAddress"] forKey:@"webAddress"];
                    }
                    if ([[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row]objectForKey:@"schemeURL"] length] > 0) {
                        [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"schemeURL"] forKey:@"schemeURL"];
                    }
                    
                    [cell.btnOpen setIsAccessibilityElement:YES];
                    //cell.btnOpen.accessibilityLabel = @"선택";
                    cell.btnOpen.accessibilityLabel = [NSString stringWithFormat:@"%@ 선택해제", [[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"]];
                    [self.selectedSubMenuArray addObject:mDic];
                    selectedCount++;
                }
            }
//            checkInsert = TRUE;
            
        } else {
            if ([self.selectedSubMenuArray count] < 16) {
                [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
                
                [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"] forKey:@"title"];
                [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"controller"] forKey:@"controller"];
                [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
                
                if ([[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row]objectForKey:@"webAddress"] length] > 0) {
                    [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"webAddress"] forKey:@"webAddress"];
                }
                if ([[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row]objectForKey:@"schemeURL"] length] > 0) {
                    [mDic setObject:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"schemeURL"] forKey:@"schemeURL"];
                }
                
                [self.selectedSubMenuArray addObject:mDic];
                selectedCount++;
            }
        }
        
        [mDic release];

    } else {
        if ([self.selectedSubMenuArray count] > 0)
        {
            for (int i=0; i<[self.selectedSubMenuArray count]; i++) {
                if ([[[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"] isEqualToString:[[[self.totalSubMenuArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"title"]]) {
                    [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
                    if (cell.frame.size.height > 0) {
                        [cell.btnOpen setIsAccessibilityElement:YES];
                        //cell.btnOpen.accessibilityLabel = @"선택해제";
                        cell.btnOpen.accessibilityLabel = [NSString stringWithFormat:@"%@ 선택해제", [[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"]];
                    } else {
                        [cell.btnOpen setIsAccessibilityElement:NO];
                        //cell.btnOpen.accessibilityLabel = [NSString stringWithFormat:@"%@ 선택", [[self.selectedSubMenuArray objectAtIndex:i] objectForKey:@"title"]];
                    }

                }
            }
        }
    }
    
    // 체크된 메뉴 갯수 확인
    selectedCount = [self.selectedSubMenuArray count];
    _lblrecordCount.text = [NSString stringWithFormat:@"마이메뉴 설정[%d]", selectedCount];
    _lblrecordCount.accessibilityLabel = [NSString stringWithFormat:@"%@ 최대 15개까지 지정 가능합니다",_lblrecordCount.text];
    cell.backgroundColor = [UIColor colorWithRed:(244/255.0f) green:(239/255.0f) blue:(233/255.0f) alpha:1.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self addItemToCart:indexPath.row itemSection:indexPath.section];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellSelectionStyleNone;
}

// edit 불가
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *path = proposedDestinationIndexPath;
    
    // 다른 section의 경우 이동 불가
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        path = sourceIndexPath;
    }
    
    return path;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int index = section;
    NSString *retStr = @"";
    
    retStr = [[self.arrayTableData objectAtIndex:index] objectForKey:@"menu.name"];
    
    
    return retStr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int index = section;
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)] autorelease];
    headerView.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(217/255.0f) blue:(195/255.0f) alpha:1.0f];
    
    UIView *lineView1 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)] autorelease];
    lineView1.backgroundColor = [UIColor colorWithRed:(209/255.0f) green:(209/255.0f) blue:(209/255.0f) alpha:1.0f];
    
    UIView *lineView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, tableView.bounds.size.height, tableView.bounds.size.width, 1)] autorelease];
    lineView2.backgroundColor = [UIColor colorWithRed:(209/255.0f) green:(209/255.0f) blue:(209/255.0f) alpha:1.0f];
    
    UIButton *T_TText=[UIButton buttonWithType:UIButtonTypeCustom];
    [T_TText setFrame:CGRectMake(0, 1, 317, 43)];
    [T_TText addTarget:self action:@selector(expandCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    T_TText.backgroundColor = [UIColor clearColor];
    T_TText.titleLabel.textAlignment = NSTextAlignmentLeft;
    T_TText.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [T_TText setTag:section];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(31, 12, tableView.bounds.size.width, 19)] autorelease];
    label.text = [[self.arrayTableData objectAtIndex:index] objectForKey:@"menu.name"];
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:RGB(74, 74, 74)];
    label.font = [UIFont systemFontOfSize:15];
    
    UIImage *imgLogo = [UIImage imageNamed:@"bullet_1"];
    UIImageView *inLogo = [[[UIImageView alloc]initWithImage:[imgLogo stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
    [inLogo setFrame:CGRectMake(10, 15, 13, 13)];
    
    NSString *tempImg = @"arrow_list_open";
    if ([_selectedSectionArray[index] isEqualToString:@"Y"]){
        tempImg = @"arrow_list_close";
        [T_TText setIsAccessibilityElement:YES];
        //T_TText.accessibilityLabel = @"펼쳐보기닫기";
        T_TText.accessibilityLabel = [NSString stringWithFormat:@"%@ 펼쳐보기닫기",label.text];
    } else {
        tempImg =@"arrow_list_open";
        [T_TText setIsAccessibilityElement:YES];
        //T_TText.accessibilityLabel = @"펼쳐보기열기";
        T_TText.accessibilityLabel = [NSString stringWithFormat:@"%@ 펼쳐보기열기",label.text];
    }
    
    UIImage *imgArrow = [UIImage imageNamed:tempImg];
    UIImageView *inArrow = [[[UIImageView alloc]initWithImage:[imgArrow stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
    [inArrow setFrame:CGRectMake(284, 8, 26, 26)];
    
    [headerView addSubview:lineView1];
    [headerView addSubview:T_TText];
    [headerView addSubview:label];
    [headerView addSubview:inLogo];
    [headerView addSubview:inArrow];
    [headerView addSubview:lineView1];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (void)openOrCloseCell:(int)section row:(int)row
{
    NSLog(@"openSection : %d, openRow : %d", section, row);
    
    if (selectedSection == section) {
        selectedSection = -1;
        
        if(selectedRow == row)
        {
            selectedRow = -1;
        }
        else
        {
            selectedRow = row;
        }
    } else {
        selectedSection = section;
    }
    
    NSNumber *num = [[self.checkedIndexPaths objectAtIndex:section] objectAtIndex:row];
    if (num == [NSNumber numberWithBool:YES])
    {
        [[self.checkedIndexPaths objectAtIndex:section] replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:NO]];
    } else {
        [[self.checkedIndexPaths objectAtIndex:section] replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:YES]];
    }
    
    [tableView1 reloadData];
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
    
    [self navigationViewHidden];
	[self setBottomMenuView];
    
    // 테이블의 선택될 섹션과 행을 값을 초기화
    selectedSection = 0;
    selectedRow = -1;
    selectedCount = 0;
    
    // 메인메뉴 전체 항목을 가져온다.
    [self setMenuTitle];
    
	totalSubMenuArray = [[NSMutableArray alloc] initWithCapacity:0];
    selectedCellDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // 전통적인 물리적 저장방법
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyMenu.plist"];
    
    // bundle
    NSString *path = [[NSBundle mainBundle]bundlePath];
    
    NSArray *Data = [NSArray arrayWithContentsOfFile:filePath];
    if (Data == nil || [Data count] == 0) {
        self.selectedSubMenuArray = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        self.selectedSubMenuArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    
    // 선택된 메뉴 아이콘의 원 태그 정보 가져오기
	NSArray	*menuArray = [[NSUserDefaults standardUserDefaults]mainMenuOrderList];
    
    // plist에서 하위 메뉴정보 가져오기
    NSString* subMenuPath = [path stringByAppendingPathComponent:@"SHBMyMenu.plist"];
	NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:subMenuPath];
	NSDictionary *depth1Dic = [dic objectForKey:@"depth1"];
	NSDictionary *depth2Dic = [dic objectForKey:@"depth2"];
    
    for (int i = 1; i < [menuArray count]; i++) {
        NSArray *depth1Array = [depth1Dic objectForKey:[NSString stringWithFormat:@"menu%d",i]];
        
        NSMutableArray *firstSubMenuArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int j = 0; j < [depth1Array count]; j++) {
            // 폴더 버튼메뉴 리스트 배열 셋팅
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if ([[[depth1Array objectAtIndex:j] objectForKey:@"depth2key"] length] == 0) {
                [mDic setObject:[[depth1Array objectAtIndex:j] objectForKey:@"title"] forKey:@"title"];
                [mDic setObject:[[depth1Array objectAtIndex:j] objectForKey:@"controller"] forKey:@"controller"];
                [mDic setObject:[[depth1Array objectAtIndex:j] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
                
                if ([[[depth1Array objectAtIndex:j] objectForKey:@"webAddress"] length] > 0) {
                    [mDic setObject:[[depth1Array objectAtIndex:j] objectForKey:@"webAddress"] forKey:@"webAddress"];
                }
                if ([[[depth1Array objectAtIndex:j] objectForKey:@"schemeURL"] length] > 0) {
                    [mDic setObject:[[depth1Array objectAtIndex:j] objectForKey:@"schemeURL"] forKey:@"schemeURL"];
                }
                
                [firstSubMenuArray addObject:mDic];
            }
            if ([[mDic objectForKey:@"controller"] length] > 0){
                
            }else{
                NSArray *depth2Array = [depth2Dic objectForKey:[[depth1Array objectAtIndex:j] objectForKey:@"depth2key"]];
                
                for (int k = 0; k < [depth2Array count]; k++) {
                    NSMutableDictionary *nDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                    [nDic setObject:[[depth2Array objectAtIndex:k] objectForKey:@"title"] forKey:@"title"];
                    [nDic setObject:[[depth2Array objectAtIndex:k] objectForKey:@"controller"] forKey:@"controller"];
                    [nDic setObject:[[depth2Array objectAtIndex:k] objectForKey:@"needsLogin"] forKey:@"needsLogin"];
                    
                    if ([[[depth2Array objectAtIndex:k] objectForKey:@"webAddress"] length] > 0) {
                        [nDic setObject:[[depth2Array objectAtIndex:k] objectForKey:@"webAddress"] forKey:@"webAddress"];
                    }
                    if ([[[depth2Array objectAtIndex:k] objectForKey:@"schemeURL"] length] > 0) {
                        [nDic setObject:[[depth2Array objectAtIndex:k] objectForKey:@"schemeURL"] forKey:@"schemeURL"];
                    }
                    
                    [firstSubMenuArray addObject:nDic];
                    [nDic release];
                }
            }
            
            [mDic release];
        }
        
        if ([depth1Dic count]+1 > i) {
            [self.totalSubMenuArray addObject:firstSubMenuArray];
//            [firstSubMenuArray release];
        }
        [firstSubMenuArray release];
        
    }
    
    self.selectedSectionArray = [NSMutableArray arrayWithArray:@[@"Y"]];
    
    for (NSInteger i = 0; i < [totalSubMenuArray count]; i++) {
        [_selectedSectionArray addObject:@"N"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [arrayTableData release];
    [totalSubMenuArray release];
    [_selectedSubMenuArray release];
    [_selectedSectionArray release];
    
    [super dealloc];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1111 && buttonIndex == 0) {
        [self previousViewAction];
	}
}

@end
