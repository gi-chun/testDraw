//
//  SHBForexRequestDetailViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestDetailViewController.h"
#import "SHBForexRequestDetailCell.h" // cell

@interface SHBForexRequestDetailViewController ()

@end

@implementation SHBForexRequestDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"환전신청내역조회"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.detailData = nil;
    
	[super dealloc];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark - Button

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopViewController];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_detailData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBForexRequestDetailCell *cell = (SHBForexRequestDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexRequestDetailCell"];
	if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexRequestDetailCell"
                                                       owner:self options:nil];
		cell = (SHBForexRequestDetailCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = _detailData[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    if (indexPath.row == 0) {
        [self.binder bind:self dataSet:cellDataSet];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
