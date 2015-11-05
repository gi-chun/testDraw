//
//  SHBNoticeStoreListViewCell.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 15..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNoticeStoreListViewCell : UITableViewCell
{
    
    id target;
	SEL openBtnSelector;
    
    int row;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL openBtnSelector;
@property (nonatomic        ) int row;
@property (retain, nonatomic) IBOutlet SHBButton *btn1; // 금리보기
@property (nonatomic, retain) IBOutlet UILabel      *label1;            // 상품명
@property (nonatomic, retain) IBOutlet UILabel      *label2;            // 가입금액
@property (nonatomic, retain) IBOutlet UILabel      *label3;            // 가입기간
@property (nonatomic, retain) IBOutlet UILabel      *label4;            // 회전주기
@property (nonatomic, retain) IBOutlet UILabel      *label5;            // 지급주기
@property (nonatomic, retain) IBOutlet UILabel      *label6;            // 이자지급방법
@property (nonatomic, retain) IBOutlet UILabel      *label7;            // 적용금리
@property (nonatomic, retain) IBOutlet UILabel      *label8;            // 상담직원
@property (nonatomic, retain) IBOutlet UILabel      *label9;            // 직원전화번호

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
