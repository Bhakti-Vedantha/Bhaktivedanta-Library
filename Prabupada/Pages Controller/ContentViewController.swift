//
//  ContentViewController.swift
//  Prabupada
//
//  Created by Shannu on 14/07/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    let dataSrc = ["VC 1", "VC 2", "VC 3", "VC 4", "VC 5"]
    var currentVCIndex = 0
    var label: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        // Do any additional setup after loading the view.
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
        
        let views : [String: Any] = ["pageView": pageVC.view]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingVC = detailViewControllerAt(index: currentVCIndex) else{
            return
        }
        
        pageVC.setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        
    }
    
    func detailViewControllerAt(index: Int) -> DataViewController?{
        if(index >= dataSrc.count || dataSrc.count == 0){
            return nil
        }
        guard let dataVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        
        dataVC.index = index
        dataVC.displayText = dataSrc[index]
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

extension ContentViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentVCIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSrc.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataVC = viewController as? DataViewController
        guard var currentIndex = dataVC?.index else{
            return nil
        }
        
        if currentIndex == 0{
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
        
        if currentIndex == dataSrc.count{
            return nil
        }
        currentIndex += 1
        currentVCIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
}
