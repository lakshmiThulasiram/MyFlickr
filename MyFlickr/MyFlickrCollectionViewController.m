//
//  MyFlickrCollectionViewController.m
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 29/06/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//


//network calls
//caching
//

#import "MyFlickrCollectionViewController.h"

#define URL_TO_CONNECT @"https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=fa30a96d7733d5b5e5a40efb5dfa660f&photoset_id=72157669724360221&user_id=141941008%40N03&format=json&nojsoncallback=1"

@interface MyFlickrCollectionViewController ()
@property (nonatomic, strong) NetworkModel *model;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation MyFlickrCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageOperationQueue = [[NSOperationQueue alloc]init];
    self.imageOperationQueue.maxConcurrentOperationCount = 4;
    
    self.imageCache = [[NSCache alloc] init];
    
    
    self.model = [[NetworkModel alloc] init];
    self.model.delegate=self;
    
    
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self fetchPhotosList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Network methods -
-(void)fetchPhotosList
{
    
    NSMutableURLRequest *therequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_TO_CONNECT]];
    [self.model sendRequest:therequest];
    
}

-(void)handleResponse:(NSDictionary *)response
{
    [self processPhotoList:response];
    [self.collectionView reloadData];

}
#pragma mark-
#pragma mark Helper Method

-(void)processPhotoList:(NSDictionary *)data
{
    NSArray *list = [data valueForKeyPath:@"photoset.photo"];
    int i=0;
    for(NSDictionary *photo in list)
    {
        PhotoModel *dataOfPhoto = [[PhotoModel alloc] init];
        dataOfPhoto.farm        = [photo objectForKey:@"farm"];
        dataOfPhoto.server      = [photo objectForKey:@"server"];
        dataOfPhoto.photoID     = [photo objectForKey:@"id"];
        dataOfPhoto.secret      = [photo objectForKey:@"secret"];
        dataOfPhoto.title       = [photo objectForKey:@"title"];
        dataOfPhoto.index       =   i;
        dataOfPhoto.url         = [self buildPhotoURL:dataOfPhoto];
        dataOfPhoto.isDownloadComplete = NO;
        i++;
        if(!self.photoList)
        {
            self.photoList = [NSMutableArray array];
        }
        [self.photoList addObject:dataOfPhoto];

    }
    
    
}
-(NSString *)buildPhotoURL:(PhotoModel *)data
{
   
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",data.farm,data.server,data.photoID,data.secret];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoList count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width/2 - 1 ,155);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoModel *data = self.photoList[indexPath.row];
    UIImage *imageFromCache = [self.imageCache objectForKey:data.url];
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.labelInfo.text  = data.title;
    
    
    if (imageFromCache) {
        cell.photoImgView.image = imageFromCache;
    }
    else
    {
      
        [self.imageOperationQueue addOperationWithBlock:^{
            NSURL *imageurl = [NSURL URLWithString:data.url];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
            
            if (img) {
                
                // update cache
                [self.imageCache setObject:img forKey:data.url];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                   
                        [cell.photoImgView setImage:img];
                }];
            }
        }];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
