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
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayLabel.text = displayText
        // Do any additional setup after loading the view.
        if index == 1{
            let image = UIImageView(frame: CGRect(x: 10, y: 15, width: contentView.frame.width - 20, height: UIScreen.main.bounds.height - 125))
            image.image = UIImage(named: displayText!)
            contentView.addSubview(image)
        }
        else{
            let textView = UITextView(frame: CGRect(x: 10, y: 15, width: contentView.frame.width - 20, height: UIScreen.main.bounds.height - 125))
            textView.text = displayText
            textView.textAlignment = .left
            textView.font = UIFont.systemFont(ofSize: CGFloat(defaults.float(forKey: "size")))
            textView.isEditable = false
            textView.showsVerticalScrollIndicator = false
            contentView.addSubview(textView)
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
