//
//  MDBannerImageCollectionViewCell.h
//  MealDeal
//
//  Created by Krati Agarwal on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPathButton.h"

@interface MDBannerImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet IndexPathButton *imageCrossBtn;

@property (weak, nonatomic) IBOutlet IndexPathButton *crossButton;
@property (weak, nonatomic) IBOutlet IndexPathButton *previewButton;

@property (strong, nonatomic) IBOutlet UIImageView *requestImgView;
@property (strong, nonatomic) IBOutlet UIWebView *requestDetailsVideoWebView;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayVideo;
@property (strong, nonatomic) IBOutlet UIWebView *imageVideoWebView;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayVideoDetails;

@end
