//
//  SHBAskStaffViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAskStaffViewController.h"
#import "SHBAskStaffService.h"

@interface SHBAskStaffViewController ()

@end

@implementation SHBAskStaffViewController

@synthesize rtnViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
	[rtnViewController release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[searchTextField setAccDelegate:self];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)executeWithTitle:(NSString*)aTitle ReturnViewController:(UIViewController*)viewController{
	self.title = aTitle;
	rtnViewController = viewController;
}

- (void)requestStaffList{
	NSString *strGubun = nil;
	if (!staffButton.enabled) {
		strGubun = @"1";
	}else{
		strGubun = @"2";
	}
	
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
							   @{
							   @"검색어" : searchTextField.text,
							   @"조회구분" : strGubun,
							   }] autorelease];
	self.service = nil;
	self.service = [[[SHBAskStaffService alloc] initWithServiceId:ASK_STAFF_QRY viewController:self] autorelease];
	self.service.previousData = forwardData;
	[self.service start];
}

#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton *)sender{
	[searchTextField resignFirstResponder];
	if (sender == staffButton || sender == bankButton){
		[staffButton setEnabled:TRUE];
		[bankButton setEnabled:TRUE];
		[sender setEnabled:FALSE];
	}else{
		//조회 버튼
		if ([searchTextField.text length] > 1) {
			[self requestStaffList];
			
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"최소 두 글자 이상 입력하여 주십시오."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			
		}
	}
}

#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"E1826"]){
		if ([[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
			self.dataList = [aDataSet arrayWithForKey:@"조회내역"];
			if (![self.dataList count]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"검색결과가 존재하지 않습니다."
															   delegate:self
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				
				[alert show];
				[alert release];
				
			}
			
			NSLog(@"dataList : [%@]",self.dataList);
			[listTable reloadData];
		}
		
	}
	
	return NO;
}


#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didCompleteButtonTouch{
	[searchTextField focusSetWithLoss:NO];
	[searchTextField resignFirstResponder];
	
};	// 완료버튼

#pragma mark - Delegate : UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int txtLen = [textField.text length];
	
	if (txtLen >= 10 && range.length == 0) return NO;
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[(SHBTextField*)textField focusSetWithLoss:YES];
	[(SHBTextField*)textField enableAccButtons:NO Next:NO];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[(SHBTextField*)textField focusSetWithLoss:NO];
	[(SHBTextField*)textField resignFirstResponder];
	[self requestStaffList];
	
	return YES;
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"SHBAskStaffViewControllerCell" owner:self options:nil];
		
		//xib파일의 객체중에 #번째 객체를 셋팅
		cell = [cellArray objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
	
    int row = [indexPath row];
	UILabel		*deptLabel = (UILabel *)[cell viewWithTag:1];
	UILabel		*nameLabel = (UILabel *)[cell viewWithTag:2];
	
	[deptLabel setText:[[self.dataList objectAtIndex:row] objectForKey:@"지점명"]];
	[nameLabel setText:[[self.dataList objectAtIndex:row] objectForKey:@"성명"]];
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[(SHBBaseViewController*)rtnViewController viewControllerDidSelectDataWithDic:[self.dataList objectAtIndex:indexPath.row]];
	
	[self.navigationController fadePopViewController];
    
}

@end
