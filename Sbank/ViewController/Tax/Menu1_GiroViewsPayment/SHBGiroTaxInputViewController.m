//
//  SHBGiroTaxInputViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxInputViewController.h"
#import "SHBGiroTaxListService.h"                       // 지로조회납부 service
#import "SHBGiroTaxListViewCell.h"                      // tableView cell
#import "SHBGiroTaxAccountInputViewController.h"        // 다음 View


@interface SHBGiroTaxInputViewController ()

@end

@implementation SHBGiroTaxInputViewController


#pragma mark -
#pragma mark Private Method

- (BOOL)checkException
{
    BOOL isError = NO;
    NSString *strErrorMessage = @"입력값을 확인해 주세요";
    
    if ( nil == textField1.text || [textField1.text isEqualToString:@""] )
    {
        strErrorMessage = @"지로번호를 입력해 주십시오.";
        goto errorCase;
    }
    else if ([textField1.text length] < 7)
    {
        strErrorMessage = @"지로번호는 7자리를 입력해 주십시오.";
        goto errorCase;
    }
    else if ( nil == textField2.text || [textField2.text isEqualToString:@""] )
    {
        strErrorMessage = @"전자납부번호를 입력해 주십시오.";
        goto errorCase;
    }
    
    return isError;
    
errorCase:
    {
        isError = YES;
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:strErrorMessage];
        
        return isError;
    }
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)buttonDidPush:(id)sender
{
    [self didCompleteButtonTouch];
    
    switch ([sender tag])
    {
        case 11:        // 도움말
        {
            //팝업뷰 오픈
            SHBPopupView *popupView = [[SHBPopupView alloc] initWithTitle:@"도움말" subView:helpView];
            [popupView showInView:self.navigationController.view animated:YES];
            [popupView release];
        }
            break;
            
        case 12:        // 조회 버튼
        {
            if ([self checkException])   // 예외사항 check
            {
                return;
            }
            
            [self didCompleteButtonTouch];
            
            // tableView 초기화
            [tableView1 reloadData];
            
            OFDataSet *aDataSet = [[[OFDataSet alloc] initWithDictionary:
                                    @{
                                    @"이용기관지로번호" : textField1.text,
                                    @"전자납부번호" : textField2.text,
                                    @"지정번호" : @"1"
                                    }] autorelease];
            
            self.service = [[[SHBGiroTaxListService alloc] initWithServiceId: TAX_LIST viewController: self] autorelease];
            [self.service setTableView: tableView1 tableViewCellName:@"SHBGiroTaxListViewCell" dataSetList:@"지로조회납부.vector.data"];
            self.service.previousData = aDataSet;
            [self.service start];
            
            return;

        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL) onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if ( [[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"G0111"] )
    {
        if ( [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"] )
        {
            for (OFDataSet *dataSet in [aDataSet arrayWithForKey:@"지로조회납부"]) {
                
                // 수납기관명 추가
                [dataSet insertObject:[aDataSet objectForKey:@"수납기관명"] forKey:@"수납기관명" atIndex:0];
                
                // 납부자명 추가
                [dataSet insertObject:[aDataSet objectForKey:@"납부자성명"] forKey:@"납부자성명" atIndex:0];
            }
            
            // tableView를 보이기 위해
            [tableView1 setScrollEnabled:YES];
            [viewLine setHidden:NO];
            [tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
    }
    
    return YES;
}

- (BOOL) onBind:(OFDataSet *)aDataSet
{
    return YES;
}

#pragma mark -
#pragma mark Notifications

- (void)textFieldDidChange
{
    if (curTextField == textField1)
    {
        if ([curTextField.text length] > 7)
        {
            curTextField.text = [curTextField.text substringToIndex:7];
        }
    }
    else
    {
        if ([curTextField.text length] > 17)
        {
            curTextField.text = [curTextField.text substringToIndex:17];
        }
    }
}

- (void)cancelButtonPushed
{
    textField1.text = @"";
    textField2.text = @"";
    
    self.service.dataList = nil;
    [tableView1 reloadData];
    
    // tableView를 가리기 위해
    [viewLine setHidden:YES];
    [tableView1 setScrollEnabled:NO];
    [tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


#pragma mark -
#pragma mark SHBTextField Delegate

- (void)didCompleteButtonTouch
{
    [super didCompleteButtonTouch];
}


#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    SHBGiroTaxAccountInputViewController *viewController = [[SHBGiroTaxAccountInputViewController alloc] initWithNibName:@"SHBGiroTaxAccountInputViewController" bundle:nil];
    
    // 정보 setting
    NSMutableDictionary *dicData = [self.service.dataList objectAtIndex:indexPath.row];
    
    [dicData setObject:textField1.text forKey:@"지로번호"];
    [dicData setObject:textField2.text forKey:@"전자납부번호"];
    [dicData setObject:[NSString stringWithFormat:@"%@원", [dicData objectForKey:@"납부금액"]] forKey:@"납부금액원"];
    
    viewController.dicDataDictionary = dicData;
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


#pragma mark -
#pragma mark Xcode Generated

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
    self.title = @"지로조회납부";
    
    self.strBackButtonTitle = @"지로조회납부 메인";
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222001;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonDidPush" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPushed) name:@"cancelButtonDidPush" object:nil];
    
    [tableView1 setScrollEnabled:NO];
    [viewLine setHidden:YES];
    [tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelButtonDidPush" object:nil];
    [super dealloc];
}


@end
