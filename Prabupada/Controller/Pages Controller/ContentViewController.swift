//
//  ContentViewController.swift
//  Prabupada
//
//  Created by Shannu on 14/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class ContentViewController: UIViewController, PageNum {
    func dataReceived(data: Int) {
        if level == 1{
            curPage = data + (pagesCount! - chapCount!)
            currentVCIndex = curPage
            configurePageViewController()
            print(curPage)
            navigationController?.navigationItem.title = "Hi"
        }
        if level == 2{
            curPage = data + count + 1
            currentVCIndex = curPage
            configurePageViewController()
        }
        if level == 3{
            curPage = data + count + 1
            currentVCIndex = curPage
            configurePageViewController()
        }
        
    }
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    @IBOutlet weak var contentView: UIView!
    
    var currentVCIndex : Int?
    var pagesCount : Int?
    var chapCount : Int?
    var label: String?
    var level_1_book : Level_1_Books!
    var level_1_pages : [Level_1_Pages]!
    var level_2_book : Level_2_Books!
    var level_2_pages : [Level_2_Pages]!
    var level_3_book : Level_3_Books!
    var level_3_pages : [Level_3_Pages]!
    var level = 0
    var curPage = 0
    var count = 0
//    var level_1_startings = ["Preface", "Introduction", "Dedication", "Foreword", "Introductory Note By George Harrison", "Invocation", "Mission", "Prologue"]
    var level_1_startings : [String]?
    var level_1_headings : [String]?
    var level_2_startings : [String]?
    var level_2_headings : [String]?
    var level_3_startings : [String]?
    var level_3_headings : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        // Do any additional setup after loading the view.
