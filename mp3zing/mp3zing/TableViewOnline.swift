//
//  TableViewOnline.swift
//  mp3zing
//
//  Created by Quang Vu on 5/17/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

// Change on each start app time
let kDOCUMENT_DIRECTORY_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first

class TableViewOnline: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var listSongs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
    }
    
    func getData(){
        let data = try? Data(contentsOf: URL(string: "http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html")!)
        let doc = TFHpple(htmlData: data)
        if let elements = doc?.search(withXPathQuery: "//h3[@class='title-item']/a") as? [TFHppleElement]
        {
            // http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\"\(id)\"}
            for element in elements{
                DispatchQueue.global(qos: .default).async(execute: {
                    // print(element.content)
                    let id = self.getID(element.object(forKey: "href") as NSString)
                    let url = URL(string: "http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\"\(id)\"}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                    var stringData = ""
                    do {
                        try stringData = String(contentsOf: url!)
                    } catch let error as Error {
                        print(error)
                    }
                    //print(stringData)
                    let json = self.convertStringToDictionary(stringData)
                    if (json != nil) {
                        self.addSongToList(json!)
                    }
                })
            }
        }
    }

    func getID(_ path: NSString) -> String {
        let id = (path.lastPathComponent as NSString).deletingPathExtension
        return id as String
    }

    func convertStringToDictionary(_ text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json!
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func addSongToList(_ json: [String: AnyObject]) {
        let title = json["title"] as! String
        let artistName = json["artist"] as! String
        let thumbnail = json["thumbnail"] as! String
        let source = json["source"]!["128"] as! String
        let currentSong = Song(title: title, artistName: artistName, thumbnail: thumbnail, source: source)
        
        listSongs.append(currentSong)
        //myTableView.reloadData() // in background
        // Update UI on Main Thread
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    // MASK: UITableViewDelegate
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
        let edit = UITableViewRowAction(style: .normal, title: "Donwload") {
            (action, index) in
            DispatchQueue.global(qos: .default).async(execute: {
                self.downloadSong(indexPath.row)
            })
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        edit.backgroundColor = UIColor(red: 248/255, green: 55/255, blue: 186/255, alpha: 1.0)
        //return [edit, delete]
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioPlay = AudioPlayer.sharedInstance
        audioPlay.pathString = listSongs[indexPath.row].sourceOnline
        audioPlay.titleSong = "\(listSongs[indexPath.row].title) Ca Sy: \(listSongs[indexPath.row].artistName)"
        audioPlay.setupAudio()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setupObserveAudio"), object: nil)
    }
    
    func downloadSong(_ index: Int) {
        let dataSong = try? Data(contentsOf: URL(string: listSongs[index].sourceOnline)!)
        if let dir = kDOCUMENT_DIRECTORY_PATH {
            let pathToWriteSong = "\(dir)/\(listSongs[index].title)"
            // Create Folder
            do
            {
                try FileManager.default.createDirectory(atPath: pathToWriteSong, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as Error {
                print(error.localizedDescription)
            }
            
            // Create Song => ghi ra plist
            writeDataToPath(dataSong as! NSObject, path: "\(pathToWriteSong)/\(listSongs[index].title).mp3")
            
            // Write Song's Information
            writeInfoSong(listSongs[index], path: pathToWriteSong)
        }
    }
    
    func writeDataToPath(_ data: NSObject, path: String)
    {
        if let dataToWrite = data as? Data {
            try? dataToWrite.write(to: URL(fileURLWithPath: path), options: [.atomic])
        } else if let dataInfo = data as? NSDictionary {
            // Dictionary VS NSDictionary
            dataInfo.write(toFile: path, atomically: true)
        }
    }
    
    func writeInfoSong(_ song: Song, path: String) {
        let dictData = NSMutableDictionary() // can change
        dictData.setValue(song.title, forKey: "title")
        dictData.setValue(song.artistName, forKey: "artistName")
        dictData.setValue("/\(song.title)/thumbnail.png", forKey: "localThumbnail")
        dictData.setValue(song.sourceOnline, forKey: "sourceOnline")
        dictData.setValue("\(path)/\(song.title).mp3", forKey: "sourceLocal")
        // write info
        writeDataToPath(dictData, path: "\(path)/info.plist")
        // write thumbnail
        let dataThumbnail = NSData(data: UIImagePNGRepresentation(song.thumbnail)!)
        writeDataToPath(dataThumbnail, path: "\(path)/thumbnail.png")
    }
    
}
