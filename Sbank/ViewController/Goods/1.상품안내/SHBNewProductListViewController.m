//
//  SHBNewProductListViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBNewProductListViewController.h"
#import "SHBNewProductListCell.h"
#import "SHBProductService.h"
#import "SHBNewProductInfoViewController.h"
#import "SHBNewProductStipulationViewController.h"
#import "SHBELD_BA17_1ViewController.h"
#import "SHB_GoldTech_ProductInfoViewcontroller.h"

@interface SHBNewProductListViewController ()

@property (nonatomic, retain) NSMutableArray *marrSectionDatas;	// 섹션데이터를 저장할 배열 (상품구분별로 섹션구분)
@property (nonatomic, retain) NSString *depositUrl;		// ??

@end

// sorting 관련
@implementation NSString (Support)

-(NSComparisonResult)nameCompare:(NSString *)comp // 스트링으로 순서 비교(오름 차순)
{
    if([self compare:comp] == NSOrderedAscending) // 문자열의 비교 : compare
        return NSOrderedAscending;
    else if([self compare:comp] == NSOrderedSame)
        return NSOrderedSame;
    else
        return NSOrderedDescending;
}

@end


@implementation SHBNewProductListViewController

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
	[_depositUrl release];
	[_marrSectionDatas release];
	[_tblProduct release];
	[super dealloc];
}

- (void)viewDidUnload
{
	self.tblProduct = nil;
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
     self.strBackButtonTitle = @"예금적금 상품신규리스트";

    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.tblProduct setBackgroundColor:RGB(244, 239, 233)];	
	
	if (![self isPushAndScheme]) {	// 푸쉬로 온게 아니면, 일반적인 상품전체리스트 전문 요청
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;

        
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
													TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
												  TASK_ACTION_KEY : @"getPrdNewList",
							   @"attributeNamed" : @"mode",
							   @"attributeValue" : @"ECHO",
							   }];
		
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00004 viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}
	
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	NSIndexPath *selectedIndexPath = [self.tblProduct indexPathForSelectedRow];
	if (selectedIndexPath) {
		[self.tblProduct deselectRowAtIndexPath:selectedIndexPath animated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
	
	[self.tblProduct flashScrollIndicators];
	
	if ([self needsAllList])	// 상품상세화면에서 백키로 왔을 때 상품 전체리스트 전문날린다.
	{
		[self setNeedsAllList:NO];
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
													TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
												  TASK_ACTION_KEY : @"getPrdNewList",
							   @"attributeNamed" : @"mode",
							   @"attributeValue" : @"ECHO",
							   }];
		
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00004 viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}

