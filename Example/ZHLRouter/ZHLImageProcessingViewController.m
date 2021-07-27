//
//  ZHLImageProcessingViewController.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import <ZHLRouter/ZHLRouter.h>

#import "ChromaKey.h"

#import "ZHLPDFProcessingProtocol.h"
#import "UIImage+ZHLProcessingTools.h"

#import "ZHLImageProcessingViewController.h"

@interface ZHLImageProcessingViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (strong,nonatomic) NSMutableArray *aaa;

@end

@implementation ZHLImageProcessingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIImage *newImage = self.image;
    //newImage = [self color:newImage name:@"CIEdges"];
   // newImage = [self edges:newImage];
    //newImage = [self maskToAlpha:newImage];
  //  newImage = [self colorInvert:newImage];
 //   newImage = [self colorInvert:newImage];
    //newImage = [self noiseReduction:newImage];
//    newImage = [self edgesxxx:newImage];
//    newImage = [self colorInvert:newImage];
    
//    ColorAccent *colorAccent = [[ColorAccent alloc] init];
//    [colorAccent setDefaults];
//    colorAccent.inputImage = [[CIImage alloc] initWithCGImage:newImage.CGImage];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *ciImage = colorAccent.outputImage;
//    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
//    newImage = [UIImage imageWithCGImage:rep];
    
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


- (UIImage *)colorMonochrome:(UIImage *)image {

    CIImage *outputImage = [CIImage imageWithCGImage:image.CGImage] ;
    // Your Idea to enhance contrast.
    // Your Idea to enhance contrast.
    CIFilter *ciColorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome"];
    [ciColorMonochrome setValue:outputImage forKey:kCIInputImageKey];
    [ciColorMonochrome setValue:@(1) forKey:@"inputIntensity"];
    [ciColorMonochrome setValue:[[CIColor alloc] initWithColor:[UIColor whiteColor]] forKey:@"inputColor"];// Black and white
    outputImage = [ciColorMonochrome valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    CGImageRelease(rep);
    return newImage;
}

- (UIImage *)edgesxxx:(UIImage *)image inputIntensity:(NSInteger)inputIntensity {

    CIImage *outputImage = [CIImage imageWithCGImage:image.CGImage] ;
    // Your Idea to enhance contrast.
    // Your Idea to enhance contrast.
    CIFilter *ciColorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome"];
    [ciColorMonochrome setValue:outputImage forKey:kCIInputImageKey];
    [ciColorMonochrome setValue:@(1) forKey:@"inputIntensity"];
    [ciColorMonochrome setValue:[[CIColor alloc] initWithColor:[UIColor whiteColor]] forKey:@"inputColor"];// Black and white
    outputImage = [ciColorMonochrome valueForKey:kCIOutputImageKey];

    // Now go on with edge detection
    //CIImage *result = outputImage;
    CIFilter *ciEdges = [CIFilter filterWithName:@"CIEdges"];
    [ciEdges setValue:outputImage forKey:kCIInputImageKey];
    [ciEdges setValue:@(inputIntensity) forKey:@"inputIntensity"];
    outputImage = [ciEdges valueForKey:kCIOutputImageKey];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:outputImage fromRect:outputImage.extent];
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

- (UIImage *)noiseReduction:(UIImage *)image inputIntensity:(NSInteger)inputIntensity {
    CIFilter *filter = [CIFilter filterWithName:@"CINoiseReduction"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    [filter setValue:@(2) forKey:@"inputSharpness"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)comicEffect:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIComicEffect"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    CIImage *ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)dotScreen:(UIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CILineScreen"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    [filter setValue:@(1) forKey:@"inputWidth"];
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

- (UIImage *)exposureAdjust:(UIImage *)image inputEV:(NSInteger)inputEV {
    CIImage * inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *exposureAdjust = [CIFilter filterWithName:@"CIExposureAdjust"];
   // [exposureAdjust setDefaults];
    [exposureAdjust setValue:inputImage forKey:kCIInputImageKey];
    [exposureAdjust setValue:@(inputEV) forKey:@"inputEV"];
    CIImage *ciImage = exposureAdjust.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef rep = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:rep];
    return newImage;
}

- (UIImage *)jjjjjj:(UIImage *)image {
    
    CIImage * inputImage = [[CIImage alloc] initWithImage:self.image];
    
    CIFilter * monoFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [monoFilter setValue:inputImage forKey:kCIInputImageKey];

    CIImage * outImage = [monoFilter valueForKey:kCIOutputImageKey];
    
    CIImage * invertImage = [outImage copy];
    
    CIFilter * invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
    [invertFilter setValue:invertImage forKey:kCIInputImageKey];
    invertImage = [invertFilter valueForKey:kCIOutputImageKey];
    
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@0 forKey:kCIInputRadiusKey];
    [blurFilter setValue:invertImage forKey:kCIInputImageKey];
    
    invertImage = [blurFilter valueForKey:kCIOutputImageKey];
    //CIDivideBlendMode
    //CILinearBurnBlendMode
    //CIHardLightBlendMode
    CIFilter * blendFilter = [CIFilter filterWithName:@"CIDivideBlendMode"];
    
    [blendFilter setValue:invertImage forKey:kCIInputImageKey];
    [blendFilter setValue:outImage forKey:kCIInputBackgroundImageKey];
    CIImage * sketchImage = [blendFilter outputImage];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:sketchImage fromRect:[inputImage extent]];
    UIImage *imagex = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return imagex;
}

