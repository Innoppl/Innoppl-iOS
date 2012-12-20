//
//  INImageCropperView.m
//  CropImage
//
//  Created by Jagadeesh Deivasigamani on 20/12/12.
//  Copyright (c) 2012 Innoppl Technlogies. All rights reserved.
//
#define getX(rect) rect.origin.x
#define getY(rect) rect.origin.y
#define getHeight(rect) rect.size.height
#define getWidth(rect) rect.size.width
#import "INImageCropperView.h"

@implementation INImageCropperView
@dynamic crop;
@dynamic image;
@dynamic unscaledCrop;
@synthesize baseImageView;

- (UIImage*)image {
    return baseImageView.image;
}

- (void)setImage:(UIImage *)image {
    baseImageView.image = image;
   
}




- (void)constrainCropToImage {
    CGRect frame = cropRectView.frame;
    
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    
    BOOL change = NO;
    
    do {
        change = NO;
        
        if (getX(frame) < 0) {
            frame.origin.x = 0;
            change = YES;
        }
        
        if (getWidth(frame) > getWidth(cropRectView.superview.frame)) {
            frame.size.width = getWidth(cropRectView.superview.frame);
            change = YES;
        }
        
        if (getWidth(frame) < 20) {
            frame.size.width = 20;
            change = YES;
        }
        
        if (getX(frame) + getWidth(frame) > getWidth(cropRectView.superview.frame)) {
            frame.origin.x = getWidth(cropRectView.superview.frame) - getWidth(frame);
            change = YES;
        }
        
        if (getY(frame) < 0) {
            frame.origin.y = 0;
            change = YES;
        }
        
        if (getHeight(frame) > getHeight(cropRectView.superview.frame)) {
            frame.size.height = getHeight(cropRectView.superview.frame);
            change = YES;
        }
        
        if (getHeight(frame) < 20) {
            frame.size.height = 20;
            change = YES;
        }
        
        if (getY(frame) + getHeight(frame) > getHeight(cropRectView.superview.frame)) {
            frame.origin.y = getHeight(cropRectView.superview.frame) - getHeight(frame);
            change = YES;
        }
    } while (change);
    
    cropRectView.frame = frame;
}

- (void)updateBounds {
    [self constrainCropToImage];
    
    CGRect frame = cropRectView.frame;
    CGFloat x = getX(frame);
    CGFloat y = getY(frame);
    CGFloat width = getWidth(frame);
    CGFloat height = getHeight(frame);
    
    CGFloat selfWidth = getWidth(self.baseImageView.frame);
    CGFloat selfHeight = getHeight(self.baseImageView.frame);
    
    topView.frame = CGRectMake(x, -1, width + 1, y);
    bottomView.frame = CGRectMake(x, y + height, width, selfHeight - y - height);
    leftView.frame = CGRectMake(-1, y, x + 1, height);
    rightView.frame = CGRectMake(x + width, y, selfWidth - x - width, height);
    
    topLeftView.frame = CGRectMake(-1, -1, x + 1, y + 1);
    topRightView.frame = CGRectMake(x + width, -1, selfWidth - x - width, y + 1);
    bottomLeftView.frame = CGRectMake(-1, y + height, x + 1, selfHeight - y - height);
    bottomRightView.frame = CGRectMake(x + width, y + height, selfWidth - x - width, selfHeight - y - height);
    
    [self didChangeValueForKey:@"crop"];
}

- (CGRect)crop {
    CGRect frame = cropRectView.frame;
    
    if (frame.origin.x <= 0)
        frame.origin.x = 0;
    
    if (frame.origin.y <= 0)
        frame.origin.y = 0;
    
    
    return CGRectMake(frame.origin.x / imageScale, frame.origin.y / imageScale, frame.size.width / imageScale, frame.size.height / imageScale);;
}

- (void)setCrop:(CGRect)crop {
    cropRectView.frame = CGRectMake(crop.origin.x * imageScale, crop.origin.y * imageScale, crop.size.width * imageScale, crop.size.height * imageScale);
    [self updateBounds];
}

- (CGRect)unscaledCrop {
    CGRect crop = self.crop;
    return CGRectMake(crop.origin.x * imageScale, crop.origin.y * imageScale, crop.size.width * imageScale, crop.size.height * imageScale);
}

