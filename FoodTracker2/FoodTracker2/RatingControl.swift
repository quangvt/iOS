//
//  RatingControl.swift
//  FoodTracker2
//
//  Created by Quang Vu on 5/12/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    // MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        // Property Observer
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        // Property Observer
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        // Property Observer
        didSet {
            setupButtons()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // init(frame:) for programatically initializing the view
    // init?(coder:) for loading the view from the storyboard
    
    // init(frame:) => load by Interface Builder
    // init?(coder:) => load by storyboard
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The butotn, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    
    
    // MARK: Private Methods
    
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            // remove from the list of views managed by the stack view
            //   This tells the stack view that it should no longoer calculate the button's
            //   size and position - but the button is still a subview of the stack view
            removeArrangedSubview(button)
            // Removes the button from the stack view entirely
            button.removeFromSuperview()
        }
        // Clears the array
        ratingButtons.removeAll()
        
        // Load Button Images
        // @IBDesignable
        // For the images to load properly in Interface Builder, you must explicitly
        //   specify the catalog's bundle. This ensures that the system can find and load the image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // (_) wildcard: you don't need to nkow which iteration of the loop is currently executing
        // half-open range operator
//        for _ in 0..<starCount {
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            // disables the button's automatically generated constraints.
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating)"
            
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 start set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    

}
