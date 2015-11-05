//
//  SHBFindBranchesLocationViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

typedef enum
{
	SearchTypeBranches = 101,	// 영업점
	SearchTypeATM,				// ATM
}BranchesSearchType;

#import "SHBFindBranchesLocationViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesCell.h"
#import "SHBUtility.h"
#import "SHBBranchesService.h"
#import "SHBBranchesLocationMapViewController.h"
#import "SHBFavoriteBranchCell.h"

#define D_WHITESPACE_WIDTH 3.0f // 자주 찾는 지점의 자간 너비
#define D_MAX_WIDTH 170.0f      // 자주 찾는 지점명의 최대 너비

@interface SHBFindBranchesLocationViewController ()
{
	BOOL isWaitingMenu;		// 대기고객조회 메뉴인지
	BranchesSearchType searchType;
}

@property (nonatomic, retain) NSMutableArray *marrSearchResults;	// 검색결과
@property (nonatomic, retain) NSDictionary *dicSelectedData;		// 선택한 데이터

- (CGFloat)getCellLabelWidth:(UILabel *)label;  // 자주 찾는 지점 셀의 라벨 너비
- (void)favoriteBranchesCheck;                  // 자주 찾는 지점을 표시할지 여부를 확인
- (void)isTableViewHidden:(BOOL)aIsHidden;      // 자주 찾는 지점이 표시될 테이블 및 관련 UI를 보여줄지, 안보여줄지 여부를 설정

@end

@implementation SHBFindBranchesLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_popupView release]; _popupView = nil;
	[_dicSelectedData release];
	[_strMenuTitle release];
	[_marrSearchResults release];
	[_headerView release];
	[_tfSearchWord release];
	[_bodyView release];
	[_tableView release];
	[_lineView release];
    self.button1 = nil;
    self.view1 = nil;
    
	[super dealloc];
}
- (void)viewDidUnload {
	[self setHeaderView:nil];
	[self setTfSearchWord:nil];
	[self setBodyView:nil];
	[self setTableView:nil];
	[self setLineView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSString *strSubTitle = nil;
	
	if ([self.strMenuTitle isEqualToString:@"대기고객조회"]) {
		isWaitingMenu = YES;
		
		[self setTitle:@"대기고객조회"];
		strSubTitle = @"영업점 검색";
		self.strBackButtonTitle = @"대기고객조회";
		[self.headerView removeFromSuperview];
		[self.bodyView setFrame:CGRectMake(0, 0, width(self.bodyView), height(self.bodyView)+29)];
	}
	else
	{
		isWaitingMenu = NO;
		
		[self setTitle:@"영업점/ATM찾기"];
		strSubTitle = @"영업점/ATM 검색";
        self.strBackButtonTitle = @"영업점/ATM 검색";
	}
	
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    [self.view insertSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:strSubTitle maxStep:0 focusStepNumber:0]autorelease] belowSubview:self.button1];
	
	searchType = SearchTypeBranches;
    
    [_tfSearchWord enableAccButtons:NO Next:NO];
    
    // 자주 찾는 지점 안내 버튼 표시 여부 초기화
    self.button1.hidden = !isWaitingMenu;
    
    // 자주 찾는 지점 표시 여부 체크
    [self favoriteBranchesCheck];
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

- (void)favoriteBranchesReloadData
{
    if  (_isFavoriteBranchShow) {
        
        [self favoriteBranchesCheck];
    }
}

#pragma mark - Action
- (IBAction)radioBtnAction:(UIButton *)sender {
	for (int nIdx = 1; nIdx <= 2; nIdx++) {
		UIButton *btn = (UIButton *)[self.headerView viewWithTag:100+nIdx];
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
	searchType = sender.tag;
	
}

- (IBAction)searchBtnAction:(UIButton *)sender {

	[self.tfSearchWord resignFirstResponder];
	
    self.tfSearchWord.text = [self.tfSearchWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	if ([SHBUtility countMultiByteStringFromUTF8String:self.tfSearchWord.text] <= 2) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"최소 2글자 이상 입력하여 주십시오."];
		
		return;
	}
	
	[self.marrSearchResults removeAllObjects];
	[self.tableView reloadData];
	
	switch (searchType) {
		case SearchTypeBranches:
			self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4307Id viewController:self]autorelease];
			break;
		case SearchTypeATM:
			self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4306Id viewController:self]autorelease];
			break;
			
		default:
			break;
	}
	
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{@"검색어" : self.tfSearchWord.text}];
	[self.service start];
    
    _isFavoriteBranchShow = NO;
}

