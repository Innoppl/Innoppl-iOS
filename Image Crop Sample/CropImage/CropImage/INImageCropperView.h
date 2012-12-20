//
//  INImageCropperView.h
//  CropImage
//
//  Created by Jagadeesh Deivasigamani on 20/12/12.
//  Copyright (c) 2012 Innoppl Technlogies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface INImageCropperView : UIView
{
    UIImageView *baseImageView;
    
    UIView *cropRectView;
    UIView *topView;
    UIView *bottomView;
    UIView *leftView;
    UIView *rightView;
    
    UIView *topLeftView;
    UIView *topRightView;
    UIView *bottomLeftView;
    UIView *bottomRightView;
    
    CGFloat imageScale;
    
    BOOL isPanning;
    NSInteger currentTouches;
    CGPoint panTouch;
    CGFloat scaleDistance;
    UIView *currentDragView;
}


@property (nonatomic, assign) CGRect crop;
@property (nonatomic, readonly) CGRect unscaledCrop;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain, readonly) UIImageView* baseImageView;

+ (UIView *)initialCropViewForImageView:(UIImageView*)imageView;

- (id)initWithImage:(UIImage*)newImage;
- (id)initWithImage:(UIImage*)newImage andMaxSize:(CGSize)maxSize;

- (UIImage*) getCroppedImage;



@end
