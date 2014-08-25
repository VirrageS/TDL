import UIKit
import QuartzCore

var MENU_SLIDE_ANIMATION_DURATION: CGFloat = 0.3
var MENU_QUICK_SLIDE_ANIMATION_DURATION: CGFloat = 0.18
var MENU_IMAGE = "menu-button"
var MENU_SHADOW_RADIUS = 10
var MENU_SHADOW_OPACITY = 1
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
    let enableSwipeGesture: Bool = true
    let enableShadow: Bool = true
    let leftMenu: UIViewController = UIViewController()
//    let leftBarButtonItem: UIBarButtonItem
//    let rightBarButtonItem: UIBarButtonItem
    let portraitSlideOffset: CGFloat = 0.0
    let landscapeSlideOffset: CGFloat = 0.0
    let panGestureSideOffset: CGFloat = 0.0
//    let sharedInstance: SlideNavigationController
//    let tapRecognizer: UITapGestureRecognizer
//    let panRecognizer: UIPanGestureRecognizer
//    let draggingPoint: CGPoint
    let singletonInstance: SlideNavigationController = SlideNavigationController()
//    let lastRevealedMenu: Menu
//    @property (nonatomic, strong) id <SlideNavigationContorllerAnimator> menuRevealAnimator;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        singletonInstance = self
        landscapeSlideOffset = MENU_DEFAULT_SLIDE_OFFSET
        portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET
        panGestureSideOffset = 0
        avoidSwitchingToSameClassViewController = true
        enableSwipeGesture = true
        delegate = self
    }

    
    func sharedInstance() -> SlideNavigationController {
        println("\(singletonInstance) SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code")
    
        return singletonInstance
    }
//
//
//    func initWithRootViewController(rootViewController: UIViewController) -> AnyObject! {
//        if self = super.initWithRootViewController:rootViewController {
//            setup()
//        }
//    
//        return self;
//    }
//    

