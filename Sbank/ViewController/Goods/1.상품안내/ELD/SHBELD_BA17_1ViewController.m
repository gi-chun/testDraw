//
//  SHBELD_BA17_1ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_1ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBELD_BA17_1Cell.h"
#import "SHBELD_WebViewController.h"
#import "SHBELD_BA17_3ViewController.h"
#import "SHBProductService.h"

@interface SHBELD_BA17_1ViewController ()

@end

@implementation SHBELD_BA17_1ViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    // 웹뷰 - 지수연동예금 초보자가이드 화면 이동
    
    NSString *URL = @"";
    
    if (AppInfo.realServer) {
        URL = [NSString stringWithFormat:@"%@/sbank/yak/eld_mobile_01.html", URL_IMAGE];
    }
    else {
        URL = [NSString stringWithFormat:@"%@/sbank/yak/eld_mobile_01.html", URL_IMAGE_TEST];
    }
    
    SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                     @"SUBTITLE" : @"지수연동예금 초보자가이드",
                                     @"URL" : URL,
                                     @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

#pragma mark - Network

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    self.viewDataSource = [aDataSet arrayWithForKey:@"상품목록"];
    
    // 테이블 리스트 건수가 0일 경우, 모집기간이 아닙니다. 표시함
    if ([self.viewDataSource count] == 0) {
        
        self.tableView1.hidden = YES;
        self.view1.hidden = NO;
        [self.view bringSubviewToFront:self.view1];
        
        if (self.isPushAndScheme)
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:990 title:nil message:@"모집기간이 지난 상품입니다."];
            
            return NO;
        }
    }
    else {
        [self.tableView1 reloadData];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 990) {
        [self.navigationController fadePopToRootViewController];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.viewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBELD_BA17_1Cell *cell = (SHBELD_BA17_1Cell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    
    if (cell == nil) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBELD_BA17_1Cell" owner:self options:nil];
        cell = (SHBELD_BA17_1Cell *)[array objectAtIndex:0];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.label1.text = self.viewDataSource[indexPath.row][@"상품한글명"];
    
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // BA17-3 화면 이동
    SHBELD_BA17_3ViewController *viewController = [[SHBELD_BA17_3ViewController alloc] initWithNibName:@"SHBELD_BA17_3ViewController" bundle:nil];
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:self.viewDataSource[indexPath.row]];
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.tableView1 = nil;
    self.view1 = nil;
    self.viewDataSource = nil;
    self.button1 = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"예금/적금 가입"]; // 타이틀
    self.strBackButtonTitle = @"지수연동예금(ELD) 목록";
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"지수연동예금(ELD)" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    [self.view bringSubviewToFront:self.button1];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kD3276Id viewController: self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
