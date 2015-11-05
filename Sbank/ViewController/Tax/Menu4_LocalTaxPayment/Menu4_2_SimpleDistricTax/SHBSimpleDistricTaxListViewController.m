//
//  SHBSimpleDistricTaxListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 6..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSimpleDistricTaxListViewController.h"
#import "SHBSimpleDistricTaxListCell.h"                         // tableView cell
#import "SHBGiroTaxListService.h"                                   // 지로 지방세 서비스
#import "SHBSimpleDistricTaxPaymentAccountViewController.h"         // 다음 view



@interface SHBSimpleDistricTaxListViewController ()

@end

@implementation SHBSimpleDistricTaxListViewController

#pragma mark -
#pragma mark Synthesize

@synthesize dicDataDictionary;
@synthesize arrayData;

#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    OFDataSet *aDataSet;
    
    // 최초 진입시
    if (intIndex == 1)
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : [self.dicDataDictionary objectForKey:@"전문종별코드"],
                     @"거래구분코드" : [self.dicDataDictionary objectForKey:@"거래구분코드"],
                     @"이용기관지로번호" : [self.dicDataDictionary objectForKey:@"이용기관지로번호"],
                     @"조회구분" : [self.dicDataDictionary objectForKey:@"조회구분"],
                     @"간편납부번호" : [self.dicDataDictionary objectForKey:@"간편납부번호"],
                     @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.dicDataDictionary objectForKey:@"고지주민번호"] : @"",
                     @"총고지건수" : [self.dicDataDictionary objectForKey:@"총고지건수"],
                     @"총고지금액" : [self.dicDataDictionary objectForKey:@"총고지금액"],
                     @"지정번호" : [NSString stringWithFormat:@"%d", intIndex],
                     @"데이터건수" : [self.dicDataDictionary objectForKey:@"데이터건수"]
                     }] autorelease];
    }
    else        // 이후 더보기 버튼
    {
        aDataSet = [[[OFDataSet alloc] initWithDictionary:
                     @{
                     @"전문종별코드" : [self.dicDataDictionary objectForKey:@"전문종별코드"],
                     @"거래구분코드" : [self.dicDataDictionary objectForKey:@"거래구분코드"],
                     @"이용기관지로번호" : [self.dicDataDictionary objectForKey:@"이용기관지로번호"],
                     @"조회구분" : [self.dicDataDictionary objectForKey:@"조회구분"],
                     @"간편납부번호" : [self.dicDataDictionary objectForKey:@"간편납부번호"],
                     @"총고지건수" : [self.dicDataDictionary objectForKey:@"총고지건수"],
                     @"총고지금액" : [self.dicDataDictionary objectForKey:@"총고지금액"],
                     @"지정번호" : [NSString stringWithFormat:@"%d", intIndex],
                     @"reservationField9" : @"재호출",
                     @"데이터건수" : [self.dicDataDictionary objectForKey:@"데이터건수"]
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
            label1.text = [NSString stringWithFormat:@"%@ 건", [aDataSet objectForKey:@"총고지건수"]];
            label2.text = [NSString stringWithFormat:@"%@ 원", [aDataSet objectForKey:@"총고지금액"]];
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
    SHBSimpleDistricTaxListCell *cell = (SHBSimpleDistricTaxListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBSimpleDistricTaxListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBSimpleDistricTaxListCell *)currentObject;
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
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    SHBSimpleDistricTaxPaymentAccountViewController *viewController = [[SHBSimpleDistricTaxPaymentAccountViewController alloc] initWithNibName:@"SHBSimpleDistricTaxPaymentAccountViewController" bundle:nil];
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
    self.strBackButtonTitle = @"간편납부번호 메인";
    
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
    
    [super dealloc];
}

@end
