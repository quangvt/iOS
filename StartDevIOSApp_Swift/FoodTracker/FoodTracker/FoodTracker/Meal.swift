//
//  Meal.swift
//  FoodTracker
//
//  Created by Quang Vu on 4/13/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit
import os.log

class Meal : NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    // MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    
    // Failable initializers always start with either init? or init!. These initializers return optional values or implicitly unwrapped optional values, respectively.
    
    // As you will see in later lessons, failable initializers are harder to use because you need to unwrap the returned optional before using it. Some developers prefer to enforce an initializer’s contract using assert() or precondition() methods. These methods cause the app to terminate if the condition they are testing fails. This means that the calling code must validate the inputs before calling the initializer.
    
    // For more information on initializers, see Initialization. For information on adding inline sanity checks and preconditions to your code, see assert(_:_:file:line:) and precondition(_:_:file:line:).
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0  {
//            return nil
//        }
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
//    init(){
//        super.init()
//    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
    
    
}
