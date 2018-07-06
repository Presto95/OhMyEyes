//
//  GameViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var count: Int = 0
    var eyesight: Float = 0
    var timer: Timer?
    var second: Int = 3
    var randomNumber: Int = 0
    var results = [CGFloat: Int]() {
        didSet {
            let filtered = results.filter { $1 == 3 }
            if filtered.count == 1 {
                self.finishGame(filtered.first?.key ?? 0)
            }
        }
    }
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
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
        self.initializeGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func initializeGame() {
        self.second = 3
        self.timerLabel.text = "\(self.second)"
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        let initialDegree = CGFloat.pi / 4 * CGFloat(8 - self.randomNumber)
        self.imageView.transform = self.imageView.transform.rotated(by: initialDegree)
        let random = CGFloat(arc4random_uniform(8))
        self.randomNumber = Int(random)
        print(randomNumber)
        let degree = CGFloat.pi / 4 * random
        self.imageView.transform = self.imageView.transform.rotated(by: degree)
    }
    
    func finishGame(_ minimumPoint: CGFloat) {
        self.timer?.invalidate()
        self.timer = nil
        let message =
        """
        시행 횟수 : \(count)
        도형의 최소 포인트 : \(minimumPoint)
        """
        let alert = UIAlertController(title: "결과", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            print("결과 코어데이터에 저장하고 메인으로 돌아가기")
            UserInformation.shared.eyePosition = nil
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCorrectAnswer() {
        let length = self.imageViewWidthConstraint.constant
        let distance: CGFloat = {
            if length <= 5 {
                return 1
            }
            else {
                return 5
            }
        }()
        self.imageViewWidthConstraint.constant = length - distance
        self.imageViewHeightConstraint.constant = length - distance
        let value = self.results[length] ?? 0
        self.results[length] = value + 1
    }
    
    func getIncorrectAnswer() {
        let length = self.imageViewWidthConstraint.constant
        let distance: CGFloat = {
            if length <= 5 {
                return 1
            }
            else {
                return 5
            }
        }()
        self.imageViewWidthConstraint.constant = length + distance
        self.imageViewHeightConstraint.constant = length + distance
    }
    
    @objc func countDown() {
        self.second -= 1
        if self.second == 0 {
            getIncorrectAnswer()
            self.view.layoutIfNeeded()
            self.initializeGame()
            self.count += 1
        }
        self.timerLabel.text = "\(self.second)"
    }
    
    @objc func touchUpButton(_ sender: UIButton) {
        if sender.tag == self.randomNumber {
            getCorrectAnswer()
        } else {
            getIncorrectAnswer()
        }
        self.view.layoutIfNeeded()
        self.initializeGame()
        self.count += 1
    }
}
