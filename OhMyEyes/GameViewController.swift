//
//  GameViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit
import CoreData

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
        if self.presentedViewController is UIAlertController { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        let initialDegree = CGFloat.pi / 4 * CGFloat(8 - self.randomNumber)
        self.imageView.transform = self.imageView.transform.rotated(by: initialDegree)
        let random = CGFloat(arc4random_uniform(8))
        self.randomNumber = Int(random)
        let degree = CGFloat.pi / 4 * random
        self.imageView.transform = self.imageView.transform.rotated(by: degree)
    }
    
    func finishGame(_ minimumPoint: CGFloat) {
        self.timer?.invalidate()
        self.timer = nil
        let message = "Number of Trials".localized + " : \(count)\n" + "Minimum Point of Shape".localized + " : \(minimumPoint)"
        let alert = UIAlertController(title: "Result".localized, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm".localized, style: .default) { _ in
            let eyePosition = UserInformation.shared.eyePosition ?? .left
            let isLeft = eyePosition == .left ? false : true
            self.saveCoreData(isLeft: isLeft, minimumPoint: Double(minimumPoint), trials: self.count, date: Date())
            UserInformation.shared.eyePosition = nil
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveCoreData(isLeft: Bool, minimumPoint: Double, trials: Int, date: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context)
        object.setValue(isLeft, forKey: "position")
        object.setValue(minimumPoint, forKey: "minimumPoint")
        object.setValue(trials, forKey: "trials")
        object.setValue(date, forKey: "date")
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    func getCorrectAnswer() {
        let length = self.imageViewWidthConstraint.constant
        let distance: CGFloat = {
            if length <= 10 {
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
            if length < 10 {
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
        self.count += 1
        if sender.tag == self.randomNumber {
            getCorrectAnswer()
        } else {
            getIncorrectAnswer()
        }
        self.view.layoutIfNeeded()
        self.initializeGame()
    }
}
