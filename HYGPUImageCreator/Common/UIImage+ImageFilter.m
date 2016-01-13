//
//  UIImage+ImageFilter.m
//  HYGPUImageCreator
//
//  Created by Shadow on 16/1/13.
//  Copyright © 2016年 Shadow. All rights reserved.
//

#import "UIImage+ImageFilter.h"
#import "GPUImage.h"

@implementation UIImage (ImageFilter)

- (UIImage *)_processFilters:(NSArray *)filters
{
  GPUImagePicture *sourceImage = [[GPUImagePicture alloc]initWithImage:self];
  GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc]init];
  
  for (NSInteger i = filters.count - 1; i >= 0; i--) {
    GPUImageOutput<GPUImageInput> *this = filters[i];
    [group addTarget:this];
    
    if (i <= 0) {
      continue;
    }
    
    GPUImageOutput<GPUImageInput> *pre = filters[i - 1];
    [pre addTarget:this];
  }
  
  [group setInitialFilters:@[filters.firstObject]];
  [group setTerminalFilter:filters.lastObject];
  
  [sourceImage addTarget:group];
  [group useNextFrameForImageCapture];
  [sourceImage processImage];
  
  UIImage *destinationImage = [group imageFromCurrentFramebufferWithOrientation:self.imageOrientation];
  [self _releaseMemory];
  
  return destinationImage;
}

- (void)_releaseMemory
{
  [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

@end