#pragma mark - Push
- (void)executeWithDic:(NSMutableDictionary *)mDic	// 푸쉬로 왔으면
{
	[super executeWithDic:mDic];
	if (mDic && [mDic objectForKey:@"productCode"]) {
        self.needsAllList = YES;
//		NSString *strProductCode = [mDic objectForKey:@"productCode"];
//		NSString *strStaffNo = [mDic objectForKey:@"recStaffNo"];
		Debug(@"mDic : %@", mDic);
		
        if (mDic[@"productCode"])
        {
            SHBNewProductInfoViewController *viewController = [[SHBNewProductInfoViewController alloc]initWithNibName:@"SHBNewProductInfoViewController" bundle:nil];
            viewController.mdicPushInfo = mDic;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];
        }
		
	}
    else {
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                     TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                                                     TASK_ACTION_KEY : @"getPrdNewList",
                                                                     @"attributeNamed" : @"mode",
                                                                     @"attributeValue" : @"ECHO",
                                                                     }];
		
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00004 viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
	return [self.marrSectionDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSMutableArray *marrSection = [self.marrSectionDatas objectAtIndex:section];
	
	return [marrSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBNewProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[SHBNewProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	
	NSDictionary *dicData = [[self.marrSectionDatas objectAtIndex:section]objectAtIndex:row];
	
	[cell.lblProductName setText:[dicData objectForKey:@"상품명"]];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSMutableDictionary *dicData = [[self.marrSectionDatas objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
	Debug(@"버전 : %@", [dicData objectForKey:@"버전"]);
	float serverVersion = [[dicData objectForKey:@"버전"]floatValue];
	float localVersion = [SIB_NEWDEPOSITVERSION floatValue];
	
	if (serverVersion > localVersion) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                         message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                        delegate:self
                                               cancelButtonTitle:@"확인"
                                               otherButtonTitles:@"업데이트", nil] autorelease];
        
        [alert setTag:4321];
		[alert show];
		
		return;
	}
	
	if ([[dicData objectForKey:@"상품구분"]intValue] >= 90) {
		UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"" message:@"해당 상품의 페이지로 이동하시면 이용중인 신한S뱅크는 자동으로 종료됩니다. 진행하시겠습니까?" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil]autorelease];
		[alert setTag:3000];
		[alert show];
		
		Debug(@"상품특약명1 : %@", [dicData objectForKey:@"상품특약명1"]);
		self.depositUrl = [dicData objectForKey:@"상품특약명1"];
		
		return;
	}
	
    // ELD
    if ([[dicData objectForKey:@"상품코드"] isEqualToString:@"999900001"]) {
        
        SHBELD_BA17_1ViewController *viewController = [[SHBELD_BA17_1ViewController alloc] initWithNibName:@"SHBELD_BA17_1ViewController" bundle:nil];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
        return;
    }
    
    // 신한골드리슈골드테크
    if ([[dicData objectForKey:@"상품코드"] isEqualToString:@"187000101"]) {
        
        SHB_GoldTech_ProductInfoViewcontroller *viewController = [[SHB_GoldTech_ProductInfoViewcontroller alloc] initWithNibName:@"SHB_GoldTech_ProductInfoViewcontroller" bundle:nil];
        viewController.dicSelectedData = dicData;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
        return;
    }
    
	SHBNewProductInfoViewController *viewController = [[SHBNewProductInfoViewController alloc]initWithNibName:@"SHBNewProductInfoViewController" bundle:nil];
	viewController.dicSelectedData = dicData;
	
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.marrSectionDatas objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    
	return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat fRetVal = 0;
	
	fRetVal = 34;
	
	return fRetVal;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *viewSection = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 317, 34)]autorelease];
	[viewSection setBackgroundColor:RGB(235, 217, 195)];
	
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, 34, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[viewSection addSubview:lineView];
	
	UIImageView *ivBullet = [[[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 13, 13)]autorelease];
	[ivBullet setImage:[UIImage imageNamed:@"bullet_1"]];
	[viewSection addSubview:ivBullet];
	
    if( [[self.marrSectionDatas objectAtIndex:section] count] > 0 )
    {
        UILabel *lblSectionTitle = [[[UILabel alloc]initWithFrame:CGRectMake(27, 0, 280, 34)] autorelease];
        [lblSectionTitle setBackgroundColor:[UIColor clearColor]];
        [lblSectionTitle setTextColor:RGB(40, 91, 142)];
        [lblSectionTitle setFont:[UIFont systemFontOfSize:15]];
        [lblSectionTitle setText:[[[self.marrSectionDatas objectAtIndex:section] objectAtIndex:0] objectForKey:@"상품구분명"]];
        [viewSection addSubview:lblSectionTitle];
    }
		
	return viewSection;
}
		
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // 상품페이지
	if (alertView.tag == 3000 && buttonIndex == alertView.cancelButtonIndex) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.depositUrl]];
		exit(1);
	}
    
    // 업데이트
    if (alertView.tag == 4321 && buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
    }
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
	if (self.service.serviceId == XDA_S00004) {
		self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
		Debug(@"self.dataList : %@", self.dataList);

		self.marrSectionDatas = [NSMutableArray array];
		
		Debug(@"%d", [self.dataList count]);
		/**
		 상품구분
		 1 = 전용상품
		 2 = 적금
		 3 = 정기예금
		 4 = 청약저축
		 5 = 특화상품
		 .
		 .
		 .
		 */
        
        NSMutableArray *arrayName = [NSMutableArray array];
        // 상품구분명에 따른 데이터를 담는 array 상품구분명 형태에 따라 공간 확보
        NSMutableArray *arrayData = [NSMutableArray array];
        
        BOOL isFirst = YES;
        
        // 상품 구분명 array에 담기
		for (NSDictionary *dic in self.dataList)
		{
            if(isFirst)
            {
                [arrayName addObject:dic[@"상품구분명"]];
                isFirst = NO;
                
                NSMutableArray *arrayTemp = [NSMutableArray array];
                [arrayData addObject:arrayTemp];
            }
            
            NSMutableArray *marrSection = [NSMutableArray array];
            [self.marrSectionDatas addObject:marrSection];
            
            BOOL isNeedInsert = YES;
            for (NSString *strName in arrayName)
            {
                if([strName isEqualToString:dic[@"상품구분명"]])
                {
                    isNeedInsert = NO;
                }
            }
            if (isNeedInsert)
            {
                NSMutableArray *arrayTemp = [NSMutableArray array];
                
                [arrayName addObject:dic[@"상품구분명"]];
                [arrayData addObject:arrayTemp];
            }
		}
        
        int intIndex = 0;
        
		for (NSDictionary *dic in self.dataList)        // 데이터를 넣는다
		{
            for ( int i = 0 ; i < [arrayName count] ; i++ )
            {
                if([dic[@"상품구분명"] isEqualToString:[arrayName objectAtIndex:i]])
                {
                    intIndex = i;
                    break;
                }
            }
            [[arrayData objectAtIndex:intIndex] addObject:dic];
		}
        
        intIndex = 0;
        
        for (NSArray *array in arrayData)
        {
            // 상품순서와 상관없이 내려오는 순서대로
            for (int i = 0 ; i < [array count] ; i++)
            {
                [[self.marrSectionDatas objectAtIndex:intIndex] addObject:[array objectAtIndex:i]];
            }
            
            // 상품순서에 따른 정렬 주석 처리
//            NSMutableArray *mArray = [NSMutableArray array];
//            NSArray *arrayResult = [NSArray array];
//            
//            for (int i = 0 ; i < [array count] ; i++)
//            {
//                [mArray addObject:[[array objectAtIndex:i] objectForKey:@"상품순서"]];
//            }
//            
//            // 상품순서에 따른 정렬
//            arrayResult = [mArray sortedArrayUsingSelector:@selector(nameCompare:)];
//            
//            for (int j = 0 ; j < [arrayResult count] ; j++)
//            {
//                for( int k = 0 ; k < [array count] ; k++)
//                {
//                    // 정렬된 배열과 비교하여 데이터 넣기
//                    if ([[arrayResult objectAtIndex:j] isEqualToString:[[array objectAtIndex:k] objectForKey:@"상품순서"]])
//                    {
//                        [[self.marrSectionDatas objectAtIndex:intIndex] addObject:[array objectAtIndex:k]];
//                        break;
//                    }
//                }
//            }
            
            intIndex++;
        }
	}
	
	[self.tblProduct reloadData];
	[self.tblProduct flashScrollIndicators];
	
	/**
	 계약기간_선택1 = 3;
	 판매종료일자 = 209912310000;
	 계약기간_선택2 = 6;
	 상품가입불가코드 = ;
	 세금우대_생계형가능여부 = 1;
	 계약기간_선택3 = 12;
	 계약기간_자유_최소기간 = 0;
	 계약기간_선택4 = 0;
	 계약기간_선택5 = 0;
	 적립방식_정기예금여부 = 1;
	 계약기간_선택여부 = 1;
	 쿠폰입력여부 = 0;
	 금액_최소금액 = 500000;
	 상품특\354\225\275명1 = 신한 스마트 정기예금 특약;
	 적립방식_자유적립식여부 = 0;
	 상품특약명3 = ;
	 가입가능나이최소 = 0;
	 계약기간_자유여부 = 0;
	 상품특약명5 = ;
	 판매시작일자 = 201207030000;
	 세금우대_세금우대가능여부 = 1;
	 금액_최대금액 = 30000000;
	 안드로이드출력여부 = 1;
	 가입가능나이최대 = 999;
	 청약여부 = 0;
	 회전주기_선택비트 = 0;
	 자동이체_최소금액 = 0;
	 이자지급방법 = 3;
	 세금우대_분기당납입한도 = 0;
	 상품특약수 = 1;
	 회전주기_고정 = 0;
	 아이패드출력여부 = 1;
	 계약기간_고정_기간 = 0;
	 계약기간_고정여부 = 0;
	 자동이체_최대금액 = 0;
	 자동이체_분기별가능금액 = 0;
	 버전 = 1.0;
	 판매한도금액 = 0;
	 상품구분순서 = 1;
	 세금우대_금액입력여부 = 0;
	 계약기간_자유_최대기간 = 0;
	 세금우대_일반과세가능여부 = 1;
	 세금우대_D4222저축종류 = 41;
	 동영상URL = ;
	 상품가입가능코드 = ;
	 상품순서 = 2;
	 상품특약명2 = ;
	 상품특약명4 = ;
	 재예치가능여부 = 0;
	 상품명 = 신한 스마트 정기예금;
	 자동이체_가능여부 = 0;
	 세금우대_안내문구출력비트 = 111000;
	 적립방식_정기적립식여부 = 0;
	 지급주기 = 0;
	 상품구분 = 1;
	 동영상여부 = 0;
	 금액_입금단위금액 = 1;
	 아이폰출력여부 = 1;
	 상품코드 = 200013503;
	 상품구분명 = 전용상품;
	 쿠폰조회여부 = 0;
	 */
	
	
    return NO;
}

@end
