//
//  ViewController.m
//  PhotoKit的使用
//
//  Created by qq on 16/6/5.
//  Copyright © 2016年 lei. All rights reserved.
//
/**
 * 演示使用ZLPickPhoto
 * 从图片库多选获取图片放到CollectionView
 */

#import <Photos/Photos.h>

#import "ViewController.h"
#import "ZLPickPhotoViewController.h"
#import "ZLPhotoCell.h"

#define ZLScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultImage;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"Cell";

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat w = ZLScreenW / 4.0;
        flowLayout.itemSize = CGSizeMake(w - 1,w - 1);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZLPhotoCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (NSMutableArray *)resultImage {
    if (!_resultImage) {
        _resultImage = [[NSMutableArray alloc] init];
    }
    return _resultImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}
- (IBAction)selectPhtotoClick {
     __weak typeof(self) weakSelf = self;
    // 创建选择图片控制器
    ZLPickPhotoViewController *vc = [[ZLPickPhotoViewController alloc] initWithCompleteHandle:^(NSArray *images) {
        [weakSelf.resultImage removeAllObjects];
        [weakSelf.resultImage addObjectsFromArray:images];
        [weakSelf.collectionView reloadData];
    }];
    // 限制最多能选多少张
    vc.limitCount = 99;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [weakSelf presentViewController:nav animated:YES completion:nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultImage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.img = self.resultImage[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
