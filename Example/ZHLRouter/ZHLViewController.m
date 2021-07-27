//
//  ZHLViewController.m
//  ZHLRouter
//
//  Created by tanghai on 06/01/2021.
//  Copyright (c) 2021 tanghai. All rights reserved.
//

#import <ZHLRouter/ZHLRouter.h>

#import "ZHLAspectFillProtocol.h"
#import "ZHLFilterServiceProtocol.h"
#import "ZHLImageProcessingProtocol.h"

#import "ZHLViewController.h"
#import <Lottie/Lottie.h>

@interface ZHLViewController () 

@end

@implementation ZHLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *v = [UIView new];
    [self.view addSubview:v ];
    v.frame = CGRectMake(0, 200, 200, 200);
    v.backgroundColor = [UIColor grayColor];
    
    
    /*
     1、下载json
     2、将json转成字符串
     3、替换字符串
     4、字符串转map，将map传给
     5、
     */
    NSDictionary *dic = [self readLocalFileWithName:@"test"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *final = [dataStr stringByReplacingOccurrencesOfString:@",\"k\":[0,0,0,1]" withString:@",\"k\":[0,0,0,0]"];
    NSDictionary *dicfinal = [self dictionaryWithJsonString:final];
    
    
    
    LOTAnimationView *lottieV =  [LOTAnimationView animationFromJSON:dicfinal];
    lottieV.animationSpeed = 1;
    lottieV.contentMode = UIViewContentModeScaleToFill;
    [v addSubview:lottieV];
    lottieV.frame = CGRectMake(0, 0, 200, 200);
    [lottieV play];
    
   
//    [lottieV playFromFrame:@(0) toFrame:@(150) withCompletion:^(BOOL animationFinished) {
//
//    }];
//    [lottieV logHierarchyKeypaths];
	
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (NSDictionary *)readLocalFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
}
- (IBAction)pushButtonAction:(id)sender {
    Class<ZHLFilterServiceProtocol>filterClass = [ZHLRouter serviceProvideForProcotol:@protocol(ZHLFilterServiceProtocol)];
    id<ZHLFilterServiceProtocol>filter = [filterClass createFilterService];
    [ZHLRouter performOnDestination:filter path:ZHLRoutePath.presentFrom(self)];
}

- (IBAction)push1ButtonAction:(id)sender {
    Class<ZHLImageProcessingProtocol>imageClass = [ZHLRouter serviceProvideForProcotol:@protocol(ZHLImageProcessingProtocol)];
    id<ZHLImageProcessingProtocol>image = [imageClass createProcessingServiceWithImage:[UIImage imageNamed:@"7D3FCAE9-DFC8-4F6B-A543-05E94CA99616"]];
    [ZHLRouter performOnDestination:image path:ZHLRoutePath.pushFrom(self)];
}

- (IBAction)fill:(id)sender {
    id<ZHLAspectFillProtocol>obj = [ZHLRouter serviceProvideForProcotol:@protocol(ZHLAspectFillProtocol)];
    [ZHLRouter performOnDestination:obj path:ZHLRoutePath.pushFrom(self)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
