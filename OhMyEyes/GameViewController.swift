//
//  GameViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

enum ArrowPosition {
    case north
    case northeast
    case east
    case southeast
    case south
    case southwest
    case west
    case northwest
    case none
}

class GameViewController: UIViewController {

    var eyePosition: EyePosition? {
        didSet {
            print(eyePosition ?? "error")
        }
    }
    var count: Int = 0 {
        didSet {
            if oldValue == 10 {
                self.presentAlertController()
            }
        }
    }
    var value: Float = 0
    var timer: Timer?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var northButton: UIButton!
    @IBOutlet weak var northeastButton: UIButton!
    @IBOutlet weak var eastButton: UIButton!
    @IBOutlet weak var southeastButton: UIButton!
    @IBOutlet weak var southButton: UIButton!
    @IBOutlet weak var southwestButton: UIButton!
    @IBOutlet weak var westButton: UIButton!
    @IBOutlet weak var northwestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [northButton, northeastButton, eastButton, southeastButton, southButton, southwestButton, westButton, northwestButton]
        for button in buttons {
            button?.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        }
    }
    
    func presentAlertController() {
        let alert = UIAlertController(title: "결과", message: "시력 : ?", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            print("결과 코어데이터에 저장하고 메인으로 돌아가기")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func touchUpButton(_ sender: UIButton) {
        self.count += 1
        var arrowPosition: ArrowPosition = .none
        switch sender.tag {
        case 0:
            arrowPosition = .north
        case 1:
            arrowPosition = .northeast
        case 2:
            arrowPosition = .east
        case 3:
            arrowPosition = .southeast
        case 4:
            arrowPosition = .south
        case 5:
            arrowPosition = .southwest
        case 6:
            arrowPosition = .west
        case 7:
            arrowPosition = .southwest
        default:
            arrowPosition = .none
        }
    }
}
