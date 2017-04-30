//
//  ViewBooks.swift
//  MyBooksQ
//
//  Created by Quang Vu on 4/29/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

class ViewBooks: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource {
    // MARK: - Properties
    var type : String!
    let booksPDF = [("abrieferhistory"),
                    ("aspoofonsexdonwireman"),
                    ("barrysworldjenvey"),
                    ("foreigneduwilliam"),
                    ("gonewithtrash"),
                    ("gospelbuckydennis"),
                    ("oddjobsbowling"),
                    ("oneclownshortwright"),
                    ("questingromana"),
                    ("thedistancetravelled")]
    let booksHTML = [("Lập trình iOS Objective-C")]
    let booksDocx = [("coexistcrane"),
                     ("darkkisssylviaday"),
                     ("isthislove"),
                     ("lovelikethishubbard"),
                     ("lumberlacewards")]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - App Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int!
        switch (type)
        {
            case "PDF": count = booksPDF.count
            case "DOCX": count = booksDocx.count
            case "HTML": count = booksHTML.count
            default: break
        }
        return count
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellwithReuseIdentifier; : forWithReuseIdentifier("CellColection", forIndexPath: indexPath)  as! ACellBook
        var thubImg : UIImage!
        var nameLabel : String!
        switch (type)
        {
        case "PDF":
            thubImg = UIImage(named: (booksPDF[indexPath.item] + (".jpg")))
            nameLabel = booksPDF[indexPath.item]
        case "DOCX":
            thubImg = UIImage(named: (booksDocx[indexPath.item] + (".jpg")))
            nameLabel = booksDocx[indexPath.item]
        case "HTML":
            thubImg = UIImage(named: (booksHTML[indexPath.item] + (".jpg")))
            nameLabel = booksHTML[indexPath.item]
        default: break
        }
        cell.imageView.image = thubImg
        cell.nameLabel.text = nameLabel
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
