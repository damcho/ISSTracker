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
    
    var ISStrackerVM:ISSTrackerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.ISStrackerVM?.stopTasks()
        self.createForm()
    }
    
    @objc func doneTapped() {
        ISStrackerVM?.updateSettings(values:form.values())
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
        return  IntRow("timer"){ row in
            row.title = "Seconds"
            row.value = Int( (self.ISStrackerVM?.settingsObject.timeInterval) ?? 10)
            row.add(rule: RuleRequired())
        }
    }
}
