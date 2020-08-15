//
//  GotoViewController.swift
//  Prabupada
//
//  Created by Shannu on 01/08/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class GotoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var pC1: UIPickerView!
    @IBOutlet weak var pC2: UIPickerView!
    @IBOutlet weak var pC3: UIPickerView!
    @IBOutlet weak var pC4: UIPickerView!
    let books = ["Books", "bg", "sb", "ks", "scc", "noi", "nod", "tlc", "si", "ej", "kc", "rv", "ekc", "kcm", "tt", "pq", "kr", "tlk", "tqk", "sr", "pp", "lcl", "py", "bb", "owk"]
    let bookNames = ["Bhagavad-gītā As It Is", "Śrīmad-Bhāgavatam", "KṚṢṆA, The Supreme Personality of Godhead", "Śrī Caitanya-caritāmṛta", "The Nectar of Instruction", "The Nectar of Devotion", "Teachings of Lord Caitanya", "Śrī Īśopaniṣad", "Easy Journey to Other Planets", "Kṛṣṇa Consciousness, The Topmost Yoga System", "Rāja-Vidyā: The King of Knowledge", "Elevation to Kṛṣṇa Consciousness", "Kṛṣṇa Consciousness, The Matchless Gift", "Transcendental Teachings of Prahlāda Mahārāja", "Perfect Questions, Perfect Answers", "Kṛṣṇa, the Reservoir of Pleasure", "Teachings of Lord Kapila, the Son of Devahuti", "Teachings of Queen Kuntī", "The Science of Self Realization", "The Path of Perfection", "Life Comes from Life", "The Perfection of Yoga", "Beyond Birth & Death", "On the Way to Kṛṣṇa"]
    var level_3 = ["Option"]
    var chapters = ["Chapter"]
    var verses = ["Verse"]
    var level = 0
    
    var heading = " "
    
    var bookName = ""
    var canto = 0
    var chapter = 0
    var verse = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(books.count)
        print(bookNames.count)
        pC1.backgroundColor = .none
        pC1.delegate = self
        pC1.dataSource = self
        pC2.delegate = self
        pC2.dataSource = self
        pC2.isHidden = true
        pC3.delegate = self
        pC3.dataSource = self
        pC3.isHidden = true
        pC4.delegate = self
        pC4.dataSource = self
        pC4.isHidden = true
