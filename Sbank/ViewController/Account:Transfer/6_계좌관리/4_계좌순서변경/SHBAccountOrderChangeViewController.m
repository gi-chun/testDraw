//
//  SHBAccountOrderChangeViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 5..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountOrderChangeViewController.h"
#import "SHBAccountOrderChangeListCell.h"           // tableView cell
#import "SHBAccountService.h"                       // 계좌 서비스
#import "SHBVersionService.h"                       // 계좌 순서 변경을 위한 서비스


@interface SHBAccountOrderChangeViewController ()

@end

@implementation SHBAccountOrderChangeViewController

#pragma mark -
#pragma mark Synthesize

@synthesize arrayTableData;

//@synthesize array1;
//@synthesize array2;
//@synthesize array3;
//@synthesize array4;


#pragma mark -
#pragma mark Private Method

- (void)requestService
{
    // 예금계좌 서비스
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
}

- (void)sendRequestService
{
    [self requestService];
}

//- (void)cellLongPress:(UILongPressGestureRecognizer *)gesture
//{
//    if ([gesture state] != UIGestureRecognizerStateBegan)
//        return;
//    
//    [tableView1 setEditing:YES animated:YES];
//}

#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
        case 11:        // 순서 초기화 버튼
        {
            SHBDataSet *aVectorSet = [[[SHBDataSet alloc] initWithDictionary:
                                        @{
                                        TASK_NAME_KEY : @"sfg.sphone.task.config.UserAccount",
                                        TASK_ACTION_KEY : @"delUseAccSort",
                                        @"고객번호" : AppInfo.customerNo
                                        }] autorelease];
            
            self.service = [[[SHBVersionService alloc] initWithServiceId:ACCOUNT_RESET viewController:self] autorelease];
            self.service.previousData = aVectorSet;
            [self.service start];
            
            strMesage = @"계좌순서가 초기화 되었습니다.";
        }
            break;
            
        case 21:        // 확인 버튼
        {
            SHBDataSet *aVectorSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                            TASK_NAME_KEY   : @"sfg.sphone.task.config.UserAccount",
                                                            TASK_ACTION_KEY : @"setUseAccSort",}] autorelease];
            int i = 0;
            
            for (NSObject *obj in self.arrayTableData)
            {
                
                NSDictionary *aDataSet1 = [[[NSDictionary alloc] initWithDictionary:@{
                                            @"고객번호" : AppInfo.customerNo,
                                            @"서비스코드" : @"D0011",
                                            @"계좌번호" : [[[self.arrayTableData objectAtIndex:i] objectForKey:@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                            @"순서" : [NSString stringWithFormat:@"%d", i+1]
                                            }] autorelease];
                
                [aVectorSet insertObject:aDataSet1 forKey:[NSString stringWithFormat:@"vector%d", i] atIndex:i];
                
                i++;
            }
            
            self.service = [[[SHBVersionService alloc] initWithServiceId:XDA_S00001 viewController:self] autorelease];
            self.service.previousData = aVectorSet;
            [self.service start];
            
            strMesage = @"계좌순서가 변경되었습니다.";
        }
            break;
            
        case 22:        // 취소 버튼
        {
            [self.navigationController fadePopViewController];
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
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D0011"] )
    {
        self.arrayTableData = [aDataSet arrayWithForKey:@"예금계좌.vector.data"];
        
        if ( [self.arrayTableData count] == 0 )
        {
            view1.hidden = NO;
            tableView1.hidden = YES;
            
            return NO;
        }
        
        [tableView1 reloadData];
        
        // 수정 상태로 진입
        [tableView1 setEditing:YES animated:YES];
        
        // 초기화로 진입된 경우
        
        
        if (![strMesage isEqualToString:@""])
        {
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strMesage];
            strMesage = @"";
        }
        
        return NO;
    }
    else if ([aDataSet objectForKey:@"result"])
    {
        // 정상 케이스
        if ( [[aDataSet objectForKey:@"result"] isEqualToString:@"1"] )
        {
            [self requestService];
            
            return NO;
        }
    }
    // 섹션의 경우
//    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D0011"] )
//    {
//        self.array1 = [aDataSet arrayWithForKeyPath:@"예금계좌.vector.data"];
//        
//        // 펀드
//        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D6010" viewController:self] autorelease];
//        self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
//        [self.service start];
//        
//        return NO;
//    }
//    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"D6010"] )
//    {
//        self.array2 = [aDataSet arrayWithForKeyPath:@"펀드계좌.vector.data"];
//        
//        // 대출
//        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"L0010" viewController:self] autorelease];
//        self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
//        [self.service start];
//        
//        return NO;
//    }
//    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"L0010"] )
//    {
//        self.array3 = [aDataSet arrayWithForKeyPath:@"대출계좌목록.vector.data"];
//        
//        // 대출
//        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"F0010" viewController:self] autorelease];
//        self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
//        [self.service start];
//        
//        return NO;
//    }
//    else if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"F0010"] )
//    {
//        self.array4 = [aDataSet arrayWithForKeyPath:@"외화계좌.vector.data"];
//        
//        NSMutableArray *tableArray = [[NSMutableArray alloc]
//                                     initWithObjects:self.array1, self.array2, self.array3, self.array4, nil];
//        
//        self.arrayTableData = tableArray;
//        
//        [tableArray release];
//
//        [tableView1 reloadData];
//        
//        // 수정 상태로 진입
//        [tableView1 setEditing:YES animated:YES];
//    }
    
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark -
#pragma mark - tableView Data Source

// 섹션의 경우
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return [self.arrayTableData count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.arrayTableData count];
//	return [[self.arrayTableData objectAtIndex:section] count];
}

