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


@interface ZHLViewController () 

@end

@implementation ZHLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
