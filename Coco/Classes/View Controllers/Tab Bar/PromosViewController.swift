//
//  PromosViewController.swift
//  Coco
//
//  Created by Tony Vazgar on 15/01/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import Foundation
import UIKit


final class PromosViewController: UIViewController{
    
    @IBOutlet weak var labelCountDown: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func updateTime(){
        let userCalendar = Calendar.current
        let date = Date()
        
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        
        let currentDate = userCalendar.date(from: components)!
        
        var eventDateComponents = DateComponents()
        eventDateComponents.year = 2022
        eventDateComponents.month = 03
        eventDateComponents.day = 07
        eventDateComponents.hour = 00
        eventDateComponents.minute = 00
        eventDateComponents.second = 00
        eventDateComponents.timeZone = TimeZone(abbreviation: "GMT-6")
        
        let eventDate = userCalendar.date(from: eventDateComponents)!
        let timeLeft  = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
        
        labelCountDown.text = "\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        
        endEvent(currentdate: currentDate, eventdate: eventDate)
    }
    
    func endEvent(currentdate: Date, eventdate: Date){
        if (currentdate >= eventdate){
            labelCountDown.text = ""
            timer.invalidate()
        }
    }
}
