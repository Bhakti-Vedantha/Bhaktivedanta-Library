//
//  SettingsViewController.swift
//  Prabupada
//
//  Created by Shannu on 15/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SettingsViewController: UITableViewController {
    let settingArr = ["Keep Awake", "Text", "Synonyms", "Translation", "Purport", "Dark Mode"]
    let defaults = UserDefaults.standard
    var labelInCell: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell
        if indexPath.item == 0{
            cell.label.text = "Font Size  " + String(Int(defaults.float(forKey: "size")))
            labelInCell = cell.label
            cell.toggler.isHidden = true
            cell.slider.value = defaults.float(forKey: "size")
            cell.slider.isContinuous = false
            cell.slider.addTarget(self, action: #selector(slideChanged), for: .valueChanged)
        }
        else{
            cell.label.text = settingArr[indexPath.item - 1]
            cell.slider.isHidden = true
            var val = true
            switch indexPath.item {
            case 1:
                val = defaults.integer(forKey: "keepAwake") == 2 ? true : false
                break
            case 2:
                val = defaults.integer(forKey: "showText") == 2 ? true : false
                break
            case 3:
                val = defaults.integer(forKey: "showSyn") == 2 ? true : false
                break
            case 4:
                val = defaults.integer(forKey: "showTra") == 2 ? true : false
                break
            case 5:
                val = defaults.integer(forKey: "showPur") == 2 ? true : false
                break
            case 6:
                val = defaults.integer(forKey: "darkMode") == 2 ? true : false
            default:
                break
            }
            cell.toggler.isOn = val
            cell.toggler.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
            cell.toggler.tag = indexPath.item
        }

        return cell
    }
    
    @objc func slideChanged(slider: UISlider){
        defaults.set(slider.value, forKey: "size")
        labelInCell.text = "Font Size  " + String(Int(defaults.float(forKey: "size")))
        print(defaults.float(forKey: "size"))
    }
    
    @objc func stateChanged(toggle: UISwitch ){
        var key = ""
        switch toggle.tag {
        case 1:
            key = "keepAwake"
            break
        case 2:
            key = "showText"
            break
        case 3:
            key = "showSyn"
            break
        case 4:
            key = "showTra"
            break
        case 5:
            key = "showPur"
            break
        case 6:
            key = "darkMode"
        default:
            print("Nothing")
        }
        let val = toggle.isOn ? 2 : 1
        defaults.set(val, forKey: key)
        print(defaults.integer(forKey: key))
        if val == 1{
            tabBarController?.overrideUserInterfaceStyle = .light
        }
        else{
            tabBarController?.overrideUserInterfaceStyle = .dark
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
