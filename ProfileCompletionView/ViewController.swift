//
//  ViewController.swift
//  ProfileCompletionView
//
//  Created by 李玲 on 7/16/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: CircularView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerView.start()
    }
    
    @IBAction func fdsfdf(_ sender: Any) {
        containerView.add()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

