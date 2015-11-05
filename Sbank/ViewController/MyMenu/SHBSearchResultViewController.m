//
//  SHBSearchResultViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSearchResultViewController.h"
#import "SHBAccountService.h"

#import "SHBSearchResultGroupTableViewCell.h"
#import "SHBSearchResultSubGroupTableViewCell.h"
#import "SHBSearchResultSpeedTypeTableViewCell.h"
#import "SHBSearchResultNormalTypeTableViewCell.h"

#define SEARCH_RESULT_GROUP     1
#define SEARCH_RESULT_SUB_GROUP 2
#define SEARCH_RESULT_SPEED     3
#define SEARCH_RESULT_NORMAL    4

@interface SHBSearchResultViewController ()
{
    int serviceType;
    NSMutableArray *tableDataArray;
    SHBTextField *txtSearch;
    UITableView *tableView1;
}
@property (nonatomic, retain) NSMutableArray *tableDataArray;
@property (nonatomic, retain) IBOutlet SHBTextField *txtSearch;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
- (void)search;
@end

@implementation SHBSearchResultViewController
@synthesize tableDataArray;;
@synthesize txtSearch;
@synthesize tableView1;

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
    [self navigationViewHidden];
	[self setBottomMenuView];
    
    startTextFieldTag = 11111111;
    endTextFieldTag = 11111111;
    
    txtSearch.text = self.data[@"SRC_WORD"];
    self.tableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self search];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnAction
{
    AppInfo.indexQuickMenu = 0;
	[self.navigationController PopSlideDownViewController];
}

- (IBAction)micBtnAction:(id)sender
{
    [txtSearch becomeFirstResponder];
}

