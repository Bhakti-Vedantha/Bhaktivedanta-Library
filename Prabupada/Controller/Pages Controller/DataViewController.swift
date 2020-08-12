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
class DataViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageDetails: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
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
    var searchText = " "
    
    var text : String?
    var syn : String?
    var trans : String?
    var pur : String?
    
    var res : [Tags]?
    var color : UIColor?
    
    var attrText : NSAttributedString?
    var attrSyn : NSAttributedString?
    var attrTrans : NSAttributedString?
    var attrPur : NSAttributedString?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageText = ""
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
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        layout.minimumInteritemSpacing = 10
        
        if self.traitCollection.userInterfaceStyle == .dark{
            color = UIColor.blue
        }
        else{
            color = UIColor.systemYellow
        }
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
        
        let req1 : NSFetchRequest<Tags> = Tags.fetchRequest()
        let p11 = NSPredicate(format: "bookName == %@", bookName!)
        let p22 = NSPredicate(format: "level == %@", String(level))
        let p33 = NSPredicate(format: "canto == %@", String(canto))
        let p44 = NSPredicate(format: "chapter == %@", String(chapter))
        let p55 = NSPredicate(format: "verse == %@", String(verse))
        let p66 = NSPredicate(format: "pageNum == %@", String(pageNum))
        req1.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p11, p22, p33, p44, p55, p66])
        do{
            res = try context.fetch(req1)
        }
        catch{
            print(error)
        }
        
        
        let fontSize = CGFloat(defaults.float(forKey: "size"))
        let style1 = NSMutableParagraphStyle()
        style1.alignment = .justified
        style1.lineSpacing = 5
        let style2 = NSMutableParagraphStyle()
        style2.alignment = .center
        style2.lineSpacing = 5
        bookmarkButton.isHidden = hidden!
        tagButton.isHidden = hidden!
        if index == 1{
            imageView.image = UIImage(named: displayText!)
            textView.isHidden = true
        }
        else{
            let textAttr : [NSAttributedString.Key : Any] = [
                .font : UIFont.italicSystemFont(ofSize: fontSize),
                .paragraphStyle : style1,
            ]
            let synAttr : [NSAttributedString.Key : Any] = [
                .font : UIFont.italicSystemFont(ofSize: fontSize),
                .paragraphStyle : style1,
            ]
            let transAttr : [NSAttributedString.Key : Any] = [
                .font : UIFont.boldSystemFont(ofSize: fontSize),
                .paragraphStyle : style1,
            ]
            let purAttr : [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: fontSize),
                .paragraphStyle : style1,
            ]
            if text != nil{
//                text = text?.replacingOccurrences(of: "\n", with: "\n\n")
                while((text!.contains("\n\n"))){
                    text = text?.replacingOccurrences(of: "\n\n", with: "")
                }
                text = text?.replacingOccurrences(of: "¶", with: " ")
                text = text?.replacingOccurrences(of: "$", with: "\n\n")
                if text!.contains("\n"){
                    text! += "\n\n"
                }
                else{
                    text! += "\n\n"
                }
                attrText = NSAttributedString(string: text!, attributes: textAttr)
            }
            if syn != nil{
                syn = syn?.replacingOccurrences(of: "\n", with: "\n\n")
                while((syn!.contains("\n\n"))){
                    syn = syn?.replacingOccurrences(of: "\n\n", with: "")
                }
                syn = syn?.replacingOccurrences(of: "$", with: "\n\n")
                syn = syn?.replacingOccurrences(of: "¶", with: " ")
                if syn!.contains("\n"){
                    syn! += "\n"
                }
                else{
                    syn! += "\n\n"
                }
                attrSyn = NSAttributedString(string: syn!, attributes: synAttr)
            }
            if trans != nil{
                trans = trans?.replacingOccurrences(of: "\n", with: "\n\n")
                while((trans!.contains("\n\n"))){
                    trans = trans?.replacingOccurrences(of: "\n\n", with: "")
                }
                trans = trans?.replacingOccurrences(of: "$", with: "\n\n")
                trans = trans?.replacingOccurrences(of: "¶", with: " ")
                if trans!.contains("\n"){
                    trans! += "\n"
                }
                else{
                    trans! += "\n\n"
                }
                attrTrans = NSAttributedString(string: trans!, attributes: transAttr)
            }
            if pur != nil{
                pur = pur?.replacingOccurrences(of: "\n", with: "\n\n")
                while((pur!.contains("\n\n"))){
                    pur = pur?.replacingOccurrences(of: "\n\n", with: "")
                }
                pur = pur?.replacingOccurrences(of: "$", with: "\n\n")
                pur = pur?.replacingOccurrences(of: "¶", with: " ")
                attrPur = NSAttributedString(string: pur!, attributes: purAttr)
            }
            let finalText : NSMutableAttributedString? = NSMutableAttributedString(string: " ")
            
            let searchAttr : [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: fontSize),
                .backgroundColor : color!
            ]
            if text != nil{
                if searchText != " " && attrText!.string.contains(searchText){
                    let arr = attrText?.string.components(separatedBy: searchText)
                    var index = 0
                    for i in arr!{
                        let newText = NSAttributedString(string: i, attributes: textAttr)
                        let seaText = NSAttributedString(string: searchText, attributes: searchAttr)
                        finalText?.append(newText)
                        if index != arr!.count - 1{
                            finalText?.append(seaText)
                        }
                        index += 1
                    }
                }
                else{
                    finalText?.append(attrText!)
                }
            }
            if syn != nil{
                if searchText != " " && attrSyn!.string.contains(searchText){
                    let arr = attrSyn?.string.components(separatedBy: searchText)
                    var index = 0
                    for i in arr!{
                        let newText = NSAttributedString(string: i, attributes: synAttr)
                        let seaText = NSAttributedString(string: searchText, attributes: searchAttr)
                        finalText?.append(newText)
                        if index != arr!.count - 1{
                            finalText?.append(seaText)
                        }
                        index += 1
                    }
                }
                else{
                    finalText?.append(attrSyn!)
                }
            }
            if trans != nil{
                if searchText != " " && attrTrans!.string.contains(searchText){
                    let arr = attrTrans?.string.components(separatedBy: searchText)
                    var index = 0
                    for i in arr!{
                        let newText = NSAttributedString(string: i, attributes: transAttr)
                        let seaText = NSAttributedString(string: searchText, attributes: searchAttr)
                        finalText?.append(newText)
                        if index != arr!.count - 1{
                            finalText?.append(seaText)
                        }
                        index += 1
                    }
                }
                else{
                    finalText?.append(attrTrans!)
                }
            }
            if pur != nil{
                if searchText != " " && attrPur!.string.contains(searchText){
                    let arr = attrPur?.string.components(separatedBy: searchText)
                    var index = 0
                    for i in arr!{
                        let newText = NSAttributedString(string: i, attributes: purAttr)
                        let seaText = NSAttributedString(string: searchText, attributes: searchAttr)
                        finalText?.append(newText)
                        if index != arr!.count - 1{
                            finalText?.append(seaText)
                        }
                        index += 1
                    }
                }
                else{
                    finalText?.append(attrPur!)
                }
            }
            
            pageDetails.textAlignment = .center
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
    
    @IBAction func addTag(_ sender: UIButton) {
        var text = ""
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Tag", message: "Tag Name Should not be empty or contain comma", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Tag", style: .default) { (action) in
            if !textField.text!.isEmpty{
//                text = textField.text!
                if textField.text!.contains(","){
                    self.addTag(sender)
                    return
                }
                text = textField.text!
                if text.first != "#"{
                    text = "#" + textField.text!
                }
                let req : NSFetchRequest<Tags> = Tags.fetchRequest()
                let p1 = NSPredicate(format: "bookName == %@", self.bookName!)
                let p2 = NSPredicate(format: "level == %@", String(self.level))
                let p3 = NSPredicate(format: "canto == %@", String(self.canto))
                let p4 = NSPredicate(format: "chapter == %@", String(self.chapter))
                let p5 = NSPredicate(format: "verse == %@", String(self.verse))
                let p6 = NSPredicate(format: "pageNum == %@", String(self.pageNum))
                let p7 = NSPredicate(format: "tagName == %@", text)
                req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p7, p1, p2, p3, p4, p5, p6])
                do{
                    let res = try self.context.fetch(req)
                    if res.count == 0{
                        let newTag = Tags(context: self.context)
                        newTag.bookName = self.bookName
                        newTag.chapter = Int32(self.chapter)
                        newTag.canto = Int32(self.canto)
                        newTag.level = Int32(self.level)
                        newTag.verse = Int32(self.verse)
                        newTag.pageNum = Int32(self.pageNum)
                        newTag.tagName = text
                        do{
                            try self.context.save()
                        }
                        catch{
                            print(error)
                        }
                        self.tagButton.titleLabel?.text = text
                        let req1 : NSFetchRequest<Tags> = Tags.fetchRequest()
                        let p11 = NSPredicate(format: "bookName == %@", self.bookName!)
                        let p22 = NSPredicate(format: "level == %@", String(self.level))
                        let p33 = NSPredicate(format: "canto == %@", String(self.canto))
                        let p44 = NSPredicate(format: "chapter == %@", String(self.chapter))
                        let p55 = NSPredicate(format: "verse == %@", String(self.verse))
                        let p66 = NSPredicate(format: "pageNum == %@", String(self.pageNum))
                        req1.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p11, p22, p33, p44, p55, p66])
                        do{
                            self.res = try self.context.fetch(req1)
                        }
                        catch{
                            print(error)
                        }
                        self.collectionView.reloadData()
                    }
                }
                catch{
                    print(error)
                }
            }
            else{
                self.addTag(sender)
            }
        }
        alert.addAction(action)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return
        }
        alert.addAction(cancel)
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Enter your Tag name"
            textField = alertTF
        }
        present(alert, animated: true, completion: nil)
//        if text == ""{
//            return
//        }
    }
    
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return res!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagViewCell
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.backgroundColor = .lightGray
        cell.tagName.textColor = .black
        cell.tagName.text = "   " + res![indexPath.item].tagName! + "   x "
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        context.delete(res![indexPath.item])
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        let req1 : NSFetchRequest<Tags> = Tags.fetchRequest()
        let p11 = NSPredicate(format: "bookName == %@", self.bookName!)
        let p22 = NSPredicate(format: "level == %@", String(self.level))
        let p33 = NSPredicate(format: "canto == %@", String(self.canto))
        let p44 = NSPredicate(format: "chapter == %@", String(self.chapter))
        let p55 = NSPredicate(format: "verse == %@", String(self.verse))
        let p66 = NSPredicate(format: "pageNum == %@", String(self.pageNum))
        req1.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p11, p22, p33, p44, p55, p66])
        do{
            self.res = try self.context.fetch(req1)
        }
        catch{
            print(error)
        }
        collectionView.reloadData()
    }
    

}
