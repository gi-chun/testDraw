//
//  SHBSearchZipViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSearchZipViewController.h"
#import "SHBCommonService.h"

@interface SHBSearchZipViewController ()

@end

@implementation SHBSearchZipViewController

@synthesize rtnViewController;

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
	
	[oldAddrTextField setAccDelegate:self];
	[newAddr1TextField setAccDelegate:self];
	[newAddr2TextField setAccDelegate:self];
	
	isOldAddress = YES;
	postDataArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
	[postDataArray release];
	[super dealloc];
}

#pragma mark - Methods
- (void)executeWithTitle:(NSString*)aTitle ReturnViewController:(UIViewController*)viewController{
	self.title = aTitle;
	rtnViewController = viewController;
}

- (void)reloadConditionForSearch{
	oldAddrTextField.text = @"";
	newAddr1TextField.text = @"";
	newAddr2TextField.text = @"";
	
	if (isOldAddress){
		oldAddrTextField.hidden = NO;
		newAddr1TextField.hidden = YES;
		newAddr2TextField.hidden = YES;
		
	}else{
		oldAddrTextField.hidden = YES;
		newAddr1TextField.hidden = NO;
		newAddr2TextField.hidden = NO;
		
	}
}

- (BOOL)checkNewAddress2:(NSString *)str{
	char *chars;
	int len;
	int i;
	//BOOL containAlphabet;
	BOOL containNumeric;
	
	if (str == nil) return NO;
	
	if ([str length] == 0 && [str isEqualToString:@""]) return NO;
	
	chars = (char*)[str UTF8String];
	len = strlen(chars);
	
	containNumeric = NO;
	
	for (i = 0; i < len; i++){
		if (!((chars[i] >= '0' && chars[i] <= '9')||(chars[i] == '-'))) {
			return NO;
		}
		
		if (chars[i] >= '0' && chars[i] <= '9')
		{
			containNumeric = YES;
			continue;
		}
		if (chars[i] == '-')
		{
			containNumeric = YES;
			continue;
		}
		
	}
	
	return containNumeric;
	
}


- (BOOL)checkCompulsory{
	if (isOldAddress){
		NSString *convertText = [[oldAddrTextField.text componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet characterSetWithCharactersInString:@"/\\:;()|@.•,!""?'[]{}#%^*=+~₩<>-&＄£¥_\""] invertedSet]] componentsJoinedByString:@""];
		
        
        
		if (oldAddrTextField.text == nil || [oldAddrTextField.text length] < 2){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"최소 두글자 이상 입력하시기 바랍니다."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			return NO;
		}
		
		if(convertText.length != 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"입력값이 유효하지 않습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }
        
	}else{
		NSString *convertText = [[newAddr1TextField.text componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet characterSetWithCharactersInString:@"/\\:;()|@.•,!""?'[]{}#%^*=+~₩<>-&＄£¥_\""] invertedSet]] componentsJoinedByString:@""];
		
        if (newAddr1TextField.text == nil || [newAddr1TextField.text length] < 1)
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"도로명(~로,~길)+건물번호를입력하세요.검색방법:예)서울시 강남구 역삼로 251 역삼로(도로명) 251(건물번호)"
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			return NO;
		}
        
		if (newAddr1TextField.text == nil || [newAddr1TextField.text length] < 2){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"최소 두글자 이상 입력하시기 바랍니다."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			return NO;
		}
        
        if ([newAddr1TextField.text length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"도로명(~로,~길)+건물번호를 입력하세요. 검색방법: 예) 서울시 강남구 역삼로 251 역삼로(도로명) 251(건물번호)"
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			return NO;
        }
		
		if(convertText.length != 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"입력값이 유효하지 않습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }
		
        if([newAddr2TextField.text length] > 0){
		   if (![self checkNewAddress2:newAddr2TextField.text]){
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"건물번호는 숫자만 입력하세요."
															   delegate:self
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				
				[alert show];
				[alert release];
				return NO;
		   }
        }else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"건물번호를 입력하세요."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			return NO;
		}
        
	}
	
	return YES;
}