- (IBAction)search
{
    [txtSearch resignFirstResponder];
    
    txtSearch.text = [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(txtSearch.text == nil || [txtSearch.text length] < 2)
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"검색어를 2자이상 입력바랍니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
	}
    
    self.dataList = [NSArray array];
    [tableView1 reloadData];
    
    serviceType = 1;
    self.service = nil;
    
    self.service = [[[SHBAccountService alloc] initWithServiceId:SEARCH viewController:self] autorelease];
    self.service.previousData = (SHBDataSet *)@{@"SRC_WORD" : txtSearch.text};
    [self.service start];
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    
//    NSString *tmpstring = [[[NSString alloc] initWithData:aContent encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"%@", tmpstring);
//    NSMutableArray *arrayData = [aDataSet arrayWithForKey:@"예금내역.vector.data"];

    switch (serviceType) {
        case 1:
        {
            if([aDataSet[@"SEARCH_CNT"] isEqualToString:@"0"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"검색결과가 없습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                
                [alert show];
                [alert release];
                
                return NO;
            }
            
            NSArray *groupArray = [aDataSet[@"GROUP_NAMES"] componentsSeparatedByString:@"|"];
            [tableDataArray removeAllObjects];
            
            for(int i = 0; i < [groupArray count]; i++){
                if([groupArray[i] isEqualToString:@"스피드이체"]){
                    NSDictionary *dic = @{@"TYPE" : [NSString stringWithFormat:@"%d", SEARCH_RESULT_GROUP],
                                          @"TITLE" : groupArray[i]};
                    [tableDataArray addObject:dic];
                    
                    NSArray *speedArray = [aDataSet arrayWithForKey:[NSString stringWithFormat:@"%@.vector.data", groupArray[i]]];
                    
                    for(NSDictionary *speedDic in speedArray){
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:speedDic];
                        dic[@"TYPE"] = [NSString stringWithFormat:@"%d", SEARCH_RESULT_SPEED];
                        dic[@"TITLE"] = speedDic[@"입금계좌별명"];
                        [tableDataArray addObject:dic];
                    }
                }else{
                    NSDictionary *dic = @{@"TYPE" : [NSString stringWithFormat:@"%d", SEARCH_RESULT_GROUP],
                                          @"TITLE" : groupArray[i]};
                    [tableDataArray addObject:dic];
                    
                    NSArray *nomarlArray = [aDataSet arrayWithForKey:[NSString stringWithFormat:@"%@.vector.data", groupArray[i]]];
                    
                    NSString *strSubGroup = @"";
                    
                    for(NSDictionary *nomarlDic in nomarlArray){
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:nomarlDic];
                        dic[@"TYPE"] = [NSString stringWithFormat:@"%d", SEARCH_RESULT_NORMAL];
                        dic[@"TITLE"] = dic[@"RESULT_NAME"];
                        dic[@"DESCRIPT"] = dic[@"RESULT_DESC"];
                        if(![strSubGroup isEqualToString:nomarlDic[@"SRC_GROUP2"]]){
                            NSDictionary *dic = @{@"TYPE" : [NSString stringWithFormat:@"%d", SEARCH_RESULT_SUB_GROUP],
                                                  @"TITLE" : nomarlDic[@"SRC_GROUP2"]};
                            [tableDataArray addObject:dic];
                            strSubGroup = nomarlDic[@"SRC_GROUP2"];
                        }
                        [tableDataArray addObject:dic];
                    }
                }
            }
            
            self.dataList = (NSArray *)tableDataArray;
            [tableView1 reloadData];
        }
            break;
        case 2:
        {
            if([self.data[@"TYPE_GB"] isEqualToString:@"W"]){
                SHBPushInfo *pushInfo = [SHBPushInfo instance];
                [pushInfo requestOpenURL:self.data[@"SCHEME_URL"] SSO:NO];
            }else{
                SHBPushInfo *pushInfo = [SHBPushInfo instance];
                if([self.data[@"SRC_GROUP"] isEqualToString:@"신한S뱅크"]){
                    if([SHBUtility isFindString:self.data[@"SCHEME_URL"] find:@"?"]){
                        AppInfo.schemaUrl = self.data[@"SCHEME_URL"];
                    }else{
                        AppInfo.schemaUrl = [NSString stringWithFormat:@"%@?", self.data[@"SCHEME_URL"]];
                    }
                    [pushInfo recieveOpenURL];
                }else{
                    [pushInfo requestOpenURL:self.data[@"SCHEME_URL"] Parm:nil];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    self.service = nil;
    
    return NO;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == txtSearch) {
        
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()-_=+{}|[]\\;:\'\"<>?,./`~";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 ) {
            
			return NO;
		}
        
		//한글 20자 제한(영문 40자)
		if (dataLength + dataLength2 > 40) {
            
			return NO;
		}
	}
	
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    return YES;
}

- (void)didCompleteButtonTouch
{
    [txtSearch resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    
    float cellHeight = 0;
    
    switch ([dic[@"TYPE"] intValue]) {
        case SEARCH_RESULT_GROUP:
        {
            cellHeight = 40.0;
        }
            break;
        case SEARCH_RESULT_SUB_GROUP:
        {
            cellHeight = 30.0;
        }
            break;
        case SEARCH_RESULT_SPEED:
        {
            cellHeight = 35.0;
        }
            break;
        case SEARCH_RESULT_NORMAL:
        {
            cellHeight = 60.0;
        }
            break;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataList[indexPath.row];
    
    switch ([dic[@"TYPE"] intValue]) {
        case SEARCH_RESULT_GROUP:
        {
            SHBSearchResultGroupTableViewCell *cell = (SHBSearchResultGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSearchResultGroupTableViewCell"];
            
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchResultGroupTableViewCell" owner:self options:nil];
                cell = (SHBSearchResultGroupTableViewCell *)array[0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.lblTitle.text = dic[@"TITLE"];

            return cell;
        }
            break;
        case SEARCH_RESULT_SUB_GROUP:
        {
            SHBSearchResultSubGroupTableViewCell *cell = (SHBSearchResultSubGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSearchResultSubGroupTableViewCell"];
            
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchResultSubGroupTableViewCell" owner:self options:nil];
                cell = (SHBSearchResultSubGroupTableViewCell *)array[0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.lblTitle.text = dic[@"TITLE"];

            return cell;
        }
            break;
        case SEARCH_RESULT_SPEED:
        {
            SHBSearchResultSpeedTypeTableViewCell *cell = (SHBSearchResultSpeedTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSearchResultSpeedTypeTableViewCell"];
            
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchResultSpeedTypeTableViewCell" owner:self options:nil];
                cell = (SHBSearchResultSpeedTypeTableViewCell *)array[0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.lblTitle.text = dic[@"TITLE"];

            return cell;
        }
            break;
        case SEARCH_RESULT_NORMAL:
        {
            SHBSearchResultNormalTypeTableViewCell *cell = (SHBSearchResultNormalTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBSearchResultNormalTypeTableViewCell"];
            
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBSearchResultNormalTypeTableViewCell" owner:self options:nil];
                cell = (SHBSearchResultNormalTypeTableViewCell *)array[0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.lblTitle.text = dic[@"TITLE"];
            cell.lblDescript.text = dic[@"DESCRIPT"];
            
            return cell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.data = self.dataList[indexPath.row];
    
    switch ([self.data[@"TYPE"] intValue]) {
        case SEARCH_RESULT_GROUP:
        case SEARCH_RESULT_SUB_GROUP:
        {
            return;
        }
            break;
        case SEARCH_RESULT_SPEED:
        {
            SHBPushInfo *pushInfo = [SHBPushInfo instance];
            AppInfo.schemaUrl = [NSString stringWithFormat:@"iphonesbank://D2011?category=03&nickName=%@&speedIndex=%@", self.data[@"입금계좌별명"], self.data[@"SP_IDX"]];
            [pushInfo recieveOpenURL];
        }
            break;
        case SEARCH_RESULT_NORMAL:
        {
            serviceType = 2;
            self.service = nil;
            self.service = [[[SHBAccountService alloc] initWithServiceId:SEARCH_LINK_HISTORY viewController:self] autorelease];
            self.service.previousData = (SHBDataSet *)@{@"SRC_ID" : self.data[@"SRC_ID"],
                                                        @"SRC_SEQ" : self.data[@"SRC_SEQ"],
                                                        };
            [self.service start];
        }
            break;
    }
}

@end
