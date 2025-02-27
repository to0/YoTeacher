//
// REFrostedContainerViewController.m
// REFrostedViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REFrostedContainerViewController.h"
#import "UIImage+REFrostedViewController.h"
#import "UIView+REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "RECommonFunctions.h"

@interface REFrostedContainerViewController ()

@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
//@property (strong, readwrite, nonatomic) UIView *backgroundView;
@property (strong, readwrite, nonatomic) NSMutableArray *backgroundViews;
@property (strong, readwrite, nonatomic) UIView *containerView;
@property (assign, readwrite, nonatomic) CGPoint containerOrigin;

@end

@interface REFrostedViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;

@end

@implementation REFrostedContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.backgroundViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.0f;
        [self.view addSubview:backgroundView];
        [self.backgroundViews addObject:backgroundView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
    }
    
    self.containerView = [[UIView alloc] initWithFrame:self.showFrame/*CGRectMake(0, 0, 250, self.view.frame.size.height)*/];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];
    
    if (self.frostedViewController.liveBlur) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barStyle = (UIBarStyle)self.frostedViewController.liveBlurBackgroundStyle;
        if ([toolbar respondsToSelector:@selector(setBarTintColor:)])
            [toolbar performSelector:@selector(setBarTintColor:) withObject:self.frostedViewController.blurTintColor];
        [self.containerView addSubview:toolbar];

    } else {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.containerView addSubview:self.backgroundImageView];
    }
    
    [self addChildViewController:self.frostedViewController.menuViewController];
    self.frostedViewController.menuViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.frostedViewController.menuViewController.view];
    [self.frostedViewController.menuViewController didMoveToParentViewController:self];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.frostedViewController.menuViewController beginAppearanceTransition:YES animated:animated];
    
    self.backgroundImageView.image = self.screenshotImage;
    self.backgroundImageView.frame = self.view.bounds;
    self.frostedViewController.menuViewController.view.frame = self.containerView.bounds;
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [self setContainerFrame:CGRectMake(- self.frostedViewController.minimumMenuViewSize.width, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [self setContainerFrame:CGRectMake(self.view.frame.size.width, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [self setContainerFrame:CGRectMake(self.showFrame.origin.y, -self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [self setContainerFrame:CGRectMake(self.showFrame.origin.y, self.view.frame.size.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
    }
    
    if (self.animateApperance)
        [self show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.frostedViewController.menuViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.frostedViewController.menuViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.frostedViewController.menuViewController endAppearanceTransition];
}

- (void)setContainerFrame:(CGRect)frame
{
    UIView *leftBackgroundView = self.backgroundViews[0];
    UIView *topBackgroundView = self.backgroundViews[1];
    UIView *bottomBackgroundView = self.backgroundViews[2];
    UIView *rightBackgroundView = self.backgroundViews[3];
    
    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x, self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x, 0, self.view.frame.size.width - frame.size.width - frame.origin.x, self.view.frame.size.height);
    
    topBackgroundView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    bottomBackgroundView.frame = CGRectMake(frame.origin.x, frame.size.height + frame.origin.y, frame.size.width, self.view.frame.size.height);
    
    self.containerView.frame = frame;
    self.backgroundImageView.frame = CGRectMake(- frame.origin.x, - frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha
{
    for (UIView *view in self.backgroundViews) {
        view.alpha = alpha;
    }
}

- (void)show
{
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0.3f];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0.3f];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.showFrame.origin.y, 0, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0.3f];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.showFrame.origin.y, self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0.3f];
        }];
    }
}

- (void)hide
{
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(- self.frostedViewController.minimumMenuViewSize.width, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width, self.showFrame.origin.y, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.showFrame.origin.y, -self.frostedViewController.minimumMenuViewSize.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
    
    if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.showFrame.origin.y, self.view.frame.size.height, self.frostedViewController.minimumMenuViewSize.width, self.frostedViewController.minimumMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
        }];
    }
}

- (void)refreshBackgroundImage
{
    self.backgroundImageView.image = self.screenshotImage;
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerOrigin = self.containerView.frame.origin;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.width = self.frostedViewController.minimumMenuViewSize.width + self.containerOrigin.x + point.x;
                    if (frame.size.width > self.view.frame.size.width)
                        frame.size.width = self.view.frame.size.width;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x < self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width) {
                frame.origin.x = self.view.frame.size.width - self.frostedViewController.minimumMenuViewSize.width;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.x = self.containerOrigin.x + point.x;
                    if (frame.origin.x < 0)
                        frame.origin.x = 0;
                    frame.size.width = self.view.frame.size.width - frame.origin.x;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y > 0) {
                frame.origin.y = 0;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.height = self.frostedViewController.minimumMenuViewSize.height + self.containerOrigin.y + point.y;
                    if (frame.size.height > self.view.frame.size.height)
                        frame.size.height = self.view.frame.size.height;
                }
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y < self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height) {
                frame.origin.y = self.view.frame.size.height - self.frostedViewController.minimumMenuViewSize.height;
            
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.y = self.containerOrigin.y + point.y;
                    if (frame.origin.y < 0)
                        frame.origin.y = 0;
                    frame.size.height = self.view.frame.size.height - frame.origin.y;
                }
            }
        }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionLeft) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionRight) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionTop) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == REFrostedViewControllerDirectionBottom) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
    }
}

@end
