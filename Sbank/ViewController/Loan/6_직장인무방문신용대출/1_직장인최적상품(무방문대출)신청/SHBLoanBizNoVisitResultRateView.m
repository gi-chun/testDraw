//
//  SHBLoanBizNoVisitResultRateView.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitResultRateView.h"
#import "SHBExchangePopupNoMoreCell.h" // cell

@implementation SHBLoanBizNoVisitResultRateView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.dataList = nil;
    
    [_popupView release];
    [_dataTable release];
    [_popupView2 release];
    [super dealloc];
}

#pragma mark -

- (void)layoutSubviews
{
    self.frame = [[UIScreen mainScreen] applicationFrame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    
    if ([_dataList count] == 0) {
        
        [_popupView setHidden:YES];
        [_popupView2 setHidden:NO];
    }
    else {
        
        [_popupView setHidden:NO];
        [_popupView2 setHidden:YES];
    }
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

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 100: {
            
            // 닫기
            
            [self fadeOut];
        }
            break;
            
        case 200: {
            
            // 확인
            
            if ([_delegate respondsToSelector:@selector(loanBizNoVisitResultRateOK)]) {
                
                [_delegate loanBizNoVisitResultRateOK];
            }
            
            [self fadeOut];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBExchangePopupNoMoreCell *cell = (SHBExchangePopupNoMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBExchangePopupNoMoreCell"];
    
    if (cell == nil) {
        
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBExchangePopupNoMoreCell"
                                                       owner:self options:nil];
		cell = (SHBExchangePopupNoMoreCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    NSDictionary *dic = _dataList[indexPath.row];
    [cell.nameLabel setText:dic[@"항목명"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
