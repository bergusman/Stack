//
//  Layout.m
//  Stack
//
//  Created by Vitaly Berg on 18/07/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "Layout.h"

@implementation LayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
    LayoutAttributes *copy = [super copyWithZone:zone];
    copy.likeProgress = self.likeProgress;
    copy.dislikeProgress = self.dislikeProgress;
    return copy;
}

@end

@interface Layout ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@property (assign, nonatomic) CGFloat x;

@property (strong, nonatomic) UICollectionViewLayoutAttributes *attr;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) LayoutAttributes *firstAttributes;

@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;

@property (strong, nonatomic) UISnapBehavior *snapBehavior;

@end

@implementation Layout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
}

- (void)prepareLayout {
    //NSLog(@"%s", __func__);
    [super prepareLayout];
    
    if (self.collectionView && !self.pan) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self.collectionView addGestureRecognizer:self.pan];
    }

}

- (void)didPan:(UIPanGestureRecognizer *)sender {
    //NSLog(@"%s", __func__);
    
    CGPoint locaiton = [sender locationInView:self.collectionView];
    CGPoint translation = [sender translationInView:self.collectionView];
    
    if (self.pan.state == UIGestureRecognizerStateBegan) {
        
        [self.animator removeBehavior:self.snapBehavior];
        
        UIOffset offset;
        offset.horizontal = -self.firstAttributes.center.x + locaiton.x;
        offset.vertical = -self.firstAttributes.center.y + locaiton.y;
        
        
        self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.firstAttributes offsetFromCenter:offset attachedToAnchor:locaiton];
        //self.attachmentBehavior.length = 0;
        [self.animator addBehavior:self.attachmentBehavior];
    }
    
    self.attachmentBehavior.anchorPoint = locaiton;
    
    if (self.pan.state == UIGestureRecognizerStateEnded || self.pan.state == UIGestureRecognizerStateCancelled) {
        [self.animator removeBehavior:self.attachmentBehavior];
        
        if (fabs(translation.x) > 80) {
            
            UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.firstAttributes]];
            [itemBehavior addLinearVelocity:CGPointMake(copysign(1000, translation.x), 0) forItem:self.firstAttributes];
            [self.animator addBehavior:itemBehavior];
            
        } else {
            [self.animator addBehavior:self.snapBehavior];
        }
    
        
        [self.pan setTranslation:CGPointZero inView:self.collectionView];
        
        
    }
    
    
    /*
    CGPoint t = [self.pan translationInView:self.collectionView];
    self.x = t.x;
    
    CGPoint p = self.attr.center;
    p.x = 100 + t.x;
    self.attr.center = p;
     */
    
    //[self invalidateLayout];
}

+ (Class)layoutAttributesClass {
    //NSLog(@"%s", __func__);
    
    return [LayoutAttributes class];
    //Class class = [UICollectionViewLayoutAttributes class];
    //return class;
}

+ (Class)invalidationContextClass {
    //NSLog(@"%s", __func__);
    Class class = [super invalidationContextClass];
    return class;
}

- (void)invalidateLayout {
    //NSLog(@"%s", __func__);
    [super invalidateLayout];
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    //NSLog(@"%s", __func__);
    [super invalidateLayoutWithContext:context];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    NSLog(@"%s", __func__);
    [super prepareForCollectionViewUpdates:updateItems];
}

- (CGSize)collectionViewContentSize {
    //NSLog(@"%s", __func__);
    return self.collectionView.bounds.size;
    //CGSize s = [super collectionViewContentSize];
    //return s;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //NSLog(@"%s", __func__);
    
    
    
    if (!self.firstAttributes) {
        self.firstAttributes = [LayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
        self.firstAttributes.center = CGPointMake(self.collectionView.bounds.size.width / 2, self.collectionView.bounds.size.height / 2);
        self.firstAttributes.bounds = CGRectMake(0, 0, 200, 260);
        self.firstAttributes.zIndex = 1000;
        
        UISnapBehavior *snapBehavoir = [[UISnapBehavior alloc] initWithItem:self.firstAttributes snapToPoint:self.firstAttributes.center];
        [self.animator addBehavior:snapBehavoir];
        
        self.snapBehavior = snapBehavoir;
        
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObjectsFromArray:[self.animator itemsInRect:rect]];
    
    
    CGPoint translation = [self.pan translationInView:self.collectionView];
    
    CGPoint center = CGPointMake(self.collectionView.bounds.size.width / 2, self.collectionView.bounds.size.height / 2);
    CGPoint cardCenter = self.firstAttributes.center;
    
    CGFloat xp = translation.x / 80;
    self.firstAttributes.likeProgress = MIN(1, MAX(0, xp));
    self.firstAttributes.dislikeProgress = MIN(1, fabs(MIN(0, xp)));
    
    
    NSLog(@"%f %f", self.firstAttributes.likeProgress, self.firstAttributes.dislikeProgress);
    
    
    
    CGFloat l = sqrt(translation.x * translation.x + translation.y * translation.y);
    
    CGFloat p = l / 80;
    
    p = MIN(1, p);
    
    
    for (int i = 0; i < 3; i++) {
        LayoutAttributes *attr = [LayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i + 1 inSection:0]];
        attr.center = CGPointMake(self.collectionView.bounds.size.width / 2, self.collectionView.bounds.size.height / 2);
        attr.bounds = CGRectMake(0, 0, 200, 260);
        attr.zIndex = 10 - i;
        
        attr.likeProgress = 0;
        attr.dislikeProgress = 0;
        
        /*
        CGAffineTransform t = CGAffineTransformMakeScale(1 - i * 0.05, 1 - i * 0.05);
        t = CGAffineTransformTranslate(t, 0, 10 * i);
        attr.transform = t;
        */
        
        
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(0, 10 * (i + 1));
        t = CGAffineTransformScale(t, 1 - 0.05 * (i + 1) + 0.05 * p, 1 - 0.05 * (i + 1) + 0.05 * p);
        attr.transform = t;
        
        [items addObject:attr];
    }
    
    
    
    return items;
    
    
    
    /*
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    attr.center = CGPointMake(100, 100);
    attr.bounds = CGRectMake(0, 0, 100, 100);
    
    attr.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:attr];
    
    attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    attr.center = CGPointMake(100, 100);
    attr.bounds = CGRectMake(0, 0, 100, 100);
    
    attr.transform = CGAffineTransformMakeScale(1, 1);
    attr.zIndex = 1;
    
    [array addObject:attr];
    
    attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    attr.center = CGPointMake(100 + self.x, 100);
    attr.bounds = CGRectMake(0, 0, 100, 100);
    
    attr.transform = CGAffineTransformMakeScale(0.9, 0.9);
    attr.zIndex = 2;
    
    self.attr = attr;
    
    [array addObject:attr];
    
    
    
    return array;
     */
    
    //NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    //return attrs;
}

@end
