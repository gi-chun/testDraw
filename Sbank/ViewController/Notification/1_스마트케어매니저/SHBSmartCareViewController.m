//
//  SHBSmartCareViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//


#define kTableTitleColor	RGB(40, 91, 142)
#define kCellH				55


#import "SHBSmartCareViewController.h"
#import "SHBAccidentPopupView.h" // popup
#import "SHBNotificationService.h" // service
#import "SHBSmartCareCell.h"
#import "SHBSmartCareTelStipulationViewController.h"
#import "SHBSmartCareDetailViewController.h"


@interface SHBSmartCareViewController ()
<SHBSmartCareTelStipulationDelegate, SHBSmartCareDetailDelegate>


@property (retain, nonatomic) SHBAccidentPopupView *popupView;
@property (retain, nonatomic) SHBSmartCareTelStipulationViewController *smartCareTelStipulation;
@property (retain, nonatomic) SHBSmartCareDetailViewController *smartCareDatail;
@property (nonatomic, retain) NSMutableArray *marrListData;	// 스마트케어 메시지 리스트
@property (nonatomic, retain) NSString *type_datail;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nameTel;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *type;
@end

@implementation SHBSmartCareViewController

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
    
    _tempLabel = @"";
    
    [_nameLabel initFrame:_nameLabel.frame];
    [_nameLabel setText:[NSString stringWithFormat:@"<midLightBlue_13>%@</midLightBlue_13><midGray_13> 고객님만을 위한</midGray_13>",
                         AppInfo.userInfo[@"고객성명"]]];
    
    [_smartCareInfoBtn.titleLabel setNumberOfLines:0];
    [_smartCareInfoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
    self.popupView = nil;
    
    self.smartCareTelStipulation = nil;
    
    self.marrListData = nil;
    self.type_datail = nil;
    self.name = nil;
    self.nameTel = nil;
    self.tel = nil;
    self.type = nil;
    
    [_smartCareInfoBtn release];
    [_dataTable release];
    [_infoView release];
    [_infoContentLabel release];
    [_nameLabel release];
    [_n_Label release];
    [_tel_no release];
    [_tempLabel release];
    [_managerInfoView release];
    [_callView release];
    [_callBtn1Label release];
    [_callBtn2Label release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSmartCareInfoBtn:nil];
    [self setDataTable:nil];
    [self setInfoView:nil];
    [self setInfoContentLabel:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.marrListData count] == 0)
    {
        return 1;
    }
    else{
        return [self.marrListData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.marrListData count] == 0) {
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
    SHBSmartCareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHBSmartCareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
	NSDictionary *dicData = [self.marrListData objectAtIndex:indexPath.row];
	//NSLog(@"dicData===%@",[dicData objectForKey:@"TITLE"]);
    
    
       if ([[dicData objectForKey:@"GBN"] isEqualToString:@"01"])
        {
            [cell.lblName setText:[NSString stringWithFormat:@"[공지사항] %@",[dicData objectForKey:@"TITLE"]]];
            [cell.lbldate setText:[NSString stringWithFormat:@"%@~%@",[dicData objectForKey:@"START_DATE"],[dicData objectForKey:@"END_DATE"]]];
        }
        
        else if([[dicData objectForKey:@"GBN"] isEqualToString:@"02"])
        {
            [cell.lblName setText:[NSString stringWithFormat:@"[전담직원소식] %@",[dicData objectForKey:@"TITLE"]]];
            [cell.lbldate setText:[NSString stringWithFormat:@"%@~%@",[dicData objectForKey:@"START_DATE"],[dicData objectForKey:@"END_DATE"]]];
            
        }
        else if([[dicData objectForKey:@"GBN"] isEqualToString:@"03"])
        {
            [cell.lblName setText:[NSString stringWithFormat:@"[관리점소식] %@",[dicData objectForKey:@"TITLE"]]];
            [cell.lbldate setText:[NSString stringWithFormat:@"%@~%@",[dicData objectForKey:@"START_DATE"],[dicData objectForKey:@"END_DATE"]]];
            
        }
        else if([[dicData objectForKey:@"GBN"] isEqualToString:@"04"] ||
                [[dicData objectForKey:@"GBN"] isEqualToString:@"05"] )
        {
            [cell.lblName setText:[NSString stringWithFormat:@"[은행이벤트] %@",[dicData objectForKey:@"TITLE"]]];
            [cell.lbldate setText:[NSString stringWithFormat:@"%@~%@",[dicData objectForKey:@"START_DATE"],[dicData objectForKey:@"END_DATE"]]];
            
        }

    
       
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if ([self.marrListData count] == 0) {
         return;
     }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dicData = [self.marrListData objectAtIndex:indexPath.row];
    self.smartCareDatail = [[[SHBSmartCareDetailViewController alloc] initWithNibName:@"SHBSmartCareDetailViewController" bundle:nil] autorelease];
    [dicData setObject:_name forKey:@"상담사이름"];
    [dicData setObject:_nameTel forKey:@"상담사번호"];
    [dicData setObject:_tel forKey:@"전화번호"];
    self.smartCareDatail.dicSelectedData = dicData;
    
    _smartCareDatail.delegate = self;
    [self.view addSubview:_smartCareDatail.view];
    
    [_smartCareDatail.view setFrame:CGRectMake(0,
                                              0,
                                              _smartCareDatail.view.frame.size.width,
                                              _smartCareDatail.view.frame.size.height - 74 - 49)];
    
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellH;
}

