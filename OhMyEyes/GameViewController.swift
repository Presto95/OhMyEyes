//
//  GameViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var eyePosition: EyePosition?
    var count: Int = 0 {
        willSet {
            if newValue == 10 {
                self.presentAlertController()
            }
        }
    }
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var eyesight: Float = 0
    var timer: Timer?
    var second: Int = 3
    var randomNumber: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var northButton: UIButton!
    @IBOutlet weak var northeastButton: UIButton!
    @IBOutlet weak var eastButton: UIButton!
    @IBOutlet weak var southeastButton: UIButton!
    @IBOutlet weak var southButton: UIButton!
    @IBOutlet weak var southwestButton: UIButton!
    @IBOutlet weak var westButton: UIButton!
    @IBOutlet weak var northwestButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [northButton, northeastButton, eastButton, southeastButton, southButton, southwestButton, westButton, northwestButton]
        var count: CGFloat = 0
        for button in buttons {
            button?.transform = button?.transform.rotated(by: CGFloat.pi / 4 * count) ?? CGAffineTransform()
            count += 1
            button?.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        self.initializeGame()
    }
    
    func initializeGame() {
        let initialDegree = CGFloat.pi / 4 * CGFloat(8 - self.randomNumber)
        self.imageView.transform = self.imageView.transform.rotated(by: initialDegree)
        let random = CGFloat(arc4random_uniform(8))
        self.randomNumber = Int(random)
        print(randomNumber)
        let degree = CGFloat.pi / 4 * random
        self.imageView.transform = self.imageView.transform.rotated(by: degree)
    }
    
    func presentAlertController() {
        let message = "맞은 횟수 : \(correctCount)"
        let alert = UIAlertController(title: "결과", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            print("결과 코어데이터에 저장하고 메인으로 돌아가기")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        self.second -= 1
        if self.second == 0 {
            self.count += 1
            self.incorrectCount += 1
            self.second = 3
            self.initializeGame()
        }
        self.timerLabel.text = "\(self.second)"
    }
    
    @objc func touchUpButton(_ sender: UIButton) {
        if sender.tag == self.randomNumber {
            self.correctCount += 1
        } else {
            self.incorrectCount += 1
        }
        self.count += 1
        self.initializeGame()
    }
}
