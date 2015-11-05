//
//  SHBProductMenualListViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBProductMenualListViewController.h"
#import "SHBProductMenualListCell.h" // cell
#import "SHBAccountService.h" // 서비스

#import "SHBNewProductSeeStipulationViewController.h"

@interface SHBProductMenualListViewController ()

@end

@implementation SHBProductMenualListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"약관 ∙ 상품설명서"];
    self.strBackButtonTitle = @"약관 ∙ 상품설명서";
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
        
        if ([dic[@"상품코드"] length] > 0) {
            
            if ([dic[@"상품부기명"] length] > 0) {
                
                [dic setObject:dic[@"상품부기명"] forKey:@"_과목명"];
            }
            else {
                
                [dic setObject:dic[@"과목명"] forKey:@"_과목명"];
            }
            
            if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                
                [dic setObject:dic[@"계좌번호"] forKey:@"_계좌번호"];
            }
            else {
                
                [dic setObject:dic[@"구계좌번호"] forKey:@"_계좌번호"];
            }
            
            [array addObject:dic];
        }
    }
    
    self.dataList = (NSArray *)array;
    
    if ([self.dataList count] == 0) {
        
        [_dataTable setHidden:YES];
        [self.view addSubview:_noDataView];
        
        FrameReposition(_noDataView, _dataTable.frame.origin.x, _dataTable.frame.origin.y);
    }
    else {
        
        [_dataTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_dataTable release];
    [_noDataView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setNoDataView:nil];
    [super viewDidUnload];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
    
    viewController.strUrl = aDataSet[@"YAKWAN_URL"];
    viewController.strBackButtonTitle = @"약관 ∙ 상품설명서 보기";
    viewController.strName = @"약관 ∙ 상품설명서";
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBProductMenualListCell *cell = (SHBProductMenualListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBProductMenualListCell"];
    
	if (!cell) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBProductMenualListCell"
                                                       owner:self options:nil];
		cell = (SHBProductMenualListCell *)array[0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceId:PRODUCT_MENUAL viewController:self] autorelease];
    
    self.service.previousData = [SHBDataSet dictionaryWithDictionary:@{ @"상품코드" : dic[@"상품코드"] }];
    
    [self.service start];
}

@end
