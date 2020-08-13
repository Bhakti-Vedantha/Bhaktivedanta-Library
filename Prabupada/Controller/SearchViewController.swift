//
//  SearchViewController.swift
//  Prabupada
//
//  Created by Shannu on 13/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let bookHeadings = ["bg", "sb", "ks", "scc", "noi", "nod", "tlc", "si", "ej", "kc", "rv", "ekc", "kcm", "tt", "pq", "kr", "tlk", "tqk", "sr", "pp", "lcl", "py", "bb", "owk"]
    let books = ["Bhagavad-gītā As It Is", "Śrīmad-Bhāgavatam", "KṚṢṆA, The Supreme Personality of Godhead", "Śrī Caitanya-caritāmṛta", "The Nectar of Instruction", "The Nectar of Devotion", "Teachings of Lord Caitanya", "Śrī Īśopaniṣad", "Easy Journey to Other Planets", "Kṛṣṇa Consciousness, The Topmost Yoga System", "Rāja-Vidyā: The King of Knowledge", "Elevation to Kṛṣṇa Consciousness", "Kṛṣṇa Consciousness, The Matchless Gift", "Transcendental Teachings of Prahlāda Mahārāja", "Perfect Questions, Perfect Answers", "Kṛṣṇa, the Reservoir of Pleasure", "Teachings of Lord Kapila, the Son of Devahuti", "Teachings of Queen Kuntī", "The Science of Self Realization", "The Path of Perfection", "Life Comes from Life", "The Perfection of Yoga", "Beyond Birth & Death", "On the Way to Kṛṣṇa"]
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var bookNames : [String] = []
    var levels : [Int] = []
    var cantos : [Int] = []
    var chapters : [Int] = []
    var verses : [Int] = []
    var pageNums : [Int] = []
    var clickedIndex = 0
    var searchText = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bookNames = []
        levels = []
        cantos = []
        chapters = []
        verses = []
        pageNums = []
        tableView.reloadData()
        searchBar.text = ""
        searchText = " "
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let tag = searchBar.text
        if tag?.count != 0{
            if tag!.prefix(1) == "#"{
                searchText = " "
                loadFromTags(tag: tag!)
            }
            else{
                searchText = tag!
                loadFromDB(tag: tag!)
            }
        }
        else{
            bookNames = []
            levels = []
            cantos = []
            chapters = []
            verses = []
            pageNums = []
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            bookNames = []
            levels = []
            cantos = []
            chapters = []
            verses = []
            pageNums = []
            tableView.reloadData()
        }
    }
    
    func loadFromDB(tag : String){
        bookNames = []
        levels = []
        cantos = []
        chapters = []
        verses = []
        pageNums = []
        let req : NSFetchRequest<Level_1_Pages> = Level_1_Pages.fetchRequest()
        do{
            let res = try context.fetch(req)
            for el in res{
                if (el.purport?.contains(tag))! || (el.syn?.contains(tag))! || (el.translation?.contains(tag))! || (el.text?.contains(tag))!{
                    bookNames.append(el.bookName!)
                    levels.append(1)
                    cantos.append(0)
                    chapters.append(0)
                    verses.append(Int(el.chapter))
                    pageNums.append(Int(el.pageNum))
                }
            }
        }
        catch{
            print(error)
        }
        
        let req2 : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
        do{
            let res = try context.fetch(req2)
            for el in res{
                if (el.purport?.contains(tag))! || (el.syn?.contains(tag))! || (el.translation?.contains(tag))! || (el.text?.contains(tag))!{
                    bookNames.append(el.bookName!)
                    levels.append(2)
                    cantos.append(0)
                    chapters.append(Int(el.chapter))
                    verses.append(Int(el.verse))
                    pageNums.append(Int(el.pageNum))
                }
            }
        }
        catch{
            print(error)
        }
        
        let req3 : NSFetchRequest<Level_3_Pages> = Level_3_Pages.fetchRequest()
        do{
            let res = try context.fetch(req3)
            for el in res{
                if (el.purport?.contains(tag))! || (el.syn?.contains(tag))! || (el.translation?.contains(tag))! || (el.text?.contains(tag))!{
                    bookNames.append(el.bookName!)
                    levels.append(3)
                    cantos.append(Int(el.level_3))
                    chapters.append(Int(el.chapter))
                    verses.append(Int(el.verse))
                    pageNums.append(Int(el.pageNum))
                }
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadFromTags(tag : String){
        let req : NSFetchRequest<Tags> = Tags.fetchRequest()
        let pred = NSPredicate(format: "tagName == %@", tag)
        req.predicate = pred
        bookNames = []
        levels = []
        cantos = []
        chapters = []
        verses = []
        pageNums = []
        do{
            let res = try context.fetch(req)
            for r in res{
                bookNames.append(r.bookName!)
                levels.append(Int(r.level))
                cantos.append(Int(r.canto))
                chapters.append(Int(r.chapter))
                verses.append(Int(r.verse))
                pageNums.append(Int(r.pageNum))
            }
            tableView.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchViewCell
        var text = bookNames[indexPath.item] + ": "
        if cantos[indexPath.item] != 0{
            text += "\(cantos[indexPath.item])."
        }
        if chapters[indexPath.item] != 0{
            text += "\(chapters[indexPath.item])."
        }
        if verses[indexPath.item] != 0{
            text += "\(verses[indexPath.item])"
        }
        cell.resultLabel.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndex = indexPath.item
        performSegue(withIdentifier: "showResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults"{
            let destVC = segue.destination as! ContentViewController
            destVC.searchText = searchText
            destVC.label = bookNames[clickedIndex]
            var index = 0
            for i in books{
                if i == bookNames[clickedIndex]{
                    destVC.bookHeading = bookHeadings[index].uppercased()
                    break
                }
                index += 1
            }
            if levels[clickedIndex] == 1{
                var c1 = 0
                var c2 = 0
                let req : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                destVC.currentVCIndex = Int(pageNums[clickedIndex]) + (c2 - c1) + 1
            }
            
            if levels[clickedIndex] == 2{
                let req : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                destVC.currentVCIndex = Int(pageNums[clickedIndex]) + co + 1
            }
            
            if levels[clickedIndex] == 3{
                let req : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookNames[clickedIndex])
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
                destVC.currentVCIndex = Int(pageNums[clickedIndex]) + co + 1
            }
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

}
