/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
	
//	//edite by yaofuyu 2011.8.16
//	if (image.size.width >= 1.4*image.size.height) {
//		UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
//		CGAffineTransform t = CGAffineTransformMakeRotation(M_PI/2);
//		rotatedViewBox.transform = t;
//		CGSize rotatedSize = rotatedViewBox.frame.size;
//		[rotatedViewBox release];
//		
//		// Create the bitmap context
//		UIGraphicsBeginImageContext(rotatedSize);
//		CGContextRef bitmap = UIGraphicsGetCurrentContext();
//		
//		// Move the origin to the middle of the image so we will rotate and scale around the center.
//		CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
//		
//		//   // Rotate the image context
//		CGContextRotateCTM(bitmap, M_PI/2);
//		
//		// Now, draw the rotated/scaled image into the context
//		CGContextScaleCTM(bitmap, 1.0, -1.0);
//		CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
//		
//		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		self.image = newImage;
//	}
//	//edite end
//	
//	else {
		self.image = image;
//	}
}

@end
