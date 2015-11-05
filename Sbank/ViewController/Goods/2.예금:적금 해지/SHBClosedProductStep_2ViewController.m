//
//  SHBClosedProductStep_2ViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//


#define kTableTitleColor	RGB(40, 91, 142)
#define kCellH				80

#import "SHBClosedProductStep_2ViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBUtility.h"
#import "SHBClosedProductStep_2Cell.h"
#import "SHBClosedProductStep_3ViewController.h"

@interface SHBClosedProductStep_2ViewController ()

@property (nonatomic, retain) NSMutableArray *marrListData;	// 해지계산서조회 계좌리스트


@end

@implementation SHBClosedProductStep_2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_marrListData release];
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
	[self setTitle:@"해지현황조회"];

    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tableView setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"해지계산서 조회" maxStep:0 focusStepNumber:0]autorelease]];
    
   // r_account = _account;
     NSString *tmp2 = [self.accountList objectForKey:@"계좌번호"];
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"공통계좌번호" : tmp2,
						   @"업무구분" : @"1",
                           @"계좌번호" : tmp2,
						   @"거래번호" : @"",
						   @"반복횟수" : @"",
						   @"거래번호2" :@"",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kD4381Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
	
	[self setGuideView];
	

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

#pragma mark - UI
- (void)setGuideView
{
	UIView *headerView = [[[UIView alloc]init]autorelease];
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[headerView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
    NSString *tmp1 = [self.accountList objectForKey:@"계좌번호"];
	[marrGuides addObject:[NSString stringWithFormat:@"고객님께서 선택하신 계좌[%@]의 해지 내역입니다.",tmp1]];
	[marrGuides addObject:@"해지계산서 조회를 선택하시면 자세한 내용을 확인 하실 수 있습니다."];
	[marrGuides addObject:@"일부해지 등은 해지계산서가 해지건별로 조회됩니다."];
	
	for (NSString *strGuide in marrGuides)
	{
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
		[ivInfoBox addSubview:ivBullet];
		
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
		[lblGuide setNumberOfLines:0];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setTextColor:RGB(74, 74, 74)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[ivInfoBox addSubview:lblGuide];
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 5 : 10);
	}
	
	[ivInfoBox setFrame:CGRectMake(3, 10, 311, fHeight)];
    
    
    UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fHeight+=15, 317, 1)]autorelease];
	[lineView2 setBackgroundColor:RGB(209, 209, 209)];
	[headerView addSubview:lineView2];

    
    [headerView setFrame:CGRectMake(0, 0, 317, fHeight)];
	[self.tableView setTableHeaderView:headerView];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.marrListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBClosedProductStep_2Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBClosedProductStep_2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	dicData = [self.marrListData objectAtIndex:indexPath.row];
	
	[cell.endDate setText:[dicData objectForKey:@"해지일"]];
	[cell.lblAccountNo setText:[dicData objectForKey:@"거래번호"]];
    [cell.lblMoney setText:[NSString stringWithFormat:@"%@원",[dicData objectForKey:@"해지금액"]]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dicData = [self.marrListData objectAtIndex:indexPath.row];
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"공통계좌번호" : [self.accountList objectForKey:@"계좌번호"],
						   @"업무구분" : @"2",
                           @"계좌번호" : [self.accountList objectForKey:@"계좌번호"],
						   @"거래번호" : [dicData objectForKey:@"거래번호"],
						   @"반복횟수" : @"",
						   @"거래번호2" :@"",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kD4390Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];

	

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellH;
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    Debug(@"aDataSet : %@", aDataSet);
	
    if([AppInfo.serviceCode isEqualToString:@"D4381"])
    {
        NSMutableArray *tmpData = [aDataSet arrayWithForKey:@"조회내역"];
        self.marrListData = [NSMutableArray array];
        
        for(int i=0; i<[tmpData count]; i++)
        {
            NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            
            [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"거래일자"] forKey:@"해지일"];
            [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"거래번호"] forKey:@"거래번호"];
            [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"거래금액"] forKey:@"해지금액"];
            [self.marrListData addObject:tmp];
            
        }
        
        [self.tableView reloadData];
        
        
        
    }
    
    
    if([AppInfo.serviceCode isEqualToString:@"D4390"])
    {
        
        SHBClosedProductStep_3ViewController *viewController = [[SHBClosedProductStep_3ViewController alloc]initWithNibName:@"SHBClosedProductStep_3ViewController" bundle:nil];
        viewController.needsCert = YES;
        viewController.dicData = aDataSet;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
        
    }

    
    return NO;
}



@end
