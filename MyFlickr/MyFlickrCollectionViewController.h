//
//  MyFlickrCollectionViewController.h
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 29/06/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "CollectionViewCell.h"
#import "DownloadOperation.h"

@interface MyFlickrCollectionViewController : UICollectionViewController<NSURLSessionDelegate,DowloadDelegate>

@end
