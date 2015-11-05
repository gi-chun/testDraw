//
//  SHBClosedProductStep_1ViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//


//#define kHeaderRowH			34
#define kTableTitleColor	RGB(40, 91, 142)
#define kCellH				100


#import "SHBClosedProductStep_1ViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBUtility.h"
#import "SHBClosedProductStep_1Cell.h"
#import "SHBClosedProductStep_2ViewController.h"

@interface SHBClosedProductStep_1ViewController ()


@property (nonatomic, retain) NSMutableArray *marrListData;	// 해지완료 계좌리스트

@end

@implementation SHBClosedProductStep_1ViewController

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
  self.strBackButtonTitle = @"예금적금 해지 계좌목록";
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tableView setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"해지현황조회" maxStep:0 focusStepNumber:0]autorelease]];
        

    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"거래구분" : @"1",
						   @"해지거래구분" : @"1",
						   @"보안계좌조회구분" : @"2",
						   @"인터넷조회제한여부" : @"1",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kD4380Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
    
	
	[self setGuideView];
	
    //	[self setAccountListData];
	
    //	[self.tableView reloadData];
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
	[marrGuides addObject:@"해지예금 현황조회는 이미 해지된 계좌의 해지내역을 조회할 수 있는 서비스 입니다."];
	[marrGuides addObject:@"해지계좌목록을 선택하시면 자세한 해지내역을 조회하실 수 있습니다."];
	
	
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
    SHBClosedProductStep_1Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBClosedProductStep_1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
    }
    
    // Configure the cell...
    

	dicData = [self.marrListData objectAtIndex:indexPath.row];
	
	[cell.lblName setCaptionText:[dicData objectForKey:@"상품명"]];
	[cell.lblAccountNo setText:[dicData objectForKey:@"계좌번호"]];
    [cell.endDate setText:[dicData objectForKey:@"해지일"]];
	[cell.startDate setText:[dicData objectForKey:@"신규일"]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SHBClosedProductStep_2ViewController *viewController = [[SHBClosedProductStep_2ViewController alloc]initWithNibName:@"SHBClosedProductStep_2ViewController" bundle:nil];
    viewController.needsCert = YES;
    viewController.accountList = [self.marrListData objectAtIndex:indexPath.row];
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
    
    
	
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
	
    if([AppInfo.serviceCode isEqualToString:@"D4380"])
    {
        int tempCount = 0;
        if (tempCount == [[aDataSet arrayWithForKey:@"해지예금현황"] count])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"해지 계좌 이력이 없습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            [self.navigationController fadePopViewController];
            return NO;
        }

       
        NSMutableArray *tmpData = [aDataSet arrayWithForKey:@"해지예금현황"];

        self.marrListData = [NSMutableArray array];
        
        for(int i=0; i<[tmpData count]; i++)
        {
          NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            
          [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"예금종류"] forKey:@"상품명"];
          [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] forKey:@"계좌번호"];
          [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"해지일"] forKey:@"해지일"];
          [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"신규일"] forKey:@"신규일"];
          [self.marrListData addObject:tmp];
          
        }
        
        [self.tableView reloadData];
        
        
        
    }
   
	
    return NO;
}



@end
