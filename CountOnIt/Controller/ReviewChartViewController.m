//
//  ReviewChartViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/6/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ReviewChartViewController.h"
#import "LoadingView.h"
#import "Global.h"
#import "UIColor+Utility.h"
#import "UIViewController+Utility.h"
#import "Tally.h"
#import "TallyChartView.h"
#import "UIImage+Utility.h"
#import "CountOnItInAppPurchases.h"
#import "UnlimitedInAppPurchaseViewController.h"

@interface ReviewChartViewController () <UIScrollViewDelegate, UnlimitedInAppPurchaseViewControllerDelegate>

@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) UIAlertView *errorAlertView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *imageToShare;
@property (strong, nonatomic) NSString *textToShare;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) TallyChartView *tallyChartView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL exportCompleted;

@end

@implementation ReviewChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Review Chart";

    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageView];
    self.imageView.image = self.imageToShare;
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)setExportCompleted:(BOOL)exportCompleted
{
    [[NSUserDefaults standardUserDefaults] setObject:exportCompleted ? @"YES" : @"NO" forKey:@"ReviewChartViewControllerExportCompleted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)exportCompleted
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReviewChartViewControllerExportCompleted"] isEqualToString:@"YES"] ? YES : NO;
}

#pragma mark - Unlimited In App Purchase

- (void)showUnlimitedInApPurchase
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UnlimitedInAppPurchaseViewController *unlimitedInAppPurchaseViewController = (UnlimitedInAppPurchaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Unlimited In App Purchase"];
    unlimitedInAppPurchaseViewController.delegate = self;
    
    [self presentViewController:unlimitedInAppPurchaseViewController animated:YES completion:nil];
}

- (void)dismissModal:(UnlimitedInAppPurchaseViewController *)sender
{
    NSLog(@"ReviewChartViewController: dismissModal: UnlimitedInAppPurchaseViewController");
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Do Export Chart"]) {
        NSLog(@"ReviewChartViewController: shouldPerformSegueWithIdentifier: Do Export Chart");
        return YES;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (IBAction)exportChart:(UIBarButtonItem *)sender
{
    if (!self.exportCompleted || [CountOnItInAppPurchases sharedInstance].unlimitedPurchased) {
        [self.loadingView show];
        [self performSelector:@selector(exportChart) withObject:nil afterDelay:GlobalDuration];
    } else {
        [self showUnlimitedInApPurchase];
    }
}

#pragma mark - Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width)?
    (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5f : 0.0f;
    
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height)?
    (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5f : 0.0f;
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX, scrollView.contentSize.height * 0.5f + offsetY);
}

#pragma mark - Interaction

- (void)exportChart
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ self.imageToShare, self.textToShare ] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAssignToContact ];
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        NSLog(@"ReviewChartViewController: activityViewController: setCompletionHandler: completed: %i", completed);
        if (completed) self.exportCompleted = YES;
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    [self.loadingView hide];
    [self.loadingView reset];
}

- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGFloat scale = 2.5f;
    [self.scrollView setZoomScale:self.scrollView.zoomScale == scale ? 0.0f : scale animated:YES];
}

#pragma mark - Drawing

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doubleTap:)];
        _tapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _tapGestureRecognizer;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        CGSize size = CGSizeMake(50.0f, 50.0f);
        CGRect frame = [UIViewController frame:self];
        CGPoint origin = CGPointMake((frame.size.width-size.width)/2, (frame.size.height-size.height)/2);
        frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _activityIndicatorView.layer.cornerRadius  = GlobalCornerRadius;
        _activityIndicatorView.layer.masksToBounds = YES;
        [self.view addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UIAlertView *)errorAlertView
{
    if (!_errorAlertView) {
        _errorAlertView = [[UIAlertView alloc] initWithTitle:@"Export Chart"
                                                     message:@"Unable to save to photo library."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    }
    return _errorAlertView;
}

- (NSString *)textToShare
{
    NSString *textToShare = @"";
    
    for (Tally *tally in self.chartTallies) {
        if (textToShare.length) textToShare = [textToShare stringByAppendingString:@"\n\n"];
        textToShare = [textToShare stringByAppendingString:tally.asSentence];
    }
    
    return textToShare;
}

- (UIImage *)imageToShare
{
    if (!_imageToShare) {
        _imageToShare = [UIImage imageWithView:self.tallyChartView];
    }
    return _imageToShare;
}

- (TallyChartView *)tallyChartView
{
    if (!_tallyChartView) {
        _tallyChartView = [[TallyChartView alloc] initWithTitle:self.chartTitle tallies:self.chartTallies];
    }
    return _tallyChartView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIViewController frame:self]];
        _scrollView.delegate = self;
        
        // NSLog(@"%f %f", _scrollView.frame.size.width, self.imageToShare.size.width);
        //0.64f;//320.0f/1000.0f;
        
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 2.5f;
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#a7a7aa"];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGSize size = self.imageToShare.size;
        
        CGFloat width, height;
        
        if (size.width > size.height) {
            width = self.view.frame.size.width;
            height = size.height/size.width*width;
        } else {
            width = self.view.frame.size.height;
            height = size.width/size.height*width;
        }
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width-width)/2.0f, (self.scrollView.frame.size.height-height)/2.0f, width, height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (LoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] init];
    }
    return _loadingView;
}

@end
