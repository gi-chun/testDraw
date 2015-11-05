//
//  SHBEasyCloseListViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseListViewController.h"
#import "SHBEasyCloseListCell.h" // cell
#import "SHBProductService.h" // service

#import "SHBEasyCloseViewController.h" // 신한e-간편해지 서비스 신청

@interface SHBEasyCloseListViewController ()

@end

@implementation SHBEasyCloseListViewController

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
    
    [self setTitle:@"신한e-간편해지"];
    self.strBackButtonTitle = @"신한e-간편해지 계좌 목록";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"거래구분" : @"9",
                              @"고객번호" : AppInfo.customerNo,
                              @"보안계좌" : @"2",
                              @"인터넷조회금지" : @"1"
                              }];
    
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kE2670Id viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
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

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"대출만기도래목록"]) {
        
        if ([dic[@"예금종류"] isEqualToString:@"2"]) {
            
            NSString *endDate = [[SHBUtility dateStringToMonth:1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            // 만기일(입력값)이 한달이내에 있는지 확인
            if ([dic[@"만기일자"] length] != 0 && [dic[@"만기일자->originalValue"] integerValue] <= [endDate integerValue]) {
                
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
                
                [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"잔액"]] forKey:@"_잔액"];
                
                NSInteger today = [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                
                if (today >= [dic[@"만기일자->originalValue"] integerValue] && [dic[@"해지가능일->originalValue"] integerValue] >= today) {
                    
                    [dic setObject:[NSString stringWithFormat:@"가능 (%@까지)", dic[@"해지가능일"]] forKey:@"_해지가능여부"];
                }
                else {
                    
                    if ([dic[@"잔액->originalValue"] longLongValue] > 50000000) {
                        
                        [dic setObject:@"불가(5천만원초과)" forKey:@"_해지가능여부"];
                    }
                    else {
                        
                        if ([dic[@"해지가능일"] length] == 0) {
                            
                            [dic setObject:@"불가(미신청)" forKey:@"_해지가능여부"];
                        }
                        else {
                            
                            if ([dic[@"만기일자->originalValue"] integerValue] > today) {
                                
                                [dic setObject:@"불가(만기미도래)" forKey:@"_해지가능여부"];
                            }
                            
                            if (today > [dic[@"해지가능일->originalValue"] integerValue]) {
                                
                                [dic setObject:@"불가(신청기간경과)" forKey:@"_해지가능여부"];
                            }
                        }
                    }
                }
                
                [array addObject:dic];
            }
        }
    }
    
    self.dataList = (NSArray *)array;
    
    [_dataTable reloadData];
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        
        return 1;
    }
    
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [cell.textLabel setText:@"해지 가능 계좌가 없습니다."];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }
    
    SHBEasyCloseListCell *cell = (SHBEasyCloseListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBEasyCloseListCell"];
    
	if (!cell) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBEasyCloseListCell"
                                                       owner:self options:nil];
		cell = (SHBEasyCloseListCell *)array[0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    if ([SHBUtility isFindString:cell.closePossibleL.text find:@"가능"]) {
        
        [cell.closePossibleL setTextColor:RGB(0, 137, 220)];
    }
    else {
        
        [cell.closePossibleL setTextColor:RGB(209, 75, 75)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        
        return;
    }
    
    NSDictionary *dic = self.dataList[indexPath.row];
    
    if ([SHBUtility isFindString:dic[@"_해지가능여부"] find:@"불가"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"해지 불가한 계좌입니다."];
        return;
    }
    
    SHBEasyCloseViewController *viewController = [[[SHBEasyCloseViewController alloc] initWithNibName:@"SHBEasyCloseViewController" bundle:nil] autorelease];
    
    viewController.data = dic;
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

@end
