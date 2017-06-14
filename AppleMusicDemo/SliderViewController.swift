//
//  SliderViewController.swift
//  AppleMusicDemo
//
//  Created by Alec O'Connor on 6/13/17.
//  Copyright © 2017 ADO. All rights reserved.
//

import UIKit

enum SliderPosition {
    case Open
    case Closed
}

class SliderViewController: UIViewController {
    
    let height: CGFloat = 80
    var heightConstraint: NSLayoutConstraint?
    var currentSliderPosition = SliderPosition.Closed
    let animationLength = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
    }
    
    func handleTap() {
        updateViewHeight(to: currentSliderPosition == .Closed ? .Open : .Closed)
    }
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
//        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        guard let parent = parent else {
            print("Parent not found")
            return
        }
        view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func updateViewHeight(to position: SliderPosition) {
        switch position {
        case .Open:
            currentSliderPosition = .Open
            UIView.animate(withDuration: animationLength) {
                guard let parent = self.parent else {
                    print("Parent not found")
                    return
                }
                self.heightConstraint?.isActive = false
                self.heightConstraint = self.view.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: self.height)
                self.heightConstraint?.isActive = true
                self.view.layer.cornerRadius = 15
                self.view.backgroundColor = UIColor.white
                self.parent?.view.layoutIfNeeded()
            }
        case .Closed:
            currentSliderPosition = .Closed
            UIView.animate(withDuration: animationLength) {
                self.heightConstraint?.isActive = false
                self.heightConstraint = self.view.heightAnchor.constraint(equalToConstant: self.height)
                self.heightConstraint?.isActive = true
                self.view.layer.cornerRadius = 0
                self.view.backgroundColor = UIColor.clear
                self.parent?.view.layoutIfNeeded()
            }
        }
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
