//
//  ACHEmbedController.h
//  StoryBoardEmbedding
//
//  Created by Abraham Hunt on 1/3/14.
//  Copyright (c) 2014 Headache Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomACHEmbedSegue : UIStoryboardSegue

@end

@interface ACHEmbedController : UIViewController

@property (nonatomic,strong) NSArray *embedSegueIdentifiers;
@property (nonatomic) NSTimeInterval fadeDuration;
- (void)swapToControllerAtIndex:(NSInteger)index;

@end
