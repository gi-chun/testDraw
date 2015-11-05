//
//  SHBNoticeSmartLetterListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartLetterListViewController.h"
#import "SHBNotificationService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBNoticeSmartLetterListCell.h" // cell
#import "SHBPopupView.h" // popup

#import "SHBNoticeSmartLetterDetailViewController.h" // 스마트레터 상세

#define MORECOUNT 10 // 더보기

@interface SHBNoticeSmartLetterListViewController ()
<SHBNoticeSmartLetterDetailDelegate, UIAlertViewDelegate>
{
    NSInteger _moreCount; // 더보기 갯수
    NSInteger _currentIndex; // 선택한 데이터
    CGFloat _tableViewHeight; // tableView 높이
}

@property (retain, nonatomic) SHBNoticeSmartLetterDetailViewController *detailViewController;
@property (retain, nonatomic) SHBPopupView *notiSettingPopupView;

@property (retain, nonatomic) NSMutableArray *deleteList; // 삭제할 스마트레터 목록

/// 스마트레터 목록 요청
- (void)startRequest;

@end

@implementation SHBNoticeSmartLetterListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewHidden];
    
    [self startRequest];
    
    _tableViewHeight = _dataTable.frame.size.height - 123;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currentIndex != -1) {
        [_detailViewController viewWillAppear:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.deleteList = nil;
    
    [_dataTable release];
    [_notiSettingView release];
    [_receive release];
    [_noReceive release];
    [_deleteView release];
    [_moreView release];
    [_edit release];
    [_receiveSetting release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setNotiSettingView:nil];
    [self setReceive:nil];
    [self setNoReceive:nil];
    [self setDeleteView:nil];
    [self setMoreView:nil];
    [self setReceiveSetting:nil];
	[super viewDidUnload];
}

#pragma mark - 

- (void)startRequest
{
    _moreCount = MORECOUNT;
    _currentIndex = -1;
    
    self.deleteList = [NSMutableArray array];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:SMARTLETTER_SERVICE
                                                       viewController:self] autorelease];
    [self.service start];
}

- (void)tableViewEditBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    [_deleteList replaceObjectAtIndex:[sender tag] withObject:[sender isSelected] ? @"1" : @"0"];
    
    [_dataTable reloadData];
}

#pragma mark - Button

/// 편집
- (IBAction)editBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        [_deleteList removeAllObjects];
        
        for (NSInteger i = 0; i < [self.dataList count]; i++) {
            [_deleteList addObject:@"0"];
        }
        
        [_dataTable setFrame:CGRectMake(0,
                                         _dataTable.frame.origin.y,
                                         _dataTable.frame.size.width,
                                         _tableViewHeight - _deleteView.frame.size.height)];
        
        
        [_deleteView setFrame:CGRectMake(0,
                                         _tableViewHeight + 29,
                                         _deleteView.frame.size.width,
                                         49)];
        
        [self.view addSubview:_deleteView];
    }
    else {
        if ([self.dataList count] > _moreCount) {
            [_dataTable setTableFooterView:_moreView];
        }
        else {
            [_dataTable setTableFooterView:nil];
        }
        
        [_deleteView removeFromSuperview];
        [_dataTable setFrame:CGRectMake(0,
                                        _dataTable.frame.origin.y,
                                        _dataTable.frame.size.width,
                                        _tableViewHeight)];
    }
    
    [_dataTable reloadData];
    
    CATransition *transition = [CATransition animation];
	[transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    if ([sender isSelected]) {
        [transition setType:kCATransitionFromRight];
    }
    else {
        [transition setType:kCATransitionFromLeft];
    }
	
	[_dataTable.layer addAnimation:transition forKey:nil];
}

/// 수신거부설정
- (IBAction)notiSettingBtn:(UIButton *)sender
{
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTLETTER_C2828
                                                       viewController:self] autorelease];
    [self.service start];
}