#pragma mark - Button

/// 전담직원 전화연결
- (IBAction)callNumber1Pressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _nameTel]]];
}

/// 상담대표번호 전화연결
- (IBAction)callNumber2Pressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _tel]]];
}

/// 스마트 케어 매니저란?
- (IBAction)infoPressed:(id)sender
{
    [_infoContentLabel initFrame:_infoContentLabel.frame];
    [_infoContentLabel setText:@"<midLightBlue_13>다양한 맞춤 메시지와 전문 상담 서비스를 스마트 금융센터 전담직원이 제공</midLightBlue_13><midGray_13>해 드리는 신한은행만의 온라인 고객 Care 서비스 입니다.</midGray_13>"];
    
    self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"스마트 케어 매니저란?"
                                                    SubViewHeight:_infoView.frame.size.height + 6
                                                   setContentView:_infoView] autorelease];
    
    [_popupView showInView:AppDelegate.navigationController.view animated:YES];
}

/// 스마트 케어 매니저란? 확인 버튼
- (IBAction)popupOKPressed:(id)sender
{
    [_popupView fadeOut];
}

/// 전화연결
- (IBAction)callPressed:(id)sender
{
    self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"전화연결"
                                                    SubViewHeight:_callView.frame.size.height + 6
                                                   setContentView:_callView] autorelease];
    
    [_popupView showInView:AppDelegate.navigationController.view animated:YES];
}

/// 전화상담 신청
- (IBAction)callAdvicePressed:(id)sender
{
    
    // 전화상담 요청 시간 확인
    NSString *tDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger tTime = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    if (![SHBUtility isOPDate:tDate] || tTime < 90000 || tTime > 173000) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"전화상담요청은 상담시간내에만 이용이 가능합니다. [상담시간 : 평일 09:00~17:30(은행휴무일제외)]"];
        return ;
    }
    
    
    
    self.smartCareTelStipulation = [[[SHBSmartCareTelStipulationViewController alloc] initWithNibName:@"SHBSmartCareTelStipulationViewController" bundle:nil] autorelease];
    _smartCareTelStipulation.delegate = self;
    
    [self.view addSubview:_smartCareTelStipulation.view];
    
    [_smartCareTelStipulation.view setFrame:CGRectMake(0,
                                                       0,
                                                       _smartCareTelStipulation.view.frame.size.width,
                                                       _smartCareTelStipulation.view.frame.size.height - 74 - 49)];
}

/// 행운의 S쿠키 선물 받기
- (IBAction)SCookiePressed:(id)sender
{
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:SMARTCARE_SCOOKIE_DATA_SERVICE viewController:self] autorelease];
    [self.service start];
}

/// 전화연결
- (IBAction)callPressed2:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1577-8000"]];
}

/// HOME
- (IBAction)homePressed:(id)sender
{
    AppInfo.indexQuickMenu = 0;
	[AppDelegate.navigationController fadePopToRootViewController];
}

#pragma mark - alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* 팝업 뜨던 것을 뷰로 변경 (14.05.15)
    if (alertView.tag == 333) {
        if (buttonIndex == 0)
        {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"telprompt://1599-8035"]];
        }
        else{
            
            [AppDelegate.navigationController fadePopToRootViewController];
            
            
            //  14.3.20 취소시 계좌조회 이동 대신 메인으로 이동 요청- 이준규 과장님
            //AppInfo.schemaUrl = @"iphoneSbank://D0011?";
            //SHBPushInfo *openURLManager = [SHBPushInfo instance];
            //[openURLManager recieveOpenURL];
     
        }
        
    }
    */
}