//    
//    - (void)viewWillLayoutSubviews
//    {
//    [super viewWillLayoutSubviews];
//    
//    // Update shadow size of enabled
//    if (self.enableShadow)
//    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
//    }
//
//    - (void)switchToViewController:(UIViewController *)viewController
//    withSlideOutAnimation:(BOOL)slideOutAnimation
//    popType:(PopType)poptype
//    andCompletion:(void (^)())completion
//    {
//    if (self.avoidSwitchingToSameClassViewController && [self.topViewController isKindOfClass:viewController.class])
//    {
//    [self closeMenuWithCompletion:completion];
//    return;
//    }
//    
//    void (^switchAndCallCompletion)(BOOL) = ^(BOOL closeMenuBeforeCallingCompletion) {
//    if (poptype == PopTypeAll) {
//    [self setViewControllers:@[viewController]];
//    }
//    else {
//    [super popToRootViewControllerAnimated:NO];
//    [super pushViewController:viewController animated:NO];
//    }
//    
//    if (closeMenuBeforeCallingCompletion)
//    {
//    [self closeMenuWithCompletion:^{
//    if (completion)
//    completion();
//    }];
//    }
//    else
//    {
//    if (completion)
//    completion();
//    }
//    };
//    
//    if ([self isMenuOpen])
//    {
//    if (slideOutAnimation)
//    {
//    [UIView animateWithDuration:(slideOutAnimation) ? MENU_SLIDE_ANIMATION_DURATION : 0
//    delay:0
//    options:UIViewAnimationOptionCurveEaseOut
//    animations:^{
//    CGFloat width = self.horizontalSize;
//    CGFloat moveLocation = (self.horizontalLocation> 0) ? width : -1*width;
//    [self moveHorizontallyToLocation:moveLocation];
//    } completion:^(BOOL finished) {
//    switchAndCallCompletion(YES);
//    }];
//    }
//    else
//    {
//    switchAndCallCompletion(YES);
//    }
//    }
//    else
//    {
//    switchAndCallCompletion(NO);
//    }
//    }
//    
//    - (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion
//    {
//    [self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeRoot andCompletion:completion];
//    }
//    
//    - (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
//    withSlideOutAnimation:(BOOL)slideOutAnimation
//    andCompletion:(void (^)())completion
//    {
//    [self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeRoot andCompletion:completion];
//    }
//    
//    - (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
//    withCompletion:(void (^)())completion
//    {
//    [self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeRoot andCompletion:completion];
//    }
//    
//    - (void)popAllAndSwitchToViewController:(UIViewController *)viewController
//    withSlideOutAnimation:(BOOL)slideOutAnimation
//    andCompletion:(void (^)())completion
//    {
//    [self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeAll andCompletion:completion];
//    }
//    
//    - (void)popAllAndSwitchToViewController:(UIViewController *)viewController
//    withCompletion:(void (^)())completion
//    {
//    [self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeAll andCompletion:completion];
//    }
//    
//    - (void)closeMenuWithCompletion:(void (^)())completion
//    {
//    [self closeMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
//    }
//    
//    - (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
//    {
//    [self openMenu:menu withDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
//    }
//    
//    - (void)toggleLeftMenu
//    {
//    [self toggleMenu:MenuLeft withCompletion:nil];
//    }
//    
//    - (void)toggleRightMenu
//    {
//    [self toggleMenu:MenuRight withCompletion:nil];
//    }
//    
//    - (BOOL)isMenuOpen
//    {
//    return (self.horizontalLocation == 0) ? NO : YES;
//    }
//    
//    - (void)setEnableShadow:(BOOL)enable
//    {
//    _enableShadow = enable;
//    
//    if (enable)
//    {
//    self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    self.view.layer.shadowRadius = MENU_SHADOW_RADIUS;
//    self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
//    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
//    self.view.layer.shouldRasterize = YES;
//    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    }
//    else
//    {
//    self.view.layer.shadowOpacity = 0;
//    self.view.layer.shadowRadius = 0;
//    }
//    }
//    
//    #pragma mark - Override Methods -
//    
//    - (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
//    {
//    if ([self isMenuOpen])
//    {
//    [self closeMenuWithCompletion:^{
//    [super popToRootViewControllerAnimated:animated];
//    }];
//    }
//    else
//    {
//    return [super popToRootViewControllerAnimated:animated];
//    }
//    
//    return nil;
//    }
//    
//    - (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//    {
//    if ([self isMenuOpen])
//    {
//    [self closeMenuWithCompletion:^{
//    [super pushViewController:viewController animated:animated];
//    }];
//    }
//    else
//    {
//    [super pushViewController:viewController animated:animated];
//    }
//    }
//    
//    - (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//    {
//    if ([self isMenuOpen])
//    {
//    [self closeMenuWithCompletion:^{
//    [super popToViewController:viewController animated:animated];
//    }];
//    }
//    else
//    {
//    return [super popToViewController:viewController animated:animated];
//    }
//    
//    return nil;
//    }
//    
//    #pragma mark - Private Methods -
//    
//    - (void)updateMenuFrameAndTransformAccordingToOrientation
//    {
//    // Animate rotatation when menu is open and device rotates
//    CGAffineTransform transform = self.view.transform;
//    self.leftMenu.view.transform = transform;
//    self.rightMenu.view.transform = transform;
//    
//    self.leftMenu.view.frame = [self initialRectForMenu];
//    self.rightMenu.view.frame = [self initialRectForMenu];
//    }
//    
//    - (void)enableTapGestureToCloseMenu:(BOOL)enable
//    {
//    if (enable)
//    {
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    self.interactivePopGestureRecognizer.enabled = NO;
//    
//    self.topViewController.view.userInteractionEnabled = NO;
//    [self.view addGestureRecognizer:self.tapRecognizer];
//    }
//    else
//    {
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    self.interactivePopGestureRecognizer.enabled = YES;
//    
//    self.topViewController.view.userInteractionEnabled = YES;
//    [self.view removeGestureRecognizer:self.tapRecognizer];
//    }
//    }
//    
//    - (void)toggleMenu:(Menu)menu withCompletion:(void (^)())completion
//    {
//    if ([self isMenuOpen])
//    [self closeMenuWithCompletion:completion];
//    else
//    [self openMenu:menu withCompletion:completion];
//    }
//    
//    - (UIBarButtonItem *)barButtonItemForMenu:(Menu)menu
//    {
//    SEL selector = (menu == MenuLeft) ? @selector(leftMenuSelected:) : @selector(righttMenuSelected:);
//    UIBarButtonItem *customButton = (menu == MenuLeft) ? self.leftBarButtonItem : self.rightBarButtonItem;
//    
//    if (customButton)
//    {
//    customButton.action = selector;
//    customButton.target = self;
//    return customButton;
//    }
//    else
//    {
//    UIImage *image = [UIImage imageNamed:MENU_IMAGE];
//    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
//    }
//    }
//    
//    - (BOOL)shouldDisplayMenu:(Menu)menu forViewController:(UIViewController *)vc
//    {
//    if (menu == MenuRight)
//    {
//    if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayRightMenu)] &&
//    [(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayRightMenu])
//    {
//    return YES;
//    }
//    }
//    if (menu == MenuLeft)
//    {
//    if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayLeftMenu)] &&
//    [(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayLeftMenu])
//    {
//    return YES;
//    }
//    }
//    
//    return NO;
//    }
//    
//    - (void)openMenu:(Menu)menu withDuration:(float)duration andCompletion:(void (^)())completion
//    {
//    [self enableTapGestureToCloseMenu:YES];
//    
//    [self prepareMenuForReveal:menu];
//    
//    [UIView animateWithDuration:duration
//    delay:0
//    options:UIViewAnimationOptionCurveEaseOut
//    animations:^{
//    CGRect rect = self.view.frame;
//    CGFloat width = self.horizontalSize;
//    rect.origin.x = (menu == MenuLeft) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
//    [self moveHorizontallyToLocation:rect.origin.x];
//    }
//    completion:^(BOOL finished) {
//    if (completion)
//    completion();
//    }];
//    }
//    
//    - (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
//    {
//    [self enableTapGestureToCloseMenu:NO];
//    
//    [UIView animateWithDuration:duration
//    delay:0
//    options:UIViewAnimationOptionCurveEaseOut
//    animations:^{
//    CGRect rect = self.view.frame;
//    rect.origin.x = 0;
//    [self moveHorizontallyToLocation:rect.origin.x];
//    }
//    completion:^(BOOL finished) {
//    if (completion)
//    completion();
//    }];
//    }
//    
//    - (void)moveHorizontallyToLocation:(CGFloat)location
//    {
//    CGRect rect = self.view.frame;
//    UIInterfaceOrientation orientation = self.interfaceOrientation;
//    Menu menu = (self.horizontalLocation >= 0 && location >= 0) ? MenuLeft : MenuRight;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//    rect.origin.x = 0;
//    rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
//    }
//    else
//    {
//    rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
//    rect.origin.y = 0;
//    }
//    
//    self.view.frame = rect;
//    [self updateMenuAnimation:menu];
//    }
//    
//    - (void)updateMenuAnimation:(Menu)menu
//    {
//    CGFloat progress = (menu == MenuLeft)
//    ? (self.horizontalLocation / (self.horizontalSize - self.slideOffset))
//    : (self.horizontalLocation / ((self.horizontalSize - self.slideOffset) * -1));
//    
//    [self.menuRevealAnimator animateMenu:menu withProgress:progress];
//    }
//    
//    - (CGRect)initialRectForMenu
//    {
//    CGRect rect = self.view.frame;
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//    
//    BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
//    
//    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
//    {
//    if (!isIos7)
//    {
//    // For some reasons in landscape belos the status bar is considered y=0, but in portrait it's considered y=20
//    rect.origin.x = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ? 0 : STATUS_BAR_HEIGHT;
//    rect.size.width = self.view.frame.size.width-STATUS_BAR_HEIGHT;
//    }
//    }
//    else
//    {
//    if (!isIos7)
//    {
//    // For some reasons in landscape belos the status bar is considered y=0, but in portrait it's considered y=20
//    rect.origin.y = (self.interfaceOrientation == UIInterfaceOrientationPortrait) ? STATUS_BAR_HEIGHT : 0;
//    rect.size.height = self.view.frame.size.height-STATUS_BAR_HEIGHT;
//    }
//    }
//    
//    return rect;
//    }
//    
//    - (void)prepareMenuForReveal:(Menu)menu
//    {
//    // Only prepare menu if it has changed (ex: from MenuLeft to MenuRight or vice versa)
//    if (self.lastRevealedMenu && menu == self.lastRevealedMenu)
//    return;
//    
//    UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
//    UIViewController *removingMenuViewController = (menu == MenuLeft) ? self.rightMenu : self.leftMenu;
//    
//    self.lastRevealedMenu = menu;
//    
//    [removingMenuViewController.view removeFromSuperview];
//    [self.view.window insertSubview:menuViewController.view atIndex:0];
//    
//    [self updateMenuFrameAndTransformAccordingToOrientation];
//    
//    [self.menuRevealAnimator prepareMenuForAnimation:menu];
//    }
//    
//    - (CGFloat)horizontalLocation
//    {
//    CGRect rect = self.view.frame;
//    UIInterfaceOrientation orientation = self.interfaceOrientation;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//    return (orientation == UIInterfaceOrientationLandscapeRight)
//    ? rect.origin.y
//    : rect.origin.y*-1;
//    }
//    else
//    {
//    return (orientation == UIInterfaceOrientationPortrait)
//    ? rect.origin.x
//    : rect.origin.x*-1;
//    }
//    }
//    
//    - (CGFloat)horizontalSize
//    {
//    CGRect rect = self.view.frame;
//    UIInterfaceOrientation orientation = self.interfaceOrientation;
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//    return rect.size.height;
//    }
//    else
//    {
//    return rect.size.width;
//    }
//    }
//    
//    #pragma mark - UINavigationControllerDelegate Methods -
//    
//    - (void)navigationController:(UINavigationController *)navigationController
//    willShowViewController:(UIViewController *)viewController
//    animated:(BOOL)animated
//    {
//    if ([self shouldDisplayMenu:MenuLeft forViewController:viewController])
//    viewController.navigationItem.leftBarButtonItem = [self barButtonItemForMenu:MenuLeft];
//    
//    if ([self shouldDisplayMenu:MenuRight forViewController:viewController])
//    viewController.navigationItem.rightBarButtonItem = [self barButtonItemForMenu:MenuRight];
//    }
//    
//    - (CGFloat)slideOffset
//    {
//    return (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
//    ? self.landscapeSlideOffset
//    : self.portraitSlideOffset;
//    }
//    
//    #pragma mark - IBActions -
//    
//    - (void)leftMenuSelected:(id)sender
//    {
//    if ([self isMenuOpen])
//    [self closeMenuWithCompletion:nil];
//    else
//    [self openMenu:MenuLeft withCompletion:nil];
//    
//    }
//    
//    - (void)righttMenuSelected:(id)sender
//    {
//    if ([self isMenuOpen])
//    [self closeMenuWithCompletion:nil];
//    else
//    [self openMenu:MenuRight withCompletion:nil];
//    }
//    
//    #pragma mark - Gesture Recognizing -
//    
//    - (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
//    {
//    [self closeMenuWithCompletion:nil];
//    }
//    
//    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//    {
//    if (self.panGestureSideOffset == 0)
//    return YES;
//    
//    CGPoint pointInView = [touch locationInView:self.view];
//    CGFloat horizontalSize = [self horizontalSize];
//    
//    return (pointInView.x <= self.panGestureSideOffset || pointInView.x >= horizontalSize - self.panGestureSideOffset)
//    ? YES
//    : NO;
//    }
//    
//    - (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
//    {
//    CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
//    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
//    NSInteger movement = translation.x - self.draggingPoint.x;
//    
//    Menu currentMenu;
//    
//    if (self.horizontalLocation > 0)
//    currentMenu = MenuLeft;
//    else if (self.horizontalLocation < 0)
//    currentMenu = MenuRight;
//    else
//    currentMenu = (translation.x > 0) ? MenuLeft : MenuRight;
//    
//    [self prepareMenuForReveal:currentMenu];
//    
//    if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
//    {
//    self.draggingPoint = translation;
//    }
//    else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
//    {
//    static CGFloat lastHorizontalLocation = 0;
//    CGFloat newHorizontalLocation = [self horizontalLocation];
//    lastHorizontalLocation = newHorizontalLocation;
//    newHorizontalLocation += movement;
//    
//    if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging)
//    [self moveHorizontallyToLocation:newHorizontalLocation];
//    
//    self.draggingPoint = translation;
//    }
//    else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
//    {
//    NSInteger currentX = [self horizontalLocation];
//    NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
//    NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
//    
//    // If the speed is high enough follow direction
//    if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION)
//    {
//    Menu menu = (velocity.x > 0) ? MenuLeft : MenuRight;
//    
//    // Moving Right
//    if (velocity.x > 0)
//    {
//    if (currentX > 0)
//    {
//    if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
//    [self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
//    }
//    else
//    {
//    [self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
//    }
//    }
//    // Moving Left
//    else
//    {
//    if (currentX > 0)
//    {
//    [self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
//    }
//    else
//    {
//    if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
//    [self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
//    }
//    }
//    }
//    else
//    {
//    if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
//    [self closeMenuWithCompletion:nil];
//    else
//    [self openMenu:(currentX > 0) ? MenuLeft : MenuRight withCompletion:nil];
//    }
//    }
//    }
//    
//    - (NSInteger)minXForDragging
//    {
//    if ([self shouldDisplayMenu:MenuRight forViewController:self.topViewController])
//    {
//    return (self.horizontalSize - self.slideOffset)  * -1;
//    }
//    
//    return 0;
//    }
//    
//    - (NSInteger)maxXForDragging
//    {
//    if ([self shouldDisplayMenu:MenuLeft forViewController:self.topViewController])
//    {
//    return self.horizontalSize - self.slideOffset;
//    }
//    
//    return 0;
//    }
//    
//    #pragma mark - Setter & Getter -
//    
//    - (UITapGestureRecognizer *)tapRecognizer
//    {
//    if (!_tapRecognizer)
//    {
//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
//    }
//    
//    return _tapRecognizer;
//    }
//    
//    func panRecognizer -> UIPanGestureRecognizer {
//        if !_panRecognizer {
//            _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
//            _panRecognizer.delegate = self;
//        }
//    
//        return _panRecognizer;
//    }
//    
//    func setEnableSwipeGesture(Bool: markEnableSwipeGesture) {
//        _enableSwipeGesture = markEnableSwipeGesture;
//    
//        if _enableSwipeGesture {
//            self.view.addGestureRecognizer(self.panRecognizer)
//        } else {
//            self.view.removeGestureRecognizer(self.panRecognizer)
//        }
//    }
//    
//    func setMenuRevealAnimator(slideNavigationContorllerAnimator: menuRevealAnimator) {
//        self.menuRevealAnimator.clear()
//        _menuRevealAnimator = menuRevealAnimator
//    }
}