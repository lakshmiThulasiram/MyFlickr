//
//  NetworkModel.m
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 10/07/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import "NetworkModel.h"

@implementation NetworkModel


-(void)sendRequest:(NSMutableURLRequest *)request
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error){
        if(!error)
        {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&jsonError];
            
            [self.delegate handleResponse:json];

        }
        
    }] resume];
}
@end
