//
//  SHBNewProductReInputNotiPopupView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductReInputNotiPopupView.h"

@implementation SHBNewProductReInputNotiPopupView

- (void)dealloc
{
	[_marrNotiOptionBtns release];
	[super dealloc];
}

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height
{
    self = [super initWithTitle:aTitle SubViewHeight:height - 8];
    if (self) {
#if 1
		UIView *bodyView = [[[UIView alloc]initWithFrame:CGRectMake(28, 42, 264, height)]autorelease];
		[bodyView setBackgroundColor:RGB(224, 227, 232)];
		[self.mainView addSubview:bodyView];
		[bodyView setFrame:CGRectMake(0, 0, width(self.mainView), height(self.mainView))];
#else
		UIView *bodyView = [[[UIView alloc]initWithFrame:CGRectMake(28, 42, 264, height)]autorelease];
		[bodyView setBackgroundColor:RGB(224, 227, 232)];
		[self insertSubview:bodyView atIndex:1];
		
		[self.mainView setHidden:YES];
		
		Debug(@"self.subviews : %@", self.subviews);
		if ([self.subviews count] == 3) {
            if ([[self.subviews objectAtIndex:2] isKindOfClass:[UIView class]]) {
                UIView *view = (UIView *)[self.subviews objectAtIndex:2];
                [view setUserInteractionEnabled:NO];
                
                [bodyView setFrame:CGRectMake(28, view.frame.origin.y + 38, 264, height)];
            }
        }
#endif
		
		CGFloat fCurrHeight = 10;
		
		self.marrNotiOptionBtns = [NSMutableArray array];
		for (int nIdx = 0; nIdx < 3; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			
			[bodyView addSubview:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(44, 44, 44)];
			[lblRadio setFont:[UIFont systemFontOfSize:14]];
			[bodyView addSubview:lblRadio];
			
			[btnRadio setFrame:CGRectMake(16, fCurrHeight, 21, 21)];
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 170, 21)];
			
			if (nIdx == 0) {
				[lblRadio setText:@"원하지않음"];
				[btnRadio setDataKey:@"0"];
				[btnRadio setSelected:YES];
			}
			else if (nIdx == 1) {
				[lblRadio setText:@"SMS 신청"];
				[btnRadio setDataKey:@"1"];
			}
			else if (nIdx == 2) {
				[lblRadio setText:@"E-mail 신청"];
				[btnRadio setDataKey:@"3"];
			}
			
			[self.marrNotiOptionBtns addObject:btnRadio];
			
			fCurrHeight += 21+10;
		}
		
		UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
		UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[bodyView addSubview:ivInfoBox];
		
		CGFloat fHeight = 10;
		
		NSMutableArray *marrGuides = [NSMutableArray array];
//		[marrGuides addObject:@"자동이체 미 희망시는 월부금 한도 내에서 자유롭게 입금은 가능하나 지연 입금으로 인하여 청약순위 선정시 불이익을 받을 수 있습니다."];
//		[marrGuides addObject:@"자동이체 신청 시 매월 자동이체금액만큼 출금계좌에서 자동이체 됩니다."];
		[marrGuides addObject:@"재예치 통지신청을 하시면, SMS 또는 E-mail로 재예치 사실을 통지하여 드립니다."];
		[marrGuides addObject:@"재예치 통지는, 재예치시점에 등록된 고객정보 상의 휴대폰 번호 또는 E-mail 주소로 보내드립니다."];
		
		for (NSString *strGuide in marrGuides)
		{
			CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(246-27, 999) lineBreakMode:NSLineBreakByCharWrapping];
			
			UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
			[ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
			[ivInfoBox addSubview:ivBullet];
			
			UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, /*284*/246-27, size.height)]autorelease];
			[lblGuide setNumberOfLines:0];
			[lblGuide setBackgroundColor:[UIColor clearColor]];
			[lblGuide setTextColor:RGB(114, 114, 114)];
			[lblGuide setFont:[UIFont systemFontOfSize:13]];
			[lblGuide setText:strGuide];
			[ivInfoBox addSubview:lblGuide];
			
			fHeight += size.height + (strGuide == [marrGuides lastObject] ? 10 : 18);
		}
		
		[ivInfoBox setFrame:CGRectMake(9, fCurrHeight, /*311*/246, fHeight)];
		fCurrHeight += fHeight;
		
		fCurrHeight += 12;
		SHBButton *btnConfirm = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btnConfirm setFrame:CGRectMake(0, 0, 150, 29)];
		[btnConfirm setCenter:CGPointMake(width(bodyView)/2, 0)];
		FrameReposition(btnConfirm, left(btnConfirm), fCurrHeight);
		[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1"] forState:UIControlStateNormal];
		[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1_focus"] forState:UIControlStateHighlighted];
		[btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:15]];
		[btnConfirm setTitle:@"확인" forState:UIControlStateNormal];
		[btnConfirm addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
		[bodyView addSubview:btnConfirm];

	}
    
    return self;
}

@end
