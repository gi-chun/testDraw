//
//  SHBNoticeCouponListViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBNoticeCouponListViewController.h"
#import "SHBNotificationService.h"              // 알림 서비스
#import "SHBNoticeCouponListViewCell.h"         // tableView cell
#import "SHBNoticeCouponDeatailListViewController.h"


@interface SHBNoticeCouponListViewController ()

@end

@implementation SHBNoticeCouponListViewController

#pragma mark -
#pragma mark Synthesize

@synthesize noticeCouponDetailViewController;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceId:COUPON_SERVICE viewController:self] autorelease];
    [self.service start];
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 11:
        {
            intIndex = intIndex + 10;
            
            if (intIndex > [arrayData count])
            {
                intIndex = [arrayData count];
            }
            
            [tableView1 reloadData];
        }
            break;
        case 12:
        {
            SHBNoticeCouponDeatailListViewController *viewController = [[[SHBNoticeCouponDeatailListViewController alloc] initWithNibName:@"SHBNoticeCouponDeatailListViewController" bundle:nil] autorelease];
            
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (aDataSet[@"NEW_LETTER"] && aDataSet[@"NEW_COUPON"]) {
        AppInfo.isSmartLetterNew = [aDataSet[@"NEW_LETTER"] isEqualToString:@"Y"] ? YES : NO;
        AppInfo.isCouponNew = [aDataSet[@"NEW_COUPON"] isEqualToString:@"Y"] ? YES : NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SmartLetter_Coupon_New" object:nil];
    }
    
    if ([aDataSet arrayWithForKeyPath:@"SmartLetter.vector.data"])
    {
        if (intIndex == 0)
        {
            intIndex = 10;
        }
        
        arrayData = [[NSArray alloc] initWithArray:[aDataSet arrayWithForKeyPath:@"SmartLetter.vector.data"]];
        
        if ([arrayData count] == 0)
        {
            [labelNoList setHidden:NO];
            
            return NO;
        }
        
        if ( [arrayData count] < intIndex )
        {
            tableView1.tableFooterView = nil;
            intIndex = [arrayData count];
        }
        else
        {
            tableView1.tableFooterView = viewMore;
        }
        
        [tableView1 reloadData];
    }
    else if ([aDataSet[@"COM_SVC_CODE"] isEqualToString:@"E2611"])
    {
        self.noticeCouponDetailViewController = [[[SHBNoticeCouponDetailViewController alloc] initWithNibName:@"SHBNoticeCouponDetailViewController" bundle:nil] autorelease];
        
        self.noticeCouponDetailViewController.dicDataDictionary = [arrayData objectAtIndex:intSelectRow];
        [self.view addSubview:noticeCouponDetailViewController.view];
        
        [noticeCouponDetailViewController.view setFrame:CGRectMake(0,
                                                                   0,
                                                                   noticeCouponDetailViewController.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    }
    else if (aDataSet[@"SmartLetter"])      // 쿠폰이 아예 없을 경우
    {
        if ([[[aDataSet objectForKey:@"SmartLetter"] objectForKey:@"vector->result"] isEqualToString:@"0"])
        {
            [labelNoList setHidden:NO];
        }
    }
    
    
    return NO;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return intIndex;
//    return [arrayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBNoticeCouponListViewCell *cell = (SHBNoticeCouponListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBNoticeCouponListViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBNoticeCouponListViewCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    [cell.imageView1 setHidden:YES];
    
    // cell 내용 설정
    NSDictionary    *dicDataDic = [arrayData objectAtIndex:indexPath.row];
    
    NSString *strDate = dicDataDic[@"유효일자"];
   // NSString *strDate = @"20131102";
    NSString *strDateResult = [SHBUtility getDateWithDash:strDate];
    NSString *redResult = [[SHBUtility getDateWithDash:strDate]stringByReplacingOccurrencesOfString:@"." withString:@"-"];

    
    int dDay = [SHBUtility getDDay:redResult]+1;
    //int dDay = [SHBUtility getDDay:@"2013-11-11"]+1;
    
    //갱신 한달 남은 인증서는 만료일 항목을 빨간색으로
        
   
    NSLog(@"dDay ==%d",dDay);
    
    
    if (dDay <= 5)
    {
        cell.label1.textColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1];
        cell.label3.textColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1];
    }
    
    cell.label1.text = dicDataDic[@"제목"];
    if ([dicDataDic[@"환전우대율"] isEqualToString:@""] || dicDataDic[@"환전우대율"] == nil) {
        cell.label2.text = @"";
    }
    else
    {
        cell.label2.text = [NSString stringWithFormat:@"%@%%", dicDataDic[@"환전우대율"]];
    }
    
    if ([strDate isEqualToString:@"제한없음"])
    {
       cell.label3.text = @"유효기간 : 제한없음";
    }
    else
    {
        cell.label3.text = [NSString stringWithFormat:@"유효기간 : %@", strDateResult];
        
    }

        
    if ([dicDataDic[@"열람상태"] isEqualToString:@"0"])
    {
        [cell.imageView1 setHidden:NO];
    }
    
    if ( [arrayData count] < intIndex || [arrayData count] == intIndex )
    {
        tableView1.tableFooterView = nil;
        intIndex = [arrayData count];
    }
    else
    {
        tableView1.tableFooterView = viewMore;
    }
    
    return cell;
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    intSelectRow = indexPath.row;
    
    self.service = nil;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"일련번호" : [[arrayData objectAtIndex:indexPath.row] objectForKey:@"일련번호"],
                            }];
    
    self.service = nil;
    self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_READ_E2611 viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}


#pragma mark -
#pragma mark Notifications

- (void)listButtonDidPush
{
    intIndex = 0;
    [tableView1 setContentOffset:CGPointMake(0, 0) animated:NO];
    [self requestService];
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    [self navigationViewHidden];
    
    // 서비스 호출
    [self requestService];
    
    // 초기값 설정
    intIndex = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponListButtonDidPush" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listButtonDidPush) name:@"couponListButtonDidPush" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.noticeCouponDetailViewController = nil;
    
    [arrayData release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponListButtonDidPush" object:nil];
    
    [super dealloc];
}

@end
