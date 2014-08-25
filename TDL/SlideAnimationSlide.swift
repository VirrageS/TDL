import UIKit

class SlideNavigationControllerAnimatorSlide {
    let slideMovement: CGFloat = 0.0
    
    init() {
        //super.init()
        slideMovement = 100.0
    }
    
    func prepareMenuForAnimation() {
        let menuViewController: UIViewController = SlideNavigationController.sharedInstance(SlideNavigationController())()
    }
}

//@interface SlideNavigationContorllerAnimatorSlide : NSObject <SlideNavigationContorllerAnimator>
//
//@property (nonatomic, assign) CGFloat slideMovement;
//
//- (id)initWithSlideMovement:(CGFloat)slideMovement;
//
//@end
//
//@implementation SlideNavigationContorllerAnimatorSlide
//
//#pragma mark - Initialization -

//
//#pragma mark - SlideNavigationContorllerAnimation Methods -
//
//- (void)prepareMenuForAnimation:(Menu)menu
//{
//    UIViewController *menuViewController = (menu == MenuLeft)
//        ? [SlideNavigationController sharedInstance].leftMenu
//    : [SlideNavigationController sharedInstance].rightMenu;
//    
//    UIInterfaceOrientation orientation= [SlideNavigationController sharedInstance].interfaceOrientation;
//    CGRect rect = menuViewController.view.frame;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        if (orientation == UIInterfaceOrientationLandscapeRight)
//        {
//            rect.origin.y = (menu == MenuLeft) ? self.slideMovement*-1 : self.slideMovement;
//        }
//        else
//        {
//            rect.origin.y = (menu == MenuRight) ? self.slideMovement*-1 : self.slideMovement;
//        }
//    }
//    else
//    {
//        if (orientation == UIInterfaceOrientationPortrait)
//        {
//            rect.origin.x = (menu == MenuLeft) ? self.slideMovement*-1 : self.slideMovement;
//        }
//        else
//        {
//            rect.origin.x = (menu == MenuRight) ? self.slideMovement*-1 : self.slideMovement;
//        }
//    }
//    
//    menuViewController.view.frame = rect;
//    }
//    
//    - (void)animateMenu:(Menu)menu withProgress:(CGFloat)progress
//{
//    UIViewController *menuViewController = (menu == MenuLeft)
//        ? [SlideNavigationController sharedInstance].leftMenu
//    : [SlideNavigationController sharedInstance].rightMenu;
//    
//    UIInterfaceOrientation orientation= [SlideNavigationController sharedInstance].interfaceOrientation;
//    
//    NSInteger location = (menu == MenuLeft)
//    ? (self.slideMovement * -1) + (self.slideMovement * progress)
//    : (self.slideMovement * (1-progress));
//    
//    if (menu == MenuLeft)
//    location = (location > 0) ? 0 : location;
//    
//    if (menu == MenuRight)
//    location = (location < 0) ? 0 : location;
//    
//    CGRect rect = menuViewController.view.frame;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
//    }
//    else
//    {
//        rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
//    }
//    
//    menuViewController.view.frame = rect;
//    }
//    
//    - (void)clear
//        {
//            [self clearMenu:MenuLeft];
//            [self clearMenu:MenuRight];
//    }
//    
//#pragma mark - Private Method -
//
//- (void)clearMenu:(Menu)menu
//{
//    UIViewController *menuViewController = (menu == MenuLeft)
//        ? [SlideNavigationController sharedInstance].leftMenu
//    : [SlideNavigationController sharedInstance].rightMenu;
//    
//    UIInterfaceOrientation orientation= [SlideNavigationController sharedInstance].interfaceOrientation;
//    
//    CGRect rect = menuViewController.view.frame;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        rect.origin.y = 0;
//    }
//    else
//    {
//        rect.origin.x = 0;
//    }
//    
//    menuViewController.view.frame = rect;
//}
