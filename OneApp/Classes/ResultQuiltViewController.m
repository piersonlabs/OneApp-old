//
//  ResultQuiltViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/9/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

#import "ResultQuiltViewController.h"

const NSInteger kNumberOfCells = 1000;

@interface ResultQuiltViewController ()

@property (nonatomic, retain) NSArray *images;

@end

@implementation ResultQuiltViewController

@synthesize images = _images;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_images release], _images = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.quiltView.backgroundColor = [UIColor blackColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - QuiltViewControllerDataSource

- (NSArray *)images {
    if (!_images) {
        NSMutableArray *imageNames = [NSMutableArray array];
        for(int i = 0; i < kNumberOfCells; i++) {
            [imageNames addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
        }
        _images = [imageNames retain];
    }
    return _images;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
    return [UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.images count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath 
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    
    cell.photoView.image = [self imageAtIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"response %d", indexPath.row + 1];
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft 
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self imageAtIndexPath:indexPath].size.height / [self quiltViewNumberOfColumns:quiltView];
}


@end
