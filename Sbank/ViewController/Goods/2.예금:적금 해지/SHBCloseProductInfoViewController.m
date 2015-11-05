//
//  SHBCloseProductInfoViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//
#define kHeaderRowH			34
#define kTableTitleColor	RGB(40, 91, 142)
#define kCellH				95

#import "SHBCloseProductInfoViewController.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBCloseProductInfoCell.h"
#import "SHBProductService.h"
#import "SHBUtility.h"
#import "SHBCloseProductInputAmountViewController.h"
#import "SHBCloseProductConfirmViewController.h"
#import "SHBClosedProductStep_1ViewController.h"  
@interface SHBCloseProductInfoViewController ()

@property (nonatomic, retain) NSMutableArray *marrListData;	// 해지대상 계좌리스트


@end

@implementation SHBCloseProductInfoViewController

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
	[self setTitle:@"예금/적금 해지"];
    self.strBackButtonTitle = @"예금적금 해지 계좌목록";
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tableView setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"해지 할 상품 계좌 목록" maxStep:0 focusStepNumber:0]autorelease]];
    
    [self.view bringSubviewToFront:self.button1];
    
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
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
	[marrGuides addObject:@"신한 온라인 서비스(인터넷뱅킹, 폰뱅킹, 신한S뱅크)를 통해 신규한 예금에 한하여 당일 해지가 가능합니다. (단, 미성년자는 법정대리인의 동의에 의해 영업점에서 예금 해지 가능)"];
	[marrGuides addObject:@"예금해지(예상조회) 가능시간은 평일 09:00~21:30 입니다."];
	[marrGuides addObject:@"중도해지 우대이율 상품의 경우 반드시 영업점에 방문하여 증빙서류 제출 후 중도해지 하여야 합니다.\n(단, 별도 증빙서류 필요한 상품에 한함)"];
	
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
	

	
	UIView *rowView = [[[UIView alloc]initWithFrame:CGRectMake(0, fHeight+=10, 317, kHeaderRowH)]autorelease];
//	[rowView setBackgroundColor:RGB(244, 244, 244)];
	[headerView addSubview:rowView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 294, kHeaderRowH)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:kTableTitleColor];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"계좌번호(해지대상)"];
	[rowView addSubview:lblTitle];
	
	UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fHeight+=kHeaderRowH, 317, 1)]autorelease];
	[lineView2 setBackgroundColor:RGB(209, 209, 209)];
	[headerView addSubview:lineView2];
	
	[headerView setFrame:CGRectMake(0, 0, 317, fHeight+1)];
	
	[self.tableView setTableHeaderView:headerView];
}

#pragma mark - button
- (IBAction)buttonDidPush:(id)sender
{
    SHBClosedProductStep_1ViewController *viewController = [[SHBClosedProductStep_1ViewController alloc]initWithNibName:@"SHBClosedProductStep_1ViewController" bundle:nil];
    viewController.needsCert = YES;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
}


