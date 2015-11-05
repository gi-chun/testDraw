//
//  SHBNoticeCuponStoreViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 15..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNoticeCuponStoreListViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util
#import "SHBNoticeStoreListViewCell.h"
#import "SHBNotificationService.h" // 서비스
#import "SHBNewProductInfoViewController.h"


@interface SHBNoticeCuponStoreListViewController ()
{
    int openedRow;

}
@end

@implementation SHBNoticeCuponStoreListViewController



#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 1;
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(openedRow == indexPath.row){
        return 290;
    }
    return 290;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBNoticeStoreListViewCell *cell = (SHBNoticeStoreListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBNoticeStoreListViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBNoticeStoreListViewCell *)currentObject;
                break;
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
   cell.row = indexPath.row;
   cell.target = self;
   cell.openBtnSelector = @selector(openCell:);
  
   
  dicSelectedData = [self.dataList objectAtIndex:indexPath.row];

    
   cell.label1.text = dicSelectedData[@"상품명"];    //상품명
   cell.label2.text = [NSString stringWithFormat:@"%@원", dicSelectedData[@"신청금액"]];    //가입금액
   
    
   if ([dicSelectedData[@"기간월"] isEqualToString:@" "] || dicSelectedData[@"기간월"] == nil)
   {
        cell.label3.text = [NSString stringWithFormat:@"%@일", dicSelectedData[@"기간일"]];  //가입기간

   }
    else
   {
        cell.label3.text = [NSString stringWithFormat:@"%@개월", dicSelectedData[@"기간월"]];  //가입기간

   }
    
   if ([dicSelectedData[@"회전주기"] isEqualToString:@"0"]) 
   {
      cell.label4.text = @"";  //회전주기
   }
   else
   {
      cell.label4.text = [NSString stringWithFormat:@"%@개월",dicSelectedData[@"회전주기"]];  //회전주기
   }
  
   if ([dicSelectedData[@"이자지급주기"] isEqualToString:@"0"])
   {
       cell.label5.text = @"";  
   }
   else
   {
       cell.label5.text = [NSString stringWithFormat:@"%@개월",dicSelectedData[@"이자지급주기"]];  
   }
       
   if ([dicSelectedData[@"이자지급방법"] isEqualToString:@"1"])
   {
       cell.label6.text = @"이자지급식";  
   }
   else if ([dicSelectedData[@"이자지급방법"] isEqualToString:@"2"])
   {
       cell.label6.text = @"만기일시복리식"; 
   }
   else
   {
      cell.label6.text = @"만기일시지급식";  
   }
        
   cell.label7.text = [NSString stringWithFormat:@"%@%%",
                                [self addComma:[dicSelectedData[@"승인이율"] doubleValue] isPoint:YES]];  //적용금리
   cell.label8.text = dicSelectedData[@"승인신청직원명"];  //상담직원
   cell.label9.text = dicSelectedData[@"승인신청직원회사전화번호"];  //직원번호
    


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    dictionary_select = self.dataList[indexPath.row];

    
    if (![dictionary_select[@"상품코드"] isEqualToString:@"200009201"] &&
        ![dictionary_select[@"상품코드"] isEqualToString:@"200013601"] &&  //s드림 정기예금
        ![dictionary_select[@"상품코드"] isEqualToString:@"200003401"] &&
        ![dictionary_select[@"상품코드"] isEqualToString:@"200009301"] )
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                         message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                        delegate:self
                                               cancelButtonTitle:@"확인"
                                               otherButtonTitles:@"업데이트", nil] autorelease];
        
        [alert setTag:4321];
		[alert show];
		
		return;
    }
    
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"상품코드" : dictionary_select[@"상품코드"],

                           }];
	self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_INFO_SERVICE
                                                         viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];

    
        
}



#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       
    // 업데이트
    if (alertView.tag == 4321 && buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dictionary_select = [[NSMutableDictionary alloc] init];
    
    self.title = @"쿠폰조회";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"금리우대설계서" maxStep:0 focusStepNumber:0] autorelease]];
    
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"고객번호" : AppInfo.customerNo,
						   @"업무구분" : @"09",
						   @"조회시작일" : AppInfo.tran_Date,
						   @"조회종료일" : AppInfo.tran_Date,
                           }];
	self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_D3249
                                                         viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];

}
 
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
   if ([AppInfo.serviceCode isEqualToString:@"D3249"])
    {
        self.dataList = [aDataSet arrayWithForKey:@"등록내역"];
    
        if([self.dataList count] == 0)
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"조회일자에 금리우대설계서가 없습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
       
        [alert show];
        [alert release];
        [self.navigationController fadePopViewController];
        return NO;
        }
    
        [_tableView1 reloadData];
    }
    
    else if (self.service.serviceId == COUPON_INFO_SERVICE)
    {
        
        //NSLog(@"상품코드 ===%@",dictionary_select[@"상품코드"]);
        cmma_string = [[NSString alloc] init];

        SHBNewProductInfoViewController *viewController = [[SHBNewProductInfoViewController alloc]initWithNibName:@"SHBNewProductInfoViewController" bundle:nil];
        
        cmma_string = [NSString stringWithFormat:@"%@",
                            [self addComma:[dictionary_select[@"승인이율"] doubleValue] isPoint:YES]];  //적용금리
        
        [dictionary_select setObject:@"1" forKey:@"영업점상품여부"];
        [dictionary_select setObject:cmma_string forKey:@"적용금리"];
        
        viewController.dicReceiveData = aDataSet;
        viewController.dicSelectedData = [dictionary_select autorelease];
      	[self checkLoginBeforePushViewController:viewController animated:YES];
      	[viewController release];
              
    }

    return YES;
    
}

#pragma mark -
#pragma btn Open

- (void)openCell:(NSDictionary *)dic
{


    int row = [dic[@"Index"] intValue];
    dictionary_select= self.dataList[row];
    
    
    if (![dictionary_select[@"상품코드"] isEqualToString:@"200009201"] &&
        ![dictionary_select[@"상품코드"] isEqualToString:@"200013601"] &&  //s드림 정기예금
        ![dictionary_select[@"상품코드"] isEqualToString:@"200003401"] &&
        ![dictionary_select[@"상품코드"] isEqualToString:@"200009301"] )
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                         message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                        delegate:self
                                               cancelButtonTitle:@"확인"
                                               otherButtonTitles:@"업데이트", nil] autorelease];
        
        [alert setTag:4321];
		[alert show];
		
		return;
    }
    
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                          @"상품코드" : dictionary_select[@"상품코드"],
                           }];
	self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_INFO_SERVICE
                                                       viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];

}
#pragma mark -
            
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.3lf", number];  // 소수점 3자리 까지 표시
    }

    return string;
}
            
         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (dictionary_select) {
        [dictionary_select release];
        dictionary_select = nil;
    }
    
    [super dealloc];
}
@end
