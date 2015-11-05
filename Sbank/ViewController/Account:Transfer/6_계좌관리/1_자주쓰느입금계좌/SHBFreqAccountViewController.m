//
//  SHBFreqAccountViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqAccountViewController.h"
#import "SHBFreqAccountListCell.h"
#import "SHBFreqAccountInquiryViewController.h"

@interface SHBFreqAccountViewController ()
{
    int selectedRow;
    int serviceType;
    
}

@property (retain, nonatomic) NSString *tempLabel; // 라벨명
@property (nonatomic, retain) NSMutableArray *checkedIndexPaths;

@end

@implementation SHBFreqAccountViewController

@synthesize tableView1;
@synthesize checkedIndexPaths;
//@synthesize tableDataArray;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
            // 입력/수정화면 전이
        case 10:
        {
            SHBFreqAccountInquiryViewController *nextViewController = [[[SHBFreqAccountInquiryViewController alloc] initWithNibName:@"SHBFreqAccountInquiryViewController" bundle:nil] autorelease];
            
//            [self.navigationController pushViewController:nextViewController animated:YES];
            [self.navigationController pushFadeViewController:nextViewController];
            
        }
            break;
            
            // 삭제
        case 20:
        {
            BOOL deleteItem = NO;
            for (int i = 0; i < [self.checkedIndexPaths count]; i++) {
                NSLog(@"checkedIndexPaths : %@", [self.checkedIndexPaths objectAtIndex:i]);
                
                NSNumber *num = [self.checkedIndexPaths objectAtIndex:i];
                if (num == [NSNumber numberWithBool:YES]) {
                    deleteItem = YES;
                    break;
                } else {
                    deleteItem = NO;
                }
            }
            
            if (deleteItem) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"삭제 후 해당정보는 복원되지\n않습니다. 삭제하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"확인", @"취소",nil];
                alert.tag = 1111;
                [alert show];
                [alert release];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"삭제하실 계좌를 선택하여 주십시오."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                alert.tag = 2222;
                [alert show];
                [alert release];
            }
            
        }
            break;
            
        default:
            break;
    }
}


- (void)dealloc
{
    [tableView1 release], tableView1 = nil;
    [_tempLabel release];
    
    [super dealloc];
}

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
    
    self.strBackButtonTitle = @"자주쓰는입금계좌 메인";
    
    AppInfo.isNeedBackWhenError = YES;
    
    _tempLabel = @"";

    [self refresh];
}

- (void)refresh
{
    serviceType = 0;
    selectedRow = -1;
    // C2210 전문호출
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2210" viewController: self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] init] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataList count] == 0) {
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
    SHBFreqAccountListCell *cell = (SHBFreqAccountListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFreqAccountListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFreqAccountListCell *)currentObject;
                break;
            }
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    cell.row = indexPath.row;
    cell.target = self;
    cell.openBtnSelector = @selector(openOrCloseCell:);
    