//        self.title = bookNames[0]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return bookNames.count
        }
        if pickerView.tag == 2{
            return level_3.count
        }
        if pickerView.tag == 3{
            return chapters.count
        }
        if pickerView.tag == 4{
            return verses.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return books[row].uppercased()
        }
        if pickerView.tag == 2{
            return level_3[row]
        }
        if pickerView.tag == 3{
            return chapters[row]
        }
        if pickerView.tag == 4{
            return verses[row]
        }
        return "0"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.title = bookNames[row]
        if pickerView.tag == 1 && row == 0{
            pC2.isHidden = true
            pC3.isHidden = true
            pC4.isHidden = true
            level = 0
        }
        if pickerView.tag == 1 && row != 0{
            print(bookNames[row - 1])
            heading = books[row].uppercased()
            let req : NSFetchRequest<Book_Levels> = Book_Levels.fetchRequest()
            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[row - 1])
            req.predicate = pred
            do{
                let res = try context.fetch(req)
                bookName = res[0].bookName!
                level = Int(res[0].level)
            }
            catch{
                print(error)
            }
            scrolled(tag: 1)
        }
        if pickerView.tag == 2 && row == 0{
            pC3.isHidden = true
            pC4.isHidden = true
            canto = 0
        }
        if pickerView.tag == 2 && row != 0{
            print(level_3[row])
            canto = Int(level_3[row])!
            scrolled(tag: 2)
        }
        if pickerView.tag == 3 && row == 0{
            pC4.isHidden = true
            chapter = 0
        }
        if pickerView.tag == 3 && row != 0{
            chapter = Int(chapters[row])!
            scrolled(tag: 3)
        }
        if pickerView.tag == 4 && row == 0{
            verse = 0
        }
        if pickerView.tag == 4 && row != 0{
            verse = Int(verses[row])!
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
    func scrolled(tag : Int){
        if tag == 1{
            pC2.isHidden = true
            pC3.isHidden = true
            pC4.isHidden = true
            if level == 1{
                let req : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let sort = NSSortDescriptor(key: "chapter", ascending: true)
                req.predicate = pred
                req.sortDescriptors = [sort]
                chapters = ["Chapter"]
                do{
                    let res = try context.fetch(req)
                    for i in res{
                        chapters.append(String(i.chapter))
                    }
                }
                catch{
                    print(error)
                }
                pC3.isHidden = false
                pC3.delegate = self
                pC3.dataSource = self
            }
            if level == 2{
                let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let sort = NSSortDescriptor(key: "chapter", ascending: true)
                let sort2 = NSSortDescriptor(key: "verse", ascending: true)
                req.predicate = pred
                req.sortDescriptors = [sort, sort2]
                chapters = ["Chapter"]
                do{
                    let res = try context.fetch(req)
                    for i in res{
                        if !chapters.contains(String(i.chapter)){
                            chapters.append(String(i.chapter))
                        }
                    }
                }
                catch{
                    print(error)
                }
                pC3.isHidden = false
                pC3.delegate = self
                pC3.dataSource = self
                pC4.isHidden = true
                pC4.delegate = self
                pC4.dataSource = self
            }
            
            if level == 3{
                let req : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let sort = NSSortDescriptor(key: "chapter", ascending: true)
                let sort2 = NSSortDescriptor(key: "verse", ascending: true)
                let sort3 = NSSortDescriptor(key: "level_3", ascending: true)
                req.predicate = pred
                req.sortDescriptors = [sort3, sort, sort2]
                level_3 = ["Option"]
                do{
                    let res = try context.fetch(req)
                    for i in res{
                        if !level_3.contains(String(i.level_3)){
                            level_3.append(String(i.level_3))
                        }
                    }
                }
                catch{
                    print(error)
                }
                pC2.isHidden = false
                pC2.delegate = self
                pC2.dataSource = self
                pC3.isHidden = true
                pC3.delegate = self
                pC3.dataSource = self
                pC4.isHidden = true
                pC4.delegate = self
                pC4.dataSource = self
            }
            
        }
        
        if tag == 2{
            pC3.isHidden = true
            pC4.isHidden = true
            let req : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
            let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
            let anotherPred = NSPredicate(format: "level_3 == %@", String(canto))
            req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred, anotherPred])
            let sort = NSSortDescriptor(key: "chapter", ascending: true)
            let sort2 = NSSortDescriptor(key: "verse", ascending: true)
            req.sortDescriptors = [sort, sort2]
            chapters = ["Chapter"]
            do{
                let res = try context.fetch(req)
                for i in res{
                    if !chapters.contains(String(i.chapter)){
                        chapters.append(String(i.chapter))
                    }
                }
            }
            catch{
                print(error)
            }
            pC3.isHidden = false
            pC3.delegate = self
            pC4.isHidden = true
            pC4.delegate = self
        }
        
        if tag == 3{
            pC4.isHidden = true
            if level == 2{
                let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let anotherPred = NSPredicate(format: "chapter == %@", String(chapter))
                req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred, anotherPred])
                let sort2 = NSSortDescriptor(key: "verse", ascending: true)
                req.sortDescriptors = [sort2]
                verses = ["Verse"]
                do{
                    let res = try context.fetch(req)
                    for i in res{
                        if !verses.contains(String(i.verse)){
                            verses.append(String(i.verse))
                        }
                    }
                    
                }
                catch{
                    print(error)
                }
                pC4.isHidden = false
                pC4.delegate = self
            }
            if level == 3{
                let req : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let anotherPred2 = NSPredicate(format: "level_3 == %@", String(canto))
                let anotherPred = NSPredicate(format: "chapter == %@", String(chapter))
                req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred, anotherPred2, anotherPred])
                let sort2 = NSSortDescriptor(key: "verse", ascending: true)
                req.sortDescriptors = [sort2]
                verses = ["Verse"]
                do{
                    let res = try context.fetch(req)
                    for i in res{
                        if !verses.contains(String(i.verse)){
                            verses.append(String(i.verse))
                        }
                    }
                }
                catch{
                    print(error)
                }
                pC4.isHidden = false
                pC4.delegate = self
            }
        }
    }
    
    @IBAction func goTo(_ sender: UIBarButtonItem) {
        if level == 0 {
            return
        }
        if level == 1 && chapter == 0{
            return
        }
        if level == 2 && (chapter == 0 || verse == 0) {
            return
        }
        if level == 3 && (chapter == 0 || verse == 0 || canto == 0){
            return
        }
        
        if level == 1{
            let reqq : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
            let p1 = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
            let p2 = NSPredicate(format: "chapter == %@ ", String(chapter))
            reqq.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
            do{
                let res = try context.fetch(reqq)
                if res.count == 0{
                    return
                }
            }
            catch{
                print(error)
            }
        }
        performSegue(withIdentifier: "goTo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTo"{
            let destVC = segue.destination as! ContentViewController
            destVC.label = bookName
            destVC.bookHeading = heading
            if level == 1{
                var c1 = 0
                var c2 = 0
                let req : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                req.predicate = pred
                do{
                    let res = try context.fetch(req)
                    c1 = Int(res[0].chaptersCount)
                    c2 = Int(res[0].pagesCount)
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
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
                let reqq : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
                let p1 = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let p2 = NSPredicate(format: "chapter == %@ ", String(chapter))
                reqq.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
                do{
                    let res = try context.fetch(reqq)
                    destVC.currentVCIndex = Int(res[0].pageNum) + (c2 - c1) + 1
                    print(res[0].pageNum)
                }
                catch{
                    print(error)
                }
            }
            
            if level == 2{
                let req : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                req.predicate = pred
                var co = 0
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
                    var another_arr : [String] = []
                    var arr_2 : [String] = []
                    var c = 0
                    for i in starter_arr{
                        if i.count != 0{
                            another_arr.append(i)
                            arr_2.append(arr[c])
                        }
                        c += 1
                    }
                    co = arr_2.count
                    destVC.count = arr_2.count
                    destVC.level_2_headings = arr_2
                    destVC.level_2_startings = another_arr
                    let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
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
                
                let reqq : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
                let p1 = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let p2 = NSPredicate(format: "chapter == %@ ", String(chapter))
                let p3 = NSPredicate(format: "verse == %@ ", String(verse))
                reqq.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
                do{
                    let res = try context.fetch(reqq)
                    destVC.currentVCIndex = Int(res[0].pageNum) + co + 1
                    print(res[0].pageNum)
                }
                catch{
                    print(error)
                }
            }
            
            if level == 3{
                let req : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                req.predicate = pred
                var co = 0
                do{
                    let res = try context.fetch(req)
                    destVC.pagesCount = Int(res[0].pagesCount) + 1
                    destVC.currentVCIndex = Int(res[0].currPage)
                    destVC.level = 3
                    destVC.level_3_book = res[0]
                    let starter_arr = [res[0].preface!, res[0].intro!]
                    let arr = ["Preface", "Introduction"]
                    var another_arr : [String] = []
                    var arr_2 : [String] = []
                    var c = 0
                    for i in starter_arr{
                        if i.count != 0{
                            another_arr.append(i)
                            arr_2.append(arr[c])
                        }
                        c += 1
                    }
                    co = arr_2.count
                    destVC.count = arr_2.count
                    destVC.level_3_headings = arr_2
                    destVC.level_3_startings = another_arr
                    let req: NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
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
                let reqq : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
                let p1 = NSPredicate(format: "bookName CONTAINS[cd] %@", bookName)
                let p2 = NSPredicate(format: "chapter == %@ ", String(chapter))
                let p3 = NSPredicate(format: "verse == %@ ", String(verse))
                let p4 = NSPredicate(format: "level_3 == %@", String(canto))
                reqq.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p4, p2, p3])
                do{
                    let res = try context.fetch(reqq)
                    destVC.currentVCIndex = Int(res[0].pageNum) + co + 1
                    print(res[0].pageNum)
                }
                catch{
                    print(error)
                }
            }
            
        }
    }
    

}
