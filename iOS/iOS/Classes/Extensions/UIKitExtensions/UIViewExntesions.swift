//
//  UIViewExntesions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    func getGesture<G: UIGestureRecognizer>(_ comparison: ((G) -> Bool)? = nil) -> G? {
        return gestureRecognizers?.filter { g in
            if let comparison = comparison {
                return g is G && comparison(g as! G)
            }
            
            return g is G
            }.first as? G
    }
    
    func getConstraint(byAttribute attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.filter { $0.firstAttribute == attr }.first
    }
    
    // load nib file
    static func loadFrom<T: UIView>(nibNamed: String, bundle : Bundle? = nil) -> T? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    // clear all subviews, destroy if needed
    func clearAll() {
        subviews.forEach { view in
            (view as? Destroyable)?.destroy()
            view.removeFromSuperview()
        }
    }
    
    
    // set corder radius for specific corners
    func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // set box shadow
    func setShadow(offset: CGSize, color: UIColor, opacity: Float, blur: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
        layer.shadowPath = shadowPath.cgPath
    }
    
    // set layer border style
    func setBorder(withColor color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    // set linear gradient background color
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor, topRatio: Double, bottomRatio: Double) {
        let gl = CAGradientLayer()
        gl.colors = [topColor.cgColor, bottomColor.cgColor]
        gl.locations = [NSNumber(value: topRatio), NSNumber(value: bottomRatio)]
        gl.frame = bounds
        layer.insertSublayer(gl, at: 0)
    }
    
    // set border view with color and color
    func borderView(_ radius: CGFloat = 25, _ color: UIColor = .white, _ width: CGFloat = 1) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
    }

}

extension UITabBarController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITabBarController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: Extension for UINavigationController
extension UINavigationController {
    
    func popViewController(animated: Bool, completions: ((UIViewController?) -> Void)?) {
        let page = topViewController
        
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock { completions?(page) }
            popViewController(animated: animated)
            CATransaction.commit()
        } else {
            popViewController(animated: animated)
            completions?(page)
        }
        
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completions: (() -> Void)?) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completions)
            pushViewController(viewController, animated: animated)
            CATransaction.commit()
        } else {
            popViewController(animated: animated)
            completions?()
        }
    }
    
}






