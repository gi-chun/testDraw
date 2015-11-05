//
//  SHBNoticeAlimViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeAlimViewController.h"
#import "SHBNoticeAlimCell.h"

@interface SHBNoticeAlimViewController ()
{
    int selectedRow;
    int selectedSection;
}
@end

@implementation SHBNoticeAlimViewController
@synthesize alimTableView;
@synthesize allAlimArray;

- (void)dealloc
{
    [allAlimArray release];
    [alimTableView release];
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    [self navigationViewHidden];
    
    self.allAlimArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self performSelector:@selector(adjustView) withObject:nil afterDelay:0.01];
    
}

- (void)adjustView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 54, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.allAlimArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.allAlimArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHBNoticeAlimCell *cell = (SHBNoticeAlimCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SHBNoticeAlimCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell =  (SHBNoticeAlimCell *)currentObject;
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)] autorelease];
    headerView.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(217/255.0f) blue:(195/255.0f) alpha:1.0f];
    
    UIView *lineView1 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)] autorelease];
    lineView1.backgroundColor = [UIColor colorWithRed:(209/255.0f) green:(209/255.0f) blue:(209/255.0f) alpha:1.0f];
    
    UIView *lineView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, tableView.bounds.size.height, tableView.bounds.size.width, 1)] autorelease];
    lineView2.backgroundColor = [UIColor colorWithRed:(209/255.0f) green:(209/255.0f) blue:(209/255.0f) alpha:1.0f];
    
    
    /*
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(31, 12, tableView.bounds.size.width, 19)] autorelease];
    label.text = [[self.arrayTableData objectAtIndex:index] objectForKey:@"menu.name"];
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:RGB(74, 74, 74)];
    label.font = [UIFont systemFontOfSize:15];
    
    
    [headerView addSubview:lineView1];
    [headerView addSubview:label];
    [headerView addSubview:lineView1];
    */
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

@end
