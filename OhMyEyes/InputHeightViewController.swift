//
//  InputHeightViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 5..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit

class InputHeightViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension InputHeightViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
}
extension InputHeightViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attr = NSAttributedString(string: "\(row + 140)", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ])
        return attr
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserInformation.shared.height = row + 140
        guard let next = storyboard?.instantiateViewController(withIdentifier: "WarningViewController") else { return }
        self.present(next, animated: false, completion: nil)
    }
}
