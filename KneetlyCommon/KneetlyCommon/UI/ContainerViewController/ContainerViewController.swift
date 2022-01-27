import UIKit

open class ContainerViewController: UIViewController {

    private var segues = [String: SwitchSegue]()
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let switchSegue = segue as? SwitchSegue {

            guard let segueIdentifier = segue.identifier else {
                fatalError("\"Switch\" segue must have identifier")
            }

            switchSegue.containerView = containerViewForSwitchSegue(segue: switchSegue)
            
            if shouldCacheViewControllerForSwitchSegue(segue: segue) {
                segues[segueIdentifier] = switchSegue
            }
        }
    }
    
    override open func performSegue(withIdentifier: String, sender: Any?) {
        if let segue = segues[withIdentifier] {
            segue.perform()
        }
        else {
            super.performSegue(withIdentifier: withIdentifier, sender: sender)
        }
    }
    
    open func containerViewForSwitchSegue(segue: SwitchSegue) -> UIView {
        return view
    }
    
    func shouldCacheViewControllerForSwitchSegue(segue: UIStoryboardSegue) -> Bool {
        return true
    }
}
