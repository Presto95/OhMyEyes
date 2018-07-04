//
//  ViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.addTarget(self, action: #selector(touchUpStartButton(_:)), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(touchUpRecordButton(_:)), for: .touchUpInside)
    }
    
    @objc func touchUpStartButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "SelectEyesViewController") else { return }
        self.present(next, animated: false, completion: nil)
    }
    
    @objc func touchUpRecordButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") else { return }
        self.present(next, animated: true, completion: nil)
    }
}

