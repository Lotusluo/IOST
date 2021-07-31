//
//  ViewController.m
//  searchDemo
//
//  Created by 陈乐杰 on 2018/8/6.
//  Copyright © 2018年 CHEN. All rights reserved.
//

#import "ViewController.h"
#import "ItemData.h"
#import "HeaderCollectionReusableView.h"
#import "CustomCollectionViewCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray <ItemData *>*dataArray;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];
}

-(NSArray  <ItemData *>*)dataArray{
    if (!_dataArray) {
        
        ItemData *data1 = [[ItemData alloc]init];
        data1.content = @"content1";
        ItemData *data2 = [[ItemData alloc]init];
        data2.content = @"content222222222222";
        _dataArray = [NSArray arrayWithObjects:data1, data2, data2, data2, data1, data1, data1, data1, data2, nil];
    }
    return _dataArray;
}


- (void)addContentView
{
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:5.0];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.baseView.frame.origin.x, self.baseView.frame.origin.y, self.baseView.bounds.size.width-20, self.baseView.bounds.size.height-40) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.baseView addSubview:self.collectionView];
     [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count / 2;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        HeaderCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor yellowColor];
        [headerView updateLabelFrame];
        reusableview = headerView;
    }
    return reusableview;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"加载数据");
    static NSString *moreCellIdentifier = @"CellIdentifier";
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreCellIdentifier forIndexPath:indexPath];
    NSLog(@"%ld",indexPath.section);
    ItemData *itemData = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.content = itemData.content;
    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 40);
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"加载 cell");
    return  [self getMultiLineWithFont:14 andText: [self.dataArray objectAtIndex:[indexPath item]].content];
}
//根据文字计算cell大小
- (CGSize)getMultiLineWithFont:(NSInteger)font andText:(NSString *)text
{
    CGSize size  = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size;
}
@end
