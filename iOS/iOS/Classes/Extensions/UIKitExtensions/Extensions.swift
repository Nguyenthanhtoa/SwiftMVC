//
//  Extensions.swift
//  StupidLazy
//
//  Created by ToaNT1 on 3/28/18.
//  Copyright © 2018 appteamvn. All rights reserved.
//

import UIKit
import WebKit

// MARK: Extension for UIBarButtonItem
extension UIBarButtonItem {
    
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}

// MARK: Extension for UIColor
extension UIColor {
    
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    static func hex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? UIColor.clear
    }
    
    convenience init?(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "")
        guard let hex = hexString.hex else { return nil }
        self.init(hex: hex)
    }
    
}

// MARK: Extension for UIColor
extension UIColor {
    
    static let primaryColor: UIColor = .hex("#004E00") // Flat green
    static let tabbarTintColor: UIColor = .hex("#003ED9")
    static let indicatorColor: UIColor = .hex("#2661D8") // main blue
    
}

// MARK: Extension for Tableview
extension UITableView {
    
    public func register<T: UITableViewCell>(withCell name: T.Type) {
        register(UINib(nibName: String(describing: name), bundle: nil), forCellReuseIdentifier: String(describing: name))
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    
    func getCellAt<T: UITableViewCell>(index : Int, _ section: Int = 0) -> T?
    {
        let indexPath = IndexPath(item: index, section: section)
        let cell =  self.cellForRow(at: indexPath)
        return cell as? T
    }
    
    func setOffsetToBottom(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: contentSize.height - frame.size.height), animated: true)
    }
    
    func scrollToLastRow(animated: Bool) {
        let rows = self.numberOfRows(inSection: 0)
        if rows > 0 {
            self.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func getIndexPath(atView view: UIView) -> IndexPath
    {
        let point = view.convert(CGPoint.zero, to: self as UIView)
        let indexPath: IndexPath! = self.indexPathForRow(at: point)
        return indexPath
    }
}

// MARK: Extension for WKWebView
extension WKWebView {
    
    func loadHtml(_ htmlString: String) {
        self.loadHTMLString(htmlString.toHtmlFormat, baseURL: nil)
    }
    
}

// MARK: Extension for Tableview
extension UICollectionView {
    
    func registCell(_ withNibIndentifier: String) {
        self.register(UINib(nibName: withNibIndentifier, bundle: nil), forCellWithReuseIdentifier: withNibIndentifier)
    }
}

extension DateFormatter {
    
    func makeDateFormat(_ format: String = "yyyy-mm-ddThh:mm:ss") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
}

// MARK: Extension for Array
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

// MARK: - Date extensions
extension Date {
    
    func asCDateString(_ format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func isLessThan(toDate date: Date) -> Bool {
        let result = Calendar.current.compare(self, to: date, toGranularity: .day)
        return result == .orderedAscending
    }
    
    var isoString: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return formatter.string(from: self.toLocalTime())
    }
    
    func asISOString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        return formatter.string(from: self)
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Check date betweek two days
    func isBetweenDates(_ beginDate: Date, _ endDate: Date) -> Bool {
        if self.compare(beginDate) == .orderedAscending {
            return false
        }
        
        if self.compare(endDate) == .orderedDescending {
            return false
        }
        
        return true
    }

}

extension NSDictionary {
    
    func toJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii) {
                return jsonString
        }
        return nil
    }
    
}

// MARK: Extension for UIBarButtonItem
extension UIButton {
    
    func cornerRadius(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}

// MARK: Extension for UIImageView
extension UIImageView {
    
    func loadNotFoundImage(_ name: String = "ic_no_img_found") {
        self.image = UIImage(named: name)
    }
    
}

extension URL {
    func isValidURL() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }
    
    func valueOf(_ queryParamaterName: String) -> String {
        guard let url = URLComponents(string: self.absoluteString) else { return "" }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value ?? ""
    }
    
}
