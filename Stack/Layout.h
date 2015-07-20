//
//  Layout.h
//  Stack
//
//  Created by Vitaly Berg on 18/07/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayoutAttributes : UICollectionViewLayoutAttributes

@property (assign, nonatomic) CGFloat likeProgress;
@property (assign, nonatomic) CGFloat dislikeProgress;

@end


@interface Layout : UICollectionViewLayout

@end