- (IBAction)buttonDidPush:(id)sender
{
    // 검색중인 경우, 키보드 내려줌
    [self.tfSearchWord resignFirstResponder];
    
    // 자주찾는지점등록안내 팝업 띄움
    if (_popupView == nil) {
        
        _popupView = [[SHBPopupView alloc] initWithTitle:@"자주 찾는 지점 등록 방법 안내" subView:self.view1];
        _popupView.delegate = self;
        
        CGRect rectTemp = _popupView.frame;
        rectTemp.origin.y = 0.0f;
        _popupView.frame = rectTemp;
        
        [self.view addSubview:_popupView];
    }
}


#pragma mark -
#pragma mark SHBPopupViewDelegate Methods

- (void)popupViewDidCancel
{
    [self.view1 removeFromSuperview];
    _popupView.delegate = nil;
    [_popupView release]; _popupView = nil;
}


#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[(SHBTextField*)textField enableAccButtons:NO Next:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self searchBtnAction:nil];
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	if (textField == self.tfSearchWord) {
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
	}
	
	return YES;
}

- (void)didCompleteButtonTouch
{
    [super didCompleteButtonTouch];
    
    [self searchBtnAction:nil];
}


#pragma mark -
#pragma mark Private Methods

- (CGFloat)getCellLabelWidth:(UILabel *)label
{
    CGSize sizeTemp = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(INT_MAX, label.frame.size.height) lineBreakMode:label.lineBreakMode];
    
    return sizeTemp.width;
}

- (void)favoriteBranchesCheck
{
    self.marrSearchResults = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] getFavoriteBranches]];
    
    if ([self.marrSearchResults count] > 0 && isWaitingMenu == YES) {
        
        [self isTableViewHidden:NO];
    }
    else {
        
        [self isTableViewHidden:YES];
    }
}

