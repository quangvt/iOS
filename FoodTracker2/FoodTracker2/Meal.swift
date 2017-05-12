////
////  Meal.swift
////  FoodTracker2
////
////  Created by Quang Vu on 5/12/17.
////  Copyright © 2017 com.quangvt. All rights reserved.
////
//
//import UIKit
//// UIKit also gives you access to Foundation
//
//import os.log
//
//
//class Meal : NSObject, NSCoding {
//    // MARK: Properties
//    var name: String
//    var photo: UIImage?
//    var rating: Int
//    
//    // MARK: Archiving Paths
//    
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
//    
//    // MARK: Types
//    struct PropertyKey {
//        static let name = "name"
//        static let photo = "photo"
//        static let rating = "rating"
//    }
//    
//    // MARK: Initialzation
//    
//    // init? : Failable initializer return optional value
//    // init! : Failable initializer return implicitly unwrapped optional
//    // Optional can either contain a valid value or nil
//    // So you must check and then safety unwrap the value before you can use it.
//    // Implicitly Unwrapped Optionals are optionals, but the system implicitly unwraps them for you
//    init?(name: String, photo: UIImage?, rating: Int) {
//        // Initialization should fail if there is no name or if the rating is negative.
//        if (name.isEmpty || rating < 0) {
//            // Only failable initializers can return 'nil'.
//            return nil
//        }
//        
//        // Initialize stored properties.
//        self.name = name
//        self.photo = photo
//        self.rating = rating
//    }
//    
//    // MARK: NSCoding
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: PropertyKey.name)
//        aCoder.encode(photo, forKey: PropertyKey.photo)
//        aCoder.encode(rating, forKey: PropertyKey.rating)
//    }
//    
//    // The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
//    required convenience init?(coder aDecoder: NSCoder) {
//        // The name is required. If we cannot decode a name string, the initializer should fail.
//        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        // Because photo is an optional property of Meal, just use conditional cast.
//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        
//        let rating = aDecoder.decodeObject(forKey: PropertyKey.rating) as? Int
//        
//        // Must call designated initializer.
//        // As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing.
//        // TODO: ! or ?
//        self.init(name: name, photo: photo, rating: rating!)
//    }
//    
//    
//    
//}

import UIKit

class Meal {
    
    //MARK: Properties
    var id: Int
    var name: String
    var photo: UIImage?
    var description: String
    var rating: Int
    
    var strUrl = "http://localhost:3000/api/meal"
    
    //MARK: Initialization
    init?(id: Int, name: String, photo: UIImage?, description: String, rating: Int) {
        
        //the name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        
        //Initialize stored properties.
        self.id = id
        self.name = name
        self.photo = photo
        self.description = name.replacingOccurrences(of: " ", with: "_").appending(".png") //(".jpg")
        self.rating = rating
        
    }
    
    //Insert to DB
    func insert() {
        
        let baseUrl = NSURL(string: strUrl)
        
        let request = NSMutableURLRequest(url: baseUrl! as URL)
        
        request.httpMethod = "POST";
        
        let param = [
            "name"  : "\(name)",
            "desc"    : "\(description)",
            "rating"    : "\(rating)"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImagePNGRepresentation(photo!) //UIImageJPEGRepresentation(photo!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithFile(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("=> response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("=> response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json as Any)
                if let parseJson = json as? [String: AnyObject] {
                    self.id = parseJson["id"] as! Int
                }
                
            } catch
            {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    //Update to DB
    func update() {
        
        strUrl += "/\(id)" //For updating
        
        let baseUrl = NSURL(string: strUrl)
        
        let request = NSMutableURLRequest(url: baseUrl! as URL);
        request.httpMethod = "PUT";
        
        let param = [
            "id" : "\(id)",
            "name"  : "\(name)",
            "rating"    : "\(rating)"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                fatalError("Cannot connect to Server!")
            }
            
            //Print response object
            print("=> response: \(String(describing: response))")
            
            //Print response body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("=> responseBody: \(String(describing: responseString))")
            
            //var err: NSError?
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    print("Result: \(json)")
                    
                }
                catch {
                    fatalError("Cannot insert into Database!")
                }
            }
        }
        task.resume()
    }
    
    //Create HTTP Body
    func createBodyWithParameters(parameters: [String: String]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        return body
    }
    
    //Create HTTP Body with FILE
    func createBodyWithFile(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = (parameters?["desc"])!
        let mimetype = "image/png" // "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    //Generate Boudary
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //Delete Meal
    func delete() {
        
        strUrl += "/\(id)"
        
        let baseUrl = NSURL(string: strUrl)
        
        let request = NSMutableURLRequest(url: baseUrl! as URL);
        request.httpMethod = "DELETE";
        
        let postString = "id=\(id)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, myerror) in
            if myerror != nil {
                fatalError("Cannot connect to Server!")
            }
            
            //Print response object
            print("=> response: \(String(describing: response))")
            
            //Print response body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("=> responseBody: \(String(describing: responseString))")
            
            //var err: NSError?
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    print("Result: \(json)")
                    
                }
                catch {
                    fatalError("Cannot insert into Database!")
                }
            }
        }
        task.resume()
    }
    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

