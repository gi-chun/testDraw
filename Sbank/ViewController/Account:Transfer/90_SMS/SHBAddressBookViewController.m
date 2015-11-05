//
//  SHBAddressBookViewController.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAddressBookViewController.h"
#import "AddressBook/AddressBook.h"
#import "SHBAddressBookCell.h"

@interface SHBAddressBookViewController ()
{
	IBOutlet UITableView	*addressTableView;
    
	NSMutableArray	*listContent;
	NSMutableArray	*filteredListContent;
    NSMutableArray  *tableTitleArray;
    NSMutableArray  *tableDataArray;
	
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
	BOOL			isSearchTable;
}

@property(nonatomic, retain) UITableView*	addressTableView;
@property(nonatomic, retain) NSMutableArray *listContent;
@property(nonatomic, retain) NSMutableArray *filteredListContent;
@property(nonatomic, retain) NSMutableArray *tableTitleArray;
@property(nonatomic, retain) NSMutableArray *tableDataArray;

@property(nonatomic, copy  ) NSString *savedSearchTerm;
@property(nonatomic		   ) NSInteger savedScopeButtonIndex;
@property(nonatomic		   ) BOOL searchWasActive;

- (NSInteger)getChosung:(NSString *)str;
- (void)filterContentForSearchText:(NSString*)searchText;
@end

@implementation SHBAddressBookViewController
@synthesize pViewController;
@synthesize pSelector;
@synthesize addressTableView;
@synthesize listContent;
@synthesize filteredListContent;
@synthesize tableTitleArray;
@synthesize tableDataArray;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    //	for(NSMutableDictionary* dic in listContent){
    //		[dic setObject:@"NO" forKey:@"Checked"];
    //	}
	
	for (NSMutableDictionary* dic in listContent) {
		if([[dic objectForKey:@"성명"] rangeOfString:searchText].length != 0){
			[self.filteredListContent addObject:dic];
		}
	}
}

- (NSInteger)getChosung:(NSString *)str
{
    NSInteger code = [str characterAtIndex:0];
    if (code >= 44032 && code <= 55203) {   // 한글영역에 대해서만 처리
        NSInteger UniCode = code - 44032;   // 한글 시작영역을 제거
        NSInteger choIndex = UniCode/21/28; // 초성
        return choIndex;
    }else{
        return 99;
    }
    
	return 99;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        [tableView setBackgroundColor:self.view.backgroundColor];
        [tableView setFrame:CGRectMake(0, 44 + 37, 317, 460 - 44 - 37)];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    return YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	[addressTableView reloadData];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	for(UIView *subView in controller.searchBar.subviews){
		NSLog(@"%@", NSStringFromClass([subView class]) );
		if([subView isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]){
			[(UIBarItem *)subView setTitle:@"완료"];
		}
	}
}

