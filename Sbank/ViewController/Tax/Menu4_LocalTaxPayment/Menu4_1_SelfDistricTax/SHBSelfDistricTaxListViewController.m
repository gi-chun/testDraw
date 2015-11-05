//
//  SHBSelfDistricTaxListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSelfDistricTaxListViewController.h"
#import "SHBSelfDistricTaxListCell.h"                   // tableView cell
#import "SHBGiroTaxListService.h"                       // 지로 지방세 서비스
#import "SHBSelfDistricTaxPaymentAccountViewController.h"           // 다음 view


@interface SHBSelfDistricTaxListViewController ()

@end

@implementation SHBSelfDistricTaxListViewController


#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;
@synthesize arrayData;
@synthesize tableView1;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    OFDataSet *aDataSet;
    
    if (intIndex == 1)      // 최초 진입
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : @"0200",
                     @"거래구분코드" : @"531001",
                     @"이용기관지로번호" : [[self.dicDataDictionary objectForKey:@"지역정보"] objectForKey:@"code"],
                     @"조회구분" : @"J",
                     @"간편납부번호" : @"",
                     //@"고지주민번호" : AppInfo.ssn,
                     @"고지주민번호" : [AppInfo getPersonalPK],
                     @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                     @"총고지건수" : @"",
                     @"총고지금액" : @"",
                     @"지정번호" : [NSString stringWithFormat:@"%d", intIndex],
                     @"데이터건수" : @""
                     }] autorelease];
    }
    else        // 재조회의 경우
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : @"0200",
                     @"거래구분코드" : @"531001",
                     @"이용기관지로번호" : [[self.dicDataDictionary objectForKey:@"지역정보"] objectForKey:@"code"],
                     @"조회구분" : @"Z",
                     @"간편납부번호" : strSimpleNumber,
                     @"총고지건수" : @"",
                     @"총고지금액" : @"",
                     @"지정번호" : [NSString stringWithFormat:@"%d", intIndex],
                     @"reservationField9" : @"재호출",
                     @"데이터건수" : @""
                     }] autorelease];
    }
    
    
    self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_DISTRIC_PAYMENT_LIST viewController: self ] autorelease];
    self.service.previousData = aDataSet;
    [self.service start];
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:
        {
            intIndex = intIndex + 10;
            [self requestService];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G1411"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            if ([aDataSet[@"지정번호"] isEqualToString:@"1"])
            {
                label1.text = [NSString stringWithFormat:@"%@ 건", [aDataSet objectForKey:@"총고지건수"]];
                label2.text = [NSString stringWithFormat:@"%@ 원", [aDataSet objectForKey:@"총고지금액"]];
                
                strSimpleNumber = aDataSet[@"간편납부번호"];
            }
            
            NSArray *array = [aDataSet arrayWithForKeyPath:@"지방세고지내역.vector.data"];
            
            for (NSDictionary *dic in array)
            {
                [self.arrayData addObject:dic];
            }
            
            // 마지막 경우 footer를 없앤다
            if ( [aDataSet[@"총고지건수"] intValue] < [aDataSet[@"지정번호"] intValue] + 10 )
            {
                tableView1.tableFooterView = nil;
            }
            else
            {
                tableView1.tableFooterView = viewMore;
            }
            
            [tableView1 reloadData];
        }
        else
        {
            [self.navigationController fadePopViewController];
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBSelfDistricTaxListCell *cell = (SHBSelfDistricTaxListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBSelfDistricTaxListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBSelfDistricTaxListCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [self.arrayData objectAtIndex:indexPath.row];

    cell.label1.text = dictionary[@"이용기관지로번호1->display"];                       // 지자체
    cell.label2.text = dictionary[@"세목명"];                                          // 세목
    cell.label3.text = dictionary[@"고지구분->display"];                                // 고지구분
    cell.label4.text = dictionary[@"납부기한"];                                         // 납부기한
    cell.label5.text = [NSString stringWithFormat:@"%@원", dictionary[@"납부금액"]];            // 납부금액
    
    return cell;
}


#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    SHBSelfDistricTaxPaymentAccountViewController *viewController = [[SHBSelfDistricTaxPaymentAccountViewController alloc] initWithNibName:@"SHBSelfDistricTaxPaymentAccountViewController" bundle:nil];
    viewController.dicDataDictionary = [self.arrayData objectAtIndex:indexPath.row];
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    // title 설정
    self.title = @"지방세납부";
    self.strBackButtonTitle = @"본인명의지방세납부 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    // 초기값 설정
    intIndex = 1;
    self.arrayData = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self requestService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.dicDataDictionary = nil;
    self.arrayData = nil;
    self.tableView1 = nil;
    
    [super dealloc];
}

@end
