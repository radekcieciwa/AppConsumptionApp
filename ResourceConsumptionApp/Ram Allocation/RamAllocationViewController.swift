//
//  FirstViewController.swift
//  ResourceConsumptionApp
//
//  Created by Radoslaw Cieciwa on 22/07/2019.
//  Copyright © 2019 BeardDev. All rights reserved.
//

import UIKit

extension Int {
    static var megaByte: Int = 1048576
}

extension Float {
    static var megaByte: Float = 1048576
}

class RamAllocationViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressValue: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var freeSpaceLabel: UILabel!
    
    private var allocator = MemoryAllocator()

    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allocator.onMemoryUpdate = { (physical, user) in
            let taken = Float(user) / Float(physical)
            let free = physical - user

            let freeInMBString = self.formatter.string(from: NSNumber(value: Float(free) / Float.megaByte))!
            let userMB = self.formatter.string(from: NSNumber(value: Float(user) / Float.megaByte))!

            self.freeSpaceLabel.text = "\(freeInMBString) MB"
            self.progressValue.text = "\(userMB) MB"
            self.progressView.progress = taken
        }

        self.allocator.clearAll()
    }

    @IBAction func startButtonPushed(_ sender: Any) {
        self.allocator.allocateMemory(128)
    }

    @IBAction func stopButtonPushed(_ sender: Any) {
        self.allocator.clearAll()
    }
}

