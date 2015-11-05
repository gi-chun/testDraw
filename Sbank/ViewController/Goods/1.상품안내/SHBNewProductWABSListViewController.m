//
//  SHBNewProductWABSListViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 2. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNewProductWABSListViewController.h"
#import "SHBProductService.h" // 서비스

#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductWABSDetailViewController.h"

@interface SHBNewProductWABSListViewController ()

- (void)setNotification;

@end

@implementation SHBNewProductWABSListViewController

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
    
    [self setNotification];
    
    [self setTitle:@"예금/적금 가입"];
    
    NSString *subTitle = [NSString stringWithFormat:@"신한 재형저축 신청결과 조회/취소"];
    
    self.strBackButtonTitle = subTitle;
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:subTitle maxStep:0 focusStepNumber:0] autorelease]];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kD3310Id viewController:self] autorelease];
    
    [self.service setTableView:_dataTable
             tableViewCellName:@"SHBNewProductWABSListCell"
                   dataSetList:@"조회내역.vector.data"];
    
	[self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dicSelectedData = nil;
    
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [super viewDidUnload];
}

#pragma mark - Notification

- (void)getElectronicSignCancel
{
    [self setNotification];
    
    for (SHBBaseViewController *viewController in self.navigationController.viewControllers) {
		if ([viewController isKindOfClass:[SHBNewProductWABSListViewController class]]) {
			[self.navigationController fadePopToViewController:viewController];
		}
	}
}

#pragma mark - 

- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"NewProductCancel"
                                               object:nil];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    self.dataList = [aDataSet arrayWithForKey:@"조회내역"];
    
    for (NSMutableDictionary *dic in self.dataList) {
        [dic setObject:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[dic objectForKey:@"예약신규금액"]]]
                forKey:@"_신규금액"];
        
        if ([[dic objectForKey:@"계좌상태"] isEqualToString:@"91"]) {
            [dic setObject:@"신규예약" forKey:@"_계좌상태"];
        }
        else {
            [dic setObject:@"취소" forKey:@"_계좌상태"];
        }
        
        [dic setObject:[dic objectForKey:@"상품명"] forKey:@"_상품명"];
        
        [dic setObject:[SHBUtility getDateWithDash:[dic objectForKey:@"예약신규일"]]
                forKey:@"_예약신규일"];
        [dic setObject:[SHBUtility getDateWithDash:[dic objectForKey:@"신규일"]]
                forKey:@"_신규예정일"];
        [dic setObject:[SHBUtility getDateWithDash:[dic objectForKey:@"만기일"]]
                forKey:@"_만기일"];
        [dic setObject:[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange([[dic objectForKey:@"계좌번호"] length] - 6, 6)]
                forKey:@"_신청번호"];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"재형저축 신청조회 리스트가 없습니다."];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController fadePopViewController];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHBNewProductWABSDetailViewController *viewController = [[[SHBNewProductWABSDetailViewController alloc] initWithNibName:@"SHBNewProductWABSDetailViewController" bundle:nil] autorelease];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.dataList objectAtIndex:indexPath.row]];
    
    [dic setObject:[self.dicSelectedData objectForKey:@"상품명"]
            forKey:@"상품명"];
    
    viewController.dicSelectedData = dic;
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
