//
//  ViewController.swift
//  SwiftCounter
//
//  Created by xuhui on 15/12/21.
//  Copyright © 2015年 softgoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timeLabel: UILabel?
    var timeButtons: [UIButton]?
    var startStopButton: UIButton?
    var clearButton: UIButton?
    
    let timeButtonInfos = [("1分", 60), ("3分", 180), ("5分", 300), ("秒", 1)]
    
    var timer: NSTimer?
    
    var isCounting: Bool = false {
        willSet(newValue){
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonsEnabled(!newValue)
            
        }
    }
    
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let mins = newSeconds / 60
            let seconds = newSeconds % 60
            timeLabel?.text = NSString(format: "%02d:%02d", mins, seconds) as String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTimeLabel()
        
        self.setuptimeButtons()
        
        self.setupActionButtons()
    }

    // UI Helpers
    func setupTimeLabel() {
        timeLabel = UILabel(frame: CGRectMake(0, 20, self.view.frame.width, 150))
        timeLabel?.text = "00:00"
        timeLabel?.textAlignment = .Center
        timeLabel?.textColor = UIColor.whiteColor()
        timeLabel?.backgroundColor = UIColor.blackColor()
        timeLabel?.font = UIFont.systemFontOfSize(80)
        
        self.view.addSubview(timeLabel!)
    }
    
    func setuptimeButtons() {
        var buttons = [UIButton]()
        
        var count:CGFloat = 0
        
        for index in timeButtonInfos{
            
            let button: UIButton = UIButton()
            button.tag = Int(count)
            button.setTitle("\(index.0)", forState: .Normal)
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: .TouchUpInside)
            
            buttons.append(button)
            
            self.view.addSubview(button)
            
            count++
        }
        
        timeButtons = buttons
        
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
        var index: CGFloat = 0
        for button in timeButtons! {
            let buttonLeft = 10 + (64 + gap) * index
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
            index++
        }
    }
    
    
    func setupActionButtons() {
        startStopButton = UIButton(frame:  CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44))
        startStopButton?.backgroundColor = UIColor.redColor()
        startStopButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton?.setTitle("启动/停止", forState: UIControlState.Normal)
        startStopButton?.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(startStopButton!)
        
        clearButton = UIButton(frame: CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44))
        clearButton?.backgroundColor = UIColor.redColor()
        clearButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton?.setTitle("复位", forState: UIControlState.Normal)
        clearButton?.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(clearButton!)

    }
    
    
    //追加时间
    func timeButtonTapped(sender: UIButton) {
        let (_, seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    //启动停止
    func startStopButtonTapped(sender: UIButton) {
        isCounting = !isCounting
        
        if isCounting {
            createAndFireLocalNotificationAfterSeconds(remainingSeconds)
        }else{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    //复位
    func clearButtonTapped(sender: UIButton) {
        remainingSeconds = 0
    }
    
    func updateTimer(timer: NSTimer){
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            self.isCounting = false
            self.timeLabel?.text = "00:00"
            self.remainingSeconds = 0
            
            let alertController = UIAlertController(title: "计时完成！", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let ok_action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(ok_action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func setSettingButtonsEnabled(enabled: Bool){
        for button in self.timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
    }
    
    func createAndFireLocalNotificationAfterSeconds(seconds: Int){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        let timeIntervalSinceNow =  NSNumber(integer: seconds).doubleValue
        
        notification.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow)
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.alertBody = "计时完成！"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

