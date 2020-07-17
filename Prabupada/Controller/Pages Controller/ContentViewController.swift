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
class ContentViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var contentView: UIView!
    
    var currentVCIndex : Int?
    var pagesCount : Int?
    var label: String?
    var book : Level_2_Books!
    var pages : [Level_2_Pages]!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        // Do any additional setup after loading the view.
        let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
        let sort = NSSortDescriptor(key: "pageNum", ascending: true)
        req.sortDescriptors = [sort]
        do{
            pages = try context.fetch(req)
        }
        catch{
            print(error)
        }
        print(label!)
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
        if(index >= pagesCount! || pagesCount! == 0){
            return nil
        }
        guard let dataVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        
        dataVC.index = index
        if index <= 4{
            dataVC.displayText = book.preface
        }
        else{
            dataVC.displayText = pages[index - 5].purport
        }
        
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
        
        if currentIndex == 1{
            navigationController?.popToRootViewController(animated: true)
            return nil
        }
        currentIndex -= 1
        currentVCIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataVC = viewController as? DataViewController
        guard var currentIndex = dataVC?.index else{
            return nil
        }
        
        if currentIndex == pagesCount{
            return nil
        }
        currentIndex += 1
        currentVCIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
}
