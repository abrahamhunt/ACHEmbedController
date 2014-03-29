//
//  ACHEmbedController.m
//  StoryBoardEmbedding
//
//  Created by Abraham Hunt on 1/3/14.
//  Copyright (c) 2014 Headache Technologies. All rights reserved.
//

#import "ACHEmbedController.h"

@implementation CustomACHEmbedSegue

- (void)perform
{
    //empty all transitioning happens in the Controller
}

@end

@interface ACHEmbedController ()

@property (nonatomic,strong) NSMutableDictionary *embeddedControllers;
@property (nonatomic) NSUInteger currentIndex;
@end

@implementation ACHEmbedController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentIndex = -1;
    [self performSegueWithIdentifier:[self.embedSegueIdentifiers firstObject] sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationController = segue.destinationViewController;
    [self addChildViewController:destinationController];
    destinationController.view.frame = self.view.bounds;
    [self.embeddedControllers setObject:destinationController forKey:segue.identifier];
    NSInteger embedIndex = [self.embedSegueIdentifiers indexOfObject:segue.identifier];
    if (embedIndex == 0 && self.currentIndex == -1)//initial setup
    {
        [self.view addSubview:destinationController.view];
        [destinationController didMoveToParentViewController:self];
        self.currentIndex = 0;
    }
    else
    {
        [self swapFromViewController:sender toViewController:destinationController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSMutableArray *disposableSegueIdentifiers = [self.embedSegueIdentifiers mutableCopy];
    [disposableSegueIdentifiers removeObjectAtIndex:self.currentIndex];
    [disposableSegueIdentifiers enumerateObjectsUsingBlock:^(NSString *embedIdentifier, NSUInteger idx, BOOL *stop) {
        UIViewController *aController = [self.embeddedControllers objectForKey:embedIdentifier];
        [aController removeFromParentViewController];
        [self.embeddedControllers removeObjectForKey:embedIdentifier];
    }];
}

#pragma mark - Public Methods

- (void)swapToControllerAtIndex:(NSInteger)index
{
    if (index != self.currentIndex)
    {
        UIViewController *newController = self.embeddedControllers[self.embedSegueIdentifiers[index]];
        UIViewController *currentController = self.embeddedControllers[self.embedSegueIdentifiers[self.currentIndex]];
        if (!newController)//controller doesn't exist, create with segue, and swap to it
        {
            [self performSegueWithIdentifier:self.embedSegueIdentifiers[index] sender:currentController];
        }
        else//does exist just swap to it
        {
            [self swapFromViewController:currentController toViewController:newController];
        }
        self.currentIndex = index;
    }
}

#pragma mark - Private Methods

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    [fromViewController willMoveToParentViewController:nil];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [toViewController didMoveToParentViewController:self];
    }];
}

#pragma mark - Properties
- (NSMutableDictionary *)embeddedControllers
{
    if (!_embeddedControllers)
    {
        _embeddedControllers = [NSMutableDictionary dictionary];
    }
    return _embeddedControllers;
}
@end
