//
//  SelectEyesViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class SelectEyesViewController: UIViewController {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.setTitle("Back".localized, for: .normal)
        self.backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.leftButton.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        self.backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
    }
    
    @objc func touchUpButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "WarningViewController") else { return }
        UserInformation.shared.eyePosition = sender.tag == 0 ? .left : .right
        self.present(next, animated: false, completion: nil)
    }
    
    @objc func touchUpBackButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