//    NSLog(@"indexPathsForSelectedRows ; [%@], cur row [%d], selectedrow [%d]", selectedRows, indexPath.row, selectedRow);
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    NSNumber *num = [self.checkedIndexPaths objectAtIndex:indexPath.row];
    
    if (selectedRow == indexPath.row) {
        if (num == [NSNumber numberWithBool:YES])
        {
            [self.checkedIndexPaths replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.checkedIndexPaths replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    if(selectedRow == indexPath.row){
        //    if(selection && selection.row == indexPath.row){
        cell.contentView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];

    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
        [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
    
    // 다시 읽어낸다.
    num = [self.checkedIndexPaths objectAtIndex:indexPath.row];
    
    if (num == [NSNumber numberWithBool:YES]) {
        cell.btnOpen.hidden = NO;
        [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
        [self.checkedIndexPaths replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"선택해제";
    }
    
    if (num == [NSNumber numberWithBool:NO]) {
        [cell.btnOpen setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        [self.checkedIndexPaths replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [cell.btnOpen setIsAccessibilityElement:YES];
        cell.btnOpen.accessibilityLabel = @"선택";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openOrCloseCell:indexPath.row];
}

- (void)openOrCloseCell:(int)row
{
    NSArray *selectedRows = [tableView1 indexPathsForSelectedRows];
    NSLog(@"openOrCloseCell indexPathsForSelectedRows ; [%@]", selectedRows);
    
    if(selectedRow == row)
    {
        selectedRow = -1;
    }
    else
    {
        selectedRow = row;
    }
    
    NSNumber *num = [self.checkedIndexPaths objectAtIndex:row];
    if (num == [NSNumber numberWithBool:YES])
    {
        [self.checkedIndexPaths replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:NO]];
    } else {
        [self.checkedIndexPaths replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:YES]];
    }

    [tableView1 reloadData];
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            // 리스트
            self.dataList = [aDataSet arrayWithForKey:@"입금계좌"];
            
            if(self.dataList == nil || [self.dataList count] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"등록되어 있는 자주쓰는 입금계좌가 존재하지 않습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                alert.tag = 3333;
                [alert show];
                [alert release];
                [tableView1 reloadData];
                return NO;
            }
            
            NSMutableArray *tableDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            for(NSDictionary *dic in self.dataList)
            {
                [tableDataArray addObject:@{
                 @"1" : [AppInfo.codeList bankNameFromCode:dic[@"입금은행코드"]],
                 @"2" : dic[@"입금계좌번호"],
                 @"3" : dic[@"입금계좌성명"],
                 @"4" : dic[@"nick_name"],
                 @"5" : dic[@"입금은행코드"],
                 }];
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            //Setup default array to keep track of the checkmarks
            self.checkedIndexPaths = [NSMutableArray arrayWithCapacity:[self.dataList count]];
            for (int i = 0; i < [self.dataList count]; i++) {
                [self.checkedIndexPaths addObject:[NSNumber numberWithBool:NO]];
            }
   
            NSLog(@"dataList : %@", self.dataList);
            if ([self.dataList count] > 0) {
                _tempLabel = @"";
            } else {
                _tempLabel = @"조회된 거래내역이 없습니다.";
            }

            [tableView1 reloadData];
            
//            [self.service release];
            self.service = nil;
            
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"정상 처리되었습니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            alert.tag = 4444;
            [alert show];
            [alert release];
            [self refresh];

            
        }
            break;
            
        default:
            break;
    }
    
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (alertView.tag == 1111 && buttonIndex == 0)
    {
        serviceType = 1;
        // C2222 전문호출
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"C2222" viewController: self] autorelease];

        SHBDataSet *aVectorSet = [[[SHBDataSet alloc] init] autorelease];
        SHBDataSet *aDataSetN = nil;//[[[SHBDataSet alloc] init] autorelease];
        
        NSLog(@"checkedIndexPaths count : %d", [self.checkedIndexPaths count]);
        int j = 0;
        for (int i = 0; i < [self.checkedIndexPaths count]; i++) {
            NSLog(@"checkedIndexPaths : %@", [self.checkedIndexPaths objectAtIndex:i]);
            
            NSNumber *num = [self.checkedIndexPaths objectAtIndex:i];
            if (num == [NSNumber numberWithBool:YES]) {
                NSDictionary *dictionary = self.dataList[i];
                aDataSetN = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"입금은행코드" : [dictionary objectForKey:@"5"],
                            @"입금계좌번호" : [dictionary objectForKey:@"2"],
                            }] autorelease];

                
                [aVectorSet insertObject:aDataSetN forKey:[NSString stringWithFormat:@"vector%i", (int)j] atIndex:j];
                j++;
                aDataSetN = nil;
            }
        }
        
                
        
        aVectorSet.vectorTitle = @"입급계좌목록";
        
        NSLog(@"aVector : %@", aVectorSet);
        self.service.requestData = aVectorSet;
        [self.service start];
	}
    
    
  }

@end
