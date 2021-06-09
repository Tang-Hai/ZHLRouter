//
//  ZHLImageProcessingViewController.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import <ZHLRouter/ZHLRouter.h>

#import "ZHLPDFProcessingProtocol.h"
#import "UIImage+ZHLProcessingTools.h"

#import "ZHLImageProcessingViewController.h"

@interface ZHLImageProcessingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (strong,nonatomic) NSMutableArray *aaa;

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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.aaa = [NSMutableArray array];
//        for (int i = 0; i < 200; i++) {
//            @autoreleasepool {
//                UIImage *image = [UIImage imageNamed:@"111111xxxxx.png"];
//                UIImage *image2 = [UIImage imageNamed:@"1a5ccdb6-a1f2-46a9-a5f8-26aaa1b0dbe8.jpeg"];
//                NSString *dir =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//                NSString *path = [dir stringByAppendingFormat:@"/%@.png", @(i)];
//                image2 = [self colorInvert:image2];
//                [UIImagePNGRepresentation(image2) writeToFile:path atomically:YES];
//                [self.aaa addObject:image];
//                [self.aaa addObject:[[UIImage alloc] initWithContentsOfFile:path]];
//            }
//        }
//    });
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"PDF" style:0 target:self action:@selector(pdf)];
}

- (void)pdf {
    Class<ZHLPDFProcessingProtocol>obj = [ZHLRouter serviceProvideForProcotol:@protocol(ZHLPDFProcessingProtocol)];
    id<ZHLPDFProcessingProtocol>objInstance = [obj createProcessingServiceWithName:@"符号表工具iOS版-使用指南"];
    [ZHLRouter performOnDestination:objInstance path:ZHLRoutePath.pushFrom(self)];
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
    CGImageRelease(rep);
    return newImage;
}

- (UIImage *)colorInvert:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    CGImageRelease(rep);
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