- (UIView*)newEdgeView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    
    [self.baseImageView addSubview:view];
    
    return view;
}

- (UIView*)newCornerView {
    UIView *view = [self newEdgeView];
    view.alpha = 0.75;
    
    return view;
}

+ (UIView *)initialCropViewForImageView:(UIImageView*)imageView {
    // 3/4 the size, centered
    
    CGRect max = imageView.bounds;
    
    CGFloat width  = getWidth(max) / 4 * 3;
    CGFloat height = getHeight(max) / 4 * 3;
    CGFloat x      = (getWidth(max) - width) / 2;
    CGFloat y      = (getHeight(max) - height) / 2;
    
    UIView* cropView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    cropView.layer.borderColor = [[UIColor whiteColor] CGColor];
    cropView.layer.borderWidth = 2.0;
    cropView.backgroundColor = [UIColor clearColor];
    cropView.alpha = 0.4;
    

    return cropView;

}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    cropRectView = [INImageCropperView initialCropViewForImageView:baseImageView];
    [self.baseImageView addSubview:cropRectView];
    
    topView = [self newEdgeView];
    bottomView = [self newEdgeView];
    leftView = [self newEdgeView];
    rightView = [self newEdgeView];
    topLeftView = [self newCornerView];
    topRightView = [self newCornerView];
    bottomLeftView = [self newCornerView];
    bottomRightView = [self newCornerView];
    

    [self updateBounds];
}

- (CGRect)calcFrameWithImage:(UIImage*)image andMaxSize:(CGSize)maxSize {
    CGFloat increase = 40.0 * 2;
    
    // if it already fits, return that
    CGRect noScale = CGRectMake(0.0, 0.0, image.size.width + increase, image.size.height + increase);
    if (getWidth(noScale) <= maxSize.width && getHeight(noScale) <= maxSize.height) {
        imageScale = 1.0;
        return noScale;
    }
    
    CGRect scaled;
    
    // first, try scaling the height to fit
    imageScale = (maxSize.height - increase) / image.size.height;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale + increase, image.size.height * imageScale + increase);
    if (getWidth(scaled) <= maxSize.width && getHeight(scaled) <= maxSize.height) {
        return scaled;
    }
    
    // scale with width if that failed
    imageScale = (maxSize.width - increase) / image.size.width;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale + increase, image.size.height * imageScale + increase);
    return scaled;
}


#pragma def Init methods overloading


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        imageScale = 1.0;
        baseImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 40.0, 40.0)];
        [self addSubview:baseImageView];
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageScale = 1.0;
        baseImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 40.0, 40.0)];
        [self addSubview:baseImageView];
        [self setup];
    }
    
    return self;
}

- (id)initWithImage:(UIImage*)newImage {
    self = [super init];
    if (self) {
        imageScale = 1.0;
        baseImageView = [[UIImageView alloc] initWithImage:newImage];
        self.frame = CGRectInset(baseImageView.frame, -40.0, -40.0);
        [self addSubview:baseImageView];
        [self setup];
    }
    
    return self;
}

