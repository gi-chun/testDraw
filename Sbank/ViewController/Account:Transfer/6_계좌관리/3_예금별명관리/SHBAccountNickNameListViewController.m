//
//  SHBAccountNickNameListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccountNickNameListViewController.h"
#import "SHBAccountService.h"
#import "SHBAccountNickNameListCell.h"
#import "SHBAccountNickNameInputViewController.h"

@interface SHBAccountNickNameListViewController ()
{
    int selectedRow;
    int serviceType;
}

@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@end

@implementation SHBAccountNickNameListViewController
@synthesize tableView1;

- (void)dealloc
{
    [tableView1 release], tableView1 = nil;
    [_tempLabel release];
    
    [super dealloc];
}

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
    
    self.title = @"계좌관리";
    self.strBackButtonTitle = @"예금별명관리 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    _tempLabel = @"";
    
    selectedRow = -1;
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    if (selectedRow != -1) {
        
        [tableView1 reloadData];
    }
    
    selectedRow = -1;
    serviceType = 0;
    // C2350 전문호출
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"거래구분" : @"9",
                            @"보안계좌조회구분" : @"2",
                            @"계좌감추기여부" : @"1",
                            @"reservationField1" : @"new",
                            }];

    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2350" viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedRow == indexPath.row){
        return 124;
    }
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [cell.textLabel setText:_tempLabel];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    SHBAccountNickNameListCell *cell = (SHBAccountNickNameListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountNickNameListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAccountNickNameListCell *)currentObject;
                break;
            }
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
//    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    cell.accountNameLabel.text = [cellDataSet objectForKey:@"과목명"];
	if ([[cellDataSet objectForKey:@"신계좌변환여부"] isEqualToString:@"1"])
    {
		cell.accountNoLabel.text = [cellDataSet objectForKey:@"계좌번호"];
	}
	else
	{
		cell.accountNoLabel.text = [cellDataSet objectForKey:@"구계좌번호"];
	}
    cell.nickNameLabel.text = [cellDataSet objectForKey:@"상품부기명"];

    cell.row = indexPath.row;
    cell.target = self;
    cell.openBtnSelector = @selector(openOrCloseCell:);
    //    NSLog(@"현재라인: [%d,%d], 상태: [%d]", indexPath.row, selectedRow, indexPath.row / 2);
    
    cell.inquiryBtnSelector = @selector(inqueryAccount:);
    cell.deleteBtnSelector = @selector(deleteAccount:);
    
    // 상품부기명을 기준으로 수정 등록을 판단
    if ([cellDataSet objectForKey:@"상품부기명"] != nil &&
		[[cellDataSet objectForKey:@"상품부기명"] length] > 0) {
        [cell.btnLeft setTitle:@"수정" forState:UIControlStateNormal];
        cell.btnRight.hidden = NO;
	}
	else {
        [cell.btnLeft setTitle:@"등록" forState:UIControlStateNormal];
        cell.btnRight.hidden = YES;
	}

    if(selectedRow == indexPath.row){
        cell.bgView.backgroundColor = RGB(244, 244, 244);
        
        if(cell.openBtnSelector != nil)
        {
            cell.btnOpen.hidden = NO;
            [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_close.png"] forState:UIControlStateNormal];
        }
        cell.btnLeft.hidden = NO;
        if ([cell.btnLeft.titleLabel.text isEqualToString:@"등록"])
            cell.btnRight.hidden = YES;
        else
            cell.btnRight.hidden = NO;
        
        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기닫기";

    }else{
        cell.bgView.backgroundColor = [UIColor clearColor];
        
        [cell.btnOpen setImage:[UIImage imageNamed:@"arrow_list_open.png"] forState:UIControlStateNormal];
        cell.btnLeft.hidden = YES;
        cell.btnRight.hidden = YES;

        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"펼쳐보기열기";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openOrCloseCell:indexPath.row];
}

- (void)openOrCloseCell:(int)row
{
    if(selectedRow == row)
    {
        selectedRow = -1;
    }
    else
    {
        selectedRow = row;
    }
    [tableView1 reloadData];
}

// 수정
- (void)inqueryAccount:(int)row
{
    NSLog(@"별명수정 %d", row);
    
    NSDictionary *dictionary = [self.dataList objectAtIndex:row];
    SHBAccountNickNameInputViewController *detailViewController = [[SHBAccountNickNameInputViewController alloc] initWithNibName:@"SHBAccountNickNameInputViewController" bundle:nil];
    detailViewController.outAccInfoDic = dictionary;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

// 삭제
- (void)deleteAccount:(int)row
{
    NSLog(@"별명삭제 %d", row);
    
    NSDictionary *dicData = [self.dataList objectAtIndex:row];
    serviceType = 1;
    // C2351 전문호출SHBAccountService
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"계좌번호" : [dicData objectForKey:@"계좌번호"],
                            @"은행구분" : @"0",
                            @"등록해제구분" : @"1",
                            @"등록해제코드" : @"21004",
                            @"반복횟수" : @"1",
                            @"변경후문자" : @"",
                            @"reservationField1" : @"delete",
                            }];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2351" viewController: self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];

}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    switch (serviceType) {
        case 0:
            self.dataList = [aDataSet arrayWithForKey:@"계좌목록"];
            break;

        case 1:
        {
            [self refresh];
        }
            break;
        default:
            break;
    }
    
    if ([self.dataList count] > 0) {
        _tempLabel = @"";
    } else {
        _tempLabel = @"조회된 거래내역이 없습니다.";
    }

    [tableView1 reloadData];
    
    self.service = nil;

    return YES;
}
@end
