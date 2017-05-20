//
//  TableViewLocal.swift
//  mp3zing
//
//  Created by Quang Vu on 5/18/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

class TableViewLocal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!

    var listSongs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self

        getData()
    }
    
    func getData()
    {
        listSongs.removeAll()
        
        if let dir = kDOCUMENT_DIRECTORY_PATH
        {
            do
            {
                let folders = try FileManager.default.contentsOfDirectory(atPath: dir)
                for folder in folders {
                    if (folder != ".DS_Store")
                    {
                        let info = NSDictionary(contentsOfFile: dir + "/" + folder + "/" + "info.plist")
                        let title = info!["title"] as! String
                        let artistName = info!["artistName"] as! String
                        let thumbnailPath = info!["localThumbnail"] as! String
                        let sourceLocal = dir + "/\(title)/\(title).mp3"
                        let currentSong = Song(title: title, artistName: artistName, localThumbnail: dir + thumbnailPath, localSource: sourceLocal)
                        listSongs.append(currentSong)
                    }
                }
                
                myTableView.reloadData()
            } catch let error as Error
            {
                print(error)
            }
        }
    }

    // UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note: Update Reuse Identifier on Storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = listSongs[indexPath.row].thumbnail
        cell.textLabel?.text = listSongs[indexPath.row].title
        cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    // edit
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Delete") {
            (action, index) in
            self.removeSongAtIndex(indexPath.row)
        }
        edit.backgroundColor = UIColor(red: 248/255, green: 55/255, blue: 186/255, alpha: 1.0)
        //return [edit, delete]
        return [edit]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioPlay = AudioPlayer.sharedInstance
        audioPlay.pathString = listSongs[indexPath.row].sourceLocal
        audioPlay.titleSong = "\(listSongs[indexPath.row].title) Ca Sy: \(listSongs[indexPath.row].artistName)"
        audioPlay.setupAudio()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setupObserveAudio"), object: nil)
    }
    
    func removeSongAtIndex(_ index: Int) {
        if let dir = kDOCUMENT_DIRECTORY_PATH {
            do {
                let path = "\(dir)/\(listSongs[index].title)"
                try FileManager.default.removeItem(atPath: path)
                listSongs.remove(at: index)
                myTableView.reloadData()
            } catch let error as Error {
                print(error)
            }
        }
    }
    


}
