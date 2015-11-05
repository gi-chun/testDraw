//
//  SHBBranchesWaitingPeopleViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBranchesWaitingPeopleViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBBranchesLocationMapViewController.h"

@interface SHBBranchesWaitingPeopleViewController ()

@property (nonatomic, retain) NSMutableArray *marrCounterList;	// 창구리스트

@end

@implementation SHBBranchesWaitingPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_marrCounterList release];
	[_dicSelectedData release];
	[_tableView release];
	[_headerView release];
	[_footerView release];
	[_lblBranchName release];
	[_lblTotalWaiting release];
	[_btnLocation release];
	[_ivBox release];
    self.button1 = nil;
    
	[super dealloc];
}
- (void)viewDidUnload {
	[self setTableView:nil];
	[self setHeaderView:nil];
	[self setFooterView:nil];
	[self setLblBranchName:nil];
	[self setLblTotalWaiting:nil];
	[self setBtnLocation:nil];
	[self setIvBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"대기고객조회"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tableView setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"대기고객수" maxStep:0 focusStepNumber:0]autorelease]];
	
	[self.tableView setTableHeaderView:self.headerView];
	
	UIImage *img = [UIImage imageNamed:@"box_infor"];
	[self.ivBox setImage:[img stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	[self.tableView setTableFooterView:self.footerView];
	[self.btnLocation setHidden:!_showLocationBtn];
	
	[self.lblBranchName setAdjustsFontSizeToFitWidth:YES];
	[self.lblBranchName setText:[NSString stringWithFormat:@"%@ (%@)", self.dicSelectedData[@"지점명"], self.dicSelectedData[@"지점대표전화번호"]]];
	
	NSInteger nTotalCnt = 0;
	for (int nIdx = 1; nIdx <= 8; nIdx++) {
		NSString *strKey = [NSString stringWithFormat:@"대기고객수%d", nIdx];
		nTotalCnt += [self.data[strKey]integerValue];
	}
	[self.lblTotalWaiting setText:[NSString stringWithFormat:@"총 대기고객수 : %d명", nTotalCnt]];
	
	[self setCounterListData];
	[self.tableView reloadData];
    
    // 자주 찾는 지점 등록 여부 확인 및 자주찾는지점등록, 삭제 버튼 초기화
    NSArray *arrayTemp = [[NSUserDefaults standardUserDefaults] getFavoriteBranches];
    
    for (NSDictionary *dicTemp in arrayTemp) {
        
        if ([dicTemp[@"점번호"] isEqualToString:self.dicSelectedData[@"점번호"]]) {
            
            _isFavoriteBranch = YES;
            break;
        }
    }
    
    self.button1.hidden = !_isFavoriteBranch;
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
}

#pragma mark - etc.
- (void)setCounterListData
{
	self.marrCounterList = [NSMutableArray array];
	
	for (int nIdx = 1; nIdx <= 8; nIdx++) {
		NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
		
		NSString *strKey = [NSString stringWithFormat:@"창구구분%d", nIdx];
		NSString *strKey2 = [NSString stringWithFormat:@"대기고객수%d", nIdx];
		
		NSString *strCounterName = nil;
		NSString *strPeopleNum = [NSString stringWithFormat:@"%@명", [SHBUtility normalStringTocommaString:self.data[strKey2]]];
		
		if ([self.data[strKey]isEqualToString:@"01"]) {
			strCounterName = @"일반상담창구";
		}
		else if ([self.data[strKey]isEqualToString:@"02"]) {
			strCounterName = @"투자상담창구";
		}
		else if ([self.data[strKey]isEqualToString:@"03"]) {
			strCounterName = @"간편상담창구";
		}
		else if ([self.data[strKey]isEqualToString:@"04"]) {
			strCounterName = @"입출금창구";
		}
		else if ([self.data[strKey]isEqualToString:@"05"]) {
			strCounterName = @"기업금융창구";
		}
		else if ([self.data[strKey]isEqualToString:@"06"]) {
			strCounterName = @"사고신고창구";
		}
		else if ([self.data[strKey]isEqualToString:@"07"]) {
			strCounterName = @"펀드전문창구";
		}
		else if ([self.data[strKey]isEqualToString:@"08"]) {
			strCounterName = @"기타창구";
		}
		else
		{
			continue;
		}
		
		if (strCounterName) {
			[mDic setObject:strCounterName forKey:@"창구명"];
			[mDic setObject:strPeopleNum forKey:@"고객수"];
			
			[self.marrCounterList addObject:mDic];
		}
	}
	
}

#pragma mark - Action
- (IBAction)locationBtnAction:(SHBButton *)sender {
	SHBBranchesLocationMapViewController *viewController = [[[SHBBranchesLocationMapViewController alloc]initWithNibName:@"SHBBranchesLocationMapViewController" bundle:nil]autorelease];
	viewController.dicSelectedData = self.dicSelectedData;
	viewController.viewType = ViewTypeWaitingPeople;
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)callBtnAction:(SHBButton *)sender {
	NSString *strPhoneNumber = self.dicSelectedData[@"지점대표전화번호"];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", strPhoneNumber]]];
}

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1000 title:@"" message:[NSString stringWithFormat:@"%@점을 자주 찾는 지점으로 등록하시겠습니까?", self.dicSelectedData[@"지점명"]]];
            break;
        case 1:
            [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1001 title:@"" message:[NSString stringWithFormat:@"%@점을 자주 찾는 지점에서 삭제하시겠습니까?", self.dicSelectedData[@"지점명"]]];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (([alertView tag] == 1000 && buttonIndex == 0) || ([alertView tag] == 1001 && buttonIndex == 0)) {
        
        NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] getFavoriteBranches]];
        
        switch ([alertView tag]) {
            case 1000: { // 자주 찾는 지점 등록
                
                if (arrayTemp == nil) {
                    
                    arrayTemp = [[NSMutableArray alloc] initWithCapacity:0];
                }
                
                // 자주 찾는 지점 등록 갯수 확인 - 예외처리
                if ([arrayTemp count] >= 10) {
                    
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"자주 찾는 지점은 최대 10개까지 등록이 가능합니다."];
                    return;
                }
                
                [arrayTemp insertObject:self.dicSelectedData atIndex:0];
                _isFavoriteBranch = YES;
            }   break;
            case 1001: { // 자주 찾는 지점 삭제
                
                for (NSDictionary *dicTemp in arrayTemp) {
                    
                    if ([dicTemp[@"점번호"] isEqualToString:self.dicSelectedData[@"점번호"]]) {
                        
                        [arrayTemp removeObject:dicTemp];
                        _isFavoriteBranch = NO;
                        break;
                    }
                }
            }   break;
                
            default:
                break;
        }
        
        [[NSUserDefaults standardUserDefaults] setFavoriteBranches:arrayTemp];
        self.button1.hidden = !_isFavoriteBranch;
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(favoriteBranchesReloadData)]) {
            
            [self.delegate favoriteBranchesReloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.marrCounterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
		
		[cell.textLabel setFont:[UIFont systemFontOfSize:15]];
		[cell.textLabel setTextColor:RGB(74, 74, 74)];
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 21)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(74, 74, 74)];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[lbl setTextAlignment:NSTextAlignmentRight];
		[self.view addSubview:lbl];
		
		[cell setAccessoryView:lbl];
    }
    
    // Configure the cell...
	NSDictionary *dicData = self.marrCounterList[indexPath.row];
	[cell.textLabel setText:dicData[@"창구명"]];
    
	UILabel *lbl = (UILabel *)cell.accessoryView;
	[lbl setText:dicData[@"고객수"]];
	
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 34;
}

@end
