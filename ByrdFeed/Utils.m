//
//  Utils.m
//  Findr
//
//  Created by Eddie Freeman on 6/17/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Utils.h"
#import "UIImageView+AFNetworking.h"

@interface Utils()

@end

@implementation Utils

+ (void)loadImageUrl:(NSURL *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
//  NSURL *urlObject = [NSURL URLWithString:url];
  __weak UIImageView *iv = imageView;
  
  [imageView
   setImageWithURLRequest:[NSURLRequest requestWithURL:url]
   placeholderImage:nil
   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     if (enableAnimation) {
       iv.alpha = 0.0;
       iv.image = image;
       [UIView animateWithDuration:0.5
                        animations:^{
                          iv.alpha = 1.0;
                        }];
     } else {
       iv.image = image;
     }
   }
   failure:nil];
}

@end
