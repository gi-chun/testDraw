//
//  SHBNoticeCuponInputViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 14..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNoticeCuponInputViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"
#import "SHBNoticeCuponEndViewController.h"
#import "SHBNotificationService.h" // 서비스


@interface SHBNoticeCuponInputViewController ()

- (BOOL)selectedCheck:(NSArray *)aArray;

@end

@implementation SHBNoticeCuponInputViewController

#pragma mark -
#pragma mark Button Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    if ([sender tag] == 0) { // 상품 및 금리조회 버튼
        
        // 타입별 예외처리
        if (!self.isTypeB) { // Type A (신한그린애너지, Mint(온라인전용) 정기예금 금리우대 쿠폰)
            
            // 신규금액 입력값 체크
             if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"007"]) {
               
                 if ([self.textField1.text length] == 0 || [[self.textField1.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] < 500000) {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"신규금액은 오십만원 이상입니다."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"확인"
                                                           otherButtonTitles:nil];
                     [alert show];
                     [alert release];
                     return;
                 }
             }
            else
            {
                
                if ([self.textField1.text length] == 0 || [[self.textField1.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] < 3000000) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"신규금액은 삼백만원 이상입니다."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
            }
           
            
            // 계약기간 입력값 체크
            if ([self.textField2.text length] == 0 || !(1 <= [self.textField2.text longLongValue] && [self.textField2.text longLongValue] <= 60)) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"계약기간은 최소 1개월 이상 60개월 이내 월 단위로 입력하셔야 합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
            self.selectCouponDic[@"계약기간"] = self.textField2.text;
        }
        else { // Type B (Tops회전, U드림회전 정기예끔 금리우대 쿠폰)
            
            // 신규금액 입력값 체크
            if ([self.textField1.text length] == 0 || [[self.textField1.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] < 500000) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"신규금액은 오십만원 이상입니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
            if (![self selectedCheck:self.collection1]) {
                
                return;
            }
            
            if (![self selectedCheck:self.collection2]) {
                
                return;
            }
        }
        
        // 선택 정보 저장
        self.selectCouponDic[@"우대금리유효기간"] = self.label1.text;  
        self.selectCouponDic[@"신규금액"] = self.textField1.text;
        
        // 선택 정보 확인용 - 삭제할것!!
        NSLog(@"우대금리유효기간 : %@", self.selectCouponDic[@"우대금리유효기간"]);
        NSLog(@"신규금액 : %@", self.selectCouponDic[@"신규금액"]);
        
        if (!self.isTypeB) {
            
            // 선택 정보 확인용 - 삭제할것!!
            NSLog(@"계약기간 : %@", self.selectCouponDic[@"계약기간"]);
        }
        else {
            
            // 선택 정보 확인용 - 삭제할것!!
            NSLog(@"계약기간_라디오 : %@", self.selectCouponDic[@"계약기간_라디오"]);
            NSLog(@"회전주기_라디오 : %@", self.selectCouponDic[@"회전주기_라디오"]);
        }
        
        //return; // 작업중 - 전문요청 안함 - 삭제할것!!
        
        // 전문 요청
        NSString *account;
        self.marrAccounts = [self outAccountList];	// 출금계좌 배열 가져오기
        
        
        if ([self.marrAccounts count] > 0) {
            self.selectedAccount = [self.marrAccounts objectAtIndex:0];
            account = [[self.selectedAccount objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""];	// 첫번째에 있는 계좌번호를 미리 박아둠
            NSLog(@"account %@",[self.selectedAccount objectForKey:@"출금계좌번호"]);
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"출금계좌정보가 없습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            [self.navigationController fadePopViewController];
            return;
        }
        
        if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"003"] ||
            [self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"004"] )    //민트
        {
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"고객번호" : AppInfo.customerNo,
                                   //@"실명번호" : [AppInfo getPersonalPK],
                                   @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                   @"상품코드" : @"200009206",
                                   @"금액" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                   @"합계" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                   @"계약기간_개월" : self.selectCouponDic[@"계약기간"],
                                   @"이자지급방법" : @"3",
                                   @"지급주기구분" : @"0",
                                   @"지급주기" : @"0",
                                   @"회전주기" : @"0",
                                   @"연동지급계좌은행구분" : @"1",
                                   @"연동지급계좌번호" : account,
                                   @"신규전조회" : @"1",
                                   @"비대면신규이율조회" : @"1",
                                   }];
            
                     
            
            [self.selectCouponDic setObject:@"3" forKey:@"이자지급방법"];
            [self.selectCouponDic setObject:@"만기일시지급식" forKey:@"이자지급방법문구"];
            [self.selectCouponDic setObject:@"0" forKey:@"이자지급주기"];
            [self.selectCouponDic setObject:@"0" forKey:@"회전주기"];
    


            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_D5022
                                                                 viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
        }
        
        else if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"007"])  //  s드림 정기예금
        {
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         //@"실명번호" : [AppInfo getPersonalPK],
                                                                         @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                                                         @"상품코드" : @"200013606",
                                                                         @"금액" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                                                         @"합계" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                                                         @"계약기간_개월" : self.selectCouponDic[@"계약기간"],
                                                                         @"이자지급방법" : @"3",
                                                                         @"지급주기구분" : @"0",
                                                                         @"지급주기" : @"0",
                                                                         @"회전주기" : @"0",
                                                                         @"연동지급계좌은행구분" : @"1",
                                                                         @"연동지급계좌번호" : account,
                                                                         @"신규전조회" : @"1",
                                                                         @"비대면신규이율조회" : @"1",
                                                                         }];
            
            
            
            [self.selectCouponDic setObject:@"3" forKey:@"이자지급방법"];
            [self.selectCouponDic setObject:@"만기일시지급식" forKey:@"이자지급방법문구"];
            [self.selectCouponDic setObject:@"0" forKey:@"이자지급주기"];
            [self.selectCouponDic setObject:@"0" forKey:@"회전주기"];
            
            
            
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_D5022
                                                                 viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
        }
        else
        {
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{   //회전, tops
                                   @"고객번호" : AppInfo.customerNo,
                                   //@"실명번호" : [AppInfo getPersonalPK],
                                   @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                   @"상품코드" : @"200013403",
                                   @"금액" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                   @"합계" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                   @"계약기간_개월" : self.selectCouponDic[@"계약기간_라디오"],
                                   @"이자지급방법" : @"2",
                                   @"지급주기구분" : @"4",
                                   @"지급주기" : self.selectCouponDic[@"회전주기_라디오"],
                                   @"회전주기" : self.selectCouponDic[@"회전주기_라디오"],
                                   @"연동지급계좌은행구분" : @"1",
                                   @"연동지급계좌번호" : account,
                                   @"신규전조회" : @"1",
                                   @"비대면신규이율조회" : @"1",
                                   }];
            
            
            [self.selectCouponDic setObject:@"2" forKey:@"이자지급방법"];
            [self.selectCouponDic setObject:@"만기일시복리식" forKey:@"이자지급방법문구"];
            [self.selectCouponDic setObject:self.selectCouponDic[@"회전주기_라디오"] forKey:@"이자지급주기"];
            [self.selectCouponDic setObject:self.selectCouponDic[@"회전주기_라디오"] forKey:@"회전주기"];
            [self.selectCouponDic setObject:@"U드림 회전정기예금(온라인특별금리우대)" forKey:@"상품명"];

            
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_D5022
                                                                 viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
        
        
    }
    else {
        
        NSArray *tempArray = nil;
        
        if (([sender tag] / 10) < 2) {
            
            tempArray = self.collection1; // 계약기간 라디오 버튼
        }
        else {
            
            tempArray = self.collection2; // 회전주기 라디오 버튼
        }
        
        for (UIButton *tempButton in tempArray) {
            
            tempButton.selected = NO;
        }
        
        UIButton *tempButton = (UIButton *)sender;
        tempButton.selected = YES;
    }
}

