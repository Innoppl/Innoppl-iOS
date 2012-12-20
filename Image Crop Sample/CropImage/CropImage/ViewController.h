//
//  ViewController.h
//  CropImage
//
//  Created by Jagadeesh Deivasigamani on 20/12/12.
//  Copyright (c) 2012 Innoppl Technlogies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INImageCropperView.h"
@interface ViewController : UIViewController
{
    INImageCropperView *imgCropper;
    
    UIImage *img;

}

@property (nonatomic, strong) INImageCropperView *imgCropper;
@property (nonatomic, strong) UIImage *img;

@end
