//
//  SHBMainViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBFoldersDelegate.h"
#import "SHBFolders.h"
#import "SHBTickerView.h"
#import "MoaSignSDK.h"
#import "SHBWebView.h"

@interface SHBMainViewController : SHBBaseViewController <UIScrollViewDelegate, SHBFoldersDelegate, UITableViewDataSource, UITableViewDelegate, MoaSignSDKDelegate,UIWebViewDelegate>

{
	IBOutlet UIImageView	*_backImageView;
	IBOutlet UIView			*_mainMenuView;
	IBOutlet UIImageView	*_leftLogoImageView;
	IBOutlet UIImageView	*_rightLogoImageView;
	IBOutlet UIScrollView	*_scrollView;
    IBOutlet SHBTickerView	*_tickerView;
	IBOutlet UIView			*_menu1View;
	IBOutlet UIView			*_menu2View;
	IBOutlet UIImageView	*_page1Image;
	IBOutlet UIImageView	*_page2Image;
	IBOutlet UIView			*_folderView;
	IBOutlet UILabel		*_firstDeptheLabel;
	IBOutlet UIButton		*_rightButton;
	IBOutlet UIButton		*_leftButton;
	
	IBOutlet UILabel		*_versionLabel;
	
	IBOutlet UIImageView	*_focusIconImage;
	IBOutlet UIImageView	*_menuTableImage1;
	IBOutlet UIImageView	*_menuTableImage2;
	IBOutlet UIImageView	*_menuTableImage3;
	IBOutlet UIImageView	*_menuTableImage4;
	IBOutlet UIImageView	*_menuTableImage5;
	IBOutlet UIImageView	*_menuTableImage6;
	
    //IBOutlet UIImageView	*_2depthBGImage;
    
	IBOutlet UIView			*_hiddenButtonView;
	IBOutlet UIView			*_hidden3depthView;
    IBOutlet UIView			*_hidden3depthBigView;
    
	//FolderView(3 depth view)
	IBOutlet UIView			*_tableMenuView;
	IBOutlet UILabel		*_depth3TitleLabel;
	IBOutlet UIButton		*_guideButton;
	IBOutlet UITableView	*_menuTable;
	
	IBOutlet UIView			*_tableBigMenuView;
	IBOutlet UILabel		*_depth3BigTitleLabel;
	IBOutlet UITableView	*_menuBigTable;
	IBOutlet UIButton		*_guideBigButton;
	IBOutlet UIImageView	*_moreImageView;
	
	SHBFolders *folder;
	
	int indexCurrentMenuPage;
	int indexCurrentBtnTag;
	int indexCurrentMenuTag;
	
	float folderHeight;
	float folderGapHeight;
	BOOL depth3Resize;
	
	NSMutableArray	*firstSubMenuArray;
	NSMutableArray	*secondSubMenuArray;
	
	BOOL	isRequestVersionInfo;
	BOOL	isRequestAppList;
    BOOL    isRequestTikerList;
    
    IBOutlet UITextField	*_1depthField;
    IBOutlet UITextField	*_2depthField;
    IBOutlet UITextField	*_3depthField;
    IBOutlet UITextField	*_3depthBigField;
    IBOutlet UITextField	*_bannerField;
    
    //배너를 위해
    IBOutlet UIButton *_bannerMainBtn1;
    IBOutlet UIButton *_bannerMainBtn2;
    IBOutlet UIButton *_bannerMainBtn3;
    IBOutlet UIButton *_bannerMainBtn4;
    IBOutlet UIButton *_bannerMainBtn5;
    IBOutlet UIButton *_bannerOpenBtn;
    
    IBOutlet UIView *_bannerView;
    IBOutlet UIButton *_bannerListBtn;
    IBOutlet UIView *_bannerScrollContentsView;
    IBOutlet UIScrollView *_bannerScrollView;
    IBOutlet UIButton *_bannerScrollBtn1;
    IBOutlet UIButton *_bannerScrollBtn2;
    IBOutlet UIButton *_bannerScrollBtn3;
    IBOutlet UIButton *_bannerScrollBtn4;
    IBOutlet UIButton *_bannerScrollBtn5;
    
