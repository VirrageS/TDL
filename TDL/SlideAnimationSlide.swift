import UIKit

class SlideNavigationControllerAnimatorSlide {
    let slideMovement: CGFloat = 100.0
    var _instance: SlideNavigationController?
    
    init() {
        
    }
    
    func prepareMenuForAnimation() {
        let menuViewController: UIViewController = _instance!.menu!
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        var rect: CGRect = menuViewController.view.frame
    
        if orientation.isLandscape {
            if orientation.isLandscape {
                rect.origin.y = self.slideMovement*(-1)
            } else {
                rect.origin.y = self.slideMovement
            }
        } else {
            if orientation.isPortrait {
                rect.origin.x = self.slideMovement*(-1)
            } else {
                rect.origin.x = self.slideMovement;
            }
        }
        
        menuViewController.view.frame = rect;
    }

    func animateMenu(progress: CGFloat) {
        let menuViewController: UIViewController = _instance!.menu!
         let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
    
        var location: CGFloat  = CGFloat(self.slideMovement*(-1)) + CGFloat(self.slideMovement*progress)
        location = (location > 0) ? 0 : location;
    
        var rect: CGRect = menuViewController.view.frame;
    
        if orientation.isLandscape {
            rect.origin.y = orientation.isLandscape ? location : location*(-1);
        } else {
            rect.origin.x = orientation.isPortrait ? location : location*(-1);
        }
    
        menuViewController.view.frame = rect;
    }
    
    func clear() {
        self.clearMenu()
    }

    func clearMenu() {
        let menuViewController: UIViewController = _instance!.menu!
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        
        var rect: CGRect = menuViewController.view.frame;
    
        if orientation.isLandscape {
            rect.origin.y = 0;
        } else {
            rect.origin.x = 0;
        }
        
        menuViewController.view.frame = rect;
    }
    
    func setInstance(instance: SlideNavigationController?) {
        _instance = instance?.sharedInstance()
    }
}
