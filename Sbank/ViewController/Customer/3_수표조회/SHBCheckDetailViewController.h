//
//  SHBCheckDetailViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 01. 17..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCheckDetailViewController : SHBBaseViewController
{
    IBOutlet UIView             *realView;      // 실제 view가 붙는 view
    
    IBOutlet UILabel            *labelSubTitle; // 서브 타이틀 라벨
    
    IBOutlet UIView             *view1;         // 당행 정상수표
    IBOutlet UILabel            *label1_1;          // 수표번호
    IBOutlet UILabel            *label1_2;          // 수표금액
    IBOutlet UILabel            *label1_3;          // 발행점 지로코드
    IBOutlet UILabel            *label1_4;          // 발행일
    IBOutlet UILabel            *label1_5;          // 발행점
    
    IBOutlet UIView             *view2;         // 당행 사고수표
    IBOutlet UILabel            *label2_1;          // 수표번호
    IBOutlet UILabel            *label2_2;          // 수표금액
    IBOutlet UILabel            *label2_3;          // 발행점 지로코드
    IBOutlet UILabel            *label2_4;          // 발행일
    IBOutlet UILabel            *label2_5;          // 발행점
    IBOutlet UILabel            *label2_6;          // 사고등록일자
    IBOutlet UILabel            *label2_7;          // 사고사유코드
    
    IBOutlet UIView             *view3;         // 당행 지급된수표
    IBOutlet UILabel            *label3_1;          // 수표번호
    IBOutlet UILabel            *label3_2;          // 수표금액
    IBOutlet UILabel            *label3_3;          // 발행점 지로코드
    IBOutlet UILabel            *label3_4;          // 발행일
    IBOutlet UILabel            *label3_5;          // 발행점
    
    IBOutlet UIView             *view4;         // 당행 사용불가수표
    IBOutlet UILabel            *label4_1;          // 수표번호
    IBOutlet UILabel            *label4_2;          // 수표금액
    IBOutlet UILabel            *label4_3;          // 발행점 지로코드
    IBOutlet UILabel            *label4_4;          // 발행일
    IBOutlet UILabel            *label4_5;          // 발행점
    
    IBOutlet UIView             *view5;             // 예외 view
    IBOutlet UILabel            *labelContents;     // 설명 label
    IBOutlet UILabel            *label5_1;          // 수표번호
    IBOutlet UILabel            *label5_2;          // 수표금액
    IBOutlet UILabel            *label5_3;          // 발행점 지로코드
    IBOutlet UILabel            *label5_4;          // 발행일
    IBOutlet UILabel            *label5_5;          // 발행점
    IBOutlet UILabel            *label5_6;          // 사고등록일자
    IBOutlet UILabel            *label5_7;          // 사고사유코드
    
    IBOutlet UIView             *view6;     // 타행 정상 view
    IBOutlet UILabel            *label6_0;          // 발행은행
    IBOutlet UILabel            *label6_1;          // 수표번호
    IBOutlet UILabel            *label6_2;          // 수표금액
    IBOutlet UILabel            *label6_3;          // 발행일
    
    IBOutlet UIView             *view7;     // 타행 정상 아닐시 view
    IBOutlet UILabel            *label7_0;          // 발행은행
    IBOutlet UILabel            *label7_1;          // 수표번호
    IBOutlet UILabel            *label7_2;          // 수표금액
    IBOutlet UILabel            *label7_3;          // 발행일
    
    IBOutlet UILabel            *labelContents2;    // 타행 설명 label
    
    
}

@property (nonatomic, retain) NSString *strMenuTitle;           // 이전뷰에서 넘어오는 title


@end
