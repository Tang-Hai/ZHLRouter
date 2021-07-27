//
//  ChromaKey.m
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/18.
//  Copyright © 2021 tanghai. All rights reserved.
//

#import "ChromaKey.h"

@implementation ChromaKey

@synthesize inputImage, inputBackgroundImage;
@synthesize inputCubeDimension, inputCenterAngle, inputAngleWidth;

+ (NSDictionary *)customAttributes
{
    return customAttrs(cubeMakeTransparent);
}

- (void)setDefaults
{
    const double centerAngle = 120.0;
    const double angleWidth = 100.0;
    self.inputCubeDimension = @(defaultCubeSize);
    self.inputCenterAngle = @(centerAngle * M_PI / 180.0);
    self.inputAngleWidth = @(angleWidth * M_PI / 180.0);
}

- (CIImage *)outputImage
{
    if ( inputCubeDimension.intValue <= 0 || nil == inputBackgroundImage || [inputAngleWidth floatValue] == 0.0 )
        return inputImage;
    
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    
    const unsigned int cubeSize = MAX(MIN(inputCubeDimension.intValue, maxCubeSize), minCubeSize);
    size_t baseMultiplier = cubeSize * cubeSize * cubeSize * 4;
    
    // you can use either uint8 data or float data by just setting this variable
    BOOL useFloat = FALSE;
    NSMutableData *cubeData = [NSMutableData dataWithLength:baseMultiplier * (useFloat ? sizeof(float) : sizeof(uint8_t))];
    
    if ( ! cubeData )
        return inputImage;
    
    if ( ! buildCubeData(cubeData, cubeSize, [inputCenterAngle floatValue], [inputAngleWidth floatValue], cubeMakeTransparent) )
        return inputImage;
    
    // don't just use inputCubeSize directly because it is a float and we want to use an int.
    [colorCube setValue:[NSNumber numberWithInt:cubeSize] forKey:@"inputCubeDimension"];
    [colorCube setValue:cubeData forKey:@"inputCubeData"];
    [colorCube setValue:inputImage forKey:kCIInputImageKey];

    CIImage *coloredKeyedImage = [colorCube valueForKey:kCIOutputImageKey];
    
    [colorCube setValue:nil forKey:@"inputCubeData"];
    [colorCube setValue:nil forKey:kCIInputImageKey];
    
    CIFilter *sourceOver = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOver setValue:coloredKeyedImage forKey:kCIInputImageKey];
    [sourceOver setValue:inputBackgroundImage forKey:kCIInputBackgroundImageKey];
    
    CIImage *outputImage = [sourceOver valueForKey:kCIOutputImageKey];
    
    [sourceOver setValue:nil forKey:kCIInputImageKey];
    [sourceOver setValue:nil forKey:kCIInputBackgroundImageKey];
    
    return outputImage;
}

@end

@implementation ColorAccent

@synthesize inputImage;
@synthesize inputCubeDimension, inputCenterAngle, inputAngleWidth;

+ (NSDictionary *)customAttributes
{
    return customAttrs(cubeMakeGrayscale);
}

- (void)setDefaults
{
    const double centerAngle = 0.0;
    const double angleWidth = 60.0;
    self.inputCubeDimension = @(defaultCubeSize);
    self.inputCenterAngle = @(centerAngle * M_PI / 180.0);
    self.inputAngleWidth = @(angleWidth * M_PI / 180.0);
}

- (CIImage *)outputImage
{
    if ( inputCubeDimension.intValue <= 0 || [inputAngleWidth floatValue] == 0.0)
        return inputImage;
    
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    
    const unsigned int cubeSize = MAX(MIN(inputCubeDimension.intValue, maxCubeSize), minCubeSize);
 
    size_t baseMultiplier = cubeSize * cubeSize * cubeSize * 4;

    // you can use either uint8 data or float data by just setting this variable
    BOOL useFloat = FALSE;
    NSMutableData *cubeData = [NSMutableData dataWithLength:baseMultiplier * (useFloat ? sizeof(float) : sizeof(uint8_t))];
    
    if ( ! cubeData )
        return inputImage;
    
    if ( ! buildCubeData(cubeData, cubeSize, [inputCenterAngle floatValue], [inputAngleWidth floatValue], cubeMakeGrayscale) )
        return inputImage;
    
    // don't just use inputCubeSize directly because it is a float and we want to use an int.
    [colorCube setValue:[NSNumber numberWithInt:cubeSize] forKey:@"inputCubeDimension"];
    [colorCube setValue:cubeData forKey:@"inputCubeData"];
    [colorCube setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *outputImage = [colorCube valueForKey:kCIOutputImageKey];
    
    [colorCube setValue:nil forKey:@"inputCubeData"];
    [colorCube setValue:nil forKey:kCIInputImageKey];
    
    return outputImage;
}

@end

