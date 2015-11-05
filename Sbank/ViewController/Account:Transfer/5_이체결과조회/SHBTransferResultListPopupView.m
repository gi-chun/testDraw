//
//  SHBTransferResultListPopupView.m
//  ShinhanBank
//
//  Created by Joon on 14. 1. 3..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBTransferResultListPopupView.h"

@implementation SHBTransferResultListPopupView

- (void)setTableViewDataSource
{
    _tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell)
    {
       
        
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:_cellNibName owner:self options:nil];
		
        if (indexPath.row == 0) {
            cell = [cellArray objectAtIndex:2];
        }
        else
        {
            //xib파일의 객체중에 #번째 객체를 셋팅
            if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"])
            {
                cell = [cellArray objectAtIndex:1];
            }
            else
            {
                cell = [cellArray objectAtIndex:0];
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
	
    int row = [indexPath row];
	UILabel		*cell_lb;
	NSDictionary *dic = [_options objectAtIndex:row];
	
	if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"])
    {
		// 더보기영역
	}
    else
    {
		// 셀의 라벨수 만큼 딕셔너리에서 벨류 셋팅
		for (int i=1; i <= _cellLblCount; i++)
        {
			cell_lb = (UILabel *)[cell viewWithTag:i];
			[cell_lb setText:[dic objectForKey:[NSString stringWithFormat:@"%i",i]]];
		}
	}
	
    return cell;
}

@end