- (id)initWithImage:(UIImage*)newImage andMaxSize:(CGSize)maxSize {
    self = [super init];
    if (self) {
        self.frame = [self calcFrameWithImage:newImage andMaxSize:maxSize];
        
        baseImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 40.0, 40.0)];
        
        baseImageView.image = newImage;
        [self addSubview:baseImageView];
        [self setup];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count]) {
        case 1: {
            currentTouches = 1;
            isPanning = NO;
            CGFloat insetAmount = 20.0;
            
            CGPoint touch = [[allTouches anyObject] locationInView:self.baseImageView];
            if (CGRectContainsPoint(CGRectInset(cropRectView.frame, insetAmount, insetAmount), touch)) {
                isPanning = YES;
                panTouch = touch;
                return;
            }
            
            CGRect frame = cropRectView.frame;
            CGFloat x = touch.x;
            CGFloat y = touch.y;
            
            currentDragView = nil;
            
            // We start dragging if we're within the rect + the inset amount
            // If we're definitively in the rect we actually start moving right to the point
            
            if (CGRectContainsPoint(CGRectInset(topLeftView.frame, -insetAmount, -insetAmount), touch)) {
                currentDragView = topLeftView;
                
                if (CGRectContainsPoint(topLeftView.frame, touch)) {
                    frame.size.width += getX(frame) - x;
                    frame.size.height += getY(frame) - y;
                    frame.origin = touch;
                }
            }
            else if (CGRectContainsPoint(CGRectInset(topRightView.frame, -insetAmount, -insetAmount), touch)) {
                currentDragView = topRightView;
                
                if (CGRectContainsPoint(topRightView.frame, touch)) {
                    frame.size.height += getY(frame) - y;
                    frame.origin.y = y;
                    frame.size.width = x - getX(frame);
                }
            }
            else if (CGRectContainsPoint(CGRectInset(bottomLeftView.frame, -insetAmount, -insetAmount), touch)) {
                currentDragView = bottomLeftView;
                
                if (CGRectContainsPoint(bottomLeftView.frame, touch)) {
                    frame.size.width += getX(frame) - x;
                    frame.size.height = y - getY(frame);
                    frame.origin.x =x;
                }
            }
            else if (CGRectContainsPoint(CGRectInset(bottomRightView.frame, -insetAmount, -insetAmount), touch)) {
                currentDragView = bottomRightView;
                
                if (CGRectContainsPoint(bottomRightView.frame, touch)) {
                    frame.size.width = x - getX(frame);
                    frame.size.height = y - getY(frame);
                }
            }
            else if (CGRectContainsPoint(CGRectInset(topView.frame, 0, -insetAmount), touch)) {
                currentDragView = topView;
                
                if (CGRectContainsPoint(topView.frame, touch)) {
                    frame.size.height += getY(frame) - y;
                    frame.origin.y = y;
                }
            }
            else if (CGRectContainsPoint(CGRectInset(bottomView.frame, 0, -insetAmount), touch)) {
                currentDragView = bottomView;
                
                if (CGRectContainsPoint(bottomView.frame, touch)) {
                    frame.size.height = y - getY(frame);
                }
            }
            else if (CGRectContainsPoint(CGRectInset(leftView.frame, -insetAmount, 0), touch)) {
                currentDragView = leftView;
                
                if (CGRectContainsPoint(leftView.frame, touch)) {
                    frame.size.width += getX(frame) - x;
                    frame.origin.x = x;
                }
            }
            else if (CGRectContainsPoint(CGRectInset(rightView.frame, -insetAmount, 0), touch)) {
                currentDragView = rightView;
                
                if (CGRectContainsPoint(rightView.frame, touch)) {
                    frame.size.width = x - getX(frame);
                }
            }
            
            cropRectView.frame = frame;
            
            [self updateBounds];
            
            break;
        }
        case 2: {
            CGPoint touch1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self.baseImageView];
            CGPoint touch2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self.baseImageView];
            
            if (currentTouches == 0 && CGRectContainsPoint(cropRectView.frame, touch1) && CGRectContainsPoint(cropRectView.frame, touch2)) {
                isPanning = YES;
            }
            
            currentTouches = [allTouches count];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count])
    {
        case 1: {
            CGPoint touch = [[allTouches anyObject] locationInView:self.baseImageView];
            
            if (isPanning) {
                CGPoint touchCurrent = [[allTouches anyObject] locationInView:self.baseImageView];
                CGFloat x = touchCurrent.x - panTouch.x;
                CGFloat y = touchCurrent.y - panTouch.y;
                
                cropRectView.center = CGPointMake(cropRectView.center.x + x, cropRectView.center.y + y);
                
                panTouch = touchCurrent;
            }
            else if ((CGRectContainsPoint(self.bounds, touch))) {
                CGRect frame = cropRectView.frame;
                CGFloat x = touch.x;
                CGFloat y = touch.y;
                
                if (x > self.baseImageView.frame.size.width)
                    x = self.baseImageView.frame.size.width;
                
                if (y > self.baseImageView.frame.size.height)
                    y = self.baseImageView.frame.size.height;
                
                
                if (currentDragView == topView) {
                    frame.size.height += getY(frame) - y;
                    frame.origin.y = y;
                }
                else if (currentDragView == bottomView) {
                    //currentDragView = bottomView;
                    frame.size.height = y - getY(frame);
                }
                else if (currentDragView == leftView) {
                    frame.size.width += getX(frame) - x;
                    frame.origin.x = x;
                }
                else if (currentDragView == rightView) {
                    //currentDragView = rightView;
                    frame.size.width = x - getX(frame);
                }
                else if (currentDragView == topLeftView) {
                    frame.size.width += getX(frame) - x;
                    frame.size.height += getY(frame) - y;
                    frame.origin = touch;
                }
                else if (currentDragView == topRightView) {
                    frame.size.height += getY(frame) - y;
                    frame.origin.y = y;
                    frame.size.width = x - getX(frame);
                }
                else if (currentDragView == bottomLeftView) {
                    frame.size.width += getX(frame) - x;
                    frame.size.height = y - getY(frame);
                    frame.origin.x =x;
                }
                else if ( currentDragView == bottomRightView) {
                    frame.size.width = x - getX(frame);
                    frame.size.height = y - getY(frame);
                }
                
                cropRectView.frame = frame;
            }
        } break;
        case 2: {
            CGPoint touch1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self.baseImageView];
            CGPoint touch2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self.baseImageView];
            
            if (isPanning) {
                CGFloat distance = [self distanceBetweenTwoPoints:touch1 toPoint:touch2];
                
                if (scaleDistance != 0) {
                    CGFloat scale = 1.0f + ((distance-scaleDistance)/scaleDistance);
                    
                    CGPoint originalCenter = cropRectView.center;
                    CGSize originalSize = cropRectView.frame.size;
                    
                    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
                    
                    if (newSize.width >= 50 && newSize.height >= 50 && newSize.width <= getWidth(cropRectView.superview.frame) && newSize.height <= getHeight(cropRectView.superview.frame)) {
                        cropRectView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
                        cropRectView.center = originalCenter;
                    }
                }
                
                scaleDistance = distance;
            }
            else if (
                     currentDragView == topLeftView ||
                     currentDragView == topRightView ||
                     currentDragView == bottomLeftView ||
                     currentDragView == bottomRightView
                     ) {
                CGFloat x = MIN(touch1.x, touch2.x);
                CGFloat y = MIN(touch1.y, touch2.y);
                
                CGFloat width = MAX(touch1.x, touch2.x) - x;
                CGFloat height = MAX(touch1.y, touch2.y) - y;
                
                cropRectView.frame = CGRectMake(x, y, width, height);
            }
            else if (
                     currentDragView == topView ||
                     currentDragView == bottomView
                     ) {
                CGFloat y = MIN(touch1.y, touch2.y);
                CGFloat height = MAX(touch1.y, touch2.y) - y;
                
                // sometimes the multi touch gets in the way and registers one finger as two quickly
                // this ensures the crop only shrinks a reasonable amount all at once
                if (height > 30 || cropRectView.frame.size.height < 45)
                {
                    cropRectView.frame = CGRectMake(getX(cropRectView.frame), y, getWidth(cropRectView.frame), height);
                }
            }
            else if (
                     currentDragView == leftView ||
                     currentDragView == rightView
                     ) {
                CGFloat x = MIN(touch1.x, touch2.x);
                CGFloat width = MAX(touch1.x, touch2.x) - x;
                
                // sometimes the multi touch gets in the way and registers one finger as two quickly
                // this ensures the crop only shrinks a reasonable amount all at once
                if (width > 30 || cropRectView.frame.size.width < 45)
                {                cropRectView.frame = CGRectMake(x, getY(cropRectView.frame), width, getHeight(cropRectView.frame));
                }
            }
        } break;
    }
    
    [self updateBounds];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    scaleDistance = 0;
    currentTouches = [[event allTouches] count];
}

- (UIImage*) getCroppedImage {
    CGRect rect = self.crop;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.image.size.width, self.image.size.height);
    //CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height);
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [self.image drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = [self imageWithImage:UIGraphicsGetImageFromCurrentImageContext() scaledToWidth:120.0f];
    //[self imageByScalingToSize:CGSizeMake(120,120) image:UIGraphicsGetImageFromCurrentImageContext()];
    
    UIGraphicsEndImageContext();
    
    
    return croppedImage;
}
static inline double radians (double degrees) {return degrees * M_PI/180;}

-(UIImage*)imageByScalingToSize:(CGSize)targetSize image:(UIImage*)img
{
    
    //Scalling image to  given size
	UIImage* sourceImage = img;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
    
	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
    
	CGContextRef bitmap;
    
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	}
    
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
    
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
	return newImage;
}


-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    //Scale image to a particular width
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




@end
