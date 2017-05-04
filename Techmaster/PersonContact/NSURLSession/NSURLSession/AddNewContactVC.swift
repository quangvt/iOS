//
//  AddNewContactVC.swift
//  NSURLSession
//
//  Created by Vinh The on 7/27/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import UIKit

protocol AddNewContactDelegate {
    func dismissAddnewContactController(addNewVC: AddNewContactVC)
}

class AddNewContactVC: UIViewController{
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var nameTextField: CustomTextField!
    
    @IBOutlet weak var phoneTextField: CustomTextField!
    
    @IBOutlet weak var cityTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var navLabel: UILabel!
    
    var delegate : AddNewContactDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMask(view, rectCorner: [.bottomLeft,.bottomRight, .topLeft, .topRight], radius: CGSize(width: 20.0, height: 20.0))
        setMask(bannerView, rectCorner: [.topLeft, .topRight], radius: CGSize(width: 20.0, height: 20.0))
        
    }
    
    // MARK: Post Request
    
    func createNewContactRequest(name: String, phone: Int, city: String?, email: String?) {
        var param : [String: AnyObject] = ["name" : name as AnyObject, "phone" : phone as AnyObject]
        if city != nil {
            param["city"] = city as AnyObject
        }
        if email != nil {
            param["email"] = email as AnyObject
        }
        // Mutable => allow to edit
        let urlRequest = NSMutableURLRequest(url: URL(string: baseURL)!)
        
        urlRequest.httpMethod = "POST"
        
        let configurationSession = URLSessionConfiguration.default
        configurationSession.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let createContactSession = URLSession(configuration: configurationSession)
        
        let dataPassing = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted )
        
        let task = createContactSession.uploadTask(with: urlRequest as URLRequest, from: dataPassing, completionHandler: {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let responseHTTP = response as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200 {
                        print(data)
                        DispatchQueue.main.async(execute: {
                            self.delegate?.dismissAddnewContactController(addNewVC: self)
                        })
                    } else {
                        print(responseHTTP.statusCode)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    // MARK: Create corner roundrect.
    
    func setMask(_ view : UIView, rectCorner : UIRectCorner, radius : CGSize){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.borderWidth = 1.0
        maskLayer.borderColor = UIColor.black.cgColor
        
        view.layer.mask = maskLayer
        
    }
    
    @IBAction func addNewContactAction(_ sender: AnyObject) {
        if let name = nameTextField.text, let phone = Int(phoneTextField.text!){
            createNewContactRequest(name: name, phone: phone, city: cityTextField.text, email: emailTextField.text)
        } else {
            print("no name no phone")
        }
    }
}


extension AddNewContactVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setValue(UIColor.clear, forKeyPath: "_placeholderLabel.textColor")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
    }
}