/// 삭제
- (IBAction)deleteBtn:(UIButton *)sender
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"삭제할 스마트레터가 없습니다."];
        return;
    }
    
    BOOL delete = NO;
    
    for (NSInteger i = 0; i < [_deleteList count]; i++) {
        if ([_deleteList[i] isEqualToString:@"1"]) {
            delete = YES;
            
            break;
        }
    }
    
    if (!delete) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"삭제할 스마트레터를 선택하여 주십시오."];
        return;
    }
    
    [UIAlertView showAlert:self
                      type:ONFAlertTypeTwoButton
                       tag:2
                     title:@""
                   message:@"삭제된 메시지는 복원하실 수 없습니다. 선택한 스마트레터를 삭제하시겠습니까?"];
}

/// 전체삭제
- (IBAction)allDeleteBtn:(UIButton *)sender
{
    if ([self.dataList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"삭제할 스마트레터가 없습니다."];
        return;
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionary];
    dataSet.vectorTitle = @"쪽지목록";
    
    for (NSInteger i = 0; i < [self.dataList count]; i++) {
        SHBDataSet *vectorSet = [SHBDataSet dictionaryWithDictionary:
                                 @{
                                 @"일련번호" : self.dataList[i][@"일련번호"],
                                 }];
        
        [dataSet insertObject:vectorSet
                       forKey:[NSString stringWithFormat:@"vector%d", i]
                      atIndex:0];
    }
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTLETTER_E2412
                                                         viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 더보기
- (IBAction)moreBtn:(UIButton *)sender
{
    if ([self.dataList count] > _moreCount) {
        _moreCount += MORECOUNT;
        
        if (_moreCount > [self.dataList count]) {
            _moreCount = [self.dataList count];
        }
        
        if ([self.dataList count] == _moreCount) {
            [_dataTable setTableFooterView:nil];
        }
        
        [_dataTable reloadData];
    }
}

/// 수신거부설정 수신
- (IBAction)notiSettingReceiveBtn:(UIButton *)sender
{
    if (sender == _receive) {
        [_receive setSelected:YES];
        [_noReceive setSelected:NO];
    }
    else if (sender == _noReceive) {
        [_receive setSelected:NO];
        [_noReceive setSelected:YES];
    }
}

/// 수신거부설정 변경
- (IBAction)notiSettingChangeBtn:(UIButton *)sender
{
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"업무구분" : [_receive isSelected] ? @"2" : @"3",
                           }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTLETTER_E2425
                                                       viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 수신거부설정 취소
- (IBAction)notiSettingCancelBtn:(UIButton *)sender
{
    [_notiSettingPopupView fadeOut];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    if ([self.service.strServiceCode isEqualToString:SMARTLETTER]) {
        for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"SmartLetter"]) {
            [dic setObject:[NSString stringWithFormat:@"%@  %@",
                            dic[@"등록지점명"], [SHBUtility getDateWithDash:dic[@"등록일"]]]
                    forKey:@"_등록지점날짜"];
            
            if ([dic[@"등록지점명"] length] > 0 && [dic[@"등록자명"] length] > 0) {
                [dic setObject:[NSString stringWithFormat:@"%@/%@", dic[@"등록지점명"], dic[@"등록자명"]]
                        forKey:@"_보낸사람"];
            }
            else if ([dic[@"등록지점명"] length] == 0 && [dic[@"등록자명"] length] > 0) {
                [dic setObject:dic[@"등록자명"]
                        forKey:@"_보낸사람"];
            }
            else if ([dic[@"등록지점명"] length] > 0 && [dic[@"등록자명"] length] == 0) {
                [dic setObject:dic[@"등록지점명"]
                        forKey:@"_보낸사람"];
            }
            else {
                [dic setObject:@" "
                        forKey:@"_보낸사람"];
            }
            
            [dic setObject:[dic[@"메세지내용"] stringByReplacingOccurrencesOfString:@"&#xa;" withString:@"\n"]
                    forKey:@"_메세지내용"];
            
            [dic setObject:[SHBUtility getDateWithDash:dic[@"등록일"]]
                    forKey:@"_날짜"];
        }
    }
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    Debug(@"%@", aDataSet);
    
    if (aDataSet[@"NEW_LETTER"] && aDataSet[@"NEW_COUPON"]) {
        AppInfo.isSmartLetterNew = [aDataSet[@"NEW_LETTER"] isEqualToString:@"Y"] ? YES : NO;
        AppInfo.isCouponNew = [aDataSet[@"NEW_COUPON"] isEqualToString:@"Y"] ? YES : NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SmartLetter_Coupon_New" object:nil];
    }
    
    if ([self.service.strServiceCode isEqualToString:SMARTLETTER]) {
        self.dataList = [aDataSet arrayWithForKey:@"SmartLetter"];
        
        if ([self.dataList count] == 0) {
            [_edit setEnabled:NO];
            
            [_dataTable reloadData];
            
            return NO;
        }
        
        for (NSInteger i = 0; i < [self.dataList count]; i++) {
            [_deleteList addObject:@"0"];
        }
        
        if ([_edit isSelected]) {
            [_dataTable setFrame:CGRectMake(0,
                                            _dataTable.frame.origin.y,
                                            _dataTable.frame.size.width,
                                            _tableViewHeight - _deleteView.frame.size.height)];
            
            [_deleteView setFrame:CGRectMake(0,
                                             _tableViewHeight + 29,
                                             _deleteView.frame.size.width,
                                             49)];
            
            [self.view addSubview:_deleteView];
        }
        else {
            if ([self.dataList count] > _moreCount) {
                [_dataTable setTableFooterView:_moreView];
            }
            else {
                [_dataTable setTableFooterView:nil];
            }
            
            [_deleteView removeFromSuperview];
            [_dataTable setFrame:CGRectMake(0,
                                            _dataTable.frame.origin.y,
                                            _dataTable.frame.size.width,
                                            _tableViewHeight)];
        }
        
        [_dataTable reloadData];
    }
    else if ([self.service.strServiceCode isEqualToString:SMARTLETTER_E2412]) {
        [self editBtn:_edit];
        [self startRequest];
    }
    else if ([self.service.strServiceCode isEqualToString:SMARTLETTER_E2425]) {
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:1
                         title:@""
                       message:@"수신여부 설정이 변경되었습니다."];
    }
    else if ([self.service.strServiceCode isEqualToString:SMARTLETTER_C2828]) {
        self.notiSettingPopupView = [[[SHBPopupView alloc] initWithTitle:@"수신여부" subView:_notiSettingView] autorelease];
        
        if ([aDataSet[@"쪽지거절여부"] isEqualToString:@"0"]) {
            [_receive setSelected:YES];
            [_noReceive setSelected:NO];
        }
        else {
            [_receive setSelected:NO];
            [_noReceive setSelected:YES];
        }
        
        [_notiSettingPopupView showInView:AppDelegate.navigationController.view animated:YES];
    }
    
    return YES;
}

