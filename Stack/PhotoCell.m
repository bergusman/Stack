//
//  PhotoCell.m
//  Stack
//
//  Created by Vitaly Berg on 18/07/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "PhotoCell.h"

#import "Layout.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nopeLabel;

@end

@implementation PhotoCell

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [super applyLayoutAttributes:layoutAttributes];
    
    
    if ([layoutAttributes isKindOfClass:[LayoutAttributes class]]) {
        NSLog(@"%s", __func__);
        LayoutAttributes *attr = (LayoutAttributes *)layoutAttributes;
        
        NSLog(@"%f %f", attr.likeProgress, attr.dislikeProgress);
        
        
        self.likeLabel.alpha = attr.likeProgress;
        self.nopeLabel.alpha = attr.dislikeProgress;
    }
}

@end