#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
   // NSLog(@"%@", aDataSet);
    if (self.service.serviceId ==SMARTCARE_MSM_TARGET_SERVICE)
    {
     
     
        if ( [[aDataSet allKeys] count] == 0)
        {
            /* 팝업 뜨던 것을 뷰로 변경 (14.05.15)
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"스마트금융센터 전담상담사가 배정되지 않았습니다. 문의사항이 있거나, 상담을 원하시는 경우 '전화연결'을 클릭하시면 바로 고객센터(1577-8000)로 연결됩니다."
                                                                delegate:self
                                                       cancelButtonTitle:@"전화연결"
                                                       otherButtonTitles:@"취소",nil] autorelease];
            
            alertView.tag = 333;
            [alertView show];
             */
            [_managerInfoView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [self.view addSubview:_managerInfoView];
        }
        
        else{
            // 상담사가 없는 경우 보이는 화면이 다르기 때문에 숨겨놨다가 상담사 존재시 화면을 보여줌
            [_dataTable setHidden:NO];
            
            self.name = aDataSet[@"JIKNM"];
            self.nameTel = aDataSet[@"TELNO"];
            self.tel = aDataSet[@"JIK_TEL_NO"];
            
            [_n_Label setText:[NSString stringWithFormat:@"%@(%@)", _name, _nameTel]];  //전당상담사
            [_tel_no setText:[NSString stringWithFormat:@"%@", _tel]];  //상담전화번호
            
            [_callBtn1Label setText:[NSString stringWithFormat:@"직통번호(%@)", _nameTel]];
            [_callBtn2Label setText:[NSString stringWithFormat:@"상담대표번호(%@)", _tel]];
            
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceId:SMARTCARE_MSM_DATA_SERVICE viewController:self] autorelease];
            [self.service start];

        
        }
 
        
    }
    
    else if (self.service.serviceId ==SMARTCARE_MSM_DATA_SERVICE)
    {
        
        if ( [[aDataSet allKeys] count] == 0)
        {
            _tempLabel = @"등록된 게시글이 없습니다.";
            [self.dataTable reloadData];
        }
        else{
            
             NSArray *listArray = [aDataSet arrayWithForKeyPath:@"data.MSM_LIST"];
            
            if ([listArray count] > 0)
            {
                
                
                if ([listArray[0] isKindOfClass:[NSArray class]])   // 여러개
                {
                    
                    self.marrListData = listArray[0];
                    
                }
                //else if ([aDataSet isKindOfClass:[NSDictionary class]])  // 한걔
                else{
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:(NSDictionary *)listArray[0]];
                    
                    [dic setObject:[dic2 objectForKey:@"TITLE"] forKey:@"TITLE"];
                    [dic setObject:[dic2 objectForKey:@"START_DATE"] forKey:@"START_DATE"];
                    [dic setObject:[dic2 objectForKey:@"END_DATE"] forKey:@"END_DATE"];
                    [dic setObject:[dic2 objectForKey:@"GBN"] forKey:@"GBN"];
                    [dic setObject:[dic2 objectForKey:@"KEYCODE"] forKey:@"KEYCODE"];
                    [dic setObject:[dic2 objectForKey:@"EVNT_SEQ"] forKey:@"EVNT_SEQ"];
                    self.marrListData = [NSMutableArray array];
                    
                    [self.marrListData addObject:dic];
                    NSLog(@"+++++++ %@",[dic objectForKey:@"TITLE"]);
                    NSLog(@"ccccc+ %d",[self.marrListData count]);
                   // [self.dataTable reloadData];
                    
                    
                }
                
                [self.dataTable reloadData];
            }
            
            
        }
        
        
         return NO;
    }
    
    else if (self.service.serviceId ==SMARTCARE_SCOOKIE_DATA_SERVICE)
    {
        
         NSString *result = aDataSet[@"result"];
        
        if ([result isEqualToString:@"1"]) { //정상발급
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"전담상담사로부터\n행운의 S쿠키 3개가 제공되었습니다.\n(매월 1회, 3개 제공)\n\n행운의 S쿠키 사용 방법은\n홈페이지에서 확인하세요."];
            return NO;

        }
        
        if ([result isEqualToString:@"9"]) {   //이미받은경우
            
        NSString *get_date = aDataSet[@"last_coupon_get_date"];
        
        // 이미 받은 경우
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:[NSString stringWithFormat:@"이번 달에 이미 S쿠키를 받으셨습니다.\n발급일 : %@\n(매월 1회, 3개 제공)\n\n행운의 S쿠키 사용 방법은\n홈페이지에서 확인하세요.", get_date]];
        return NO;
        }

        
    }
    
    return NO;
}



#pragma mark -
- (void)startRequest
{
    self.service = nil;
      self.service = [[[SHBNotificationService alloc] initWithServiceId:SMARTCARE_MSM_TARGET_SERVICE viewController:self] autorelease];

    [self.service start];
}



#pragma mark - SHBSmartCareTelStipulation Delegate

- (void)smartCareTelStipulationBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_smartCareTelStipulation.view setAlpha:0];
    [_smartCareTelStipulation.view removeFromSuperview];
    
    
}

- (void)smartCareDetailBack
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    [_smartCareDatail.view setAlpha:0];
    [_smartCareDatail.view removeFromSuperview];
    
    
}




@end
