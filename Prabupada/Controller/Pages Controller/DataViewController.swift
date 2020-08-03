//
//  DataViewController.swift
//  Prabupada
//
//  Created by Shannu on 14/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class DataViewController: UIViewController{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageDetails: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    let defaults = UserDefaults.standard
    var index : Int?
    var displayText: String?
    var textForDetails : String?
    var titleForNav : String?
    var bookName : String?
    var level = 0
    var canto = 0
    var chapter = 0
    var verse = 0
    var pageNum = 0
    var hidden : Bool?
    
    var text : String?
    var syn : String?
    var trans : String?
    var pur : String?
    
    var attrText : NSAttributedString?
    var attrSyn : NSAttributedString?
    var attrTrans : NSAttributedString?
    var attrPur : NSAttributedString?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        if defaults.integer(forKey: "darkMode") == 2{
            textView.textColor = UIColor.white
        }
        else{
            textView.textColor = UIColor.black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayLabel.text = displayText
        // Do any additional setup after loading the view.
        let req : NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        let p1 = NSPredicate(format: "bookName == %@", bookName!)
        let p2 = NSPredicate(format: "level == %@", String(level))
        let p3 = NSPredicate(format: "canto == %@", String(canto))
        let p4 = NSPredicate(format: "chapter == %@", String(chapter))
        let p5 = NSPredicate(format: "verse == %@", String(verse))
        let p6 = NSPredicate(format: "pageNum == %@", String(pageNum))
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4, p5, p6])
        do{
            let res = try context.fetch(req)
            if res.count == 0{
                bookmarkButton.tintColor = .none
            }
            else{
                bookmarkButton.tintColor = .systemYellow
            }
        }
        catch{
            print(error)
        }
        
        
        let fontSize = CGFloat(defaults.float(forKey: "size"))
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        bookmarkButton.isHidden = hidden!
        if index == 1{
            imageView.image = UIImage(named: displayText!)
            textView.isHidden = true
        }
        else{
            
            if text != nil{
                let textAttr : [NSAttributedString.Key : Any] = [
                    .font : UIFont.italicSystemFont(ofSize: fontSize),
                    .paragraphStyle : style,
                ]
                text = text?.replacingOccurrences(of: "\n", with: "\n\t")
                text = text?.replacingOccurrences(of: "$", with: "\t")
                text! += "\n\n"
                attrText = NSAttributedString(string: text!, attributes: textAttr)
            }
            if syn != nil{
                let synAttr : [NSAttributedString.Key : Any] = [
                    .font : UIFont.italicSystemFont(ofSize: fontSize),
                    .paragraphStyle : style,
                ]
                syn = syn?.replacingOccurrences(of: "\n", with: "\n\t")
                syn = syn?.replacingOccurrences(of: "$", with: "\t")
                syn! += "\n\n"
                attrSyn = NSAttributedString(string: syn!, attributes: synAttr)
            }
            if trans != nil{
                let transAttr : [NSAttributedString.Key : Any] = [
                    .font : UIFont.boldSystemFont(ofSize: fontSize),
                    .paragraphStyle : style,
                ]
                trans = trans?.replacingOccurrences(of: "\n", with: "\n\t")
                trans = trans?.replacingOccurrences(of: "$", with: "\t")
                trans! += "\n\n"
                attrTrans = NSAttributedString(string: trans!, attributes: transAttr)
            }
            if pur != nil{
                let purAttr : [NSAttributedString.Key : Any] = [
                    .font : UIFont.systemFont(ofSize: fontSize),
                    .paragraphStyle : style,
                ]
                pur = pur?.replacingOccurrences(of: "\n", with: "\n\t")
                pur = pur?.replacingOccurrences(of: "$", with: "\t")
                attrPur = NSAttributedString(string: pur!, attributes: purAttr)
            }
            let finalText : NSMutableAttributedString? = NSMutableAttributedString(string: " ")
            
            if text != nil{
                finalText?.append(attrText!)
            }
            if syn != nil{
                finalText?.append(attrSyn!)
            }
            if trans != nil{
                finalText?.append(attrTrans!)
            }
            if pur != nil{
                finalText?.append(attrPur!)
            }
            
            pageDetails.textAlignment = .justified
            imageView.isHidden = true
//            displayText = displayText?.replacingOccurrences(of: "\n", with: "\n\t")
//            displayText = displayText?.replacingOccurrences(of: "$", with: "\t")
            pageDetails.text = textForDetails
            textView!.attributedText = finalText
//            textView.textColor = UIColor.systemBackground
//            if defaults.integer(forKey: "darkMode") == 2{
//                textView.textColor = UIColor.white
//            }
//            else{
//                textView.textColor = UIColor.black
//            }
//            textView!.textAlignment = .left
//            textView!.font = UIFont.systemFont(ofSize: CGFloat(defaults.float(forKey: "size")))
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
    
    
    @IBAction func addBookmark(_ sender: UIButton) {
        print(bookName!)
        print(level)
        print(canto)
        print(chapter)
        print(verse)
        print(pageNum)
        
        let req : NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        let p1 = NSPredicate(format: "bookName == %@", bookName!)
        let p2 = NSPredicate(format: "level == %@", String(level))
        let p3 = NSPredicate(format: "canto == %@", String(canto))
        let p4 = NSPredicate(format: "chapter == %@", String(chapter))
        let p5 = NSPredicate(format: "verse == %@", String(verse))
        let p6 = NSPredicate(format: "pageNum == %@", String(pageNum))
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4, p5, p6])
        do{
            let res = try context.fetch(req)
            if res.count == 0{
                let newBookmark = Bookmarks(context: context)
                newBookmark.bookName = bookName
                newBookmark.level = Int32(level)
                newBookmark.canto = Int32(canto)
                newBookmark.chapter = Int32(chapter)
                newBookmark.verse = Int32(verse)
                newBookmark.pageNum = Int32(pageNum)
                do{
                    try context.save()
                }
                catch{
                    print(error)
                }
                bookmarkButton.tintColor = .systemYellow
            }
            else{
                context.delete(res[0])
                do{
                    try context.save()
                }
                catch{
                    print(error)
                }
                bookmarkButton.tintColor = .none
            }
        }
        catch{
            print(error)
        }
    }
    

}
