//
//  BackEnabledNavigationController.swift
//  AppStoreJSONApis
//
//  Created by Brian Voong on 3/5/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
}