#pragma mark -
#pragma mark tableView delegate
-(CGFloat) tableView : (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
	return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }else{
        return [self.tableDataArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.filteredListContent count];
    }else{
        return [[self.tableDataArray objectAtIndex:section] count];
    }
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBAddressBookCell *cell = (SHBAddressBookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBAddressBookCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBAddressBookCell *)currentObject;
                break;
            }
        }
        cell.selectionStyle	= UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
	NSDictionary *dic = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView){
		isSearchTable = YES;
        dic = [self.filteredListContent objectAtIndex:indexPath.row];
    }else{
		isSearchTable = NO;
        dic = [[self.tableDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.lblData01.text = dic[@"성명"];
	cell.lblData02.text	= dic[@"전화번호"];
	
	return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return tableTitleArray;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [tableTitleArray objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return index;
        }
    }
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView){
        dic = [self.filteredListContent objectAtIndex:indexPath.row];
    }else{
        dic = [[self.tableDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    NSString *phoneNo = dic[@"전화번호"];
    
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    [self.pViewController performSelector:self.pSelector withObject:@{@"TEL" : phoneNo}];
    [self.navigationController fadePopViewController];
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

    self.title = AppInfo.eSignNVBarTitle;
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
	self.listContent = [[NSMutableArray alloc] initWithCapacity:0];

    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        NSArray *peoples = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for(id people in peoples)
        {
            ABMutableMultiValueRef multi =  ABRecordCopyValue((ABRecordRef)people, kABPersonPhoneProperty);
            NSArray* phoneNumbers = (NSArray*)ABMultiValueCopyArrayOfAllValues(multi);
            
            if (phoneNumbers != nil)
            {
                for(NSString *phoneNo in phoneNumbers)
                {
                    phoneNo = [phoneNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if(!([phoneNo isEqualToString:@""] || phoneNo==nil))
                    {
                        if([phoneNo length] > 9 && [phoneNo hasPrefix:@"01"])
                        {
                            NSString *strName = (NSString *)ABRecordCopyCompositeName((ABRecordRef)people);
                            
                            NSString *strSortName1 = (NSString *)ABRecordCopyValue((ABRecordRef)people, kABPersonLastNameProperty);
                            strSortName1 = [strSortName1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSString *strSortName2 = (NSString *)ABRecordCopyValue((ABRecordRef)people, kABPersonFirstNameProperty);
                            strSortName2 = [strSortName2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            if (!strName) {
                                strName = @" ";
                            }
                            
                            if (!strSortName1) {
                                strSortName1 = @" ";
                            }
                            
                            if (!strSortName2) {
                                strSortName2 = @" ";
                            }
                            
                            [self.listContent addObject:@{
                             @"성명" : strName,
                             @"전화번호" : phoneNo,
                             @"정렬" : [NSString stringWithFormat:@"%@%@", strSortName1, strSortName2],
                             }];
                            break;
                        }
                    }
                }
            }
        }
    }
	
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:listContent] autorelease];
    
    NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"정렬" ascending:YES];
    
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
    [sortOrder release];
    
    self.listContent = tempArray;
    
	if([self.listContent count] == 0){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"불러올 주소록이 없습니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}else{
        
        //index array
        NSMutableArray *aToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㄱ
        NSMutableArray *bToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㄴ
        NSMutableArray *cToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㄷ
        NSMutableArray *dToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㄹ
        NSMutableArray *eToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅁ
        NSMutableArray *fToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅂ
        NSMutableArray *gToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅅ
        NSMutableArray *hToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅇ
        NSMutableArray *iToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅈ
        NSMutableArray *jToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅊ
        NSMutableArray *kToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅋ
        NSMutableArray *lToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅌ
        NSMutableArray *mToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅍ
        NSMutableArray *nToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //ㅎ
        NSMutableArray *zToArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];  //else
        
        for(NSDictionary *dic in self.listContent){
            NSString *strFirst = [dic[@"성명"] substringToIndex:1];
            
            switch ([self getChosung:strFirst]) {
                case 0:
                case 1:{  // ㄱ, ㄲ
                    [aToArray addObject:dic];
                }
                    break;
                case 2:{  // ㄴ
                    [bToArray addObject:dic];
                }
                    break;
                case 3:
                case 4:{  // ㄷ, ㄸ
                    [cToArray addObject:dic];
                }
                    break;
                case 5:{  // ㄹ
                    [dToArray addObject:dic];
                }
                    break;
                case 6:{  // ㅁ
                    [eToArray addObject:dic];
                }
                    break;
                case 7:
                case 8:{  // ㅂ, ㅃ
                    [fToArray addObject:dic];
                }
                    break;
                case 9:
                case 10:{  // ㅅ, ㅆ
                    [gToArray addObject:dic];
                }
                    break;
                case 11:{  // ㅇ
                    [hToArray addObject:dic];
                }
                    break;
                case 12:
                case 13:{  // ㅈ, ㅉ
                    [iToArray addObject:dic];
                }
                    break;
                case 14:{  // ㅊ
                    [jToArray addObject:dic];
                }
                    break;
                case 15:{  // ㅋ
                    [kToArray addObject:dic];
                }
                    break;
                case 16:{  // ㅍ
                    [lToArray addObject:dic];
                }
                    break;
                case 17:{  // ㅋ
                    [mToArray addObject:dic];
                }
                    break;
                case 18:{  // ㅎ
                    [nToArray addObject:dic];
                }
                    break;
                default:{  // 기타
                    [zToArray addObject:dic];
                }
                    break;
            }
        }
        
        tableTitleArray = [[NSMutableArray alloc] initWithCapacity:0];
        tableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if(aToArray.count > 0){
            [tableTitleArray addObject:@"ㄱ"];
            [tableDataArray addObject:aToArray];
        }
        if(bToArray.count > 0){
            [tableTitleArray addObject:@"ㄴ"];
            [tableDataArray addObject:bToArray];
        }
        if(cToArray.count > 0){
            [tableTitleArray addObject:@"ㄷ"];
            [tableDataArray addObject:cToArray];
        }
        if(dToArray.count > 0){
            [tableTitleArray addObject:@"ㄹ"];
            [tableDataArray addObject:dToArray];
        }
        if(eToArray.count > 0){
            [tableTitleArray addObject:@"ㅁ"];
            [tableDataArray addObject:eToArray];
        }
        if(fToArray.count > 0){
            [tableTitleArray addObject:@"ㅂ"];
            [tableDataArray addObject:fToArray];
        }
        if(gToArray.count > 0){
            [tableTitleArray addObject:@"ㅅ"];
            [tableDataArray addObject:gToArray];
        }
        if(hToArray.count > 0){
            [tableTitleArray addObject:@"ㅇ"];
            [tableDataArray addObject:hToArray];
        }
        if(iToArray.count > 0){
            [tableTitleArray addObject:@"ㅈ"];
            [tableDataArray addObject:iToArray];
        }
        if(jToArray.count > 0){
            [tableTitleArray addObject:@"ㅊ"];
            [tableDataArray addObject:jToArray];
        }
        if(kToArray.count > 0){
            [tableTitleArray addObject:@"ㅋ"];
            [tableDataArray addObject:kToArray];
        }
        if(lToArray.count > 0){
            [tableTitleArray addObject:@"ㅌ"];
            [tableDataArray addObject:lToArray];
        }
        if(mToArray.count > 0){
            [tableTitleArray addObject:@"ㅍ"];
            [tableDataArray addObject:mToArray];
        }
        if(nToArray.count > 0){
            [tableTitleArray addObject:@"ㅎ"];
            [tableDataArray addObject:nToArray];
        }
        if(zToArray.count > 0){
            [tableTitleArray addObject:@"#"];
            [tableDataArray addObject:zToArray];
        }
        
		self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
		
		self.searchDisplayController.searchContentsController.view.frame = CGRectMake(0.0, 0.0, 3170.0f, 316.0f);
		if (self.savedSearchTerm){
			[self.searchDisplayController			setActive:self.searchWasActive];
			[self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
			[self.searchDisplayController.searchBar setText:savedSearchTerm];
			
			self.savedSearchTerm = nil;
		}
		
		[self.addressTableView reloadData];
		self.addressTableView.scrollEnabled = YES;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    self.searchWasActive		= [self.searchDisplayController isActive];
    self.savedSearchTerm		= [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex	= [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredListContent	= nil;
    self.tableTitleArray        = nil;
    self.tableDataArray         = nil;
}

- (void)dealloc {
	[addressTableView		release];
	[listContent			release];
	[filteredListContent	release];
    [tableTitleArray        release];
    [tableDataArray         release];
    
    [super dealloc];
}

@end
