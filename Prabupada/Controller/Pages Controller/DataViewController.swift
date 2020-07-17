//
//  DataViewController.swift
//  Prabupada
//
//  Created by Shannu on 14/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    var index : Int?
    var displayText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewForPurport = UITextView(frame: CGRect(x: 20, y: 20, width: contentView.frame.width - 40, height: contentView.frame.height))
        viewForPurport.text = displayText
        viewForPurport.showsVerticalScrollIndicator = false
        viewForPurport.backgroundColor = UIColor.lightGray
        viewForPurport.font = UIFont.systemFont(ofSize: CGFloat(defaults.float(forKey: "size")))
        viewForPurport.isEditable = false
        contentView.addSubview(viewForPurport)
//        displayLabel.text = displayText
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
