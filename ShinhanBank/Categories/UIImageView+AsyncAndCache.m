//
//  UIImageView+AsyncAndCache.m
//
//  Created by Yongho Ji on 10. 12. 3..
//  Copyright 2010 Wecon Communications. All rights reserved.
//

#import "UIImageView+AsyncAndCache.h"


@implementation UIImageView (AsyncAndCache)

static AsyncAndCacheImageOperatorManager *__manager = nil;

+ (AsyncAndCacheImageOperatorManager *)_manager
{
	if (__manager == nil)
	{
		__manager = [[AsyncAndCacheImageOperatorManager alloc]init];
	}
	return __manager;
}

+(void)setMaxAsyncCount:(NSUInteger)count
{
	[[UIImageView _manager] setMaxAsyncCount:count];
}

- (void)dealloc
{
	[super dealloc];
}

-(id)initWithURLString:(NSString*)url
{
	if (self == [super init])
	{
		[self setImageURL:[NSURL URLWithString:url]];
	}
	return self;
}

-(id)initWithURL:(NSURL*)url
{
	if (self == [super init])
	{
		[self setImageURL:url];
	}
	return self;
}

-(void)setImageURLString:(NSString*)url
{
	if (url == nil)
	{
		return;
	}
	[self setImageURL:[NSURL URLWithString:url]];
}

-(void)setImageURL:(NSURL*)url
{
	if (url == nil || [url path]==nil)
	{
		return;
	}
    //NSLog(@"step 1");
	AsyncAndCacheImageOperator *operator = [[AsyncAndCacheImageOperator alloc]initWithURL:url imageView:self];
	[[UIImageView _manager] addImageOperator:operator];
	[operator release];
}

@end


@implementation AsyncAndCacheImageOperator

@synthesize imageView = _imageView;


static NSString *__cacheImagePath;

