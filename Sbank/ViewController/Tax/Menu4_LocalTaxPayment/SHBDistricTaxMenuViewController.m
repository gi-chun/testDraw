//
//  SHBDistricTaxMenuViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBDistricTaxMenuViewController.h"
#import "SHBDistricRegionCell.h"            // cell
#import "SHBGiroTaxListService.h"           // 지로지방세 서비스
#import "SHBSelfDistricTaxListViewController.h"         // casting 문제로 다음 view중 하나 import


@interface SHBDistricTaxMenuViewController ()

@end

@implementation SHBDistricTaxMenuViewController

#pragma mark -
#pragma mark Button Action

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:        // 지역 선택 버튼
        {
            if ( [[SHBAppInfo sharedSHBAppInfo].codeList.jibangCode count] == 0 )
            {            
                SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                        @{
                                        @"codeKey" : @"tax_jibang_region"
                                        }];
                
                self.service = [[[SHBGiroTaxListService alloc] initWithServiceId:TAX_COMMON_CODE viewController:self] autorelease];
                self.service.previousData = aDataSet;
                [self.service start];
            }
            
            //팝업뷰 오픈
            viewRegionPopupView = [[SHBPopupView alloc] initWithTitle:@"지역찾기" subView:viewPopupView];
            viewRegionPopupView.delegate = self;
            [viewRegionPopupView showInView:self.navigationController.view animated:YES];
            [viewRegionPopupView release];
        }
            break;
            
        case 12:        // 검색 버튼
        {
            [textFieldSearch resignFirstResponder];
            
            if ([textFieldSearch.text length] == 0)
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"지역을 선택해 주시기 바랍니다."];
                return;
            }
            else if ([textFieldSearch.text length] < 2)
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"검색시 시, 군 명을 최소 두 글자 이상 입력해주시기 바랍니다."];
                return;
            }
            
            [arraySearchRegion removeAllObjects];
            
            NSRange range;
            BOOL    isNoMatch = YES;
            
            for (NSDictionary *dic in [SHBAppInfo sharedSHBAppInfo].codeList.jibangCode)
            {
                range = [[dic objectForKey:@"value"] rangeOfString:textFieldSearch.text];
                
                if ( range.location == NSNotFound )
                {
                    ;
                }
                else
                {
                    [arraySearchRegion addObject:dic];
                    isNoMatch = NO;
                }
            }
            
            if ( isNoMatch == YES )
            {
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"찾으시는 지역이 존재하지 않습니다."];
                return;
            }
            
            [tableViewRegion reloadData];
        }
            
            break;
            
        case 13:        // 실행
        {            
            // 조회구분선택에 따른 분기 필요
            int intSelectedDistrict = intButtonIndex;
            
            // class name 과 viewController 생성
            NSString    *strClassName = nil;
            SHBBaseViewController       *viewController = nil;
            
            switch (intSelectedDistrict) {
                    
                case 21:     // 본인명의 지방세 납부
                {
                    strClassName = @"SHBSelfDistricTaxListViewController";
                }
                    break;
                    
                case 22:     // 간편납부번호로 지방세납부
                {
                    strClassName = @"SHBSimpleDistricTaxInputNoViewController";
                }
                    break;
                    
                case 23:     // 전자납부번호로 지방세납부
                {
                    strClassName = @"SHBElectronDistricTaxInputNoViewController";
                }
                    break;
                    
                default:
                    break;
            }
            
            NSString *strValue = @"전국";
            NSString *strCode = @"000000000";
            
            if ([[SHBAppInfo sharedSHBAppInfo].codeList.jibangCode count] > 0)
            {
                for (NSDictionary *dic in [SHBAppInfo sharedSHBAppInfo].codeList.jibangCode)
                {
                    if ([[dic objectForKey:@"value"] isEqualToString:labelRegion.text])
                    {
                        strValue = [dic objectForKey:@"value"];
                        strCode = [dic objectForKey:@"code"];
                        
                        break;
                    }
                }
            }
            NSMutableDictionary    *dicData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
            
            [dicData setObject:strValue forKey:@"value"];
            [dicData setObject:strCode forKey:@"code"];
            
            [dicDataDictionary setObject:dicData forKey:@"지역정보"];
            
            viewController = [[NSClassFromString(strClassName) alloc]initWithNibName:strClassName bundle:nil];
            ((SHBSelfDistricTaxListViewController *)viewController).dicDataDictionary = dicDataDictionary;      // data 전달 문제로 casting
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)radioButtonDidPush:(id)sender
{
    if (intButtonIndex == [sender tag])
        return;
    
    intButtonIndex = [sender tag];
    
    for (int i = 21 ; i < 24 ; i++)
    {
        ((UIButton*)[self.view viewWithTag:i]).selected = NO;
    }
    
    ((UIButton*)[self.view viewWithTag:intButtonIndex]).selected = YES;
}


#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
//    NSLog(@"onParseonParse : %@", aDataSet);
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
//    NSLog(@"onBindonBind : %@", aDataSet);
    
    if ( [aDataSet objectForKey:@"data"] )
    {
//        [SHBAppInfo sharedSHBAppInfo].codeList.jibangCode = (NSMutableDictionary*)[aDataSet dictionaryWithValuesForKeys:[aDataSet arrayWithForKeyPath:@"data"]];
        [SHBAppInfo sharedSHBAppInfo].codeList.jibangCode = [aDataSet arrayWithForKeyPath:@"data"];
    }
    
    return YES;
}


#pragma mark -
#pragma mark SHBPopupView Delegate

- (void)popupViewDidCancel
{
    textFieldSearch.text = @"";
}

#pragma mark -
#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arraySearchRegion count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBDistricRegionCell *cell = (SHBDistricRegionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBDistricRegionCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBDistricRegionCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dictionary = [arraySearchRegion objectAtIndex:indexPath.row];
    cell.labelRegion.text = [dictionary objectForKey:@"value"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableViewRegion deselectRowAtIndexPath:indexPath animated:YES];  //선택해제
    
    [dicDataDictionary setObject:[arraySearchRegion objectAtIndex:indexPath.row] forKey:@"지역정보"];
    
    [viewRegionPopupView closePopupViewWithButton:nil];
    
    labelRegion.text = [[dicDataDictionary objectForKey:@"지역정보"] objectForKey:@"value"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"지방세납부";        // title 설정
    self.strBackButtonTitle = @"지방세납부선택 메인";
    
    intButtonIndex = 21;             // radio button 초기값 설정
    
    arraySearchRegion = [[NSMutableArray alloc] initWithCapacity:0];
    dicDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // textField이동으로 tag 값 지정
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [viewRegionPopupView release];
    [arraySearchRegion release];
    [dicDataDictionary release];
    
    [super dealloc];
}

@end