- (BOOL)selectedCheck:(NSArray *)aArray
{
    BOOL isSelected = NO;
    
    for (UIButton *tempButton in aArray) {
        
        if (tempButton.selected) {
            
            isSelected = YES;
            
            if (aArray == self.collection1) {
                
                NSString *stringTemp = nil;
                
                if (tempButton.tag == 10) {
                    
                    stringTemp = @"12"; // 1년
                }
                else if (tempButton.tag == 11) {
                    
                    stringTemp = @"24"; // 2년
                }
                else if (tempButton.tag == 12) {
                    
                    stringTemp = @"36"; // 3년
                }
                
                self.selectCouponDic[@"계약기간_라디오"] = stringTemp;
            }
            else {
                
                NSString *stringTemp = nil;
                
                if (tempButton.tag == 20) {
                    
                    stringTemp = @"1"; // 1개월
                }
                else if (tempButton.tag == 21) {
                    
                    stringTemp = @"3"; // 3개월
                }
                else if (tempButton.tag == 22) {
                    
                    stringTemp = @"6"; // 6개월
                }
                
                self.selectCouponDic[@"회전주기_라디오"] = stringTemp;
            }
        }
    }
    
    if (!isSelected) {
        
        if (aArray == self.collection1) {
            
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"계약기간을 선택하여 주세요."];
        }
        else {
            
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"회전주기를 선택하여 주세요."];
        }
        
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == self.textField1) {
        
        // 신규금액 - 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 ) {
			return NO;
		}
        
		if (dataLength + dataLength2 > 14) {
			return NO;
		}
		else {
            
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]]) {
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
				return NO;
			}
            else {
                
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
				return NO;
			}
		}
	}
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.textField1) {
        
        self.label2.text = [NSString stringWithFormat:@"%@ 원", [SHBUtility changeNumberStringToKoreaAmountString:textField.text]];
    }
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectCouponDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectCouponDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    self.contentsView = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.label1 = nil;
    self.textField1 = nil;
    self.label2 = nil;
    self.textField2 = nil;
    self.collection1 = nil;
    self.collection2 = nil;
    self.selectCouponDic = nil;
    self.marrAccounts = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark View Life Cycle

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 네비게이션 타이틀 및 서브 타이틀 정보 초기화
    self.title = @"쿠폰조회";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"우대금리 조회하기" maxStep:0 focusStepNumber:0] autorelease]];
    
    // 우대금리유효기간 정보 초기화
    self.label1.text = self.selectCouponDic[@"우대금리유효기간"];
    
    // Type에 따른 서브 뷰 초기화
    if (!self.isTypeB) { // Type A (신한그린애너지, Mint(온라인전용) 정기예금 금리우대 쿠폰)
        
        CGRect tempRect = self.view1.frame;
        tempRect.origin.y = 187.0;
        self.view1.frame = tempRect;
        [self.contentsView addSubview:self.view1];
        
        tempRect = self.view3.frame;
        tempRect.origin.y = self.view1.frame.origin.y + self.view1.frame.size.height;
        self.view3.frame = tempRect;
        [self.contentsView addSubview:self.view3];
        
        startTextFieldTag = 100;
        endTextFieldTag = 101;
        if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"007"]) {
           self.textField1.placeholder = @"오십만원 이상";
        }
        else{
            self.textField1.placeholder = @"삼백만원 이상";
        }
    }
    else { // Type B (Tops회전, U드림회전 정기예끔 금리우대 쿠폰)
        
        CGRect tempRect = self.view2.frame;
        tempRect.origin.y = 187.0;
        self.view2.frame = tempRect;
        [self.contentsView addSubview:self.view2];
        
        tempRect = self.view3.frame;
        tempRect.origin.y = self.view2.frame.origin.y + self.view2.frame.size.height;
        self.view3.frame = tempRect;
        [self.contentsView addSubview:self.view3];
        
        startTextFieldTag = 100;
        endTextFieldTag = 100;
        
        self.textField1.placeholder = @"오십만원 이상";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
       
    if ([AppInfo.serviceCode isEqualToString:@"D5022"])
    {

      //  nameCode_5022 = @"200009206";
      //   name_5022 = @"민트";
       nameCode_5022 = [aDataSet objectForKey:@"상품코드"];
        
        if ([nameCode_5022 isEqualToString:@"200009206"])
        {
            name_5022 = @"Mint(온라인전용) 정기예금";
        }
        
        else if ([nameCode_5022 isEqualToString:@"200009207"])
        {
            name_5022 = @"Mint 정기예금(온라인 특별금리우대-I)";
        }
        
        else if ([nameCode_5022 isEqualToString:@"200013608"])
        {
            name_5022 = @"Mint 정기예금(온라인 특별금리우대-II)";
        }
        
        else if ([nameCode_5022 isEqualToString:@"200013606"])
        {
            name_5022 = @"S드림 정기예금";
        }
        
        else if ([nameCode_5022 isEqualToString:@"200013607"])
        {
            name_5022 = @"S드림 정기예금(온라인 특별금리우대-I)";
        }

        else if ([nameCode_5022 isEqualToString:@"200013608"])
        {
            name_5022 = @"S드림 정기예금(온라인 특별금리우대-II)";
        }
        else if ([nameCode_5022 isEqualToString:@"200013403"])
        {
            name_5022 = @"U드림 회전정기예금";
        }
        
        else if ([nameCode_5022 isEqualToString:@"200013410"])
        {
            name_5022 = @"U드림 회전정기예금(온라인 특별금리우대-I)";
        }
        
        
        else if ([nameCode_5022 isEqualToString:@"200013411"])
        {
            name_5022 = @"U드림 회전정기예금(온라인 특별금리우대-II)";
        }
        

                
        sumpercent_1 = [[NSString alloc] initWithFormat:@"%@",
                        [self addComma:[aDataSet [@"대고객이율"] doubleValue] isPoint:YES]];  //적용금
       
        NSLog(@"sumpercent_1 %@",sumpercent_1);

        if (!self.isTypeB)
        {

            month = [[NSString alloc] initWithFormat:@"%@",self.selectCouponDic[@"계약기간"]];
        }
        else
        {
            
           month = [[NSString alloc] initWithFormat:@"%@",self.selectCouponDic[@"계약기간_라디오"]];
        }
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"기준일자" : AppInfo.tran_Date,
                                   @"계좌관리점번호" : @"9999",
                                   @"은행구분" : @"1",
                                   @"고객번호" : AppInfo.customerNo,
                                   @"계약기간월수" : month,
                                   @"신규금액" : [self.selectCouponDic[@"신규금액"]stringByReplacingOccurrencesOfString:@"," withString:@""],
                                   }];
        
            if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"003"])  //그린애
            {
                name_5024 =@"신한 그린愛너지 정기예금";
                nameCode_5024 = @"200009301";
                [dataSet insertObject:nameCode_5024 forKey:@"상품CODE" atIndex:0];
                [dataSet insertObject:@"3" forKey:@"수신이자지급방법" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기CODE" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"금리회전기간월수" atIndex:0];
                

            }
            
            else if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"004"]) //민트
            {
                name_5024 =@"Mint(민트) 정기예금";
                nameCode_5024 = @"200009201";
                [dataSet insertObject:nameCode_5024 forKey:@"상품CODE" atIndex:0];
                [dataSet insertObject:@"3" forKey:@"수신이자지급방법" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기CODE" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"금리회전기간월수" atIndex:0];
            }
        
            else if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"005"]) //TOPS회전
            {
                name_5024 =@"TOPS 회전 정기예금";
                nameCode_5024 = @"200003401";
                [dataSet insertObject:nameCode_5024 forKey:@"상품CODE" atIndex:0];
                [dataSet insertObject:@"2" forKey:@"수신이자지급방법" atIndex:0];
                [dataSet insertObject:self.selectCouponDic[@"회전주기_라디오"] forKey:@"이자지급주기" atIndex:0];
                [dataSet insertObject:@"4" forKey:@"이자지급주기CODE" atIndex:0];
                [dataSet insertObject:self.selectCouponDic[@"회전주기_라디오"] forKey:@"금리회전기간월수" atIndex:0];

            }
        
        
            else if ([self.selectCouponDic[@"마케팅실행채널ID"]isEqualToString:@"007"]) //s드림 정기예금 14.6.23 추가
            {
                name_5024 =@"S드림 정기예금";
                nameCode_5024 = @"200013601";
                [dataSet insertObject:nameCode_5024 forKey:@"상품CODE" atIndex:0];
                [dataSet insertObject:@"3" forKey:@"수신이자지급방법" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"이자지급주기CODE" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"금리회전기간월수" atIndex:0];
            }
        
            self.service = nil;
            self.service = [[[SHBNotificationService alloc] initWithServiceCode:COUPON_D5024
                                                                 viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
        }
    
    
    else if ([AppInfo.serviceCode isEqualToString:@"D5024"])
    {

        sumpercent_2 = [[NSString alloc] initWithFormat:@"%@",
                        [self addComma: [aDataSet[@"적용금리"] doubleValue] isPoint:YES]];  //적용금리
               
        float f_sumpercent_1 = [sumpercent_1 floatValue];
        float f_sumpercent_2 = [sumpercent_2 floatValue];
        
        if(f_sumpercent_2  >= f_sumpercent_1 ) //5024
        {
            [self.selectCouponDic setObject:sumpercent_2 forKey:@"적용금리"];
            [self.selectCouponDic setObject:name_5024 forKey:@"상품명"];
            [self.selectCouponDic setObject:nameCode_5024 forKey:@"상품코드"];
 
        }
        
        else 
        {
            [self.selectCouponDic setObject:sumpercent_1 forKey:@"적용금리"];
            [self.selectCouponDic setObject:name_5022 forKey:@"상품명"];
            [self.selectCouponDic setObject:nameCode_5022 forKey:@"상품코드"];

        }
        
        NSLog(@"sumpercent_5022 %@",sumpercent_1);
        NSLog(@"sumpercent_5024 %@",sumpercent_2);
       NSLog(@"name_5024 %@",name_5024);
        NSLog(@"nameCode_5024 %@",nameCode_5024);
        NSLog(@"name_5022 %@",name_5022);
        NSLog(@"nameCode_5022 %@",nameCode_5022);
        

        [self.selectCouponDic setObject:self.selectCouponDic[@"신규금액"] forKey:@"신규금액"];
        [self.selectCouponDic setObject:month forKey:@"계약기간"];
        
        
       
        if ( self.selectCouponDic[@"권유직원번호"] != nil ||
            ![self.selectCouponDic[@"권유직원번호"] isEqualToString:@""])
        {
            [self.selectCouponDic setObject:self.selectCouponDic[@"권유직원번호"] forKey:@"승인신청행원번호"];
        }
        
        
        //다음 뷰컨트롤러로 이동
        SHBNoticeCuponEndViewController *viewController = [[[SHBNoticeCuponEndViewController alloc] initWithNibName:@"SHBNoticeCuponEndViewController" bundle:nil] autorelease];
        if (!self.isTypeB)
        {
            
             viewController.isTypeB = NO;  //민트, 그린애,민트(온리인)
        }
        else
        {
            
            viewController.isTypeB = YES;  //(TOP회전정기, U드림 회전정기예금
        }
        
        viewController.selectCouponDic = self.selectCouponDic;
        viewController.needsCert = YES;
        
        [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:YES];
        
        
    }

    return YES;
}

#pragma mark -

- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.3lf", number];  // 소수점 3자리 까지 표시
    }
    
    
    
    return string;
}

@end
