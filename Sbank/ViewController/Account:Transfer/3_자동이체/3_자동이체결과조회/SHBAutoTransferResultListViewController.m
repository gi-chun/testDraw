//
//  SHBAutoTransferResultListViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferResultListViewController.h"
#import "SHBAutoTransferResultCell.h"

@interface SHBAutoTransferResultListViewController ()
{
    int totListCnt;
}
@end

@implementation SHBAutoTransferResultListViewController
@synthesize service;

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    switch ([sender tag]) {
        case 100:
        {
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:self.dataList] autorelease];
            
            if(sender.isSelected)
            {
                sender.selected = NO;
                sender.accessibilityLabel = @"과거 거래순 정렬";
            }
            else
            {
                sender.selected = YES;
                sender.accessibilityLabel = @"최근 거래순 정렬";
            }
            
            if([self.data[@"서비스코드"] isEqualToString:@"D2213"])
            {
                NSSortDescriptor *sortOrder1 = [[NSSortDescriptor alloc] initWithKey:@"처리일자" ascending:sender.isSelected];
                NSSortDescriptor *sortOrder2 = [[NSSortDescriptor alloc] initWithKey:@"처리시간" ascending:sender.isSelected];
                
                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder1, sortOrder2, nil]];
                [sortOrder1 release];
                [sortOrder2 release];
            }
            else
            {
                NSSortDescriptor *sortOrder1 = [[NSSortDescriptor alloc] initWithKey:@"처리일자" ascending:sender.isSelected];
                
                [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder1, nil]];
                [sortOrder1 release];
            }
            
            self.dataList = (NSArray *)tempArray;
            
            [_tableView1 reloadData];
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    _btnSort.selected = YES;
    
    if([self.data[@"서비스코드"] isEqualToString:@"D2213"])
    {
        NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        
        for(NSDictionary *dic in [aDataSet arrayWithForKey:@"이체결과"])
        {
            NSString *strTemp1 = [dic[@"지급계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strTemp2 = [self.data[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strTemp3 = [self.data[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if([dic[@"지급정지"] isEqualToString:@"0"] &&
               ([strTemp1 isEqualToString:strTemp2] ||
                [strTemp1 isEqualToString:strTemp3]) &&
               (![dic[@"이체종류"] isEqualToString:@"03"] &&
                ![dic[@"이체종류"] isEqualToString:@"11"] &&
                ![dic[@"이체종류"] isEqualToString:@"13"]))
            {
                [tempArray addObject:dic];
            }
        }
        
        self.dataList = (NSArray *)tempArray;
    }
    else
    {
        self.dataList = [aDataSet arrayWithForKey:@"이체결과"];
    }
    
    [_tableView1 reloadData];
    
    totListCnt = [self.dataList count];

    if(totListCnt == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"자동이체 거래내역이 존재하지 않습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        /* iOS7에서 죽는 현상 발생하여 수정
        UILabel *label_alert = (UILabel*)[[alert subviews] objectAtIndex:1];
        
        if(label_alert != nil && [label_alert isKindOfClass:[UILabel class]])
        {
            [label_alert setTextAlignment:UITextAlignmentLeft];
        }
        */
        [alert show];
        [alert release];
    }
    
    if(totListCnt >= 500)
    {
        _lblInqueryTerm.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (500건 이상)", self.data[@"조회시작일"], self.data[@"조회종료일"]];
    }
    else
    {
        _lblInqueryTerm.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (%d건)", self.data[@"조회시작일"], self.data[@"조회종료일"], totListCnt];
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController fadePopViewController];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SHBAutoTransferResultCell *cell = (SHBAutoTransferResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAutoTransferResultCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAutoTransferResultCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = self.dataList[indexPath.row];

    NSArray *captionArray = nil;

    if([self.data[@"서비스코드"] isEqualToString:@"D2213"])
    {
        
        NSString *strTemp1 = @"";
        NSString *strTemp2 = @"";
        
        if(![dictionary[@"이체주기"] isEqualToString:@""])
        {
            switch ([dictionary[@"이체주기"] intValue]) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                {
                    strTemp1 = [NSString stringWithFormat:@"%d개월", [dictionary[@"이체주기"] intValue]];
                }
                    break;
                case 91:
                {
                    strTemp1 = @"월요일";
                }
                    break;
                case 92:
                {
                    strTemp1 = @"화요일";
                }
                    break;
                case 93:
                {
                    strTemp1 = @"수요일";
                }
                    break;
                case 94:
                {
                    strTemp1 = @"목요일";
                }
                    break;
                case 95:
                {
                    strTemp1 = @"금요일";
                }
                    break;
                case 99:
                {
                    strTemp1 = @"매일";
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        switch ([dictionary[@"이체종류"] intValue]) {
            case 1:
            {
                strTemp2 = @"적금/신탁/청약";
            }
                break;
            case 2:
            {
                strTemp2 = @"예금이자 지급이체";
            }
                break;
            case 3:
            {
                strTemp2 = @"대출이자 납입이체";
            }
                break;
            case 4:
            {
                strTemp2 = @"수익증권 이체";
            }
                break;
            case 5:
            {
                strTemp2 = @"입출금통장간";
            }
                break;
            case 8:
            {
                strTemp2 = @"swing service 이체";
            }
                break;
            case 11:
            {
                strTemp2 = @"만기(해지)이체";
            }
                break;
            case 12:
            {
                strTemp2 = @"기간연장";
            }
                break;
            case 13:
            {
                strTemp2 = @"외화예금이체";
            }
                break;
            case 14:
            {
                strTemp2 = @"이자원가";
            }
                break;
            case 15:
            {
                strTemp2 = @"원리금재예치";
            }
                break;
            case 17:
            {
                strTemp2 = @"퇴직신탁이체";
            }
                break;
            case 18:
            {
                strTemp2 = @"CMA이체";
            }
                break;
            case 19:
            {
                strTemp2 = @"외화송금이체";
            }
                break;
            case 20:
            {
                strTemp2 = @"개인채무자회생이체";
            }
                break;
                
            default:
                break;
        }
        
        captionArray = @[@"처리일자", @"입금은행", @"입금계좌번호", @"지급계좌표시", @"이체금액", @"이체일자", @"이체주기", @"이체종류", @"이체결과"];
        cell.lblData01.text = [NSString stringWithFormat:@"%@ %@", dictionary[@"처리일자"], dictionary[@"처리시간"]];
        cell.lblData02.text = @"신한은행";
        cell.lblData03.text = dictionary[@"입금계좌번호"];
        cell.lblData04.text = dictionary[@"지급계좌통장메모"];
        cell.lblData05.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
        cell.lblData06.text = dictionary[@"이체일"];
        cell.lblData07.text = strTemp1;
        cell.lblData08.text = strTemp2;
        cell.lblData09.text = [dictionary[@"결과"] isEqualToString:@"01"] ? @"정상" : @"오류";
    }
    else
    {
        captionArray = @[@"처리일자", @"입금은행", @"입금계좌번호", @"지급계좌표시", @"이체금액", @"이체일자", @"입금통장표시", @"수수료", @"이체결과"];
        cell.lblData01.text = dictionary[@"처리일자"];
        cell.lblData02.text = [AppInfo.codeList bankNameFromCode:dictionary[@"타행은행코드"]];
        cell.lblData03.text = dictionary[@"타행환계좌번호"];
        cell.lblData04.text = dictionary[@"지급계좌통장메모"];
        cell.lblData05.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
        cell.lblData06.text = dictionary[@"이체일"];
        cell.lblData07.text = dictionary[@"입금계좌통장메모"];
        cell.lblData08.text = [NSString stringWithFormat:@"%@원", dictionary[@"수수료"]];
        cell.lblData09.text = [dictionary[@"결과"] isEqualToString:@"00"] ? @"정상" : @"오류";
    }

    if(![cell.lblData09.text isEqualToString:@"정상"])
    {
        cell.lblData09.textColor = RGB(209, 75, 75);
        UILabel *label = cell.lblCaption[8];
        label.textColor = RGB(209, 75, 75);
    }
    
    
    for(int i = 0; i < [cell.lblCaption count]; i ++)
    {
        UILabel *label = cell.lblCaption[i];
        label.text = captionArray[i];
    }
    
//
//    if([dictionary[@"처리상태"] length] != 0)
//    {
//        int tmp = [dictionary[@"처리상태"] intValue];
//        
//        switch (tmp) {
//            case 1:
//            {
//                cell.lblState.text = @"[처리중]";
//                cell.lblState.textColor = RGB(209, 75, 75);
//            }
//                break;
//            case 2:
//            {
//                cell.lblState.text = @"[정상]";
//                cell.lblState.textColor = RGB(0, 137, 220);
//            }
//                break;
//            case 3:
//            case 4:
//            case 5:
//            {
//                cell.lblState.text = @"[오류]";
//                cell.lblState.textColor = RGB(209, 75, 75);
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    else
//    {
//        if([dictionary[@"처리상태"] isEqualToString:@"정상"])
//        {
//            cell.lblState.text = @"[정상]";
//            cell.lblState.textColor = RGB(0, 137, 220);
//        }
//        else
//        {
//            cell.lblState.text = @"";
//        }
//    }
//    
//    cell.lblRecvName.text = dictionary[@"입금계좌성명"];
//    cell.lblTranAmount.text = [NSString stringWithFormat:@"%@원", dictionary[@"이체금액"]];
    
    return cell;
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
    
    self.title = @"자동이체";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    _lblAccountNo.text = self.data[@"출금계좌번호"];
    _lblInqueryTerm.text = [NSString stringWithFormat:@"조회기간 : %@ ~ %@ (0건)", self.data[@"조회시작일"], self.data[@"조회종료일"]];
    
    self.service = [[[SHBAccountService alloc] initWithServiceCode:self.data[@"서비스코드"] viewController:self] autorelease];
    
    //주의 : 보이는게 구계좌라도 전문 보낼때는 신계좌로 보내야 함.
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"출금계좌번호" : [self.data[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                            @"조회시작일" : [self.data[@"조회시작일"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                            @"조회종료일" : [self.data[@"조회종료일"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                            }] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblAccountNo release];
    [_lblInqueryTerm release];
    [_btnSort release];
    [_tableView1 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAccountNo:nil];
    [self setLblInqueryTerm:nil];
    [self setBtnSort:nil];
    [self setTableView1:nil];
    [super viewDidUnload];
}
@end
