//
//  NetworkModel.h
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 10/07/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetworkModel;

@protocol NetworkDelegate <NSObject>

-(void)handleResponse:(NSDictionary *)response;

@end

@interface NetworkModel : NSObject<NSURLSessionDelegate>
-(void)sendRequest:(NSMutableURLRequest *)request;


@property (nonatomic,weak) id<NetworkDelegate> delegate;
@end
