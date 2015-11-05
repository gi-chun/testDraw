//
//  SHBAutoTransferInqueryViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferInqueryViewController.h"
#import "SHBAutoTransferListViewController.h"
#import "SHBAccountService.h"

@interface SHBAutoTransferInqueryViewController ()

@end

@implementation SHBAutoTransferInqueryViewController
@synthesize outAccInfoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            _btnAccountNo.selected = YES;
            
            NSMutableArray *tableDataArray = [self outAccountList];
            
            if ([tableDataArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"출금가능 계좌가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return;
            }
            
            self.dataList = (NSArray *)tableDataArray;
            
            SHBListPopupView *popupView = [[SHBListPopupView alloc] initWithTitle:@"출금계좌" options:tableDataArray CellNib:@"SHBAccountListPopupCell" CellH:50 CellDispCnt:5 CellOptCnt:2];
            [popupView setDelegate:self];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
        case 200:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
        }
            break;
        case 201:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
        }
            break;
        case 300:
        {
            self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2210" viewController:self] autorelease];
            
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                     @{
                                     @"업무구분" : @"1",
                                     @"출금계좌번호" : _btnAccountNo.titleLabel.text,
                                     @"자동이체조회구분" : _btnSelector1.isSelected ? @"0" : @"9",
                                     }] autorelease];
            
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        default:
            break;
    }
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
    self.service = nil;

//    if([aDataSet[@"데이타건수"] intValue] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"해당계좌에 조회할 내용이 없습니다."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"확인"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        [alert release];
//        
//        return NO;
//    }
    
    [aDataSet insertObject:_btnAccountNo.titleLabel.text forKey:@"_출금계좌번호" atIndex:0];
    [aDataSet insertObject:self.outAccInfoDic[@"출금계좌번호"] forKey:@"_신계좌번호" atIndex:0];
    
    SHBAutoTransferListViewController *nextViewController = [[[SHBAutoTransferListViewController alloc] initWithNibName:@"SHBAutoTransferListViewController" bundle:nil] autorelease];
    nextViewController.data = aDataSet;
    nextViewController.nType = _btnSelector1.isSelected ? 0 : 9;
    [self.navigationController pushFadeViewController:nextViewController];
    
    return NO;
}

#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex{
    _btnAccountNo.selected = NO;
    self.outAccInfoDic = self.dataList[anIndex];
    
    [_btnAccountNo setTitle:self.dataList[anIndex][@"2"] forState:UIControlStateNormal];
    
    _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 조회계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
    _btnAccountNo.accessibilityHint = @"조회계좌번호를 바꾸시려면 이중탭 하십시오";
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
}

- (void)listPopupViewDidCancel{
    _btnAccountNo.selected = NO;
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, _btnAccountNo);
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
    self.strBackButtonTitle = @"자동이체 조회 계좌선택";
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnAccountNo setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
        _btnAccountNo.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_btnAccountNo release];
    [_btnSelector1 release];
    [_btnSelector2 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    self.outAccInfoDic = nil;
    
    [self setBtnAccountNo:nil];
    [self setBtnSelector1:nil];
    [self setBtnSelector2:nil];
    [super viewDidUnload];
}

@end
