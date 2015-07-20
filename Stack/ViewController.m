//
//  ViewController.m
//  Stack
//
//  Created by Vitaly Berg on 18/07/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "ViewController.h"

#import "PhotoCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (indexPath.item % 10)]];
    return cell;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
