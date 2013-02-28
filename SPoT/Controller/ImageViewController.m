//
//  ImageViewController.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIPopoverController *urlPopover;

@end

@implementation ImageViewController

// returns whether the "Show URL" segue should be allowed to fire
// prohibits the segue if we don't have a URL set in us yet or
//  if a popover showing the URL is already visible

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]) {
        return (self.imageURL && !self.urlPopover.popoverVisible) ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

// uses an AttributedStringViewController to display the URL of the image we are currently displaying
// if being presented by a Popover segue, grab ahold of the popover so that we can avoid
//  putting it up multiple times (by prohibiting it in shouldPerformSegueWithIdentfier:sender:)

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show URL"]) {
        if ([segue.destinationViewController isKindOfClass:[AttributedStringViewController class]]) {
            AttributedStringViewController *asc = (AttributedStringViewController *)segue.destinationViewController;
            asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
                self.urlPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
            }
        }
    }
}

// sets the title of the titleBarButtonItem (if connected) to the passed title

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// sets the title of the titleBarButtonItem (if connected) to self.title
//  (just in case setTitle: was called before self.titleBarButtonItem outlet was loaded)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

-(void)viewWillLayoutSubviews
{
    CGFloat imageHeightToWidthScale = self.imageView.image.size.height/self.imageView.image.size.width;
    CGFloat scrollViewHeightToWidthScale = self.scrollView.bounds.size.height/self.scrollView.bounds.size.width;
    if (imageHeightToWidthScale > scrollViewHeightToWidthScale) {
        [self.scrollView zoomToRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.width*scrollViewHeightToWidthScale) animated:YES];
    }
    else {
        [self.scrollView zoomToRect:CGRectMake(0, 0, self.imageView.image.size.height/scrollViewHeightToWidthScale, self.imageView.image.size.width) animated:YES];
    }
}


@end