- (void)requestZipCode{
	[postDataArray removeAllObjects];
	[listTableView reloadData];
	
	if (isOldAddress){
		SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
									@{
									TASK_NAME_KEY : @"sfg.rib.task.common.ZipTask",
									TASK_ACTION_KEY : @"getZipList",
									@"DONG_NM" : oldAddrTextField.text,
									}] autorelease];
        self.service = nil;
		self.service = [[[SHBCommonService alloc] initWithServiceId:OLD_ZIP_CODE viewController:self] autorelease];
		self.service.previousData = forwardData;
		[self.service start];
	}else{
		NSRange partRange = [newAddr2TextField.text rangeOfString:@"-" options:NSRegularExpressionSearch];  //"-"가 포함되어있는지 여부
		NSString *strAddNo1;
		NSString *strAddNo2;
		NSArray *addNoArray = [newAddr2TextField.text componentsSeparatedByString:@"-"];
        
		if(partRange.length == 0){
			strAddNo1 = [addNoArray objectAtIndex:0];	//본번
			strAddNo2 = @"";							//부번
		}else{
			strAddNo1 = [addNoArray objectAtIndex:0];	//본번
			strAddNo2 = [addNoArray objectAtIndex:1];	//부번
		}
        
		SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								   @{
								   @"검색도로명" : newAddr1TextField.text,
									@"검색건물본번" : strAddNo1,
									@"검색건물부번" : strAddNo2,
									@"검색구분" : @"4",
									}] autorelease];
		
		self.service = [[[SHBCommonService alloc] initWithServiceId:NEW_ZIP_CODE viewController:self] autorelease];
		self.service.previousData = forwardData;
		[self.service start];
	}
}

#pragma mark - IBActions
- (IBAction)buttonPressed:(UIButton*)sender{
	[oldAddrTextField resignFirstResponder];
	[newAddr1TextField resignFirstResponder];
	[newAddr2TextField resignFirstResponder];
	
	if (sender == oldButton){
		oldButton.enabled = YES;
		newButton.enabled = YES;
		sender.enabled = NO;
		isOldAddress = YES;
		[self reloadConditionForSearch];
	}else if (sender == newButton){
		oldButton.enabled = YES;
		newButton.enabled = YES;
		sender.enabled = NO;
		isOldAddress = NO;
		[self reloadConditionForSearch];
	}
	else{
		if (![self checkCompulsory]) return;
		
		[self requestZipCode];
	}
}

#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if ([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2821"]){
		if ([[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
			self.dataList = [aDataSet arrayWithForKey:@"주소내역.vector.data"];
			NSLog(@"self.dataList : [%@]",self.dataList);
			
			for (int i = 0; i < [self.dataList count]; i++) {
				NSString *postNo = [[self.dataList objectAtIndex:i] objectForKey:@"우편번호"];
				NSMutableDictionary	*mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
				[mDic setObject:[postNo substringToIndex:3] forKey:@"POST1"];
				[mDic setObject:[postNo substringFromIndex:3] forKey:@"POST2"];
				[mDic setObject:[[self.dataList objectAtIndex:i] objectForKey:@"도로명주소"] forKey:@"ADDR1"];
				[mDic setObject:@"" forKey:@"ADDR2"];
                [mDic setObject:@"도로명주소" forKey:@"주소종류"];
				[postDataArray addObject:mDic];
				[mDic release];
			}
			
			if (![postDataArray count]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"검색결과가 존재하지 않습니다."
															   delegate:self
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				
				[alert show];
				[alert release];
			}
			
			[listTableView reloadData];
		}
		
	}else{
		self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
        
		for (int i = 0; i < [self.dataList count]; i++) {
			NSDictionary *nDic = [self.dataList objectAtIndex:i];
			NSString *postNo = [nDic objectForKey:@"POSTNO"];
			NSMutableDictionary	*mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            if ([postNo length] == 6) {
                [mDic setObject:[postNo substringToIndex:3] forKey:@"POST1"];
                [mDic setObject:[postNo substringFromIndex:3] forKey:@"POST2"];
            }
            else {
                [mDic setObject:@"" forKey:@"POST1"];
                [mDic setObject:@"" forKey:@"POST2"];
            }
			[mDic setObject:[SHBUtility nilToString:[nDic objectForKey:@"ADR"]] forKey:@"ADDR1"];
			[mDic setObject:[SHBUtility nilToString:[nDic objectForKey:@"DONG_LT_ADR"]] forKey:@"ADDR2"];
            [mDic setObject:@"지번주소" forKey:@"주소종류"];
			[postDataArray addObject:mDic];
			[mDic release];
		}
		
		if (![postDataArray count]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"검색결과가 존재하지 않습니다."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];

			[alert show];
			[alert release];
		}
		
		[listTableView reloadData];
	}
	
	return NO;
}


