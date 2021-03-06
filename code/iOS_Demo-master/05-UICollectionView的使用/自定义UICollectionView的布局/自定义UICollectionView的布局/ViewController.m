//
//  ViewController.m
//  自定义UICollectionView的布局
//
//  Created by Tengfei on 15/12/27.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "ViewController.h"
#import "Layout/LineLayout.h"
#import "ViscosityLayout.h"
#import "CollectionViewCell.h"
#import "UITestView.h"
#import "FileOwnerTest.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,weak)UICollectionView *collectionView;

@end

@implementation ViewController

static NSString *const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect rect = CGRectMake(0, 160, self.view.frame.size.width, 180);
    ViscosityLayout *flowLayout = [[ViscosityLayout alloc]init];

    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    self.collectionView = collectionView;
    
    [self.view addSubview:self.collectionView];
    
//    FileOwnerTest* fileOwnerTest = [[FileOwnerTest alloc] init];
//    UITextView* testview = [[[NSBundle mainBundle] loadNibNamed:@"UITestView"
//                                                          owner:fileOwnerTest options:nil] lastObject];
//    fileOwnerTest.fileOwnerTest.text = @"changed";
//    if(testview){
//        NSLog(@"加载xib成功");
//        [self.view addSubview:testview];
//    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init] animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.index = indexPath.item;
//    cell.backgroundColor = KRandomColor;
    return cell;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        for (int i = 1; i<=20; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataArray;
}


@end