+ (NSString *)_cacheImagePath
{
	if (__cacheImagePath==nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *cachePath = [paths objectAtIndex:0];
		__cacheImagePath = [[[cachePath stringByAppendingPathComponent:@"cacheImages"] stringByAppendingString:@"/"]retain];
		
		
		NSFileManager *manager = [NSFileManager defaultManager];
		if (![manager fileExistsAtPath:__cacheImagePath])
		{
			[manager createDirectoryAtPath:__cacheImagePath withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}
	return __cacheImagePath;
}


- (id)initWithURL:(NSURL*)url imageView:(UIImageView*)imageView
{
	self = [super init];
	if (self != nil)
	{
		_url = [url retain];
		_imageView = [imageView retain];
	}
	
	//이미지 캐쉬 디렉토리 경로
	
	return self;
}

- (void)dealloc
{
	[_loadCompleteTarget release];
	[_url release];
	[_imageView release];
	[super dealloc];
}

- (void)main
{
	NSData *data;
	UIImage *image;
	
	NSArray *paths = [[_url path] componentsSeparatedByString:@"/"];
	NSString *fileName = [paths objectAtIndex:[paths count]-1];
	NSString *cachePath = [AsyncAndCacheImageOperator _cacheImagePath];
	NSString *filePath = [cachePath stringByAppendingString:fileName];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	
	if (_canceled==YES)
	{
		if (_loadCompleteTarget!=nil)
		{
			[_loadCompleteTarget performSelectorOnMainThread:_loadCompleteSelector withObject:self waitUntilDone:YES];
		}
		return;
	}
	//NSLog(@"step 5");
    UIActivityIndicatorView *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [_imageView addSubview:_activityIndicatorView];
    
    _activityIndicatorView.center = _imageView.center;
    
    [_activityIndicatorView startAnimating];
    
	//해당 경로에 이미지 파일이 있는지 확인한다.
	if( NO == [manager fileExistsAtPath:filePath] )
	{
		//이미지를 원격에서 가져와서 cache처리 한다.
        
        data = [NSData dataWithContentsOfURL:_url];
        
		image = [UIImage imageWithData:data];
		if (NO==[manager createFileAtPath:filePath contents:data attributes:nil])
		{
			////NSLog(@"이미지 저장실패 : %@",filePath);
		}
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloadFinishNoti" object:nil];
	}
	else
	{
		//cache처리된 이미지를 읽어온다.
		image = [UIImage imageWithContentsOfFile:filePath];
	}
	
	if (_canceled==NO)
	{
        _imageView.contentMode = UIViewContentModeRedraw;
		_imageView.image = image;
        [_imageView setNeedsDisplay];
        
	}
    
	if (_loadCompleteTarget!=nil)
	{
		[_loadCompleteTarget performSelectorOnMainThread:_loadCompleteSelector withObject:self waitUntilDone:YES];
	}
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView release];
    
}

- (void)cancel
{
	_canceled = YES;
}

- (void)setLoadCompleteWithTarget:(id)target selector:(SEL)selector
{
	[target retain];
	[_loadCompleteTarget release];
	_loadCompleteTarget = target;
	_loadCompleteSelector = selector;
}

@end

@implementation AsyncAndCacheImageOperatorManager

-(id)init
{
	if (self == [super init])
	{
		_maxAsyncCount = 10;
		_currentAscynCount = 0;
		_standByImageOperators = [[NSMutableArray alloc]init];
		_loadImageOperators = [[NSMutableArray alloc]init];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
	[_standByImageOperators release];
	[_loadImageOperators release];
}

-(void)setMaxAsyncCount:(NSUInteger)count
{
	_maxAsyncCount = count;
}

-(void)addImageOperator:(AsyncAndCacheImageOperator*)imageOperator
{
    //NSLog(@"step 2");
	//대기열에서 중복되는 imageView가 있는가 체크
	UIImageView *imageView = imageOperator.imageView;
	for (AsyncAndCacheImageOperator *operator in _standByImageOperators)
	{
		if (imageView == operator.imageView)
		{
			[_standByImageOperators removeObject:operator];
			break;
		}
	}
	//로드중인 imageView중에 같은 것이 있다면 로드 cancel시킨다.
	for (AsyncAndCacheImageOperator *operator in _loadImageOperators)
	{
		if (imageView == operator.imageView)
		{
			[operator cancel];
		}
	}
	
	//대기열에 추가
	[_standByImageOperators addObject:imageOperator];
	
	[self performSelector:@selector(_load) withObject:nil];
	
}

-(void)_load
{
    //NSLog(@"step 3");
	//로드 실시
	while (_currentAscynCount < _maxAsyncCount && [_standByImageOperators count] > 0)
	{
		_currentAscynCount++;
		AsyncAndCacheImageOperator *imageOperator = [_standByImageOperators objectAtIndex:0];
		[_loadImageOperators addObject:imageOperator];
        
        if ([_standByImageOperators count] > 0) {
            [_standByImageOperators removeObjectAtIndex:0];
        }
		
		[imageOperator setLoadCompleteWithTarget:self selector:@selector(_loadComplete:)];
		[NSThread detachNewThreadSelector:@selector(_loadThread:) toTarget:self withObject:imageOperator];
	}
}

//이미지 로드를 실시한다. ImageOperator가 로드한다.
-(void)_loadThread:(AsyncAndCacheImageOperator*)imageOperator
{
    //NSLog(@"step 4");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	
	[imageOperator main];
	
	[pool release];
}

//이미지 로드가 완료되면 해당 Operator를 삭제한다.
-(void)_loadComplete:(AsyncAndCacheImageOperator*)imageOperator
{
    //NSLog(@"step 6");
	UIImageView *imageView = imageOperator.imageView;
	for (AsyncAndCacheImageOperator *operator in _loadImageOperators)
	{
		if (imageView == operator.imageView)
		{
			[_loadImageOperators removeObject:operator];
			break;
		}
	}
	_currentAscynCount--;
	//다시 다른 이미지 로드 요청
	[self performSelector:@selector(_load)];
}


@end