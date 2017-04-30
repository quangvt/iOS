//
//  ViewBooks.swift
//  MyBooks
//
//  Created by CanDang on 1/4/16.
//  Copyright © 2016 CanDang. All rights reserved.
//

import UIKit

class ViewBooks: UIViewController{
    var type : String!
    let booksPDF = [
        ("abrieferhistory"),
        ("aspoofonsexdonwireman"),
        ("barrysworldjenvey"),
        ("foreigneduwilliam"),
        ("gonewithtrash"),
        ("gospelbuckydennis"),
        ("oddjobsbowling"),
        ("oneclownshortwright"),
        ("questingromana"),
        ("thedistancetravelled")
    ]
    let booksHTML = [
        ("Lập trình iOS Objective-C")
    ]
    let booksDocx = [
        ("coexistcrane"),
        ("darkkisssylviaday"),
        ("isthislove"),
        ("lovelikethishubbard"),
        ("lumberlacewards")
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        type = self.tabBarItem.title!
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewBooks {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int!
        switch(type)
        {
        case "PDF" : count = booksPDF.count
        case "DOCX" : count = booksDocx.count
        case "HTML" : count = booksHTML.count
        default : break
        }
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellColection", for: indexPath) as! ACellBook
        cell.imageView.contentMode = .scaleAspectFit
        var thubImg : UIImage!
        var nameLabel : String!
        switch(type)
        {
        case "PDF" : thubImg = UIImage(named:(booksPDF[(indexPath as NSIndexPath).item] + (".jpg")))
        nameLabel = booksPDF[(indexPath as NSIndexPath).item]
        case "DOCX" : thubImg = UIImage(named:(booksDocx[(indexPath as NSIndexPath).item] + (".jpg")))
        nameLabel = booksDocx[(indexPath as NSIndexPath).item]
        case "HTML" : thubImg = UIImage(named:(booksHTML[(indexPath as NSIndexPath).item] + (".jpg")))
        nameLabel = booksHTML[(indexPath as NSIndexPath).item]
        default : break
        }
        cell.imageView.image = thubImg
        cell.nameLabel.text = nameLabel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let viewDetailBook = self.storyboard!.instantiateViewController(withIdentifier: "DetailBook") as! DetailBook
        var urlString : String!
        switch(type)
        {
        case "PDF" : urlString = booksPDF[(indexPath as NSIndexPath).item]
        case "DOCX" : urlString = booksDocx[(indexPath as NSIndexPath).item]
        case "HTML" : urlString = booksHTML[(indexPath as NSIndexPath).item]
        default : break
        }
        viewDetailBook.urlString = urlString
        viewDetailBook.type = self.tabBarItem.title!
        self.navigationController!.pushViewController(viewDetailBook, animated: true)
        
    }

}
