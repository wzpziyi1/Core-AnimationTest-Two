//
//  ViewController.m
//  图片切换
//
//  Created by 王志盼 on 15/12/17.
//  Copyright © 2015年 王志盼. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) int currentIndex;

@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *behindImageView;

@end

@implementation ViewController

- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
        
        for (int i = 1; i <= 7; i++) {
            UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"%d",i]];
            [_images addObject:image];
        }
    }
    return _images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.currentImageView.image = self.images[_currentIndex];
}


- (void)addAnimateWithPoint:(CGPoint )point angle:(CGFloat)angle fromZ:(CGFloat)fromZ toZ:(CGFloat)toZ view:(UIView *)view
{
    CABasicAnimation *zPosition = [[CABasicAnimation alloc] init];
    zPosition.keyPath = @"zPosition";
    zPosition.fromValue = @(fromZ);
    zPosition.toValue = @(toZ);
    zPosition.duration = 1.2;
    
    CAKeyframeAnimation *rotation = [[CAKeyframeAnimation alloc] init];
    rotation.keyPath = @"transform.rotation";
    rotation.values = @[@(0), @(angle), @(0)];
    rotation.duration = 2;
    rotation.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAKeyframeAnimation *position = [[CAKeyframeAnimation alloc] init];
    position.keyPath = @"position";
//    CGPointMake(110, -20)
    position.values = @[
                        [NSValue valueWithCGPoint:CGPointZero],
                        [NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointZero]
                        ];
    
    position.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
    
    position.additive = YES;
    position.duration = 1.2;
    
    CAAnimationGroup *animateGroup = [[CAAnimationGroup alloc] init];
    animateGroup.animations = @[zPosition, rotation, position];
//    animateGroup.beginTime = 0.5;
    animateGroup.delegate = self;
    animateGroup.duration = 1.2;
    [animateGroup setValue:view forKey:@"view"];
    [view.layer addAnimation:animateGroup forKey:nil];
    
    view.layer.zPosition = toZ;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAAnimationGroup *group = [anim valueForKey:@"view"];
    if (group != nil) {
        self.currentImageView.image = self.images[_currentIndex];
        self.currentImageView.layer.zPosition = 1;
        self.behindImageView.image = nil;
        self.behindImageView.layer.zPosition = -1;
    }
}
- (IBAction)previous:(id)sender {
    self.currentIndex = (self.currentIndex + 1) % self.images.count;
    self.behindImageView.image = self.images[_currentIndex];
    
    [self addAnimateWithPoint:CGPointMake(-90, 20) angle:0.15 fromZ:-1 toZ:1 view:self.behindImageView];
    [self addAnimateWithPoint:CGPointMake(90, -20) angle:-0.15 fromZ:1 toZ:-1 view:self.currentImageView];
}

- (IBAction)next:(id)sender {
    self.currentIndex = (self.currentIndex + 6) % self.images.count;
    self.behindImageView.image = self.images[_currentIndex];
    [self addAnimateWithPoint:CGPointMake(-90, 20) angle:-0.15 fromZ:-1 toZ:1 view:self.behindImageView];
    [self addAnimateWithPoint:CGPointMake(90, -20) angle:0.15 fromZ:1 toZ:-1 view:self.currentImageView];
}
@end
