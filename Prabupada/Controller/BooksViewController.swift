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
        if defaults.integer(forKey: "keepAwake") == 2{
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else{
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView.reloadData()
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
        if defaults.integer(forKey: "darkMode") == 0{
            defaults.set(1, forKey: "darkMode")
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
        cell.bookName.backgroundColor = .systemBackground
//        if self.traitCollection.userInterfaceStyle == .dark{
//            cell.bookName.backgroundColor = .black
//        }
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
                    let arr = ["Preface", "Introduction", "Dedication", "Foreword", "Introductory Note by George Harrison", "Invocation", "Lord Caitanya’s Mission", "Prologue"]
                    let starter_arr = [res[0].preface, res[0].intro, res[0].dedication, res[0].foreword, res[0].introNote, res[0].invocation, res[0].mission, res[0].prologue]
                    var another_arr : [String] = []
                    var arr_2 : [String] = []
                    var c = 0
                    for i in starter_arr{
                        if i?.count != 0{
                            another_arr.append(i!)
                            arr_2.append(arr[c])
                        }
                        c += 1
                    }
                    destVC.level_1_startings = another_arr
                    destVC.level_1_headings = arr_2
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
            if books[clickedIndex].level == 2{
                let req : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                req.predicate = pred
                do{
                    let res = try context.fetch(req)
                    destVC.pagesCount = Int(res[0].pagesCount) + 1
                    destVC.chapCount = Int(res[0].chaptersCount)
                    print(res[0].pagesCount)
                    destVC.currentVCIndex = Int(res[0].currPage)
                    destVC.level = 2
                    destVC.level_2_book = res[0]
                    let arr = ["Preface", "Introduction", "Dedication", "Foreword"]
                    let starter_arr = [res[0].preface!, res[0].intro!, res[0].dedication!, res[0].foreword!]
                    destVC.level_2_headings = arr
                    destVC.level_2_startings = starter_arr
                    let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                    req.predicate = pred
                    let sort = NSSortDescriptor(key: "pageNum", ascending: true)
                    req.sortDescriptors = [sort]
                    do{
                        destVC.level_2_pages = try context.fetch(req)
                    }
                    catch{
                        print(error)
                    }
                }
                catch{
                    print(error)
                }
            }
            
            if books[clickedIndex].level == 3{
                let req : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                req.predicate = pred
                do{
                    let res = try context.fetch(req)
                    destVC.pagesCount = Int(res[0].pagesCount) + 1
                    destVC.currentVCIndex = Int(res[0].currPage)
                    destVC.level = 3
                    destVC.level_3_book = res[0]
                    let starter_arr = [res[0].preface!, res[0].intro!]
                    let arr = ["Preface", "Introduction"]
                    destVC.level_3_headings = arr
                    destVC.level_3_startings = starter_arr
                    let req: NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", books[clickedIndex].bookName!)
                    req.predicate = pred
                    let sort = NSSortDescriptor(key: "pageNum", ascending: true)
                    req.sortDescriptors = [sort]
                    do{
                        destVC.level_3_pages = try context.fetch(req)
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
        let files = ["tlk", "mg", "tqk", "bbd", "poy", "iso", "ecs", "tlc", "nod", "kb", "ttp", "owk", "rv", "noi", "tys", "pop", "ej", "pqpa", "krp"]
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
                let arr = ["KṚṢṆA, The Supreme Personality of Godhead", "The Nectar of Instruction", "Śrī Īśopaniṣad", "Kṛṣṇa Consciousness, The Topmost Yoga System", "Rāja-Vidyā: The King of Knowledge", "The Nectar of Devotion", "Teachings of Lord Caitanya", "Elevation to Kṛṣṇa Consciousness", "Kṛṣṇa Consciousness, The Matchless Gift", "Transcendental Teachings of Prahlāda Mahārāja", "Teachings of Lord Kapila, the Son of Devahuti", "Teachings of Queen Kuntī", "The Path of Perfection", "The Perfection of Yoga", "Beyond Birth & Death", "On the Way to Kṛṣṇa", "Easy Journey to Other Planets", "Perfect Questions, Perfect Answers", "Kṛṣṇa, the Reservoir of Pleasure"]
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
        
//        return
        let req1 : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
        do{
            let res = try context.fetch(req1)
            if res.count != 0{
                return
            }
        }
        catch{
            print(error)
        }
        
        //Level 2
        let titles = ["bg", "ssr", "lcfl"]
        var im = -1
        for i in titles{
            im += 1
            let url = Bundle.main.url(forResource: i, withExtension: "json")
            if let jsonData = url{
                if let data = try? Data(contentsOf: jsonData){
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        if let dict = json as? [Dictionary<String, Any>] {
                            var maxChap = 0
                            var pagesCount = 0
                            let book = Level_2_Books(context: context)
                            for page in dict {
                                pagesCount += 1
                                guard let bookName = page["book"] as? String else {
                                    print("1")
                                    return
                                }
                                guard let chapter = page["chapter"] as? String else {
                                    print("3")
                                    return
                                }
    //                            maxChap = chapter > maxChap ? chapter : maxChap
                                
                                guard let verse = page["verse"] as? String else {
                                    print("4")
                                    return
                                }
                                
                                guard let text = page["text"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let syn = page["synonyms"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let trans = page["translation"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let purp = page["purport"] as? String else {
                                    print("5")
                                    return
                                }

                                let request : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
                                let predicate = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                                request.predicate = predicate
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
                                let lis = ["Preface", "Introduction", "Foreword", "Dedication"]
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
                                    do{
                                        try context.save()
                                    }
                                    catch{
                                        print(error)
                                    }
                                }
                                else{
                                    let curPage = Level_2_Pages(context: context)
                                    curPage.bookName = bookName
                                    let arr = chapter.components(separatedBy: ". ")
                                    let arr1 = verse.components(separatedBy: ". ")
                                    curPage.chapterName = arr[1]
                                    curPage.chapter = Int32(arr[0])!
                                    maxChap = Int(arr[0])! > maxChap ? Int(arr[0])! : maxChap
                                    if arr1.count == 1{
                                        curPage.verse = Int32(arr1[0])!
                                    }
                                    else{
                                        curPage.verse = Int32(arr1[0])!
                                        curPage.verseName = arr1[1]
                                    }
                                    
                                    curPage.purport = purp
                                    curPage.text = text
                                    curPage.syn = syn
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
                            let pagesReq : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", book.bookName!)
                            pagesReq.predicate = pred
                            let sortDesc = NSSortDescriptor(key: "verse", ascending: true)
                            let sort = NSSortDescriptor(key: "chapter", ascending: true)
                            pagesReq.sortDescriptors = [sort, sortDesc]
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
                        else {
                            print("Err4")
                        }
                    }
                    else{
                        print("Err1")
                    }
                }
                else {
                    print("Err2")
                }
            }
            else {
                print("Err3")
            }
        }
         
        let levels4 = Book_Levels(context: context)
        levels4.bookName = "Bhagavad-gītā As It Is"
        levels4.level = 2
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        let levels5 = Book_Levels(context: context)
        levels5.bookName = "Life Comes from Life"
        levels5.level = 2
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        let levels6 = Book_Levels(context: context)
        levels6.bookName = "The Science of Self Realization"
        levels6.level = 2
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        
//        return
        let req2 : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
        do{
            let res = try context.fetch(req2)
            if res.count != 0{
                return
            }
        }
        catch{
            print(error)
        }
        
        //Level 3
        let level_3_arr = ["sb", "cc"]
        var ind = -1
        let names = ["Śrīmad-Bhāgavatam", "Śrī Caitanya-caritāmṛta"]
        for i in level_3_arr{
            ind += 1
            let url = Bundle.main.url(forResource: i, withExtension: "json")
            if let jsonData = url{
                if let data = try? Data(contentsOf: jsonData){
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        if let dict = json as? [Dictionary<String, Any>]{
                            var pagesCount = 0
                            let book = Level_3_Books(context: context)
                            for page in dict{
                                pagesCount += 1
                                let bookName = names[ind]
                                guard let chapter = page["chapter"] as? String else {
                                    print("3")
                                    return
                                }
                                guard let level_3 = page["canto"] as? String else {
                                    print("3")
                                    return
                                }
                                guard let verse = page["verse"] as? String else {
                                    print("4")
                                    return
                                }
                                guard let text = page["text"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let syn = page["synonyms"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let trans = page["translation"] as? String else {
                                    print("5")
                                    return
                                }
                                guard let purp = page["purport"] as? String else {
                                    print("5")
                                    return
                                }
                                
                                let request : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
                                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                                request.predicate = pred
                                var res : [NSManagedObject] = []
                                do{
                                    res = try context.fetch(request)
                                }
                                catch{
                                    print(error)
                                }
                                if res.count == 0{
                                    book.bookName = bookName
                                    book.currPage = 1
                                    book.pagesCount = 1
                                    do{
                                        try context.save()
                                    }
                                    catch{
                                        print(error)
                                    }
                                }
                                let lis = ["Preface", "Introduction"]
                                if lis.contains(chapter){
                                    if lis[0] == chapter{
                                        book.preface = purp
                                    }
                                    if lis[1] == chapter{
                                        book.intro = purp
                                    }
                                    do{
                                        try context.save()
                                    }
                                    catch{
                                        print(error)
                                    }
                                }
                                else{
                                    let currPage = Level_3_Pages(context: context)
                                    currPage.bookName = bookName
                                    let arr = chapter.components(separatedBy: ". ")
                                    let arr1 = level_3.components(separatedBy: ". ")
                                    let arr2 = verse.components(separatedBy: ". ")
                                    currPage.chapterName = arr[1]
                                    currPage.chapter = Int32(arr[0])!
                                    if arr1.count == 1{
                                        currPage.level_3_name = arr1[0]
                                    }
                                    else{
                                        currPage.level_3 = Int32(arr1[0])!
                                        currPage.level_3_name = arr1[1]
                                    }
                                    currPage.verse = Int32(arr2[0])!
                                    currPage.verseName = arr2[1]
                                    currPage.purport = purp
                                    currPage.text = text
                                    currPage.syn = syn
                                    currPage.translation = trans
                                    do{
                                        try context.save()
                                    }
                                    catch{
                                        print(error)
                                    }
                                }
                            }
                            book.pagesCount = Int32(pagesCount)
                            do{
                                try context.save()
                            }
                            catch{
                                print(error)
                            }
                            let pagesReq : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", book.bookName!)
                            pagesReq.predicate = pred
                            let sortDesc = NSSortDescriptor(key: "verse", ascending: true)
                            let sort = NSSortDescriptor(key: "chapter", ascending: true)
                            let sort2 = NSSortDescriptor(key: "level_3", ascending: true)
                            pagesReq.sortDescriptors = [sort2, sort, sortDesc]
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
                        print("Err1")
                    }
                }
                else{
                    print("Err2")
                }
            }
            else{
                print("Err3")
            }
        }
        let levels1 = Book_Levels(context: context)
        levels1.bookName = names[0]
        levels1.level = 3
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        let levels2 = Book_Levels(context: context)
        levels2.bookName = names[1]
        levels2.level = 3
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
}
