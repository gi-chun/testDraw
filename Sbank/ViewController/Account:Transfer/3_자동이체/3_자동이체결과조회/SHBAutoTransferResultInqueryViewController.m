//
//  SHBAutoTransferResultInqueryViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferResultInqueryViewController.h"
#import "SHBAutoTransferResultListViewController.h"

@interface SHBAutoTransferResultInqueryViewController ()

@end

@implementation SHBAutoTransferResultInqueryViewController
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
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:-7]] animated:NO];
            [_endDateField selectDate:[NSDate date] animated:NO];
        }
            break;
        case 201:
        {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:-1 toDay:0]] animated:NO];
            [_endDateField selectDate:[NSDate date] animated:NO];
        }
            break;
        case 202:
        {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:-3 toDay:0]] animated:NO];
            [_endDateField selectDate:[NSDate date] animated:NO];
        }
            break;
        case 300:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = YES;
            _btnSelector2.selected = NO;
        }
            break;
        case 301:
        {
            if(sender.isSelected) return;
            
            _btnSelector1.selected = NO;
            _btnSelector2.selected = YES;
        }
            break;
        case 400:
        {
            SHBAutoTransferResultListViewController *nextViewController = [[[SHBAutoTransferResultListViewController alloc] initWithNibName:@"SHBAutoTransferResultListViewController" bundle:nil] autorelease];
            nextViewController.data = @{@"서비스코드" : _btnSelector1.isSelected ? @"D2213" : @"D2214",
                                        @"출금계좌번호" : _btnAccountNo.titleLabel.text,
                                        @"조회시작일" : _startDateField.textField.text,
                                        @"조회종료일" : _endDateField.textField.text,
                                        @"계좌번호" : self.outAccInfoDic[@"출금계좌번호"],
                                        };
            [self.navigationController pushFadeViewController:nextViewController];
        }
            break;
        default:
            break;
    }
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
    self.strBackButtonTitle = @"자동이체 결과조회";
    
    // 기간지정 시작
    [_startDateField initFrame:_startDateField.frame];
    [_startDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_startDateField.textField setTextColor:RGB(44, 44, 44)];
    [_startDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_startDateField setDelegate:self];
    [_startDateField setmaximumDate:[NSDate date]];
    [_startDateField selectDate:[NSDate date] animated:NO];
    
    // 기간지정 종료
    [_endDateField initFrame:_endDateField.frame];
    [_endDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_endDateField.textField setTextColor:RGB(44, 44, 44)];
    [_endDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_endDateField setDelegate:self];
    [_endDateField setmaximumDate:[NSDate date]];
    [_endDateField selectDate:[NSDate date] animated:NO];
    
    NSArray * accountArray = [self outAccountList];
    
    if([accountArray count] != 0)
    {
        self.outAccInfoDic = accountArray[0];
        [_btnAccountNo setTitle:self.outAccInfoDic[@"2"] forState:UIControlStateNormal];
        _btnAccountNo.accessibilityLabel = [NSString stringWithFormat:@"선택된 조회계좌번호는 %@ 입니다", _btnAccountNo.titleLabel.text];
        _btnAccountNo.accessibilityHint = @"조회계좌번호를 바꾸시려면 이중탭 하십시오";
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
    [_startDateField release];
    [_endDateField release];
    [_btnSelector1 release];
    [_btnSelector2 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBtnAccountNo:nil];
    [self setStartDateField:nil];
    [self setEndDateField:nil];
    [self setBtnSelector1:nil];
    [self setBtnSelector2:nil];
    [super viewDidUnload];
}
@end
