//
//  MyFlickrCollectionViewController.m
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 29/06/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import "MyFlickrCollectionViewController.h"

#define URL_TO_CONNECT @"https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=fa30a96d7733d5b5e5a40efb5dfa660f&photoset_id=72157669724360221&user_id=141941008%40N03&format=json&nojsoncallback=1"

@interface MyFlickrCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *photoList;
@end

@implementation MyFlickrCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self fetchPhotosList];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
-(void)fetchPhotosList
{
    
    NSMutableURLRequest *therequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_TO_CONNECT]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:therequest completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error){
        if(!error)
        {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&jsonError];
            [self processPhotoList:json];
            
            [self.collectionView reloadData];
        }
        
    }] resume];
    

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
-(void)downloadCompleted:(PhotoModel *)data
{
    [self.photoList removeObjectAtIndex:data.index];
    [self.photoList insertObject:data atIndex:data.index];
    [self.collectionView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoList count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width/2 -1,155);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PhotoModel *data = self.photoList[indexPath.row];
   
    cell.labelInfo.text  = data.title;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self buildPhotoURL:data]]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.photoImgView setImage:image];
        });
    });

    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
