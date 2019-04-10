//
//  NXTSplashViewController.swift
//  NXTPulse
//
//  Created by Pradeep on 3/21/19.
//  Copyright © 2019 Tarento Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class NXTSplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.handleViewDisplayProcess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func handleViewDisplayProcess() {
        self.pushToAuthenticationViewController(fromVC: self) { (authenticationViewController) in
        }
    }

    func pushToAuthenticationViewController(fromVC:UIViewController, completionHandler: @escaping( (UIViewController) -> Void)) {
        let authenticationVC = NXTPulseBaseViewController.pulseAuthenticationController()
        fromVC.navigationController?.pushViewController(authenticationVC, animated: false)
        completionHandler(authenticationVC)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
