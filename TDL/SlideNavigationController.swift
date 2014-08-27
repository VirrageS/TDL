import UIKit
import QuartzCore

var MENU_SLIDE_ANIMATION_DURATION: NSTimeInterval = 0.3
var MENU_QUICK_SLIDE_ANIMATION_DURATION: NSTimeInterval = 0.18
var MENU_IMAGE = "menu-button"
var MENU_SHADOW_RADIUS: CGFloat = 10
var MENU_SHADOW_OPACITY: Float = 1
var MENU_DEFAULT_SLIDE_OFFSET: CGFloat = 60.0
var MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION = 1200
var STATUS_BAR_HEIGHT = 20

class SlideNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate  {
    enum PopType {
        case PopTypeAll
        case PopTypeRoot
    }
    
    let slideNavigationControllerShouldDisplayLeftMenu: Bool = true
    let avoidSwitchingToSameClassViewController: Bool = true
    var _enableSwipeGesture: Bool = true
    var enableShadow: Bool? = true
    var menu: UIViewController?
    var leftBarButtonItem: UIBarButtonItem?
//    let rightBarButtonItem: UIBarButtonItem
    let portraitSlideOffset: CGFloat = 60.0
    let landscapeSlideOffset: CGFloat = 0.0
    let panGestureSideOffset: CGFloat = 50.0
//    let sharedInstance: SlideNavigationController?
    var _tapRecognizer: UITapGestureRecognizer?
    var _panRecognizer: UIPanGestureRecognizer?
    var draggingPoint: CGPoint!
    var singletonInstance: SlideNavigationController?
    let lastRevealedMenu: AnyObject?
    var _menuRevealAnimator: SlideNavigationControllerAnimatorSlide?
//    @property (nonatomic, strong) id <SlideNavigationContorllerAnimator> menuRevealAnimator;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        
        singletonInstance = self
        landscapeSlideOffset = MENU_DEFAULT_SLIDE_OFFSET
        portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET
        panGestureSideOffset = 0
        avoidSwitchingToSameClassViewController = true
        _enableSwipeGesture = true
        delegate = self
    }

    
    func sharedInstance() -> SlideNavigationController {
        if singletonInstance == nil {
            println("\(singletonInstance) SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code")
        }
    
        return singletonInstance!
    }


    func initWithRootViewController(rootViewController: UIViewController) -> AnyObject! {
//        setup()
    
        return self;
    }
    

    
    override func viewWillLayoutSubviews()  {
        super.viewWillLayoutSubviews()
    
    // Update shadow size of enabled
        if (enableShadow != nil) {
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        enableTapGestureToCloseMenu(false)
        view.layer.shadowOpacity = 0
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        
        updateMenuFrameAndTransformAccordingToOrientation()
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
        view.layer.shadowOpacity = MENU_SHADOW_OPACITY
    }

    func switchToViewController(viewController: UIViewController, slideOutAnimation: Bool, poptype: PopType, completion: (Bool) -> Void) {
        if avoidSwitchingToSameClassViewController { // missing && [self.topViewController isKindOfClass:viewController.class])
            closeMenuWithCompletion(completion)
            return;
        }
    
        let switchAndCallCompletion = { (closeMenuBeforeCallingCompletion: Bool) -> () in
            if poptype == PopType.PopTypeAll {
                self.setViewControllers([viewController], animated: false)
            } else {
                self.popToRootViewControllerAnimated(false)
                self.pushViewController(viewController, animated: false)
            }
        
            if closeMenuBeforeCallingCompletion {
                self.closeMenuWithCompletion(completion)
            }
        }
        
        if isMenuOpen() {
            if slideOutAnimation {
                UIView.animateWithDuration(MENU_SLIDE_ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    var width: CGFloat = self.horizontalSize()
                    var moveLocation: CGFloat = self.horizontalLocation() > 0 ? width : width*(-1)
                    self.moveHorizontallyToLocation(moveLocation)
                    }, completion: { (Bool) -> Void in
                        switchAndCallCompletion(true)
                })
            } else {
                switchAndCallCompletion(true)
            }
        } else {
            switchAndCallCompletion(false)
        }
    }

    func switchToViewController(viewController: UIViewController, completion: (Bool) -> Void) {
        switchToViewController(viewController, slideOutAnimation: true, poptype: PopType.PopTypeRoot, completion)
    }
    
    func popToRootAndSwitchToViewController(viewController: UIViewController, slideOutAnimation: Bool, completion: (Bool) -> Void) {
        switchToViewController(viewController, slideOutAnimation: slideOutAnimation, poptype: PopType.PopTypeRoot, completion)
    }
    
    func popToRootAndSwitchToViewController(viewController: UIViewController, completion: (Bool) -> Void) {
        switchToViewController(viewController, slideOutAnimation: true, poptype: PopType.PopTypeRoot, completion)
    }

    func popAllAndSwitchToViewController(viewController: UIViewController, slideOutAnimation: Bool, completion: (Bool) -> Void) {
        switchToViewController(viewController, slideOutAnimation: slideOutAnimation, poptype: PopType.PopTypeAll, completion)
    }
    
    func popAllAndSwitchToViewController(viewController: UIViewController, completion: (Bool) -> Void) {
        switchToViewController(viewController, slideOutAnimation: true, poptype: PopType.PopTypeAll, completion)
    }
    
    func closeMenuWithCompletion(completion: (Bool) -> Void) {
        closeMenuWithDuration(MENU_SLIDE_ANIMATION_DURATION, completion)
    }
    
    func openMenu(completion: (Bool) -> Void) {
        openMenu(MENU_SLIDE_ANIMATION_DURATION, completion)
    }
    
    func toggleLeftMenu() {
        toggleMenu({ (Bool) -> Void in })
    }
    
    func isMenuOpen() -> Bool {
        return horizontalLocation() == 0 ? false : true;
    }
    
    func setEnableShadow(enable: Bool) {
        enableShadow = enable
        
        if enable {
            view.layer.shadowColor = UIColor.darkGrayColor().CGColor
            view.layer.shadowRadius = MENU_SHADOW_RADIUS
            view.layer.shadowOpacity = MENU_SHADOW_OPACITY
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
            view.layer.shouldRasterize = true;
            view.layer.rasterizationScale = UIScreen.mainScreen().scale
        } else {
            view.layer.shadowOpacity = 0;
            view.layer.shadowRadius = 0;
        }
    }

    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]! {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in
                self.popToRootViewControllerAnimated(animated)
                return
            })
        } else {
            return popToRootViewControllerAnimated(animated)
        }
        
        return nil;
    }
    
    override func pushViewController(viewController: UIViewController!, animated: Bool) {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in
                self.pushViewController(viewController, animated: animated)
            })
        } else {
            pushViewController(viewController, animated: animated)
        }
    }

    override func popToViewController(viewController: UIViewController!, animated: Bool) -> [AnyObject]! {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in
                self.popToViewController(viewController, animated: animated)
                return
            })
        } else {
            return popToViewController(viewController, animated: animated)
        }
        
        return nil
    }

    func updateMenuFrameAndTransformAccordingToOrientation() {
        let transform: CGAffineTransform = view.transform

        menu!.view.transform = transform
        menu!.view.frame = initialRectForMenu()
    }
    
    func enableTapGestureToCloseMenu(enable: Bool) {
        if enable {
            interactivePopGestureRecognizer.enabled = false
            topViewController.view.userInteractionEnabled = false
            view.addGestureRecognizer(tapRecognizer())
        } else {
            interactivePopGestureRecognizer.enabled = true
            topViewController.view.userInteractionEnabled = true
            view.removeGestureRecognizer(tapRecognizer())
        }
    }

    
    func toggleMenu(completion: (Bool) -> Void) {
        if isMenuOpen() {
            closeMenuWithCompletion(completion)
        } else {
            openMenu(completion)
        }
    }
    
    func barButtonItemForMenu() -> UIBarButtonItem {
        let selector: Selector = "leftMenuSelected:"
        var customButton: UIBarButtonItem? = leftBarButtonItem
        
        if customButton != nil {
            customButton!.action = selector
            customButton!.target = self
            return customButton!
        } else {
            let image: UIImage = UIImage(named: "menu-button")
            return UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        }
    }

    func shouldDisplayMenu(vc: UIViewController) -> Bool {
        // missing if vc.respondsToSelector(Selector( slideNavigationControllerShouldDisplayLeftMenu)  && [(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayRightMenu])
            return true
        
//        return false
    }
    
    func openMenu(duration: NSTimeInterval, completion: (Bool) -> Void) {
        enableTapGestureToCloseMenu(true)
        prepareMenuForReveal()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            var rect: CGRect = self.view.frame
            var width: CGFloat = self.horizontalSize()
            rect.origin.x = width - self.slideOffset()
            self.moveHorizontallyToLocation(rect.origin.x)
            }, completion: completion
        )
    }
   
    
    func closeMenuWithDuration(duration: NSTimeInterval, completion: (Bool) -> Void) {
        enableTapGestureToCloseMenu(false)

        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {() -> Void in
            var rect: CGRect = self.view.frame
            rect.origin.x = 0
            self.moveHorizontallyToLocation(rect.origin.x)
            }, completion: completion
        )
    }
    
    func moveHorizontallyToLocation(location: CGFloat) {
        var rect: CGRect = self.view.frame
        let orientation: UIInterfaceOrientation = interfaceOrientation
        if orientation.isLandscape {
            rect.origin.x = 0
            rect.origin.y = location
        } else {
            rect.origin.x = location
            rect.origin.y = 0
        }
        
        view.frame = rect
        updateMenuAnimation()
    }
    
    func updateMenuAnimation() {
        var progress: CGFloat = horizontalLocation() / (horizontalSize() - slideOffset())
        _menuRevealAnimator?.animateMenu(progress)
    }
    
    func initialRectForMenu() -> CGRect {
        var rect: CGRect = view.frame
        rect.origin.x = 0
        rect.origin.y = 0
        
        return rect;
    }

    // is it needed?
    func prepareMenuForReveal() {
//        if lastRevealedMenu is leftMenu {
//            return
//        }
//        
//        let menuViewController = leftMenu
//        let removingMenu
//        
//        if (self.lastRevealedMenu && menu == self.lastRevealedMenu)
//        return;
//        
//        UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
//        UIViewController *removingMenuViewController = (menu == MenuLeft) ? self.rightMenu : self.leftMenu;
//        
//        self.lastRevealedMenu = menu;
//        
//        [removingMenuViewController.view removeFromSuperview];
//        [self.view.window insertSubview:menuViewController.view atIndex:0];
//        
//        [self updateMenuFrameAndTransformAccordingToOrientation];
//        
//        [self.menuRevealAnimator prepareMenuForAnimation:menu];
    }
    
    func horizontalLocation() -> CGFloat {
        var rect: CGRect = view.frame
        var orientation: UIInterfaceOrientation = interfaceOrientation
        
        if orientation.isLandscape {
            return rect.origin.y
        } else {
            return rect.origin.x
        }
    }
    
    func horizontalSize() -> CGFloat {
        var rect: CGRect = view.frame
        var orientation: UIInterfaceOrientation = interfaceOrientation
        
        if orientation.isLandscape {
            return rect.size.height
        } else {
            return rect.size.width
        }
    }
    
    func navigationController(navigationController: UINavigationController!, willShowViewController viewController: UIViewController!, animated: Bool) {
        if shouldDisplayMenu(viewController) {
            viewController.navigationItem.leftBarButtonItem = barButtonItemForMenu()
        }
    }
    
    func slideOffset() -> CGFloat {
        return interfaceOrientation.isLandscape ? landscapeSlideOffset : portraitSlideOffset
    }

    
    func leftMenuSelected(sender: AnyObject) {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in })
        } else {
            openMenu({ (Bool) -> Void in })
        }
    }
    
    func tapDetected(tapRecognizer: UITapGestureRecognizer) {
        closeMenuWithCompletion({ (Bool) -> Void in })
    }
   
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        if panGestureSideOffset == 0 {
            return true
        }
        
        var pointInView: CGPoint = touch.locationInView(view)

        return (pointInView.x <= panGestureSideOffset || pointInView.x >= horizontalSize() - panGestureSideOffset)
    }
    
    func panDetected(aPanRecognizer: UIPanGestureRecognizer) {
        var translation: CGPoint = aPanRecognizer.translationInView(aPanRecognizer.view)
        var velocity: CGPoint = aPanRecognizer.velocityInView(aPanRecognizer.view)
        var movement: CGFloat = translation.x - draggingPoint.x
        
        if aPanRecognizer.state == UIGestureRecognizerState.Began {
            draggingPoint = translation
        } else if aPanRecognizer.state == UIGestureRecognizerState.Changed {
            var lastHorizontalLocation: CGFloat = 0
            var newHorizontalLocation: CGFloat = horizontalLocation()
            
            lastHorizontalLocation = newHorizontalLocation
            newHorizontalLocation += movement
            
            if newHorizontalLocation >= CGFloat(minXForDragging()) && newHorizontalLocation <= CGFloat(maxXForDragging()) {
                moveHorizontallyToLocation(newHorizontalLocation)
            }
                
            draggingPoint = translation
        } else if aPanRecognizer.state == UIGestureRecognizerState.Ended {
            var currentX: CGFloat = horizontalLocation()
            var currentXOffset = (currentX > 0) ? currentX : currentX*(-1)
            var possitiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x*(-1)
            
            if possitiveVelocity >= CGFloat(MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION) {
                if currentX > 0 {
                    closeMenuWithDuration(MENU_QUICK_SLIDE_ANIMATION_DURATION, completion: { (Bool) -> Void in })
                } else {
                    if shouldDisplayMenu(self.visibleViewController) {
                        openMenu(MENU_QUICK_SLIDE_ANIMATION_DURATION , completion: { (Bool) -> Void in })
                    }
                }
            } else {
                if currentXOffset < (self.horizontalSize() - self.slideOffset())/2 {
                    closeMenuWithCompletion({ (Bool) -> Void in })
                } else {
                    openMenu({ (Bool) -> Void in })
                }
            }
        }
    }

    func minXForDragging() -> Int {
        return 0;
    }
    
    func maxXForDragging() -> Int {
        return Int(horizontalSize()) - Int(slideOffset())
    }
    
    func tapRecognizer() -> UITapGestureRecognizer {
        if !(_tapRecognizer != nil) {
            _tapRecognizer = UITapGestureRecognizer(target: self, action: "tapDetected:")
        }
        
        return _tapRecognizer!
    }
    
    func panRecognizer() -> UIPanGestureRecognizer {
        if !(_panRecognizer != nil) {
            _panRecognizer = UIPanGestureRecognizer(target: self, action: "panDetected:")
            _panRecognizer!.delegate = self;
        }
    
        return _panRecognizer!;
    }
    
    func setEnableSwipeGesture(markEnableSwipeGesture: Bool) {
        _enableSwipeGesture = markEnableSwipeGesture;
    
        if _enableSwipeGesture {
            self.view.addGestureRecognizer(panRecognizer())
        } else {
            self.view.removeGestureRecognizer(panRecognizer())
        }
    }
    
    func setMenuRevealAnimator(menuRevealAnimator: SlideNavigationControllerAnimatorSlide) {
        menuRevealAnimator.clear()
        _menuRevealAnimator = menuRevealAnimator
    }
}
