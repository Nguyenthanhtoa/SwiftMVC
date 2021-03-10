//
//  DEViewController.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/6/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import Toaster

class BasePage: UIViewController {
    
    var disposeBag: DisposeBag! = DisposeBag()
    var indicatorView: NVActivityIndicatorView!
    let service = ApiService()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var refreshControl: UIRefreshControl!
    var emptyView: UIView!
    var emptyLbl: UILabel!
    var reloadBtn: UIButton!
    var varEmptyVisible = BehaviorRelay(value: false)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initActivityIndicator()
        initEmptyView()
        
        initialize()
        react()
        loadSource()
        
        varEmptyVisible
            .asObservable()
            .subscribe(onNext: setEmptyVisible) => disposeBag
    }
    
    // MARK: - For subclass to override
    func initialize() {}
    func react() {}
    func loadSource() {}
    func makeSource() {}
    func reload() {
        loadSource()
    }

    func destroy() {
        disposeBag = nil
    }
    
    // MARK: indicatorView
    func initActivityIndicator() {
        let frame = CGRect(x: view.center.x - 15, y: view.center.y - 15, width: 30, height: 30)
        indicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin)
        indicatorView.color = .indicatorColor
        view.addSubview(indicatorView)
    }
    
    // MARK: Empty lbl
    func initEmptyView() {
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        emptyView.center = view.center
        emptyView.backgroundColor = .clear
        view.addSubview(emptyView)
        
        emptyLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        emptyLbl.textAlignment = .center
        emptyLbl.text = dataManager.isConnected() ? "Không có dữ liệu." : "Không thể kết nối với internet!"
        emptyLbl.backgroundColor = .clear
        emptyLbl.numberOfLines = 0
        emptyView.addSubview(emptyLbl)

        reloadBtn = UIButton(type: .custom)
        reloadBtn.frame = CGRect(x: 66, y: emptyLbl.bounds.height, width: 120, height: 40)
        reloadBtn.backgroundColor = .primaryColor
        reloadBtn.cornerRadius(radius: 5)
        reloadBtn.setTitle("Thử lại", for: .normal)
        reloadBtn.setTitleColor(.white, for: .normal)
        reloadBtn.addTarget(self, action: #selector(reloadSource), for: .touchUpInside)
//        emptyView.addSubview(reloadBtn)
    }
    
    @objc func reloadSource() {
        varEmptyVisible.accept(false)
        reload()
    }
    
    func setEmptyVisible(_ isVisible: Bool) {
        emptyView.isHidden = !isVisible
    }
}

//MARK: Toast and indicator
extension BasePage: NVActivityIndicatorViewable {
    
    // MARK: Activity indicator
    func showLoading(_ message: String? = "Xin chờ..."){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: message, type: NVActivityIndicatorType.circleStrokeSpin)
        delay(Scheduler.loadingTimeout, closure: { self.hideLoading() })
    }
    
    func hideLoading() {
        stopAnimating(nil)
    }
    
    // Indicator
    func showIndicator() {
        indicatorView.startAnimating()
        delay(Scheduler.loadingTimeout, closure: { self.hideIndicator() })
    }
    
    func hideIndicator(_ isDelay: Bool = false) {
        if isDelay {
            delay(0.5, closure: { self.indicatorView.stopAnimating() })
        } else {
            indicatorView.stopAnimating()
        }
    }
    
    // MARK: Toast
    func showToast(_ message: String = "") {
        ToastCenter.default.cancelAll()
        Toast(text: message).show()
    }
    
}

//MARK: Navigation bar action
extension BasePage {
    
    func isLogin() -> Bool {
        return dataManager.varUser.value != nil
    }
}

// Refresh control
extension BasePage {
    
    func initPullToRefresh(with scrollView: UIScrollView) {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(doReload), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    @objc func doReload() {
        reload()
    }
    
}