- (void)isTableViewHidden:(BOOL)aIsHidden
{
    _isFavoriteBranchShow = !aIsHidden;
    self.lineView.hidden = aIsHidden;
    self.tableView.hidden = aIsHidden;
    
    if (_isFavoriteBranchShow) {
        
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.marrSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 자주 찾는 지점 리스트 표시 - 예외처리
    if (_isFavoriteBranchShow) {
        
        SHBFavoriteBranchCell *cell = (SHBFavoriteBranchCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        
        if (cell == nil) {
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBFavoriteBranchCell" owner:self options:nil];
            cell = (SHBFavoriteBranchCell *)[array objectAtIndex:0];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        cell.label2.text = [self.marrSearchResults objectAtIndex:indexPath.row][@"지점명"];
        
        // 라벨 위치 및 사이즈 초기화
        CGRect rectTemp = cell.label1.frame;
        rectTemp.size.width = [self getCellLabelWidth:cell.label1];
        cell.label1.frame = rectTemp;
        
        rectTemp.origin.x += rectTemp.size.width + D_WHITESPACE_WIDTH;
        rectTemp.size.width = [self getCellLabelWidth:cell.label2];
        
        if (rectTemp.size.width > D_MAX_WIDTH) { // 예외처리
            
            rectTemp.size.width = D_MAX_WIDTH;
        }
        
        cell.label2.frame = rectTemp;
        
        rectTemp.origin.x += rectTemp.size.width  + D_WHITESPACE_WIDTH;
        rectTemp.size.width = [self getCellLabelWidth:cell.label3];
        cell.label3.frame = rectTemp;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    SHBBranchesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBBranchesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	
	NSDictionary *dicData = [self.marrSearchResults objectAtIndex:indexPath.row];
	
	if (searchType == SearchTypeBranches) {
        if ([self.strMenuTitle isEqualToString:@"대기고객조회"]) {
            [cell set3Line:YES];
            [cell.lblBranch setText:[dicData objectForKey:@"지점명"]];
            [cell.lblAddress setText:[dicData objectForKey:@"지점주소"]];
            [cell.lblTel setText:[dicData objectForKey:@"지점대표전화번호"]];
        }
        else {
            [cell set3Line:NO];
            [cell.lblBranch setText:[dicData objectForKey:@"지점명"]];
            [cell.lblAddress setText:[dicData objectForKey:@"지점주소"]];
        }
	}
	else if (searchType == SearchTypeATM) {
		[cell set3Line:YES];
		[cell.lblBranch setText:[dicData objectForKey:@"자동화코너명"]];
		[cell.lblAddress setText:[dicData objectForKey:@"주소"]];
		[cell.lblTel setText:@"ATM"];
	}
	
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	self.dicSelectedData = [self.marrSearchResults objectAtIndex:row];
	
	if (isWaitingMenu) {
		NSString *strNum = [[self.dicSelectedData objectForKey:@"점번호"]substringFromIndex:1];
		self.service = [[[SHBBranchesService alloc]initWithServiceId:kE4308Id viewController:self]autorelease];
		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
									@"작업구분" : @"S",
									@"조회점번호" : strNum,
									}];
		[self.service start];
	}
	else
	{
		ViewType type;
		if (searchType == SearchTypeBranches) {
			type = ViewTypeBranch;
		}
		else
		{
			type = ViewTypeATMNoMap;
		}
		
		SHBBranchesLocationMapViewController *viewController = [[[SHBBranchesLocationMapViewController alloc]initWithNibName:@"SHBBranchesLocationMapViewController" bundle:nil]autorelease];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.viewType = type;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 자주 찾는 지점 리스트 표시 - 예외처리
    if (_isFavoriteBranchShow) {
        
        return 40.0f;
    }
    
	return 68;
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
	Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == kE4307Id || self.service.serviceId == kE4306Id) {
		/**
		 (
		 {
		 점번호 = 01117;
		 지점위도좌표 = 37.564161255193;
		 지점경도좌표 = 126.975965548298;
		 지점대표전화번호 = 02-778-3905;
		 지점명 = 덕수궁;
		 지점주소 = 서울특별시 중구 서소문동 21-1 (효성빌딩);
		 }
		 ,
		 {
		 점번호 = 01165;
		 지점위도좌표 = 37.562668325028;
		 지점경도좌표 = 126.972994535945;
		 지점대표전화번호 = 02-753-0202;
		 지점명 = 서소문;
		 지점주소 = 서울특별시 중구 서소문동 58-7;
		 }
		 
		 )
		 */
		
		/**
		 (
		 {
		 자동화코너관리번호 = 상업등기소;
		 주소 = 중구 서소문동 37-8                                                                                                                                                                           37.5644013;
		 자동화코너명 = 서울특별시;
		 지점경도좌표 = 346029;
		 지점위도좌표 = 43075     126.973151;
		 }
		 
		 )
		 */
		self.marrSearchResults = [aDataSet arrayWithForKey:@"검색결과"];
		Debug(@"self.marrSearchResults : %@", self.marrSearchResults);
		
		if ([self.marrSearchResults count] > 0) {
			[self.lineView setHidden:NO];
			[self.tableView setHidden:NO];
			[self.tableView reloadData];
		}
		else
		{
			[self.lineView setHidden:YES];
			[self.tableView setHidden:YES];
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"검색결과가 존재하지 않습니다."];
		}
	}
	else if (self.service.serviceId == kE4308Id)
	{
		/**
		 조회점번호 = 1100;
		 COM_JSTAR_VALUE = SHB01          395       15674;
		 COM_EF_TIME = 213319;
		 창구구분1 = 01;
		 창구구분5 = 05;
		 COM_SEC_CHK = ;
		 COM_UPMU_GBN = R;
		 COM_JUMIN_NO = 0;
		 COM_CIF_NO = 0;
		 COM_WEB_DOMAIN = etcwb1t1;
		 COM_NO_SEND = ;
		 COM_SEC_CHAL1 = ;
		 대기고객수2 = 00005;
		 대기고객수4 = 00005;
		 창구구분2 = 02;
		 대기고객수6 = 00005;
		 COM_TRAN_TIME = 21:33:35;
		 대기고객수8 = 00005;
		 COM_SUBCHN_KBN = 02;
		 COM_RESULT_CD = 0;
		 COM_CHANNEL_KBN = DT;
		 창구구분6 = 06;
		 COM_EF_YOIL = 5;
		 입력조회구분 = S;
		 COM_SYS_GBN = T;
		 입력점번호 = 1100;
		 창구구분3 = 03;
		 COM_ECHO_TYPE = ;
		 창구구분7 = 07;
		 COM_EF_DATE = 20121207;
		 COM_TRAN_DATE = 2012.12.07;
		 COM_USER_ERR = ;
		 필러 = 00001;
		 COM_YEYAK_ICHE = ;
		 COM_SVC_CODE = E4308;
		 COM_ICHEPSWD_CHK = ;
		 COM_FILLER1 = ;
		 COM_EF_SERIALNO = 20781546;
		 COM_SEC_CHAL2 = ;
		 COM_LANGUAGE = 1;
		 대기고객수1 = 00005;
		 대기고객수3 = 00005;
		 COM_IP_ADDR = 59.7.254.139;
		 COM_TRAN_TIME->originalValue = 213335;
		 대기고객수5 = 00005;
		 COM_PKTLEN = 262;
		 COM_TRAN_DATE->originalValue = 20121207;
		 대기고객수7 = 00005;
		 창구구분4 = 04;
		 창구구분8 = 08;
		 COM_PG_SERIAL = ;
		 COM_FILLER2 = ;
		 COM_END_MARK = ZZ;
		 */
		SHBBranchesWaitingPeopleViewController *viewController = [[[SHBBranchesWaitingPeopleViewController alloc]initWithNibName:@"SHBBranchesWaitingPeopleViewController" bundle:nil]autorelease];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.showLocationBtn = YES;
		viewController.data = aDataSet;
        viewController.delegate = self;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
	
	return NO;
}

@end