    // 공지사항뷰
    IBOutlet UIView *_noticeView;
    IBOutlet SHBWebView *_noticeWebView;
    
}

@property(nonatomic, retain) IBOutlet UIButton *notiCloseBtn;
@property(nonatomic, retain) IBOutlet UIButton *notiTypeBtn;
@property(nonatomic, retain) IBOutlet UILabel *notiTypeLabel;
@property(nonatomic, retain) IBOutlet UIView *notiView;
@property(nonatomic, retain) IBOutlet UIView *notiPView;

//인증서 안내 버튼
@property(nonatomic, retain) IBOutlet UIButton *certExplainBtn;
//타공인 인증서 등록 안내
@property(nonatomic, retain) IBOutlet UIButton *exCertExplainBtn;

- (IBAction)openFolder:(UIButton*)sender;			// 메뉴아이콘 터치시 폴더 오픈
- (IBAction)firstSubMenuPressed:(UIButton*)sender;	// 2Depth 메뉴에서 버튼 터치
- (IBAction)closeTableMenu:(UIButton*)sender;		// 3Depth 메뉴에서 이전메뉴로 돌아가기
- (IBAction)guideButtonPressed:(UIButton*)sender;	// 3Depth 메뉴에서 안내버튼 터치
- (IBAction)arrowButtonPressed:(UIButton*)sender;	// 스크롤뷰의 좌우 화살표 터치
- (IBAction)noticeViewClosePressed:(id)sender;      // 공지사항뷰의 닫기 버튼 터치

- (IBAction)mainBannerBtnClick:(id)sender; //메인화면 배너 오픈 터치
- (IBAction)mainBannerListBtnClick:(id)sender; //메인화면 배너 리스트 오픈 터치

- (IBAction)mainBannerContentClick:(id)sender;

- (IBAction)certExplainClick:(id)sender;

- (void)bannerSetAccessbility;

// 스크롤시 하단의 페이지 이미지 셋팅
- (void)setImageWithPage:(int)page;

// 스크롤뷰의 현재페이지 계산
- (int)getCurrentPageNumInScollerView:(UIScrollView *)scrollView pageWidth:(CGFloat)pageWidth;

// 아래로 폴더 열기
- (void)openFolderDown:(id)sender;

// 폴더 열때 하단의 타이틀바 숨기기/보이기
- (void)folderTitleBarWithHidden:(BOOL)hidden SenderTag:(int)senderTag;

// 메뉴 아이폰 셋팅하기
- (void)setMenuIcon;

// 폴더 Depth 1 메뉴 셋팅
- (void)loadFolderFirstDepthWithIndex:(int)index;

// 폴더 Depth 2 메뉴 셋팅
- (void)loadFolderSecondDepthWithTitle:(NSString*)title Key:(NSString*)depth2Key Sender:(UIButton*)sender;

// Push ViewController
- (void)pushMenuViewController:(NSDictionary*)nDic;

// 3단계 메뉴 사이즈 조절시 자동 스크롤
- (void)resizeMainMenuView:(float)height;

// 오픈된 폴더 강제 닫기
- (void)closeFolderMenu;

// 간편조회 설정시 계좌조회화면으로 이동
- (void)executeEasyInquiryAccount;

- (void) startTicker;				// 티커 표시하기
//- (BOOL)isJailBreakPhone;			// 탈옥 체크
- (void)requestVersionInfo;			// 버젼정보 요청
- (void)requestSavePhoneInfo;		// 핸드폰정보 등록 요청
- (void)requestBankCode;			// 은행코드 요청
- (void)requestOtherAppList;		// 신한은행 어플 목록 요청

/// 모아사인용
- (void)moaSignDidLoaded;

///공지 사항 후 강제 종료가 아니고 공지url이 있어 웹뷰를 뛰워야 되는경우...
- (void)noticeWebViewDidLoaded;
- (IBAction)notiBtnTypeClicked:(id)sender;

- (IBAction)test:(id)sender;
@end
