//
//  SettingsViewController.swift
//  ISSTracker
//
//  Created by Damian Modernell on 15/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

        self.createForm()
    }
    
    @objc func doneTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createForm() {
        self.form.append(self.createSection())
    }
    
    func createSection() -> Section {
        return Section("ISS Position update time interval")
            <<< self.createTimerSelection()
    }

    func createTimerSelection() -> IntRow{
        return  IntRow("IntRow"){ row in
            row.title = "Seconds"
            row.value = 10
           
            }
    }
    

}
