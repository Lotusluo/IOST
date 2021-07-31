//
//  ViewController.m
//  JATableCellNestTableDemo
//
//  Created by JasoneIo on 16/6/27.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

#import "ViewController.h"
#import "JADataModel.h"
#import "JANestCell.h"
#import "JAHeaderFooterView.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <JADataModel *> *dataArr;

@property (strong, nonatomic) JANestCell *nestCell;
@property (strong, nonatomic) JAHeaderFooterView *headerView;
@end

@implementation ViewController

- (JANestCell *)nestCell
{
    if (!_nestCell) {
        _nestCell = [[NSBundle mainBundle] loadNibNamed:JANestCellIdentifier owner:self options:nil].firstObject;
    }
    return _nestCell;
}

- (JAHeaderFooterView *)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:JAHeaderFooterViewIdentifier owner:self options:nil].firstObject;
    }
    return _headerView;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [JADataModel fetchDataModelList];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    [self.tableView registerNib:[UINib nibWithNibName:JANestCellIdentifier bundle:nil] forCellReuseIdentifier:JANestCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:JAHeaderFooterViewIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:JAHeaderFooterViewIdentifier];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JADataModel *sectionModel = self.dataArr[section];
    return sectionModel.dayjourney.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JANestCell *cell = [tableView dequeueReusableCellWithIdentifier:JANestCellIdentifier forIndexPath:indexPath];
    cell.dayModel = self.dataArr[indexPath.section].dayjourney[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JADataModel *sectionModel = self.dataArr[indexPath.section];
    self.nestCell.dayModel = sectionModel.dayjourney[indexPath.row];
    return [self.nestCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JADataModel *sectionModel = self.dataArr[section];
    JAHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:JAHeaderFooterViewIdentifier];
    [view configureTitleDay:sectionModel.outday subTitle:sectionModel.title isNeedHideTopLine:sectionModel.hideTopLine];
    
    UIView *colorView = [[UIView alloc] initWithFrame:view.bounds];
    colorView.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    view.backgroundView = colorView;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JADataModel *sectionModel = self.dataArr[section];
    [self.headerView configureTitleDay:sectionModel.outday subTitle:sectionModel.title isNeedHideTopLine:sectionModel.hideTopLine];
    CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    JADataModel *sectionModel = self.dataArr[section];
    return sectionModel.lastSetion ? 20.0f : CGFLOAT_MIN;
}

@end
