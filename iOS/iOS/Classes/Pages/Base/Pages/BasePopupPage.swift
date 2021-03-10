//
//  BasePopup
//  SteakBox
//
//  Created by ToaNT1 on 4/7/18.
//  Copyright © 2018 ThanhToa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasePopup: BasePage {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        modalPresentationStyle = .overCurrentContext
    }
    
    func removeAnimate()
    {
        dismiss(animated: false, completion: nil)
    }
    
}

