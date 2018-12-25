//
//  LoadingView.m
//  PetrolBao
//
//  Created by mac on 13-5-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "LoadingView.h"

#if __has_feature(objc_arc)
    #define MB_RETAIN(exp) exp
#else
    #define MB_RETAIN(exp) [exp retain]
#endif

#define loadingWidth Size(230)
#define loadingheight Size(75)

@implementation LoadingView

@synthesize labelText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.labelText = @"加载中...";
    }
    return self;
}

- (void)showLoadingView:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated
{
    methodForExecution = method;
	targetForExecution = MB_RETAIN(target);
	objectForExecution = MB_RETAIN(object);
    [self initLabel];
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
}

- (void)showLoadingViewOnly
{
    [self initLabel];
}

- (void)initLabel
{
    for (UIView *subVi in self.subviews) {
        [subVi removeFromSuperview];
    }
    [self.layer removeAllAnimations];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth -loadingWidth)/2, (kScreenHeight -loadingheight)/2, loadingWidth, loadingheight)];
    loadingView.backgroundColor = COLOR(68, 83, 91, 1);
    loadingView.layer.cornerRadius = Size(8);
    [self addSubview:loadingView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), 0, loadingWidth-Size(15 *2), loadingheight)];
    lab.font = SystemFontOfSize(14);
    lab.textColor = BACKGROUND_DARK_COLOR;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.labelText;
    [loadingView addSubview:lab];
    
}

- (void)launchExecution
{
	@autoreleasepool {
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
        //[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
		//[self performSelectorOnMainThread:methodForExecution withObject:nil waitUntilDone:NO];
        //[targetForExecution performSelectorOnMainThread:methodForExecution withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp
{
    targetForExecution = nil;
	objectForExecution = nil;
}

@end