- (UIImage *)xxxxxxxx:(UIImage *)image {
    
  //  image = [self grayImage:image];
    
    CIImage * inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter * monoFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [monoFilter setValue:inputImage forKey:kCIInputImageKey];

    CIImage * outImage = [monoFilter valueForKey:kCIOutputImageKey];
    
    {
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
        UIImage *imagex = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        imagex = [self covertToGrayScale:imagex];
        outImage = [[CIImage alloc] initWithImage:imagex];
    }
    
    
    CIImage * invertImage = [outImage copy];
    
    CIFilter * invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
    [invertFilter setValue:invertImage forKey:kCIInputImageKey];
    invertImage = [invertFilter valueForKey:kCIOutputImageKey];
    
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@1 forKey:kCIInputRadiusKey];
    [blurFilter setValue:invertImage forKey:kCIInputImageKey];
    
    invertImage = [blurFilter valueForKey:kCIOutputImageKey];
    //CIDivideBlendMode
    //CILinearBurnBlendMode
    //CIHardLightBlendMode
    CIFilter * blendFilter = [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    
    [blendFilter setValue:invertImage forKey:kCIInputImageKey];
    [blendFilter setValue:outImage forKey:kCIInputBackgroundImageKey];
    CIImage * sketchImage = [blendFilter outputImage];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:sketchImage fromRect:[inputImage extent]];
    UIImage *imagex = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return imagex;
}

/**
 转化灰度
 */
- (UIImage *)grayImage:(UIImage *)image {
   
    int width = image.size.width;
    int height = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), image.CGImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

/**
 二值化
 */
- (UIImage *)covertToGrayScale:(UIImage *)image {
    
    CGSize size =[image size];
    int width =size.width;
    int height =size.height;
    
    //像素将画在这个数组
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    //清空像素数组
    memset(pixels, 0, width*height*sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用 pixels 创建一个 context
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    int tt =1;
    CGFloat intensity;
    int bw;
    
    for (int y = 0; y <height; y++) {
        for (int x =0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 3. / 255.;
//            if (intensity > 0.999) {
//                bw = 255;
//            } else {
                bw = 255 * intensity * 0.8;
        //    }
            
//            if (intensity > 0.8 && intensity < 0.99) {
//                bw = 255 * intensity * 0.25;
//            } else if (intensity >= 0.99) {
//                bw = 255;
//            } else {
//                bw = 255 * intensity * 0.25;
//            }
            
            rgbaPixel[tt] = bw;
            rgbaPixel[tt + 1] = bw;
            rgbaPixel[tt + 2] = bw;
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef newimage = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:newimage];
    // we're done with image now too
    CGImageRelease(newimage);
    
    return resultUIImage;
}


- (IBAction)show:(id)sender {
    UIImagePickerController *im = [[UIImagePickerController alloc] init];
    im.delegate = self;
    [self presentViewController:im animated:true completion:nil];
}


- (IBAction)sssss:(UISlider *)sender {
    UIImage *newImage = self.image;
//    newImage = [self colorMonochrome:newImage];
//    newImage = [self noiseReduction:newImage inputIntensity:sender.value];
//    newImage = [self edgesxxx:newImage inputIntensity:5];
//    newImage = [self colorInvert:newImage];

    newImage = [self xxxxxxxx:newImage];
    
    newImage = [self covertToGrayScale:newImage];
    
    newImage = [self xxxxxxxx:newImage];
    newImage = [self exposureAdjust:newImage inputEV:sender.value];
    newImage = [self xxxxxxxx:newImage];
   // newImage = [self jjjjjj:newImage];
//    newImage = [self colorMonochrome:newImage];
//    newImage = [self colorInvert:newImage];
    self.imageview.image = newImage;//.dither;
    NSLog(@"%@",@(sender.value));
    
//    UIActivityViewController *action = [[UIActivityViewController alloc] initWithActivityItems:@[newImage] applicationActivities:nil];
//    [self presentViewController:action animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
     self.image = info[UIImagePickerControllerOriginalImage];
    [self sssss:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
