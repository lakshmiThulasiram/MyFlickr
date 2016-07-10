//
//  PhotoModel.h
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 29/06/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL  isDownloadComplete;


@end
