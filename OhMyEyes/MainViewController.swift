//
//  ViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit
import StoreKit

class MainViewController: UIViewController {

    var isAppeared: Bool = true
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.addTarget(self, action: #selector(touchUpStartButton(_:)), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(touchUpRecordButton(_:)), for: .touchUpInside)
        if UserDefaults.standard.integer(forKey: "launchCount") % 4 == 0 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } 
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAppeared = true
        self.rotateImageView(imageView: leftImageView, duration: 2)
        self.rotateImageView(imageView: rightImageView, duration: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isAppeared = false
    }
    
    func rotateImageView(imageView: UIImageView, duration: TimeInterval) {
        var degree: CGFloat
        if imageView.tag == 0 {
            degree = CGFloat.pi
        } else {
            degree = -(CGFloat.pi * 0.999)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            imageView.transform = imageView.transform.rotated(by: degree)
        }) { _ in
            if self.isAppeared {
                self.rotateImageView(imageView: imageView, duration: 2)
            }
        }
    }
    
    @objc func touchUpStartButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "SelectEyesViewController") else { return }
        self.present(next, animated: false, completion: nil)
    }
    
    @objc func touchUpRecordButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") else { return }
        self.present(next, animated: false, completion: nil)
    }
}

