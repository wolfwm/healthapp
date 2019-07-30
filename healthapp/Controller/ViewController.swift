//
//  ViewController.swift
//  healthapp
//
//  Created by Wolfgang Walder on 26/06/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        startButton.backgroundColor = .clear
        startButton.setBackgroundImage(UIImage(named: "Hexagonal Shape Button"), for: .normal)
        // Do any additional setup after loading the view.
    }


}

