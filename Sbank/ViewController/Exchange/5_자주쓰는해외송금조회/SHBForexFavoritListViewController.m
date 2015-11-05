//
//  SHBForexFavoritListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritListViewController.h"
#import "SHBForexFavoritListCell.h" // cell
#import "SHBExchangeService.h" // 서비스

#import "SHBForexFavoritDetailViewController.h" // 자주쓰는 해외송금 상세

#define TABLEVIEWCELL_HEIGHT 111 // cell 최소 높이
#define DATALABEL_WIDTH 180 // label 최대 길이

@interface SHBForexFavoritListViewController ()

/**
 view를 text 크기에 맞춰 조정
 @param view 조정할 view
 @param xx x좌표
 @param yy y좌표
 @param text text
 */
- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text;

@end

@implementation SHBForexFavoritListViewController

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
    
    [self setTitle:@"자주쓰는 해외송금/조회"];
    self.strBackButtonTitle = @"자주쓰는 해외송금 목록";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F2035_SERVICE
                                                   viewController:self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_dataTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
	[super viewDidUnload];
}

#pragma mark -

- (void)adjustToView:(UIView *)view originX:(CGFloat)xx originY:(CGFloat)yy text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:15]];
    
    CGSize labelSize = [text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(view.frame.size.width, 999)
                            lineBreakMode:label.lineBreakMode];
    
    if (labelSize.height > 36) {
        labelSize.height = 36;
    }
    else {
        labelSize.height = 16;
    }
    
    [view setFrame:CGRectMake(xx,
                              yy,
                              view.frame.size.width,
                              labelSize.height + 2)];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    Debug(@"%@", aDataSet);
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"조회내역"]) {
        // 가변 길이 설정
        CGFloat addHeight = 0;
        
        UILabel *label = [[[UILabel alloc] init] autorelease];
        [label setFont:[UIFont systemFontOfSize:15]];
        
        CGSize label1Size = [dic[@"수취인은행정보1"] sizeWithFont:label.font
                                        constrainedToSize:CGSizeMake(999, 16)
                                            lineBreakMode:label.lineBreakMode];
        
        CGSize label2Size = [dic[@"수취인정보내용1"] sizeWithFont:label.font
                                        constrainedToSize:CGSizeMake(999, 16)
                                            lineBreakMode:label.lineBreakMode];
        
        
        if (DATALABEL_WIDTH < label1Size.width) {
            addHeight += 18;
        }
        
        if (DATALABEL_WIDTH < label2Size.width) {
            addHeight += 18;
        }
        
        [dic setObject:[NSString stringWithFormat:@"%f", addHeight + 1]
                forKey:@"cellHeight"];
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    self.dataList = [aDataSet arrayWithForKey:@"조회내역"];
    
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"과거 해외송금 내역이 존재하지 않습니다."];
        return NO;
    }
    
    [_dataTable reloadData];
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController fadePopViewController];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    return TABLEVIEWCELL_HEIGHT + [cellDataSet[@"cellHeight"] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBForexFavoritListCell *cell = (SHBForexFavoritListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexFavoritListCell"];
	if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexFavoritListCell"
                                                       owner:self options:nil];
		cell = (SHBForexFavoritListCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    // 가변 길이 설정
    CGFloat yy = cell.bankName.frame.origin.y;
    
    [self adjustToView:cell.bankName
               originX:cell.bankName.frame.origin.x
               originY:yy
                  text:cell.bankName.text];
    
    yy += cell.bankName.frame.size.height + 9;
    
    [self adjustToView:cell.accountNumberLabel
               originX:cell.accountNumberLabel.frame.origin.x
               originY:yy
                  text:cell.accountNumberLabel.text];
    [self adjustToView:cell.accountNumber
               originX:cell.accountNumber.frame.origin.x
               originY:yy
                  text:cell.accountNumber.text];
    
    yy += cell.accountNumber.frame.size.height + 9;
    
    [self adjustToView:cell.consigneeLabel
               originX:cell.consigneeLabel.frame.origin.x
               originY:yy
                  text:cell.consigneeLabel.text];
    [self adjustToView:cell.consignee
               originX:cell.consignee.frame.origin.x
               originY:yy
                  text:cell.consignee.text];
    
    [cell.line setFrame:CGRectMake(cell.line.frame.origin.x,
                                   TABLEVIEWCELL_HEIGHT + [cellDataSet[@"cellHeight"] floatValue] - 1,
                                   cell.line.frame.size.width,
                                   cell.line.frame.size.height)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBForexFavoritDetailViewController *viewController = [[[SHBForexFavoritDetailViewController alloc] initWithNibName:@"SHBForexFavoritDetailViewController" bundle:nil] autorelease];
    [viewController setDetailData:self.dataList[indexPath.row]];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
