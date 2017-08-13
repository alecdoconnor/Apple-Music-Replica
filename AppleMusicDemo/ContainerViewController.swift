//
//  ContainerViewController.swift
//  AppleMusicDemo
//
//  Created by Alec O'Connor on 6/13/17.
//  Copyright © 2017 ADO. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSliderView()
    }
    
    func addSliderView() {
        let sliderViewController = SliderViewController()
        
        addChildViewController(sliderViewController)
        view.addSubview(sliderViewController.view)
        sliderViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

