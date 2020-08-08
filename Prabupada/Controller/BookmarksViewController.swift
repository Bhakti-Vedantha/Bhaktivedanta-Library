//
//  BookmarksViewController.swift
//  Prabupada
//
//  Created by Shannu on 02/08/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    
    var clickedIndex = 0
    var bookmarks : [Bookmarks]!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        let req : NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        do{
            bookmarks = try context.fetch(req)
        }
        catch{
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let req : NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        do{
            bookmarks = try context.fetch(req)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarksCell", for: indexPath) as! BookmarksViewCell
        
        cell.bookmarkName.text = bookmarks[indexPath.item].bookName! + " - "
        var text = ""
        if bookmarks[indexPath.item].canto != 0{
            text += String(bookmarks[indexPath.item].canto) + "."
        }
        if bookmarks[indexPath.item].chapter != 0{
            text += String(bookmarks[indexPath.item].chapter)
            if bookmarks[indexPath.item].level != 1{
                text += "."
            }
        }
        if bookmarks[indexPath.item].verse != 0{
            text += String(bookmarks[indexPath.item].verse)
        }
        cell.bookmarkName.text! += text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndex = indexPath.item
        performSegue(withIdentifier: "open", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "open"{
            let destVC = segue.destination as! ContentViewController
            destVC.label = bookmarks[clickedIndex].bookName
            if bookmarks[clickedIndex].level == 1{
                var c1 = 0
                var c2 = 0
                let req : NSFetchRequest<Level_1_Books> = Level_1_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                destVC.currentVCIndex = Int(bookmarks[clickedIndex].pageNum) + (c2 - c1) + 1
            }
            
            if bookmarks[clickedIndex].level == 2{
                let req : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                destVC.currentVCIndex = Int(bookmarks[clickedIndex].pageNum) + co + 1
            }
            
            if bookmarks[clickedIndex].level == 3{
                let req : NSFetchRequest<Level_3_Books> = Level_3_Books.fetchRequest()
                let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                    let pred = NSPredicate(format: "bookName CONTAINS[cd] %@", bookmarks[clickedIndex].bookName!)
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
                destVC.currentVCIndex = Int(bookmarks[clickedIndex].pageNum) + co + 1
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
