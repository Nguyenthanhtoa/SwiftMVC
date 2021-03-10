//
//  Font.swift
//  phimbo
//
//  Created by Dao Duy Duong on 10/23/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit

struct Font {
    static let system = System()
    static let helvetica = Helvetica()
    
    static let helveticaBold: UIFont = {
        return Helvetica().bold(withSize: 16)
    }()
    static let helveticaLight: UIFont = {
        return Helvetica().light(withSize: 16)
    }()
    static let helveticaRegular: UIFont = {
        return Helvetica().normal(withSize: 16)
    }()
}

protocol FontFactory {
    var normalName: String { get }
    var lightName: String { get }
    var boldName: String { get }
    
    func normal(withSize size: CGFloat) -> UIFont
    func light(withSize size: CGFloat) -> UIFont
    func bold(withSize size: CGFloat) -> UIFont
}

extension FontFactory {
    
    func normal(withSize size: CGFloat) -> UIFont {
        return UIFont(name: normalName, size: size)!
    }
    
    func light(withSize size: CGFloat) -> UIFont {
        return UIFont(name: lightName, size: size)!
    }
    
    func bold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: boldName, size: size)!
    }
}

struct System: FontFactory {
    internal var normalName: String {
        return ""
    }
    internal var lightName: String {
        return ""
    }
    internal var boldName: String {
        return ""
    }
    
    func normal(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    func light(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
    
    func bold(withSize size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
}

class Helvetica: FontFactory {
    internal var normalName: String {
        return "Helvetica"
    }
    internal var lightName: String {
        return "Helvetica-Light"
    }
    internal var boldName: String {
        return "Helvetica-Bold"
    }
}



