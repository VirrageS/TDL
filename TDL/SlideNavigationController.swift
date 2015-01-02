import UIKit
import QuartzCore

let DEBUG: Bool = false

let MENU_SLIDE_ANIMATION_DURATION: NSTimeInterval = 0.3
let MENU_QUICK_SLIDE_ANIMATION_DURATION: NSTimeInterval = 0.18
let MENU_SHADOW_RADIUS: CGFloat = 5
let MENU_SHADOW_OPACITY: Float = 1
let MENU_DEFAULT_SLIDE_OFFSET: CGFloat = 60.0
let MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION = 1200

var singletonInstance: SlideNavigationController?
var bar: UINavigationBar?

@objc protocol SlideNavigationControllerDelegate {
    optional func shouldDisplayMenu() -> Bool
}

class SlideNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    enum PopType {
        case PopTypeAll
        case PopTypeRoot
    }

    var avoidSwitchingToSameClassViewController: Bool = false
    var _enableSwipeGesture: Bool?
    var enableShadow: Bool?
    
    let portraitSlideOffset: CGFloat = MENU_DEFAULT_SLIDE_OFFSET
    let landscapeSlideOffset: CGFloat = MENU_DEFAULT_SLIDE_OFFSET
    let panGestureSideOffset: CGFloat = MENU_DEFAULT_SLIDE_OFFSET
    
    var _delegate: SlideNavigationControllerDelegate?
    
    
    var menu: UIViewController?
    var lastRevealedMenu: UIViewController?

    var _tapRecognizer: UITapGestureRecognizer?
    var _panRecognizer: UIPanGestureRecognizer?
    
    var draggingPoint: CGPoint! = CGPoint(x: 0, y: 0)
    var leftBarButtonItem: UIBarButtonItem?
    var _menuRevealAnimator: SlideNavigationControllerAnimatorSlide?
   
    convenience override init() {
        self.init(nibName: nil, bundle: nil)

        if DEBUG {
            println("init called")
        }
        
        if singletonInstance == nil {
            singletonInstance = self
        }
//        
//        if bar == nil {
//            bar = self.navigationBar
//        }
//        self.navigationBar.bounds.origin = CGPoint(x: -10, y: 0)
        
        avoidSwitchingToSameClassViewController = true
        setEnableSwipeGesture(true)
        setEnableShadow(true)
        delegate = self
    }
    
    func sharedInstance() -> SlideNavigationController {
        if singletonInstance == nil {
            println("\(singletonInstance) SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code")
        }
    
        return singletonInstance!
    }

//    func initWithRootViewController(rootViewController: UIViewController) -> AnyObject! {
//        return self;
//    }

    override func viewWillLayoutSubviews()  {
        super.viewWillLayoutSubviews()
    
        // Update shadow size of enabled
        if (enableShadow != nil) {
            if enableShadow! {
                view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
            }
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
        if DEBUG {
            println("switchToViewController step #1 called")
        }
        
        if avoidSwitchingToSameClassViewController && topViewController == viewController {
            closeMenuWithCompletion(completion)
            return
        }
    
        let switchAndCallCompletion = { (closeMenuBeforeCallingCompletion: Bool) -> () in
            if poptype == PopType.PopTypeAll {
                self.setViewControllers([viewController], animated: false)
            } else {
                // #TODO
//                self.popToRootViewControllerAnimated(false)
                self.pushViewController(viewController, animated: false)
            }
        
            if closeMenuBeforeCallingCompletion {
                self.closeMenuWithCompletion(completion)
            }
        }
        
        if DEBUG {
            println("switchToViewController step #2 called")
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
        
        if DEBUG {
            println("switchToViewController step #3 called")
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

    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in
                self.popToRootViewControllerAnimated(animated)
                return
            })
        } else {
            return super.popToRootViewControllerAnimated(animated)
        }
        
        return nil;
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if isMenuOpen() {
            closeMenuWithCompletion({ (Bool) -> Void in
                self.pushViewController(viewController, animated: animated)
            })
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }

    override func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]? {
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
        if DEBUG {
            println("toggleMenu called")
        }
        
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
            let image: UIImage = UIImage(named: "menu-button")!
            return UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        }
    }

    func shouldDisplayMenu(vc: UIViewController) -> Bool {
        if DEBUG {
            println("shouldDisplayMenu called")
        }
        
        if let check = _delegate?.shouldDisplayMenu!() {
            if DEBUG {
                print(check)
            }
            return check
        }
        
        return true
    }
    
    func openMenu(duration: NSTimeInterval, completion: (Bool) -> Void) {
        if DEBUG {
            println("openMenu called")
        }
        
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

    func prepareMenuForReveal() {
        if lastRevealedMenu != nil {
            if lastRevealedMenu == menu {
                return
            }
        }

        lastRevealedMenu = menu
        
        view.window?.insertSubview(menu!.view, atIndex: 0)
//        view.window?.insertSubview(bar!, atIndex: 1)
//        .navigationBar.topItem.title = "Hello"
//        navigationItem.title = "lol"
        
        updateMenuFrameAndTransformAccordingToOrientation()
        _menuRevealAnimator?.prepareMenuForAnimation()
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
        if DEBUG {
            println("navigationController called")
        }
        
        if shouldDisplayMenu(viewController) {
            viewController.navigationItem.leftBarButtonItem = barButtonItemForMenu()
            
            if DEBUG {
                println("leftButtonSet called")
            }
        }
    }
    
    func slideOffset() -> CGFloat {
        return interfaceOrientation.isLandscape ? landscapeSlideOffset : portraitSlideOffset
    }

    
    func leftMenuSelected(sender: AnyObject) {
        if DEBUG {
            println("leftMenuSelected called")
        }
        if isMenuOpen() {
            if DEBUG {
                println("leftMenuSelected -> isMenuOpen -> true -> called")
            }
            
            closeMenuWithCompletion({ (Bool) -> Void in })
        } else {
            if DEBUG {
                println("leftMenuSelected -> isMenuOpen -> false -> called")
            }
            
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
        var translation: CGPoint = aPanRecognizer.translationInView(aPanRecognizer.view!)
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
        return 0
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
        if DEBUG {
            println("panRecognizer called")
        }
        
        if !(_panRecognizer != nil) {
            _panRecognizer = UIPanGestureRecognizer(target: self, action: "panDetected:")
            _panRecognizer!.delegate = self
        }
    
        return _panRecognizer!
    }
    
    func setEnableSwipeGesture(markEnableSwipeGesture: Bool) {
        _enableSwipeGesture = markEnableSwipeGesture
    
        if (_enableSwipeGesture != nil) {
            self.view.addGestureRecognizer(panRecognizer())
        } else {
            self.view.removeGestureRecognizer(panRecognizer())
        }
    }
    
    func setMenuRevealAnimator(menuRevealAnimator: SlideNavigationControllerAnimatorSlide) {
        menuRevealAnimator.setInstance(singletonInstance!)
        menuRevealAnimator.clear()
        _menuRevealAnimator = menuRevealAnimator
    }
}
