//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.

#if os(iOS) || os(tvOS)

import UIKit

public var cacheControllerViewNibs = NSCache<NSString, UIViewController>()

// extension UINavigationController {
//    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
//        pushViewController(viewController, animated: animated)
//
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil) { _ in
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
//
//    func popViewController(animated: Bool, completion: @escaping () -> ()) {
//        popViewController(animated: animated)
//
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil) { _ in
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
// }

////Extension:- UIViewController iPhoneX - Bottom SafeLayoutGuide 색칠
// private static let insetBackgroundViewTag = 98721 //Cool number
//
// func paintSafeAreaBottomInset(withColor color: UIColor) {
//    guard #available(iOS 11.0, *) else {
//        return
//    }
//    if let insetView = view.viewWithTag(UIViewController.insetBackgroundViewTag) {
//        insetView.backgroundColor = color
//        return
//    }
//
//    let insetView = UIView(frame: .zero)
//    insetView.tag = UIViewController.insetBackgroundViewTag
//    insetView.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(insetView)
//    view.sendSubview(toBack: insetView)
//
//    insetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//    insetView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    insetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    insetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//    insetView.backgroundColor = color
// }

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        }
        else if presentingViewController != nil {
            return true
        }
        else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        }
        else {
            return false
        }
    }

    private struct AssociatedKeys {
        static var cache: UInt8 = 0
    }

    public var cache: Bool {
        get {
            if let info: Bool = objc_getAssociatedObject(self, &AssociatedKeys.cache) as? Bool {
                return info
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cache, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public class func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private class func fromXib<T: UIViewController>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let vc = cacheControllerViewNibs.object(forKey: self.className as NSString) {
            return vc as! T
        }
        let vc = T(nibName: T.className, bundle: nil)
            cacheControllerViewNibs.countLimit = 100
            cacheControllerViewNibs.setObject(vc, forKey: self.className as NSString)
            vc.cache = cache
        return vc
    }

    public var parentVCs: [UIViewController] {
        var vcs: [UIViewController] = [UIViewController]()
        var vc: UIViewController? = self.parent
        while vc != nil {
            vcs.append(vc!)
            vc = vc!.parent
        }
        return vcs
    }

    public var topParentVC: UIViewController? {
        var vcs = parentVCs

        if let navi: UINavigationController = vcs.last as? UINavigationController {
            vcs.remove(object: navi)
            if let lastVC = vcs.last {
                return lastVC
            }
        }
        return nil
    }

    public func getParentVC<T: UIViewController>(type: T.Type) -> T? {
        for vc in parentVCs {
            if let vcT = vc as? T {
                return vcT
            }
        }
        return nil
    }

    // MARK: - Notifications

    ///  Removes NotificationCenter'd observer
    open func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    //  Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    //  Dismisses keyboard
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - VC Container

    ///  Returns maximum y of the ViewController
    open var top: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.top
        }
        if let nav = self.navigationController {
            if nav.isNavigationBarHidden {
                return view.top
            }
            else {
                return nav.navigationBar.bottom
            }
        }
        else {
            return view.top
        }
    }

    ///  Returns minimum y of the ViewController
    open var bottom: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.bottom
        }
        if let tab = tabBarController {
            if tab.tabBar.isHidden {
                return view.bottom
            }
            else {
                return tab.tabBar.top
            }
        }
        else {
            return view.bottom
        }
    }

    ///  Returns Tab Bar's height
    open var tabBarHeight: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }

    ///  Returns Navigation Bar's height
    open var navigationBarHeight: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.h
        }
        return 0
    }

    ///  Returns Navigation Bar's color
    open var navigationBarColor: UIColor? {
        get {
            if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }

    ///  Returns current Navigation Bar
    open var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }

    /// EZSwiftExtensions
    open var applicationFrame: CGRect {
        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
    }

    // MARK: - VC Flow

    ///  Pushes a view controller onto the receiver’s stack and updates the display.
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    ///  Pops the top view controller from the navigation stack and updates the display.
    open func popVC(_ animated: Bool = false) {
        navigationController?.popViewController(animated: animated)
    }

    open func popVC(popVCs: [UIViewController]) {
        guard let nv = navigationController else { return }
        let vcs = nv.viewControllers.filter({ vc -> Bool in
            return !popVCs.contains(vc)
        })
        nv.viewControllers = vcs
    }

    ///   Hide or show navigation bar
    public var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }

    ///   Added extension for popToRootViewController
    open func popToRootVC(_ animated: Bool = false) {
        navigationController?.popToRootViewController(animated: true)
    }

    ///  Presents a view controller modally.
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    ///  Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }

    ///  Adds the specified view controller as a child of the current view controller.
    open func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    ///  Adds image named: as a UIImageView in the Background
    open func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    ///  Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    #if os(iOS)

    @available(*, deprecated)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    #endif
}

#endif
