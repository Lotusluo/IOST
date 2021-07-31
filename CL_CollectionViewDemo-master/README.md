# CL_CollectionViewDemo
CL_CollectionViewDemo
现在支持左对齐，居中对齐，靠右对齐。
根据文字计算cell 大小

EqualSpaceFlowLayoutEvolve * flowLayout = [[EqualSpaceFlowLayoutEvolve alloc]initWthType:AlignWithRight];

self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];

