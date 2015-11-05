//
//  SHBNoticeSmartCardListViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartCardListViewController.h"
#import "SHBNoticeSmartCardListViewCell.h"
#import "SHBNotificationService.h"
#import "SHBPopupView.h" // popup
#import "SHBNoticeSmartCardDetailViewController.h"

@interface SHBNoticeSmartCardListViewController ()
<SHBSmartCardDetailDelegate>

@property (retain, nonatomic) NSArray        *arrayData;

@end

@implementation SHBNoticeSmartCardListViewController


#pragma mark -
#pragma mark Synthesize

//@synthesize noticeCouponDetailViewController;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"거래구분" : @"01",
                              @"고객번호" : AppInfo.customerNo,
                              }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTCARD_E2820 viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];

    
    
    
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1) {
        [_notiSettingPopupView fadeOut];
    }
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 11:
        {
            intIndex = intIndex + 10;
            
            if (intIndex > [_arrayData count])
            {
                intIndex = [_arrayData count];
            }
            
            [tableView1 reloadData];        }
            break;
            
        default:
            break;
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
    
    isType =  YES;
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                             @"거래구분" : [_receive isSelected] ? @"12" : @"11",  //수신거부해제 12(수신)  수신거부등록 11(수신거부)
                            @"고객번호" : AppInfo.customerNo,
                             }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTCARD_E2823
                                                         viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 수신거부설정 취소
- (IBAction)notiSettingCancelBtn:(UIButton *)sender
{
    [_notiSettingPopupView fadeOut];
}



