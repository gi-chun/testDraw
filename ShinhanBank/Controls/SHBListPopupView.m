//
//  SHBListPopupView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 24..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBListPopupView.h"

#define LIST_POPUP_VIEW_TAG	12345

@interface SHBListPopupView (private)
- (void)fadeIn;
- (void)fadeOut;
@end


@implementation SHBListPopupView
@synthesize delegate;

#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle options:(NSMutableArray *)aOptions CellNib:(NSString*)cellNib CellH:(float)cellH CellDispCnt:(float)cellDispCnt CellOptCnt:(float)cellOptCnt
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		_dispOptions = [aOptions copy];
		_cellNibName = [cellNib copy];
		_cellLblCount = cellOptCnt;
		_cellHeight   = cellH;
		
		_options = [[NSMutableArray alloc] initWithCapacity:0];
		
		NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:_cellNibName owner:self options:nil];
		if ([cellArray count] == 1){
			for (int i=0; i<[_dispOptions count]; i++) {
				[_options addObject:[_dispOptions objectAtIndex:i]];
			}
			
		}else{
			// 더보기 Cell 존재시
			// 한번에 20건씩 나눠서 보여줌.
			for (int i=0; i<[_dispOptions count]; i++) {
				if (i == 20) break;
				[_options addObject:[_dispOptions objectAtIndex:i]];
			}
			// 더보기 영역 추가
			if ([_dispOptions count]>20){
				NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
				[mDic setObject:@"more"	forKey:@"1"];
				[_options addObject:mDic];
				[mDic release];
			}
		}
		
		// Popup Image
		float tableHeight = (cellH * cellDispCnt) + 5;
		float top = (self.frame.size.height - (tableHeight+52+5))/2;
		
		UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 276, 42+tableHeight+10)];
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = LIST_POPUP_VIEW_TAG;
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 200, 35)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setText:aTitle];
		
		UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 52, 4, 45, 29)];
		closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, 276, tableHeight+10)];
		subView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1];
		
		UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 42)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 276, tableHeight)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42+tableHeight, 276, 10)];
		[topImageView setImage:[UIImage imageNamed:@"popup_title.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		//TableView
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 42, 260, tableHeight)];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
		_tableView.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:227.0f/255.0f blue:232.0f/255.0f alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
		
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
		[popupView addSubview:titleLabel];
		[popupView addSubview:closeButton];
		[popupView addSubview:_tableView];
		
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
		[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
        //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
        //dimmButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        titleLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, titleLabel);
        }
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
		[dimmButton release];
        [subView release];
		[titleLabel release];
		[closeButton release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
		[popupView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}
- (void)logoutClose
{
    [self fadeOut];
}
- (void)dealloc
{
    [_options release];
	[_dispOptions release];
    [_tableView release];
    [super dealloc];
}

#pragma mark - Private Methods
- (void)fadeIn{
	UIView *popupView = [self viewWithTag:LIST_POPUP_VIEW_TAG];
    popupView.transform = CGAffineTransformMakeScale(.2, .2);
    popupView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        popupView.alpha = 1;
        popupView.transform = CGAffineTransformMakeScale(1, 1);
    }];
	
}
- (void)fadeOut
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIView *popupView = [self viewWithTag:LIST_POPUP_VIEW_TAG];
    [UIView animateWithDuration:.35 animations:^{
        popupView.transform = CGAffineTransformMakeScale(.2, .2);
        popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

- (void)closePopupViewWithButton:(UIButton*)sender{
	// tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(listPopupViewDidCancel)]) {
        [self.delegate listPopupViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}

- (void)reloadTableViewWithIndex:(NSInteger)index{
    
	// 더보기 부분을 다음 데이터로 교체
	[_options replaceObjectAtIndex:index withObject:[_dispOptions objectAtIndex:index]];
	
	// 다음 20건의 데이터 추가
	if (([_dispOptions count] - [_options count]) > 0)
    {
		for (int i=index+1; i<(20+index); i++)
        {
			if ([_dispOptions count] > i)
            {
				// 전체 데이터 수가 추가할 Index보다 클때만 Add.
				[_options addObject:[_dispOptions objectAtIndex:i]];
			}
            else
            {
				break;
			}
		}
		
		// 더보기 영역 추가
		if (([_dispOptions count] - [_options count]) > 0){
			NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
			[mDic setObject:@"more"	forKey:@"1"];
			[_options addObject:mDic];
			[mDic release];
		}
	}
	
	[_tableView reloadData];

}


#pragma mark - Tableview datasource & delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_options count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"]) return 28;
	
	return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:_cellNibName owner:self options:nil];
		
		//xib파일의 객체중에 #번째 객체를 셋팅
		if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"]){
			cell = [cellArray objectAtIndex:1];
		}else{
			cell = [cellArray objectAtIndex:0];
		}
		
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
	
    int row = [indexPath row];
	UILabel		*cell_lb;
	NSDictionary *dic = [_options objectAtIndex:row];
	
	if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"]){
		// 더보기영역
		
	}else{
		// 셀의 라벨수 만큼 딕셔너리에서 벨류 셋팅
		for (int i=1; i <= _cellLblCount; i++) {
			cell_lb = (UILabel *)[cell viewWithTag:i];
			[cell_lb setText:[dic objectForKey:[NSString stringWithFormat:@"%i",i]]];
		}
	}
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if ([[[_options objectAtIndex:indexPath.row] objectForKey:@"1"] isEqualToString:@"more"]){
		// 더보기 (다음 20건) 추가
		[self reloadTableViewWithIndex:indexPath.row];
	}else{
		// tell the delegate the selection
		if (self.delegate && [self.delegate respondsToSelector:@selector(listPopupView:didSelectedIndex:)]) {
			[self.delegate listPopupView:self didSelectedIndex:[indexPath row]];
		}
		
		// dismiss self
		[self fadeOut];
	}
    
}

@end
