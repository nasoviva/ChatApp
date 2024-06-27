//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by hverda on 25/06/2024.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "ChatApp"
//        var char = 0.0
//        let titleText = "ChatApp"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: (0.1 * char), repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            char += 1
//        }
    }


    @IBAction func registerPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
}

