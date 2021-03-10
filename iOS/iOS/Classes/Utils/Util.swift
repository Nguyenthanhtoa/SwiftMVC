//
//  Util.swift
//  HealthCare
//
//  Created by Dao Duy Duong on 11/18/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import ObjectMapper

struct Util {
    
    // MARK: Load nib
    static func loadNib<T: UIView>(fromNamed name: String) -> T? {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    //MARK: Create navigation
    static func navigationButton(withImage image: UIImage? = nil, title: String? = nil, andInsets insets: UIEdgeInsets? = nil) -> UIBarButtonItem {
        let btn = UIBarButtonItem()
        btn.imageInsets = insets ?? .zero
        btn.image = image
        btn.title = title

        return btn
    }
    
    //MARK: Create navigation
    static func navigationTitle(withFrame frame: CGRect) -> UILabel {
        let titleLbl = UILabel(frame: frame)
        titleLbl.textColor = .white
        titleLbl.font = Font.system.bold(withSize: 17)
        titleLbl.numberOfLines = 2
        titleLbl.textAlignment = .center
        
        return titleLbl
    }
    
    //MARK: Create badge navigation button
    static func navigationBadgeButton(withImage image: UIImage? = nil) -> SSBadgeButton {
        let btn = SSBadgeButton()
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        btn.badge = "0"
        
        return btn
    }
    
    //MARK: get page with storyboard id
    static func getPage<T: UIViewController>(fromId id: String) -> T? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) as? T
    }
    
    static func getScript(withResourceName fileName: String, resourceType: String = "js") -> String {
        guard let scriptPath = Bundle.main.path(forResource: fileName, ofType: resourceType),
            let scriptSource = try? String(contentsOfFile: scriptPath) else { return "" }
        
        return scriptSource
    }

}
