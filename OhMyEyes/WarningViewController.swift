//
//  WarningViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 5..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    var second: Int = 3
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if self.second == 0 {
            self.timer?.invalidate()
            self.timer = nil
            guard let next = storyboard?.instantiateViewController(withIdentifier: "GameViewController") else { return }
            self.present(next, animated: false, completion: nil)
        }
        self.countdownLabel.text = "\(self.second)"
        self.second -= 1
    }
}
