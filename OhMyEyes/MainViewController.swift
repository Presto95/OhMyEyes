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
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.addTarget(self, action: #selector(touchUpStartButton(_:)), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(touchUpRecordButton(_:)), for: .touchUpInside)
        self.rotateImageView(imageView: leftImageView, duration: 2)
        self.rotateImageView(imageView: rightImageView, duration: 2)
      
    }
    
    func rotateImageView(imageView: UIImageView, duration: TimeInterval) {
        var degree: CGFloat = .infinity
        if imageView.tag == 0 {
            degree = CGFloat.pi
        } else {
            degree = -(CGFloat.pi * 0.999)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            imageView.transform = imageView.transform.rotated(by: degree)
        }) { _ in
            self.rotateImageView(imageView: imageView, duration: duration)
        }
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