//        navigationController?.navigationItem.title = label
        if currentVCIndex! >= pagesCount! || currentVCIndex == 0{
            currentVCIndex = 1
        }
        if level == 1{
            self.title = level_1_book.bookName
//            count = (pagesCount! - chapCount!) - 2
        }
        if level == 2{
            self.title = level_2_book.bookName
//            count = 4
        }
        if level == 3{
            self.title = level_3_book.bookName
//            count = 2
        }
        print(label!)
        print(pagesCount!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        do{
            if level == 1{
                level_1_book.currPage = Int32(currentVCIndex!)
            }
            if level == 2{
                level_2_book.currPage = Int32(currentVCIndex!)
            }
            if level == 3{
                level_3_book.currPage = Int32(currentVCIndex!)
            }
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
    
    func configurePageViewController() {
        guard let pageVC = storyboard?.instantiateViewController(withIdentifier: String(describing: PageViewController.self)) as? PageViewController else{
            return
        }
        
        pageVC.delegate = self
        pageVC.dataSource = self
        
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageVC.view)
        
        let views : [String: Any] = ["pageView": pageVC.view!]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingVC = detailViewControllerAt(index: currentVCIndex!) else{
            return
        }
        
        pageVC.setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        
    }
    
    func detailViewControllerAt(index: Int) -> DataViewController?{
        print(index)
        if(index > pagesCount! || pagesCount! == 0 || index <= 0){
            currentVCIndex = 1
            navigationController?.popToRootViewController(animated: true)
            return nil
        }
        guard let dataVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        dataVC.index = index
        print(index)
        if level == 1{
            dataVC.canto = 0
            dataVC.chapter = 0
            dataVC.bookName = level_1_book.bookName
            if index <= (pagesCount! - chapCount!){
                dataVC.hidden = true
                if index == 1{
//                    self.title = level_1_book.bookName
                    dataVC.displayText = level_1_book.bookName
                }
                else{
//                    self.title = level_1_headings![index - 2]
                    dataVC.textForDetails = level_1_headings![index - 2]
                    dataVC.pur = "\n\t"
                    dataVC.pur! += level_1_startings![index - 2]
                }
//                dataVC.displayText = anotherArr[level_1_index]
//                navigationController?.title = level_1_startings[level_1_index]
//                dataVC.titleForNav = level_1_startings![level_1_index]
            }
            else{
                dataVC.hidden = false
                dataVC.pageNum = Int(level_1_pages[index - (pagesCount! - chapCount!) - 1].pageNum)
                dataVC.verse = Int(level_1_pages[index - (pagesCount! - chapCount!) - 1].chapter)
                dataVC.level = 1
//                self.title = level_1_pages[index - 1 - (pagesCount! - chapCount!)].chapterName
                dataVC.textForDetails = "\tChapter : \(level_1_pages[index - (pagesCount! - chapCount!) - 1].chapter). \(level_1_pages[index - (pagesCount! - chapCount!) - 1].chapterName!)\n\n\n"
//                dataVC.displayText = "\n\t"
                if defaults.integer(forKey: "showText") == 2 && level_1_pages[index - (pagesCount! - chapCount!) - 1].text!.count != 0 {
//                    dataVC.displayText! += level_1_pages[index - 1 - (pagesCount! - chapCount!)].text!
                    dataVC.text = "\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].text!
                }
                if defaults.integer(forKey: "showSyn") == 2 && level_1_pages[index - 1 - (pagesCount! - chapCount!)].syn!.count != 0 {
//                    dataVC.displayText! += "\n\nSynonyms\n\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].syn!
                    dataVC.syn = "\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].syn!
                }
                if defaults.integer(forKey: "showTra") == 2 && level_1_pages[index - 1 - (pagesCount! - chapCount!)].translation!.count != 0 {
//                    dataVC.displayText! += "\n\nTranslation\n\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].translation!
                    dataVC.trans = "\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].translation!
                }
                if defaults.integer(forKey: "showPur") == 2 && level_1_pages[index - 1 - (pagesCount! - chapCount!)].purport!.count != 0 {
//                    if dataVC.displayText == "\tChapter : \(level_1_pages[index - (pagesCount! - chapCount!) - 1].chapter). \(level_1_pages[index - (pagesCount! - chapCount!) - 1].chapterName!)\n\n\n"{
//                        dataVC.displayText! += level_1_pages[index - 1 - (pagesCount! - chapCount!)].purport!
//                    }
//                    else{
//                        dataVC.displayText! += "\n\nPurport\n\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].purport!
//                    }
                    dataVC.pur = "\n" + level_1_pages[index - 1 - (pagesCount! - chapCount!)].purport!
                    
                }
            }
        }
        if level == 2{
            dataVC.bookName = level_2_book.bookName
            dataVC.canto = 0
            if index <= count + 1{
                dataVC.hidden = true
                if index == 1{
//                    self.title = level_1_book.bookName
                    dataVC.displayText = level_2_book.bookName
                }
                else{
//                    self.title = level_1_headings![index - 2]
                    dataVC.textForDetails = level_2_headings![index - 2]
                    dataVC.pur = "\n\t"
                    dataVC.pur! += level_2_startings![index - 2]
                }
//                dataVC.displayText = anotherArr[level_1_index]
//                navigationController?.title = level_1_startings[level_1_index]
//                dataVC.titleForNav = level_1_startings![level_1_index]
            }
            else{
                dataVC.hidden = false
                dataVC.pageNum = Int(level_2_pages[index - count - 2].pageNum)
                dataVC.chapter = Int(level_2_pages[index - count - 2].chapter)
                dataVC.verse = Int(level_2_pages[index - count - 2].verse)
                dataVC.level = 2
//                self.title = level_1_pages[index - 1 - (pagesCount! - chapCount!)].chapterName
                dataVC.textForDetails = "\tChapter : \(level_2_pages[index - count - 2].chapter). \(level_2_pages[index - count - 2].chapterName!)\n\tVerse : \(level_2_pages[index - count - 2].verse)\n\n"

//                dataVC.displayText = "\n\t"
                if defaults.integer(forKey: "showText") == 2 && level_2_pages[index - count - 2].text!.count != 0 {
//                    dataVC.displayText! += level_2_pages[index - 6].text!
                    dataVC.text = "\n" + level_2_pages[index - count - 2].text!
                }
                if defaults.integer(forKey: "showSyn") == 2 && level_2_pages[index - count - 2].syn!.count != 0 {
//                    dataVC.displayText! += "\n\nSynonyms\n\n" + level_2_pages[index - 6].syn!
                    dataVC.syn = "\n" + level_2_pages[index - count - 2].syn!
                }
                if defaults.integer(forKey: "showTra") == 2 && level_2_pages[index - count - 2].translation!.count != 0 {
//                    dataVC.displayText! += "\n\nTranslation\n\n" + level_2_pages[index - 6].translation!
                    dataVC.trans = "\n" + level_2_pages[index - count - 2].translation!
                }
                if defaults.integer(forKey: "showPur") == 2 && level_2_pages[index - count - 2].purport!.count != 0 {
//                    if dataVC.displayText == "\tChapter : \(level_2_pages[index - 6].chapter). \(level_2_pages[index - 6].chapterName!)\n\n\n"{
//                        dataVC.displayText! += level_2_pages[index - 6].purport!
//                    }
//                    else{
//                        dataVC.displayText! += "\n\nPurport\n\n" + level_2_pages[index - 6].purport!
//                    }
                    dataVC.pur = "\n" + level_2_pages[index - count - 2].purport!
                }
            }
        }
        
        if level == 3{
            dataVC.bookName = level_3_book.bookName
            if index <= count + 1{
                dataVC.hidden = true
                if index == 1{
                    dataVC.displayText = level_3_book.bookName
                }
                else{
                    dataVC.textForDetails = level_3_headings![index - 2]
                    dataVC.pur = "\n\t"
                    dataVC.pur! += level_3_startings![index - 2]
                }
            }
            else{
                dataVC.hidden = false
                dataVC.pageNum = Int(level_3_pages[index - count - 2].pageNum)
                dataVC.canto = Int(level_3_pages[index - count - 2].level_3)
                dataVC.chapter = Int(level_3_pages[index - count - 2].chapter)
                dataVC.verse = Int(level_3_pages[index - count - 2].verse)
                dataVC.level = 3
                dataVC.textForDetails = "\t\(level_3_pages[index - count - 2].level_3). \(level_3_pages[index - count - 2].level_3_name!) . Chapter : \(level_3_pages[index - count - 2].chapter). \(level_3_pages[index - count - 2].chapterName!)\n\tVerse : \(level_3_pages[index - count - 2].verse)\n\n"
//                dataVC.displayText = "\n\t"
                if defaults.integer(forKey: "showText") == 2 && level_3_pages[index - count - 2].text!.count != 0 {
//                    dataVC.displayText! += level_3_pages[index - 4].text!
                    dataVC.text = "\n" + level_3_pages[index - count - 2].text!
                }
                if defaults.integer(forKey: "showSyn") == 2 && level_3_pages[index - count - 2].syn!.count != 0 {
//                    dataVC.displayText! += "\n\nSynonyms\n\n" + level_3_pages[index - 4].syn!
                    dataVC.syn = "\n" + level_3_pages[index - count - 2].syn!
                }
                if defaults.integer(forKey: "showTra") == 2 && level_3_pages[index - count - 2].translation!.count != 0 {
//                    dataVC.displayText! += "\n\nTranslation\n\n" + level_3_pages[index - 4].translation!
                    dataVC.trans = "\n" + level_3_pages[index - count - 2].translation!
                }
                if defaults.integer(forKey: "showPur") == 2 && level_3_pages[index - count - 2].purport!.count != 0 {
//                    if dataVC.displayText == "\tChapter : \(level_3_pages[index - 4].chapter). \(level_3_pages[index - 4].chapterName!)\n\n\n"{
//                        dataVC.displayText! += level_3_pages[index - 4].purport!
//                    }
//                    else{
//                        dataVC.displayText! += "\n\nPurport\n\n" + level_3_pages[index - 4].purport!
//                    }
                    dataVC.pur = "\n" + level_3_pages[index - count - 2].purport!
                }
            }
        }
//        if index <= 4{
//            dataVC.displayText = book.preface
//        }
//        else{
//            if defaults.integer(forKey: "showText") == 2 && pages[index - 5].text!.count != 0 {
//                dataVC.displayText = pages[index - 5].text!
//            }
//            if defaults.integer(forKey: "showSyn") == 2 && pages[index - 5].syn!.count != 0 {
//                dataVC.displayText! += "\n\nSynonyms\n\n" + pages[index - 5].syn!
//            }
//            if defaults.integer(forKey: "showTra") == 2 && pages[index - 5].translation!.count != 0 {
//                dataVC.displayText! += "\n\nTranslation\n\n" + pages[index - 5].translation!
//            }
//            if defaults.integer(forKey: "showPur") == 2 && pages[index - 5].purport!.count != 0 {
//                dataVC.displayText! += "\n\nPurport\n\n" + pages[index - 5].purport!
//            }
//        }
        curPage += 1
        
        return dataVC
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func showTableOfContents(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showTOC", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTOC"{
            let destVC = segue.destination as! TOCTableViewController
            var chap : [String] = []
            var pageNums : [Int] = []
            if level == 1{
                for page in level_1_pages {
                    if !chap.contains(page.chapterName!){
                        chap.append(page.chapterName!)
                        pageNums.append(Int(page.pageNum))
                        print(pageNums[pageNums.count - 1])
                    }
                }
                destVC.data = self
                destVC.bookName = level_1_book.bookName
                destVC.chap = chap
                destVC.pageNums = pageNums
            }
            if level == 2{
                for page in level_2_pages{
                    if !chap.contains(page.chapterName!){
                        chap.append(page.chapterName!)
                        pageNums.append(Int(page.pageNum))
                        print(pageNums[pageNums.count - 1])
                    }
                }
                destVC.data = self
                destVC.bookName = level_2_book.bookName
                destVC.chap = chap
                destVC.pageNums = pageNums
            }
            if level == 3{
                for page in level_3_pages{
                    let str = "\(page.level_3_name!): \(page.chapter). \(page.chapterName!)"
                    if !chap.contains(str){
                        chap.append(str)
                        pageNums.append(Int(page.pageNum))
                    }
                }
                destVC.data = self
                destVC.bookName = level_3_book.bookName
                destVC.chap = chap
                destVC.pageNums = pageNums
            }
        }
    }
}

@available(iOS 13.0, *)
extension ContentViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentVCIndex!
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesCount!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataVC = viewController as? DataViewController
        guard var currentIndex = dataVC?.index else{
            return nil
        }
        
        currentIndex -= 1
        if currentIndex != 0{
            currentVCIndex = currentIndex
        }
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataVC = viewController as? DataViewController
        guard var currentIndex = dataVC?.index else{
            return nil
        }
        
        
        currentIndex += 1
        if currentIndex != pagesCount! + 1{
            currentVCIndex = currentIndex
        }
        
        return detailViewControllerAt(index: currentIndex)
    }
}
