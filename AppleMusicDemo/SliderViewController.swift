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
    
    // MARK: - Slider Variables
    
    var currentSliderPosition = SliderPosition.Closed
    let animationLength = 0.25
    
    var heightAvailable: CGFloat = 100
    var modalHeight: (min: CGFloat, max: CGFloat) = (80, 100)
    var modalHeightRange: CGFloat {
        return modalHeight.max - modalHeight.min
    }
    var translationInitialHeight: CGFloat = 0
    
    let shadow = UIView()
    
    // MARK: - Content Variables
    var albumImage: UIImage?
    var albumImageView: UIView?
    
    
    // MARK: - View Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        setUpShadowView()
        heightAvailable = parent!.view.bounds.height
        modalHeight.max = heightAvailable * CGFloat(0.8)
        updateViewFrame(to: currentSliderPosition, animated: false)
        addContent()
    }
    
    func setUpShadowView() {
        shadow.frame = view.superview!.frame
        view.superview?.addSubview(shadow)
        view.superview?.bringSubview(toFront: view)
        
        shadow.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        shadow.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(shadowTap))
        shadow.addGestureRecognizer(tap)
    }
    
    func addContent() {
        // Image
        albumImage = UIImage(named: "singleAlbum")
        albumImageView = UIImageView(image: albumImage)
        view.addSubview(albumImageView!)
        
        
        resizeContent()
    }
    
    func resizeContent() {
        // Image
        let aspectSizeHeight = view.bounds.height - 16
        let aspectSizeWidth = view.bounds.width - 16
        let aspectSize = aspectSizeWidth < aspectSizeHeight ? aspectSizeWidth : aspectSizeHeight
        albumImageView?.frame = CGRect(x: 8, y: 8, width: aspectSize, height: aspectSize)
        albumImageView?.layer.cornerRadius = 8
        albumImageView?.layer.masksToBounds = true
    }
    
    
    // MARK: - Slider View Animation
    
    func updateViewFrame(to sliderPosition: SliderPosition, animated: Bool) {
        currentSliderPosition = sliderPosition
        UIView.animate(withDuration: animated ? animationLength : 0.0) {
            self.updateAnimatingValues(to: sliderPosition == .Open ? 1.0 : 0.0)
            self.view.layoutIfNeeded()
        }
    }
    
    func updateAnimatingValues(to rawPercentage: CGFloat) {
        guard let parent = parent else {
            print("Parent not found in updateAnimationValue")
            return
        }
        
        let percentage = rawPercentage < 0 ? 0
            : rawPercentage > 1 ? 1
            : rawPercentage
        
        let frameWidth = parent.view.frame.width
        
        let height = modalHeightRange * percentage + modalHeight.min
        let cornerRadius = round(15 * percentage)
        let backgroundColor = UIColor(white: 1.0, alpha: percentage)
        
        view.frame = CGRect(x: 0, y: heightAvailable - height, width: frameWidth, height: height)
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColor
        shadow.alpha = percentage
        shadow.isHidden = percentage == 0 ? true : false
        
        resizeContent()
    }
    
    
    // MARK: - Gesture Selectors
    
    func handleTap() {
        updateViewFrame(to: currentSliderPosition == .Closed ? .Open : .Closed, animated: true)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        switch recognizer.state {
        case .began:
            translationInitialHeight = view.frame.origin.y
            fallthrough
        case .changed:
            let destinationHeight = translationInitialHeight + translation.y
            let percentageOfHeight = 1 - (destinationHeight - modalHeight.min) / modalHeightRange
            updateAnimatingValues(to: percentageOfHeight)
        case .ended:
            let velocity = recognizer.velocity(in: view)
            if velocity.y == 0 {
                let destinationHeight = translationInitialHeight + translation.y
                let percentageOfHeight = 1 - (destinationHeight - modalHeight.min) / modalHeightRange
                let status: SliderPosition = percentageOfHeight >= 0.5 ? .Open : .Closed
                updateViewFrame(to: status, animated: true)
                return
            }
            updateViewFrame(to: velocity.y < 0 ? .Open : .Closed, animated: true)
        default:
            break
        }
    }
    
    func shadowTap() {
        updateViewFrame(to: .Closed, animated: true)
    }
    
    
    // MARK: - Utilities
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