//#pragma mark - Etc.
//- (void)setAccountListData
//{
//	//NSMutableArray *tmpData = [AppInfo.userInfo arrayWithForKey:@"예금계좌"];
//    
//    NSMutableArray *tmpData = self.accountArray;
//
//    
//	self.marrListData = [NSMutableArray array];
//	
//	for(int i=0; i<[tmpData count]; i++)
//	{
//		
//		if (
//			(   (   [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] >= 200 &&
//				 [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] <= 240  )  &&
//			 
//			 [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 216  )  )
//		{
//			
//			
//			NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
//			if ([[[tmpData objectAtIndex:i] objectForKey:@"상품부기명"] length] > 0)
//			{
//				[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"상품부기명"] forKey:@"상품명"];
//				
//			}
//			else
//			{
//				[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"과목명"] forKey:@"상품명"];
//			}
//			
//			
//			[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] forKey:@"계좌번호"];
//			[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"잔액"] forKey:@"잔액"];
//			[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"은행코드"] forKey:@"은행코드"];
//			[tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"구계좌번호"] forKey:@"구계좌번호"];
//			[self.marrListData addObject:tmp];
//		}
//		
//	}
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.marrListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBCloseProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBCloseProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	NSDictionary *dicData = [self.marrListData objectAtIndex:indexPath.row];
	
	[cell.lblName setText:[dicData objectForKey:@"상품명"]];
	[cell.lblAccountNo setText:[dicData objectForKey:@"계좌번호"]];
    [cell.Money setText:[NSString stringWithFormat:@"%@원",[dicData objectForKey:@"잔액"]]];
    [cell.date setText:[dicData objectForKey:@"만기일자"]];
    
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
    
    
    /*  재형저축 해지 가능 2014.3.13 4.0.2 버전부터 적용
    
    if ([[[self.marrListData objectAtIndex:row] objectForKey:@"계좌번호"] hasPrefix:@"232"]) { // 재형저축
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"재형저축 중도해지는 이자과세 확인을 위하여 영업점에서만 가능합니다."];
        
        return;
    }*/
	
    

     
     if ([[[self.marrListData objectAtIndex:row] objectForKey:@"계좌번호"] hasPrefix:@"290"]) { // 신탁상품 해지
         
        // NSLog(@"==========%@",[self.marrListData objectAtIndex:row] );
         // NSLog(@"==========%@",[[self.marrListData objectAtIndex:row] objectForKey:@"계좌번호"]);
         SHBCloseProductConfirmViewController *viewController = [[SHBCloseProductConfirmViewController alloc]initWithNibName:@"SHBCloseProductConfirmViewController" bundle:nil];
         viewController.nMaxStep = 5;
         viewController.nFocusStep = 1;
         viewController.name_D3342 = [[self.marrListData objectAtIndex:row] objectForKey:@"상품명"];
         viewController.account_D3342 = [[self.marrListData objectAtIndex:row] objectForKey:@"계좌번호"];
         viewController.nServiceCode = kD3342Id;
         viewController.needsCert = YES;
         AppInfo.Close_type = @"only_allClose";
         [self checkLoginBeforePushViewController:viewController animated:YES];
         [viewController release];
         return;
     }
    
    
    
	NSString *str1 = [[[self.marrListData objectAtIndex:row]objectForKey:@"계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
	NSString *str2 = [[self.marrListData objectAtIndex:row]objectForKey:@"은행코드"];
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"고객번호" : AppInfo.customerNo,
						   //@"실명번호" : AppInfo.ssn,
                           //@"실명번호" : [AppInfo getPersonalPK],
                           @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
						   @"계좌번호" : str1,
						   @"은행구분" : @"1",
						   @"거래점용은행구분" : str2,
						   @"거래점용계좌번호" : str1,
						   @"업무구분" : @"1",
						   @"직원조회" : @"1",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kD3280Id viewController:self]autorelease];
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
	
    if([AppInfo.serviceCode isEqualToString:@"D0011"]) {
        
        NSMutableArray *tmpData = [aDataSet arrayWithForKey:@"예금계좌"];
        
        self.marrListData = [NSMutableArray array];
        
        for(int i=0; i<[tmpData count]; i++)
        {
            
            if (
                (
                 (
                  ([[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] >= 200 &&
                   [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] <= 240
                   )
                  &&
                  [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 216
                 )
                 ||
                 [[[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] == 290 &&
                 [[[tmpData objectAtIndex:i] objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||
                 [[[tmpData objectAtIndex:i] objectForKey:@"상품코드"] isEqualToString:@"290000601"]
                 )
                )
            {
                
                
                NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
                if ([[[tmpData objectAtIndex:i] objectForKey:@"상품부기명"] length] > 0)
                {
                    [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"상품부기명"] forKey:@"상품명"];
                    
                }
                else
                {
                    [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"과목명"] forKey:@"상품명"];
                }
                
                
                [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"계좌번호"] forKey:@"계좌번호"];
                [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"잔액"] forKey:@"잔액"];
                if ([[tmpData objectAtIndex:i] objectForKey:@"만기일자"] != nil) {  //주택청약은 만기일자 없음 2014. 2.27
                     [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"만기일자"] forKey:@"만기일자"];
                }
              //  [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"만기일자"] forKey:@"만기일자"];
                [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"은행코드"] forKey:@"은행코드"];
                [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"상품코드"] forKey:@"상품코드"];
                
              //  [tmp setObject:[[tmpData objectAtIndex:i] objectForKey:@"구계좌번호"] forKey:@"구계좌번호"];
                [self.marrListData addObject:tmp];
                

           
            }
            
        }
        
        [self.tableView reloadData];
        
        
        
    }
	else if (self.service.serviceId == kD3280Id) {
		self.data = aDataSet;	// D3280 데이터
		
		NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:1 AgoDay:0];
		NSString *currentDate = [dates objectAtIndex:1];
		
		self.service = [[[SHBProductService alloc]initWithServiceId:kD3611Id viewController:self]autorelease];
		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
									@"조회일자" : currentDate,
									@"attributeNamed" : @"mode",
									@"attributeValue" : @"ECHO",
									}];
		[self.service start];
	}
	else if (self.service.serviceId == kD3611Id) {
		self.dataList = [aDataSet arrayWithForKey:@"상품목록"];
		
		for (NSDictionary *dic in self.dataList)
		{
			NSString *strCode = [dic objectForKey:@"상품코드"];
			if ([[self.data objectForKey:@"상품코드"] isEqualToString:strCode]
				&& [[self.data objectForKey:@"일부해지건수"]intValue] < 2) {
				// 일부해지 화면으로 이동
				SHBCloseProductInputAmountViewController *viewController = [[SHBCloseProductInputAmountViewController alloc]initWithNibName:@"SHBCloseProductInputAmountViewController" bundle:nil];
				viewController.D3280 = self.data;
				viewController.needsCert = YES;
				[self checkLoginBeforePushViewController:viewController animated:YES];
				[viewController release];
				
				return NO;
			}
		}
		
		// 전체해지 화면으로 이동
		SHBCloseProductConfirmViewController *viewController = [[SHBCloseProductConfirmViewController alloc]initWithNibName:@"SHBCloseProductConfirmViewController" bundle:nil];
		viewController.nMaxStep = 5;
		viewController.nFocusStep = 1;
		viewController.D3280 = self.data;
		viewController.nServiceCode = kD3281Id;
		viewController.needsCert = YES;
        AppInfo.Close_type = @"only_allClose";
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
    
    
    return NO;
}


@end
