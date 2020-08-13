//
//  TabViewController.swift
//  Prabupada
//
//  Created by Shannu on 02/08/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

//@available(iOS 13.0, *)
class TabViewController: UITabBarController{

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *){
            if defaults.integer(forKey: "darkMode") == 0{
                overrideUserInterfaceStyle = .light
            }
            else{
                if defaults.integer(forKey: "darkMode") == 1{
                    overrideUserInterfaceStyle = .light
                }
                else{
                    overrideUserInterfaceStyle = .dark
                }
            }
        }
        
        // Do any additional setup after loading the view.
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