#pragma mark - SHBNoticeSmartLetterDetail

- (void)smartLetterDetailBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_detailViewController.view setAlpha:0];
    [_detailViewController.view removeFromSuperview];
    
    NSMutableDictionary *dic = self.dataList[_currentIndex];
    
    [dic setObject:@"1"
            forKey:@"열람상태"];
    
    [_dataTable reloadData];
}

- (void)smartLetterDetailList
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_detailViewController.view setAlpha:0];
    [_detailViewController.view removeFromSuperview];
    
    [self startRequest];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1) {
        [_notiSettingPopupView fadeOut];
    }
    else if ([alertView tag] == 2) {
        if (buttonIndex == 0) {
            SHBDataSet *dataSet = [SHBDataSet dictionary];
            dataSet.vectorTitle = @"쪽지목록";
            
            NSInteger count = 0;
            
            for (NSInteger i = 0; i < [_deleteList count]; i++) {
                if ([_deleteList[i] isEqualToString:@"1"]) {
                    SHBDataSet *vectorSet = [SHBDataSet dictionaryWithDictionary:
                                             @{
                                             @"일련번호" : self.dataList[i][@"일련번호"],
                                             }];
                    
                    [dataSet insertObject:vectorSet
                                   forKey:[NSString stringWithFormat:@"vector%d", count]
                                  atIndex:count];
                    
                    count++;
                }
            }
            
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTLETTER_E2412
                                                                 viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] > _moreCount) {
        return _moreCount;
    }
    
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:nil] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
        [cell.textLabel setText:@"수신된 스마트레터가 없습니다."];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:RGB(44, 44, 44)];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_edit setHidden:YES];
        [_receiveSetting setFrame:_edit.frame];
        
        return cell;
    }
    else {
        SHBNoticeSmartLetterListCell *cell = (SHBNoticeSmartLetterListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBNoticeSmartLetterListCell"];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBNoticeSmartLetterListCell"
                                                           owner:self options:nil];
            cell = (SHBNoticeSmartLetterListCell *)array[0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [_edit setHidden:NO];
        [_receiveSetting setFrame:CGRectMake(103, 43, 94, 25)];
        
        [cell.edit setTag:indexPath.row];
        [cell.edit addTarget:self action:@selector(tableViewEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_currentIndex == indexPath.row) {
            [cell setTag:100];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        else {
            [cell setTag:0];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        if ([_edit isSelected]) {
            [cell.edit setHidden:NO];
            [cell.dataView setFrame:CGRectMake(40,
                                               cell.dataView.frame.origin.y,
                                               cell.dataView.frame.size.width,
                                               cell.dataView.frame.size.height)];
            
            if ([[_deleteList objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                [cell.edit setSelected:YES];
            }
            else {
                [cell.edit setSelected:NO];
            }
        }
        else {
            [cell.edit setHidden:YES];
            [cell.dataView setFrame:CGRectMake(8,
                                               cell.dataView.frame.origin.y,
                                               cell.dataView.frame.size.width,
                                               cell.dataView.frame.size.height)];
        }
        
        OFDataSet *cellDataSet = self.dataList[indexPath.row];
        [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
        
        if ([cellDataSet[@"열람상태"] isEqualToString:@"1"]) {
            [cell.readImage setHidden:YES];
        }
        else {
            [cell.readImage setHidden:NO];
            
            CGSize labelSize = [cell.subject.text sizeWithFont:cell.subject.font
                                             constrainedToSize:CGSizeMake(999, 16)
                                                 lineBreakMode:cell.subject.lineBreakMode];
            
            if (labelSize.width >= 250) {
                labelSize.width = 250;
            }
            
            [cell.subject setFrame:CGRectMake(cell.subject.frame.origin.x,
                                              cell.subject.frame.origin.y,
                                              labelSize.width,
                                              cell.subject.frame.size.height)];
            [cell.readImage setFrame:CGRectMake(cell.subject.frame.origin.x + labelSize.width + 5,
                                                cell.readImage.frame.origin.y,
                                                cell.readImage.frame.size.width,
                                                cell.readImage.frame.size.height)];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    _currentIndex = indexPath.row;
    
    AppInfo.commonDic = self.dataList[_currentIndex];
	
    self.detailViewController = [[[SHBNoticeSmartLetterDetailViewController alloc] initWithNibName:@"SHBNoticeSmartLetterDetailViewController" bundle:nil] autorelease];
    [_detailViewController setDelegate:self];
	[self.view addSubview:_detailViewController.view];
    
    [_detailViewController.view setFrame:CGRectMake(0,
                                                    0,
                                                    _detailViewController.view.frame.size.width,
                                                    _detailViewController.view.frame.size.height - 74 - 49)];
}

@end
