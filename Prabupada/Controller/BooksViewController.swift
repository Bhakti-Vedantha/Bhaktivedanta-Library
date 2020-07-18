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
    var books : [Level_2_Books]!
    var label = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2, height: (self.collectionView.frame.size.height - 20) / 2)
        // Do any additional setup after loading the view.
        let request : NSFetchRequest<Level_2_Books> = Level_2_Books.fetchRequest()
        do{
            books = try context.fetch(request)
        }
        catch{
            print(error)
        }
        print(books[0].currPage)
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
            destVC.currentVCIndex = Int(books[clickedIndex].currPage)
            print(Int(books[clickedIndex].currPage))
            destVC.pagesCount = Int(books[clickedIndex].pagesCount)
            destVC.book = books[clickedIndex]
            let req : NSFetchRequest<Level_2_Pages> = Level_2_Pages.fetchRequest()
            let sort = NSSortDescriptor(key: "pageNum", ascending: true)
            req.sortDescriptors = [sort]
            do{
                destVC.pages = try context.fetch(req)
            }
            catch{
                print(error)
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
