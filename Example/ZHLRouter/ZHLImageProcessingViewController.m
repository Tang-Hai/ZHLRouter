//
//  ZHLImageProcessingViewController.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import "UIImage+ZHLProcessingTools.h"

#import "ZHLImageProcessingViewController.h"

@interface ZHLImageProcessingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation ZHLImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIImage *newImage = self.image;
    //newImage = [self color:newImage name:@"CIEdges"];
    newImage = [self edges:newImage];
    //newImage = [self maskToAlpha:newImage];
    newImage = [self colorInvert:newImage];
 //   newImage = [self colorInvert:newImage];
    //newImage = [self noiseReduction:newImage];
    
    self.imageview.image = newImage;//.dither;
}

- (UIImage *)color:(UIImage *)image name:(NSString *)name {
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)edges:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIEdges"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    [filter setValue:@(20) forKey:@"inputIntensity"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)colorInvert:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)maskToAlpha:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)noiseReduction:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CINoiseReduction"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    [filter setValue:@(2) forKey:@"inputSharpness"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
