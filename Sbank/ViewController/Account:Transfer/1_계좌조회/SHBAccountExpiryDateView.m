//
//  SHBAccountExpiryDateView.m
//  ShinhanBank
//
//  Created by Joon on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBAccountExpiryDateView.h"
#import "SHBAccountExpiryDateListCell.h" // cell

@implementation SHBAccountExpiryDateView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.dataList = nil;
    
    [_popupView release];
    [_dataTable release];
    [_infoView release];
    [_infoView2 release];
    [_checkBtn release];
    [super dealloc];
}

#pragma mark -

- (void)layoutSubviews
{
    self.frame = [[UIScreen mainScreen] applicationFrame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    
    [_infoView initFrame:_infoView.frame];
    [_infoView setText:@"<midGray_13>오늘 날짜를 기준으로 이후 1개월까지의</midGray_13>"];
    [_infoView2 initFrame:_infoView2.frame];
    [_infoView2 setText:@"<midLightBlue_13>만기예정 및 경과상품</midLightBlue_13><midGray_13>의 목록을 보여줍니다.</midGray_13>"];
}

#pragma mark - Notification

- (void)logoutClose
{
    [self fadeOut];
}

#pragma mark - 

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    
    if (animated) {
        [self fadeIn];
    }
}

- (void)fadeIn
{
    _popupView.transform = CGAffineTransformMakeScale(.2, .2);
    _popupView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        _popupView.alpha = 1;
        _popupView.transform = CGAffineTransformMakeScale(1, 1);
    }];
	
}

- (void)fadeOut
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [UIView animateWithDuration:.35 animations:^{
        _popupView.transform = CGAffineTransformMakeScale(.2, .2);
        _popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Button

- (IBAction)closePopupViewWithButton:(UIButton *)sender
{
    [self fadeOut];
}

- (IBAction)checkButton:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    if ([_checkBtn isSelected]) {
        
        switch (_accountType) {
                
            case 0: {
                
                // 예금/신탁
                
                [[NSUserDefaults standardUserDefaults] setExpiryDateValue:AppInfo.tran_Date];
            }
                break;
                
            case 2: {
                
                // 대출
                
                [[NSUserDefaults standardUserDefaults] setExpiryDateValue2:AppInfo.tran_Date];
            }
                break;
                
            default:
                break;
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self fadeOut];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBAccountExpiryDateListCell *cell = (SHBAccountExpiryDateListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBAccountExpiryDateListCell"];
    
    if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountExpiryDateListCell"
                                                       owner:self options:nil];
		cell = (SHBAccountExpiryDateListCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    NSDictionary *dic = _dataList[indexPath.row];
    
    [cell.accountName initFrame:cell.accountName.frame
                      colorType:RGB(74, 74, 74)
                       fontSize:15
                      textAlign:0];
    [cell.accountName setCaptionText:dic[@"계좌명"]];
    
    [cell.accountNo setText:dic[@"계좌번호"]];
    [cell.expiryDate setText:[NSString stringWithFormat:@"만기일 %@", dic[@"_만기일자"]]];
    
    NSString *today = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *expiryDate = [dic[@"_만기일자"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([expiryDate integerValue] <= [today integerValue])
    {
        [cell.expiryDate setTextColor:RGB(0, 137, 220)];
    }
    else
    {
        [cell.expiryDate setTextColor:RGB(44, 44, 44)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(accountExpiryDateSelected:withIndex:)]) {
        NSDictionary *dic = _dataList[indexPath.row];
        [_delegate accountExpiryDateSelected:dic withIndex:indexPath.row];
    }
    
    [self fadeOut];
}

@end
