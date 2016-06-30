//
//  CollectionViewCell.m
//  MyFlickr
//
//  Created by Lakshmi Thulasiram on 29/06/16.
//  Copyright © 2016 Lakshmi Thulasiram. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.photoImgView=[[UIImageView alloc] initWithFrame:self.bounds];
        self.photoImgView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.photoImgView];
        
        self.labelInfo = [[UILabel alloc] initWithFrame:self.bounds];
        self.labelInfo.backgroundColor=[UIColor clearColor];
        self.labelInfo.hidden=YES;
        self.labelInfo.userInteractionEnabled=YES;
        self.labelInfo.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelInfo];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self.contentView addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)tapped
{
    if(self.labelInfo.hidden)
    {
        self.labelInfo.hidden=NO;

        [UIView transitionFromView:self.photoImgView toView:self.labelInfo
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            self.photoImgView.hidden=YES;
                        }];
    }
    else
    {
        self.photoImgView.hidden=NO;

        [UIView transitionFromView:self.labelInfo toView:self.photoImgView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            self.labelInfo.hidden=YES;
                            
                        }];    }
}
@end
