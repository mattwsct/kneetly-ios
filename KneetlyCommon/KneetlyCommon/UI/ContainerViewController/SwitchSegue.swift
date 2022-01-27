import UIKit

typealias AnimationsBlock = () -> Void

@IBDesignable

open class SwitchSegue: UIStoryboardSegue {
    
    var containerView: UIView?
    
    var animationDuration = TimeInterval(0.4)
    
    var animationsForTransition: ((_ fromViewController: UIViewController, _ toViewController: UIViewController) -> AnimationsBlock)?
    
    var animationOptions = UIViewAnimationOptions.transitionCrossDissolve
    
    override open func perform() {
        
        guard let containerView = containerView else {
            fatalError("containerView must be defined to perform switchSegue")
        }
        
        let fromViewController = lastViewControllerInContainerView()
        let toViewController = destination
        
        if fromViewController == toViewController {
            return
        }
        
        toViewController.view.frame = containerView.bounds
        
        if source.childViewControllers.contains(toViewController) {
            toViewController.removeFromParentViewController()
        }
        
        source.addChildViewController(toViewController)
        
        if let fromViewController = fromViewController {
            source.transition(from: fromViewController, to: toViewController, duration: animationDuration, options: animationOptions, animations: animationsForTransition?(fromViewController, toViewController)) { (finished) in
                // do something
            }
        }
        else {
            containerView.addSubview(toViewController.view)
        }
    }
    
    private func lastViewControllerInContainerView() -> UIViewController? {
        for child in source.childViewControllers.reversed() {
            if child.view.superview == containerView {
                return child
            }
        }
        
        return nil
    }
}
