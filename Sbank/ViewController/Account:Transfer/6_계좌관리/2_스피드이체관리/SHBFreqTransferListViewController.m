//
//  SHBFreqTransferListViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqTransferListViewController.h"
#import "SHBFreqTransferRegViewController.h"
#import "SHBFreqTransferListCell.h"
#import "SHBAccountService.h"

@interface SHBFreqTransferListViewController ()

@end

@implementation SHBFreqTransferListViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:   // 신규등록
        {
            if([self.dataList count] == 99)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"스피드 이체등록은 최대 99건까지만 등록가능합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            SHBFreqTransferRegViewController *nextViewController = [[[SHBFreqTransferRegViewController alloc] initWithNibName:@"SHBFreqTransferRegViewController" bundle:nil] autorelease];
            nextViewController.nType = 0;
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    //self.dataList = aDataSet[@"data"];
    self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
    
    NSLog(@"datalist:%@",self.dataList);

    [_tableView1 reloadData];
    
    self.service = nil;
    
    if([self.dataList count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"스피드이체 등록 내역이 없습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    return NO;
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 135;
    //return 169;
    //if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_1)
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
    {
        return 169;
    }else
    {
        return 135;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBFreqTransferListCell *cell = (SHBFreqTransferListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBFreqTransferListCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBFreqTransferListCell *)currentObject;
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.cellButtonActionDelegate = self;
    cell.row = indexPath.row;
    //NSLog(@"abcd:%f",floor(NSFoundationVersionNumber));
    //if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_1)
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
    {
        cell.widgetBtn.hidden = NO;
        cell.widgetBtn.enabled = YES;
        
    }else
    {
        cell.widgetBtn.hidden = YES;
        cell.widgetBtn.enabled = NO;
    }
    NSDictionary *dictionary = [self.dataList objectAtIndex:indexPath.row];
   
    cell.accountNickName.text = dictionary[@"입금계좌별명"];
    cell.amount.text = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:dictionary[@"이체금액"]]];
    cell.outAccountNo.text = dictionary[@"출금계좌번호"];
    cell.bankName.text = [AppInfo.codeList bankNameFromCode:dictionary[@"입금은행코드"]];
    cell.inAccountNo.text = dictionary[@"입금계좌번호"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = self.dataList[indexPath.row];
    
    SHBFreqTransferRegViewController *nextViewController = [[[SHBFreqTransferRegViewController alloc] initWithNibName:@"SHBFreqTransferRegViewController" bundle:nil] autorelease];
    nextViewController.data = dictionary;
    nextViewController.nType = 1;
    [self.navigationController pushFadeViewController:nextViewController];
}

- (void)refresh
{
    if(self.service != nil)
    {
        self.service = nil;
    }
    
    self.service = [[[SHBAccountService alloc] initWithServiceId:FREQ_TRANSFER_LIST viewController:self] autorelease];
    [self.service start];
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
    
    self.title = @"계좌관리";
    self.strBackButtonTitle = @"스피드이체 관리";

    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView1 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView1:nil];
    [super viewDidUnload];
}

#pragma mark SHBCellActionProtocol

- (void)cellButtonActionisOpen:(int)aRow
{
    
    //if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_1)
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_0)
    {
        SHBDataSet *tmpSet = self.dataList[aRow];
        NSString *nickName = tmpSet[@"입금계좌별명"];
    
        nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        nickName = [nickName stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    
        //NSString *argStr = [NSString stringWithFormat:@"screenID=D2011&category=03&nickName=%@&speedIndex=%@", tmpSet[@"입금계좌별명"],tmpSet[@"SP_IDX"]];
        //NSString *argStr = [NSString stringWithFormat:@"screenID=D2011&category=03&nickName=%@&speedIndex=%@", @"test",tmpSet[@"SP_IDX"]];
        //NSString *argStr = [NSString stringWithFormat:@"screenID=D2011&category=03&nickName=%@&speedIndex=%@&updt=%@", nickName,tmpSet[@"SP_IDX"],[SHBUtility nilToString:tmpSet[@"수정일시"]]];
        NSString *argStr = [NSString stringWithFormat:@"screenID=D2011&category=03&nickName=%@&speedIndex=%@", nickName,tmpSet[@"SP_IDX"]];
        //argStr = [argStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        #ifdef DEVELOPER_MODE
                NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"dev-m.shinhan.com", WIDGET_SERVICE_URL,argStr];
        #else
                NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, @"m.shinhan.com", WIDGET_SERVICE_URL,argStr];
        #endif
        
        NSLog(@"aaaa:%@",urlStr);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    
    
}

- (void)cellButtonAction:(int)aTag
{
    
}



@end
