//
//  DataViewController.swift
//  Prabupada
//
//  Created by Shannu on 14/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

class DataViewController: UIViewController{

    @IBOutlet weak var contentView: UIView!
    let defaults = UserDefaults.standard
    var index : Int?
    var displayText: String?
    var titleForNav : String?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayLabel.text = displayText
        // Do any additional setup after loading the view.
        if index == 1{
            imageView.image = UIImage(named: displayText!)
            textView.isHidden = true
        }
        else{
            imageView.isHidden = true
            displayText = displayText?.replacingOccurrences(of: "\n", with: "\n\t")
            displayText = displayText?.replacingOccurrences(of: "$", with: "\t")
            textView!.text = displayText
            textView!.textAlignment = .left
            textView!.font = UIFont.systemFont(ofSize: CGFloat(defaults.float(forKey: "size")))
            textView!.isEditable = false
            textView!.showsVerticalScrollIndicator = false
        }
        
//        navigationController?.title = titleForNav
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