#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didPrevButtonTouch{
	[oldAddrTextField resignFirstResponder];
	[newAddr1TextField resignFirstResponder];
	[newAddr2TextField resignFirstResponder];
	
	if (indexCurrentTextField == 3){
		[newAddr2TextField focusSetWithLoss:NO];
		[newAddr1TextField becomeFirstResponder];
	}
}
- (void)didNextButtonTouch{
	[oldAddrTextField resignFirstResponder];
	[newAddr1TextField resignFirstResponder];
	[newAddr2TextField resignFirstResponder];
	
	if (indexCurrentTextField == 2){
		[newAddr1TextField focusSetWithLoss:NO];
		[newAddr2TextField becomeFirstResponder];
	}
}
- (void)didCompleteButtonTouch{
	if (indexCurrentTextField == 1){
		[oldAddrTextField focusSetWithLoss:NO];
		[oldAddrTextField resignFirstResponder];
	}else if (indexCurrentTextField == 2){
		[newAddr1TextField focusSetWithLoss:NO];
		[newAddr1TextField resignFirstResponder];
	}else if (indexCurrentTextField == 3){
		[newAddr1TextField focusSetWithLoss:NO];
		[newAddr2TextField resignFirstResponder];
	}
	
};	// 완료버튼

#pragma mark - Delegate : UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	indexCurrentTextField = textField.tag;
	
	[(SHBTextField*)textField focusSetWithLoss:YES];
	if (indexCurrentTextField == 1){
		[(SHBTextField*)textField enableAccButtons:NO Next:NO];
	}else if (indexCurrentTextField == 2){
		[(SHBTextField*)textField enableAccButtons:NO Next:YES];
	}else if (indexCurrentTextField == 3){
		[(SHBTextField*)textField enableAccButtons:YES Next:NO];
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[(SHBTextField*)textField focusSetWithLoss:NO];
	[(SHBTextField*)textField resignFirstResponder];
    
    [self buttonPressed:nil];
	
	return YES;
}


#pragma mark - Tableview datasource & delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [postDataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        NSArray *cellArray = [[NSBundle mainBundle]loadNibNamed:@"SHBSearchZipViewControllerCell" owner:self options:nil];
		
		//xib파일의 객체중에 #번째 객체를 셋팅
		cell = [cellArray objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
		
    }
	
    int row = [indexPath row];
	UILabel		*addrLabel = (UILabel *)[cell viewWithTag:10];
	
	NSDictionary *nDic = [postDataArray objectAtIndex:row];
	addrLabel.text = [NSString stringWithFormat:@"%@-%@ %@ %@",[nDic objectForKey:@"POST1"],[nDic objectForKey:@"POST2"],[nDic objectForKey:@"ADDR1"],[nDic objectForKey:@"ADDR2"]];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[(SHBBaseViewController*)rtnViewController viewControllerDidSelectDataWithDic:[postDataArray objectAtIndex:indexPath.row]];
	
	[self.navigationController fadePopViewController];
    
}


@end