// 섹션의 경우
//// 헤더 높이
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}
//
//// 섹션 이름
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *strTitle = @"";
//    
//    switch (section) {
//            
//        case 0:
//        {
//            strTitle = @"예금신탁";
//        }
//            break;
//            
//        case 1:
//        {
//            strTitle = @"펀드";
//        }
//            break;
//            
//        case 2:
//        {
//            strTitle = @"대출";
//        }
//            break;
//            
//        case 3:
//        {
//            strTitle = @"외환";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return strTitle;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // custom cell
    static NSString *CellIdentifier = @"Cell";
    SHBAccountOrderChangeListCell *cell = (SHBAccountOrderChangeListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAccountOrderChangeListCell" owner:self options:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAccountOrderChangeListCell *)currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
	NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    
    NSString *strName = @"과목명";
    
    // 계좌별명이 있는 경우
    if ( [[[self.arrayTableData objectAtIndex:row] objectForKey:@"상품부기명"] length] > 0 )
    {
        strName = @"상품부기명";
    }
    
    NSString *strAccount = ([[[self.arrayTableData objectAtIndex:row] objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? @"계좌번호" : @"구계좌번호";

    // 대출이 포함된 경우
//    if (section == 2)
//    {
//        strName = @"대출과목명";
//        strAccount = @"대출계좌번호";
//    }
    
    // 섹션으로 구성되는 경우
//	NSString *strAccountName = [[[self.arrayTableData objectAtIndex:section] objectAtIndex:row] objectForKey:strName];
//    NSString *strAccountNumber = [[[self.arrayTableData objectAtIndex:section] objectAtIndex:row] objectForKey:strAccount];
    
    NSString *strAccountName = [[self.arrayTableData objectAtIndex:row] objectForKey:strName];
    NSString *strAccountNumber = [[self.arrayTableData objectAtIndex:row] objectForKey:strAccount];
    
	[cell.label1 setText:strAccountName];
    [cell.label2 setText:strAccountNumber];

    // long press
//    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
//    [longGesture setMinimumPressDuration:1.0];
//    [cell addGestureRecognizer:longGesture];
//    [longGesture release];
//    
//    [cell setShouldIndentWhileEditing:NO];
    
    return cell;
}

// 이동 가능
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 섹션으로 구성되는 경우
//	NSInteger sourceRow = sourceIndexPath.row;
//	NSInteger destinationRow = destinationIndexPath.row;
//    
//    NSInteger sourceSection = sourceIndexPath.section;
//    NSInteger destinationSection = destinationIndexPath.section;
//	
//	NSDictionary *dicSource;
//    
//    // 소스를 데스티니로
//    dicSource = [NSDictionary dictionaryWithDictionary:[[self.arrayTableData objectAtIndex:sourceSection] objectAtIndex:sourceRow]];
//    
//    [[self.arrayTableData objectAtIndex:sourceSection] removeObjectAtIndex:sourceRow];
//    [[self.arrayTableData objectAtIndex:destinationSection] insertObject:dicSource atIndex:destinationRow];
    
    NSInteger sourceRow = sourceIndexPath.row;
	NSInteger destinationRow = destinationIndexPath.row;
	
	NSDictionary *dicSource;
    
    // 소스를 데스티니로
    dicSource = [NSDictionary dictionaryWithDictionary:[self.arrayTableData objectAtIndex:sourceRow]];
    
    [self.arrayTableData removeObjectAtIndex:sourceRow];
    [self.arrayTableData insertObject:dicSource atIndex:destinationRow];
}

#pragma mark -
#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 62;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellSelectionStyleNone;
}

// edit 불가
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

// section으로 나눠질 시 다른 section으로 이동하지 못하게 막는 부분
//// Allows customization of the target row for a particular row as it is being moved/reordered
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    NSIndexPath *path = proposedDestinationIndexPath;
//    
//    // 다른 section의 경우 이동 불가
//    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
//    {
//        path = sourceIndexPath;
//    }
//    
//    return path;
//}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"계좌관리";
    
    strMesage = @"";
    
    // 계좌순서 서비스
    [self requestService];
    
    // Gesture Remove
	[self.view removeGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.arrayTableData = nil;
    
//    self.array1 = nil;
//    self.array2 = nil;
//    self.array3 = nil;
//    self.array4 = nil;
    
    [super dealloc];
}

@end