/// 수신거부설정
- (IBAction)notiSettingBtn:(UIButton *)sender   //버튼선택시
{
    isType =  NO;
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                             @"거래구분" : @"10",
                              @"고객번호" : AppInfo.customerNo,
                             }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:SMARTCARD_E2823
                                                         viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
    
   
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    
    if ([self.service.strServiceCode isEqualToString:SMARTCARD_E2820])
    {
        
        if ([aDataSet arrayWithForKeyPath:@"내역.vector.data"])
        {
            
            self.arrayData = [NSArray arrayWithArray:[aDataSet arrayWithForKeyPath:@"내역.vector.data"]];
         
            if ([_arrayData count] == 0)
            {
                self.arrayData = nil;
                
                [labelNoList setHidden:NO];
                [self.receiveSetting setHidden:YES];  // 수신거부 설정 버튼 없애기 2014.8.8
            }
            else
            {
                [labelNoList setHidden:YES];
                [self.receiveSetting setHidden:NO];  // 수신거부 설정 버튼 없애기 2014.8.8
                for (int i=0; i<[_arrayData count]; i++)
                {
                    NSDictionary *tmpDic = _arrayData[i];
                    if ([tmpDic[@"발송번호"] isEqualToString:self.productCode])
                    {
                        self.detailViewController = [[[SHBNoticeSmartCardDetailViewController alloc] initWithNibName:@"SHBNoticeSmartCardDetailViewController" bundle:nil] autorelease];
                        self.detailViewController.dicDataDictionary = [_arrayData objectAtIndex:intSelectRow];
                        self.detailViewController.delegate = self;
                        
                        [self.view addSubview:self.detailViewController.view];

                    }
                    
                }
            }
            
            [tableView1 reloadData];
        }
        
        else if ([aDataSet arrayWithForKeyPath:@"내역"])
        {
            self.arrayData = nil;
            
            if ([[[aDataSet objectForKey:@"내역"] objectForKey:@"vector->result"] isEqualToString:@"0"])
            {
                [labelNoList setHidden:NO];
                [self.receiveSetting setHidden:YES];  // 수신거부 설정 버튼 없애기 2014.8.8
            }
            else {
                
                self.arrayData = [NSArray arrayWithArray:[aDataSet arrayWithForKeyPath:@"내역"]];
                
                if ([_arrayData count] == 0) {
                    
                    [labelNoList setHidden:NO];
                    [self.receiveSetting setHidden:YES];  // 수신거부 설정 버튼 없애기 2014.8.8
                }
                else {
                    
                    [labelNoList setHidden:YES];
                    [self.receiveSetting setHidden:NO];  // 수신거부 설정 버튼 없애기 2014.8.8
                    
                    for (int i=0; i<[_arrayData count]; i++)
                    {
                        NSDictionary *tmpDic = _arrayData[i];
                        if ([tmpDic[@"발송번호"] isEqualToString:self.productCode])
                        {
                            self.detailViewController = [[[SHBNoticeSmartCardDetailViewController alloc] initWithNibName:@"SHBNoticeSmartCardDetailViewController" bundle:nil] autorelease];
                            self.detailViewController.dicDataDictionary = [_arrayData objectAtIndex:intSelectRow];
                            self.detailViewController.delegate = self;
                            
                            [self.view addSubview:self.detailViewController.view];
                            
                        }
                        
                    }
                }
            }
            
            [tableView1 reloadData];
        }

    }
    
    
    else if ([self.service.strServiceCode isEqualToString:SMARTCARD_E2823])
    {
        if (isType ==  NO)  // 수신 상태조회
        {
            self.notiSettingPopupView = [[[SHBPopupView alloc] initWithTitle:@"수신여부" subView:_notiSettingView] autorelease];
            
            if ([aDataSet[@"수신거부상태"] isEqualToString:@"0"]) {
                [_receive setSelected:YES];
                [_noReceive setSelected:NO];
            }
            else {
                [_receive setSelected:NO];
                [_noReceive setSelected:YES];
            }
            
            [_notiSettingPopupView showInView:AppDelegate.navigationController.view animated:YES];
            
        }
        
        else   // 수신거부 등록, 해제
        {
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:1
                             title:@""
                           message:@"변경내용이 저장되었습니다."];

        }
        
        
      }
    
    
    
    return NO;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   return [_arrayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBNoticeSmartCardListViewCell *cell = (SHBNoticeSmartCardListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([_arrayData count] == 0 || _arrayData == nil)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:nil] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
        [cell.textLabel setText:@"받은 명함이 없습니다."];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:RGB(44, 44, 44)];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        return cell;
    }
    
    else
    {
     
        if(cell == nil)
        {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBNoticeSmartCardListViewCell" owner:self options:nil];
        
            for (id currentObject in topLevelObjects)
            {
                if ([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell =  (SHBNoticeSmartCardListViewCell *)currentObject;
                    break;
                }
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    
        [cell.imageView1 setHidden:YES];
    
        // cell 내용 설정
        NSDictionary    *dicDataDic = [_arrayData objectAtIndex:indexPath.row];
        
        NSString *date1 = [dicDataDic[@"스마트명함조회기간"] substringToIndex:4];
        NSString *date2 = [dicDataDic[@"스마트명함조회기간"] substringWithRange:NSMakeRange(4,2)];
        NSString *date3 = [dicDataDic[@"스마트명함조회기간"] substringFromIndex:6];

    
        cell.label1.text = [NSString stringWithFormat:@"%@", dicDataDic[@"직원명"]];
        cell.label2.text = [NSString stringWithFormat:@"%@.%@.%@", date1,date2,date3];
        //cell.label2.text = dicDataDic[@"스마트명함조회기간"];
        cell.label3.text = [NSString stringWithFormat:@"지점명: %@", dicDataDic[@"지점명"]];
        if (![dicDataDic[@"대화명"] isEqualToString:@""]) {
            cell.label4.text = [NSString stringWithFormat:@"[%@]", dicDataDic[@"대화명"]];
        }
        
        if([[dicDataDic objectForKey:@"전담직원여부"] isEqualToString:@"1"])
        {
            cell.label5.text = @"전담직원";
            cell.label5.backgroundColor = [UIColor redColor];
        }
        
        return cell;
    }
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    intSelectRow = indexPath.row;
    
    self.detailViewController = [[[SHBNoticeSmartCardDetailViewController alloc] initWithNibName:@"SHBNoticeSmartCardDetailViewController" bundle:nil] autorelease];
    self.detailViewController.dicDataDictionary = [_arrayData objectAtIndex:intSelectRow];
	self.detailViewController.delegate = self;
    
    [self.view addSubview:self.detailViewController.view];
    
   
}


- (void)smartCardDetailBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [self.detailViewController.view setAlpha:0];
    [self.detailViewController.view removeFromSuperview];
    
    // 서비스 호출
    [self requestService];
}


- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self navigationViewHidden];
    
    [self setBottomMenuView];
    // 서비스 호출
    [self requestService];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
   // self.noticeCouponDetailViewController = nil;
    
    self.productCode = nil;
    
    self.arrayData = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponListButtonDidPush" object:nil];
    
    [super dealloc];
}

@end
