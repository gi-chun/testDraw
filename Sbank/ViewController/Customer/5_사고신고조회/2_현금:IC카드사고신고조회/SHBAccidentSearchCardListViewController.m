//
//  SHBAccidentSearchCardListViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSearchCardListViewController.h"
#import "SHBAccidentSearchCardListCell.h"

@interface SHBAccidentSearchCardListViewController ()

@end

@implementation SHBAccidentSearchCardListViewController

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
    [self setTitle:@"사고신고 조회"];
    
    self.strBackButtonTitle = @"현금/IC카드사고신고조회 상세";
    
//    _lblName.text = AppInfo.commonDic[@"고객명"];
//    _lblCustomerNo.text = [NSString stringWithFormat:@"%@-●●●●●●●",
//                           [AppInfo.commonDic[@"주민등록번호"] substringWithRange:NSMakeRange(0, 6)] ] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.listData count] == 0) {
        return 1;
    }
    
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.listData count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [cell.textLabel setText:@"조회된 거래내역이 없습니다."];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    SHBAccidentSearchCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"SHBAccidentSearchCardListCell" owner:self options:nil];
		
		cell = [array objectAtIndex:0];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    OFDataSet *cellDataSet = self.listData[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 154;
}

@end
