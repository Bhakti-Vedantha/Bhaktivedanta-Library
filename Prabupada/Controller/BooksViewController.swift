//
//  BooksViewController.swift
//  Prabupada
//
//  Created by Shannu on 13/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class BooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var collectionView: UICollectionView!
    let defaults = UserDefaults.standard
    var clickedIndex = 0
    var books : [Book_Levels]!
    var label = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2, height: (self.collectionView.frame.size.height - 20) / 2)
        // Do any additional setup after loading the view.
        let request : NSFetchRequest<Book_Levels> = Book_Levels.fetchRequest()
        do{
            books = try context.fetch(request)
        }
        catch{
            print(error)
        }
//        print(books[0].currPage)
        storeIfNot()
    }
    
    func storeIfNot(){
        if defaults.integer(forKey: "showText") == 0{
            defaults.set(2, forKey: "showText")
        }
        if defaults.integer(forKey: "showSyn") == 0{
            defaults.set(2, forKey: "showSyn")
        }
        if defaults.integer(forKey: "showTra") == 0{
            defaults.set(2, forKey: "showTra")
        }
        if defaults.integer(forKey: "showPur") == 0{
            defaults.set(2, forKey: "showPur")
        }
        if defaults.integer(forKey: "keepAwake") == 0{
            defaults.set(2, forKey: "keepAwake")
        }
        if defaults.float(forKey: "size") == 0 {
            defaults.set(20, forKey: "size")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BookCollectionViewCell
        
        cell.bookName.text! = books[indexPath.item].bookName!
        cell.bookImage.image = UIImage(named: books[indexPath.item].bookName! + ".jpg")
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.label = books[indexPath.item].bookName!
        clickedIndex = indexPath.item
        performSegue(withIdentifier: "openBook", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openBook"{
            let destVC = segue.destination as! ContentViewController
            destVC.label = self.label
            if books[clickedIndex].level == 1{
                let req : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                req.predicate = pred
                do{
                    let res = try context.fetch(req)
                    destVC.pagesCount = Int(res[0].pagesCount) + 1
                    destVC.chapCount = Int(res[0].chaptersCount)
                    print(res[0].pagesCount)
                    destVC.currentVCIndex = Int(res[0].currPage)
//                        Int(res[0].currPage)
                    destVC.level = 1
                    destVC.level_1_book = res[0]
                    let starter_arr = [res[0].preface, res[0].intro, res[0].dedication, res[0].foreword, res[0].introNote, res[0].invocation, res[0].mission, res[0].prologue]
                    var another_arr : [String] = []
                    for i in starter_arr{
                        if i?.count != 0{
                            another_arr.append(i!)
                        }
                    }
                    destVC.level_1_startings = another_arr
                    let req : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                    req.predicate = pred
                    let sort = NSSortDescriptor(key: "pageNum", ascending: true)
                    req.sortDescriptors = [sort]
                    do{
                        destVC.level_1_pages = try context.fetch(req)
                    }
                    catch{
                        print(error)
                    }
                }
                catch{
                    print(error)
                }
            }
//            destVC.currentVCIndex = Int(books[clickedIndex].currPage)
//            print(Int(books[clickedIndex].currPage))
//            destVC.pagesCount = Int(books[clickedIndex].pagesCount)
//            destVC.book = books[clickedIndex]
//            let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
//            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
//            req.predicate = pred
//            let sort = NSSortDescriptor(key: "pageNum", ascending: true)
//            req.sortDescriptors = [sort]
//            do{
//                destVC.pages = try context.fetch(req)
//            }
//            catch{
//                print(error)
//            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadData() {
        
        // Level 1
        let files = ["tlk", "mg", "tqk", "bbd", "poy", "iso", "ecs", "tlc", "nod", "kb", "ttp", "owk", "rv", "noi", "tys", "pop"]
        let req : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
        do{
            let res = try context.fetch(req)
            if res.count == 0{
                for file in files{
                        let url = Bundle.main.url(forResource: file, withExtension: "json")
                        if let jsonData = url{
                            if let data = try? Data(contentsOf: jsonData){
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                    if let dict = json as? [Dictionary<String, Any>] {
                                        var maxChap = 0
                                        var pagesCount = 0
                                        let book = Level_1_Books(context: context)
                                        for page in dict{
                                            pagesCount += 1
                                            guard let bookName = page["book"] as? String else {
                                                print("1")
                                                return
                                            }
                                            guard let chapter = page["chapter"] as? String else {
                                                print("2")
                                                return
                                            }
                                            guard let text = page["text"] as? String else {
                                                                                    print("5")
                                                                                    return
                                                                                }
                                            let syn = page["synonyms"] as? String
//                                            guard let syn = page["synonyms"] as? String else {
//                                                print("6")
//                                                return
//                                            }
                                            guard let trans = page["translation"] as? String else {
                                                print("7")
                                                return
                                            }
                                            guard let purp = page["purport"] as? String else {
                                                print("8")
                                                return
                                            }
                                            let request : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
                                            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                                            request.predicate = pred
                                            var results : [NSManagedObject] = []
                                            do{
                                                results = try context.fetch(request)
                                            }
                                            catch{
                                                print(error)
                                            }
                                            if results.count == 0{
                                                book.bookName = bookName
                                                book.chaptersCount = 0
                                                book.currPage = 1
                                                book.pagesCount = 1
                                                do{
                                                    try context.save()
                                                }
                                                catch{
                                                    print(error)
                                                }
                                            }
                                            let lis = ["Preface", "Introduction", "Foreword", "Dedication", "Introductory Note by George Harrison", "Invocation", "Lord Caitanya’s Mission", "Prologue"]
                                            if lis.contains(chapter){
                                                if lis[0] == chapter{
                                                    book.preface = purp
                                                }
                                                if lis[1] == chapter{
                                                    book.intro = purp
                                                }
                                                if lis[2] == chapter{
                                                    book.foreword = purp
                                                }
                                                if lis[3] == chapter{
                                                    book.dedication = purp
                                                }
                                                if lis[4] == chapter{
                                                    book.introNote = purp
                                                }
                                                if lis[5] == chapter{
                                                    book.invocation = purp
                                                }
                                                if lis[6] == chapter{
                                                    book.mission = purp
                                                }
                                                if lis[7] == chapter{
                                                    book.prologue = purp
                                                }
                                                do{
                                                    try context.save()
                                                }
                                                catch{
                                                    print(error)
                                                }
                                            }
                                            else {
                                                let curPage = Level_1_Pages(context: context)
                                                curPage.bookName = bookName
                                                let arr = chapter.components(separatedBy: ". ")
                                                curPage.chapterName = arr[1]
                                                curPage.chapter = Int32(arr[0])!
                                                maxChap = Int(arr[0])! > maxChap ? Int(arr[0])! : maxChap
                                                curPage.purport = purp
                                                curPage.text = text
                                                if syn != nil{
                                                    curPage.syn = syn
                                                }
                                                curPage.translation = trans
                                                do{
                                                    try context.save()
                                                }
                                                catch{
                                                    print(error)
                                                }
                                            }
                                        }
                                        book.chaptersCount = Int32(maxChap)
                                        book.pagesCount = Int32(pagesCount)
                                        do{
                                            try context.save()
                                        }
                                        catch{
                                            print(error)
                                        }
                                        let pagesReq : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
                                        let pred = NSPredicate(format: "bookName CONTAINS %@", book.bookName!)
                                        let sort = NSSortDescriptor(key: "chapter", ascending: true)
                                        pagesReq.predicate = pred
                                        pagesReq.sortDescriptors = [sort]
                                        do{
                                            let pagesArr = try context.fetch(pagesReq)
                                            var num = 1
                                            for i in pagesArr{
                                                i.pageNum = Int32(num)
                                                num += 1
                                            }
                                            try context.save()
                                        }
                                        catch{
                                            print(error)
                                        }
                                    }
                                    else{
                                        print("Err4")
                                    }
                                }
                                else{
                                    print("Err5")
                                }
                            }
                            else{
                                print("Err6")
                            }
                        }
                        else{
                            print("Err10")
                        }
                    }
                let arr = ["KṚṢṆA, The Supreme Personality of Godhead", "The Nectar of Instruction", "Śrī Īśopaniṣad", "Kṛṣṇa Consciousness, The Topmost Yoga System", "Rāja-Vidyā: The King of Knowledge", "The Nectar of Devotion", "Teachings of Lord Caitanya", "Elevation to Kṛṣṇa Consciousness", "Kṛṣṇa Consciousness, The Matchless Gift", "Transcendental Teachings of Prahlāda Mahārāja", "Teachings of Lord Kapila, the Son of Devahuti", "Teachings of Queen Kuntī", "The Path of Perfection", "The Perfection of Yoga", "Beyond Birth & Death", "On the Way to Kṛṣṇa"]
                print(arr.count)
                for a in arr{
                    let levels = Book_Levels(context: context)
                    levels.bookName = a
                    levels.level = 1
                    do{
                        try context.save()
                    }
                    catch{
                        print(error)
                    }
                }

                }
        }
        catch{
            print(error)
        }
    }

}
