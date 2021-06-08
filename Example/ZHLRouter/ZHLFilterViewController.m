//
//  ZHLFilterViewController.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import <ZHLRouter/ZHLRouter.h>

#import "ZHLFilterViewController.h"

@interface ZHLFilterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *im2;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation ZHLFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.

}

- (IBAction)backButton:(id)sender {
    [ZHLRouter popViewController:self];
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.shapeLayer.frame = self.lineView.bounds;
        [self.lineView.layer addSublayer:self.shapeLayer];
    }
    [self.array addObject:@(point)];
    UIBezierPath *b = [UIBezierPath bezierPath];
    [self.array enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [b moveToPoint:obj.CGPointValue];
        } else {
            [b addLineToPoint:obj.CGPointValue];
        }
    }];
    self.shapeLayer.path = b.CGPath;
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.shapeLayer = nil;
        [self.array removeAllObjects];
    }
    UIGraphicsBeginImageContextWithOptions(self.lineView.bounds.size, NO, 0);
    [self.lineView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIFilter *filter = [CIFilter filterWithName:@"CIShadedMaterial"];
    [filter setValue:[CIImage imageWithCGImage:screenShot.CGImage] forKey:@"inputImage"];
    [filter setValue:[CIImage imageWithCGImage:[UIImage imageNamed:@"sha"].CGImage] forKey:@"inputShadingImage"];
    self.im2.image = [UIImage imageWithCIImage:filter.outputImage scale:1 orientation:0];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer.strokeColor = UIColor.whiteColor.CGColor;
        _shapeLayer.lineWidth = 18;
    }
    return _shapeLayer;
}

@end
