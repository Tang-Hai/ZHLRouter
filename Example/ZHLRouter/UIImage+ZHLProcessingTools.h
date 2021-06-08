//
//  UIImage+ZHLProcessingTools.h
//  ZHLRouter_Example
//
//  Created by MAC on 2021/6/3.
//  Copyright © 2021 tanghai. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHLProcessingTools)

- (UIImage *)covertToGrayScale;
- (UIImage *)grayImage;
- (UIImage *)dither;
@end

NS_ASSUME_NONNULL_END
