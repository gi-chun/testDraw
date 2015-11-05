//
//  SHBExRateListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExRateListViewController.h"
#import "SHBExchangeService.h"
#import "SHBExRateListCell.h"
#import "SHBExRateRequestViewController.h"

@interface SHBExRateListViewController ()
{
    int serviceType;
}

@end

@implementation SHBExRateListViewController
@synthesize inquiryList;
@synthesize widgetBtn;

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
    
    self.title = @"환율조회";
    
    self.strBackButtonTitle = @"환율조회 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    if (AppInfo.isiPhoneFive)
    {
        [self.exRateListTable setFrame:CGRectMake(self.exRateListTable.frame.origin.x, self.exRateListTable.frame.origin.y, self.exRateListTable.frame.size.width, self.view.frame.size.height - 37 - 35 - 30 - 64)];
        [self.widgetBtn setFrame:CGRectMake(self.widgetBtn.frame.origin.x, self.view.frame.size.height - 40, self.widgetBtn.frame.size.width, self.widgetBtn.frame.size.height)];
    }
    
    [self refresh];
}

- (void)refresh
{
    NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:0 AgoDay:0];
    NSString *startDate = [dates objectAtIndex:0];
    
    startDate = [SHBUtility getPreOPDate:startDate];

    if( nil == startDate )
    {
        dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:0 AgoDay:-1];
        startDate = [dates objectAtIndex:0];
    }

    serviceType = 0;
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"조회일자" : startDate,
                            @"고시회차" : @"0"
                            }] autorelease];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3730_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.inquiryList = nil;
    [widgetBtn release];
    [_exRateListTable release];
    [_lblExRate release];
    
	[super dealloc];
}

- (IBAction)registerWidget:(id)sender
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
    {
        [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:1561 title:@"" message:@"홈 화면에 통화목록\n아이콘이 생성됩니다.\n등록 하시겠습니까?"];
    }else
    {
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"iOS 5.0 이상 버젼에서\n등록 가능 합니다."];
    }
    
}
#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0: {
            serviceType = 1;
            _lblExRate.text = [NSString stringWithFormat:@"%@(%@/%@회차)", aDataSet[@"고시일자"], aDataSet[@"고시시간"], aDataSet[@"고시회차"]];
            self.inquiryList = [aDataSet arrayWithForKey:@"조회내역"];
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"codeKey" : @"CUR_C",
                                    @"language" : @"ko",
                                    @"type" : @"vector",
                                    }];
            
            self.service = nil;
            self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_CODE_SERVICE
                                                           viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 1: {
            NSDictionary *dataObject = nil;
            NSMutableDictionary *listItemDic = nil;
            NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];

            for (int i=0; i<[inquiryList count]; i++){
                dataObject = [inquiryList objectAtIndex:i];
                listItemDic = [[[NSMutableDictionary alloc] init] autorelease];
                
                for (NSMutableDictionary *dic in aDataSet[@"data"]) {
                    if ([[dataObject objectForKey:@"통화CODE"] isEqualToString:dic[@"hashtable"][@"code"]]) {
                        [listItemDic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"hashtable"][@"value"], dic[@"hashtable"][@"code"]]
                                forKey:@"1"];
                        [listItemDic setObject:[NSString stringWithFormat:@"%@", [dataObject objectForKey:@"매매기준환율"]] forKey:@"2"];
                        [listItemDic setObject:[NSString stringWithFormat:@"%@", [dataObject objectForKey:@"통화CODE"]] forKey:@"3"];
                        break;
                    }
                }
                [list addObject:listItemDic];
            }
            self.dataList = list;
            [_exRateListTable reloadData];
   
        }
            break;
            
        default:
            break;
    }
    

    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBExRateListCell *cell = (SHBExRateListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBExRateListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBExRateListCell *)currentObject;
                break;
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

//        UIView *selectionColor = [[UIView alloc] init];
//        selectionColor.backgroundColor = [UIColor colorWithRed:(108/255.0) green:(157/255.0) blue:(203/255.0) alpha:1];
//        cell.selectedBackgroundView = selectionColor;
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setSelectedBackgroundView:nil];
    }
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
//    [cell.codeLabel setTextColor:RGB(40, 91, 412)];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SHBExRateRequestViewController *viewController = [[SHBExRateRequestViewController alloc] initWithNibName:@"SHBExRateRequestViewController" bundle:nil];
    [viewController setDetailData:self.dataList[indexPath.row]];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alert clickedButtonAtIndex:buttonIndex];
    if (alert.tag == 1561 && buttonIndex == 0)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
        {
            //계좌조회 위젯
            NSString *nickName = @"S뱅크통화목록";
            
            nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            nickName = [nickName stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
            
            NSString *argStr = [NSString stringWithFormat:@"screenID=F3730&nickName=%@",nickName];
            #ifdef DEVELOPER_MODE
                        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"dev-m.shinhan.com", WIDGET_SERVICE_URL,argStr];
            #else
                        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"m.shinhan.com", WIDGET_SERVICE_URL,argStr];
            #endif
            NSLog(@"aaaa:%@",urlStr);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
}
@end
