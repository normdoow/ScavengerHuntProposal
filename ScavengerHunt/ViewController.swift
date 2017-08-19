//
//  ViewController.swift
//  ScavengerHunt
//
//  Created by Noah Bragg on 8/15/16.
//  Copyright © 2016 NoahBragg. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //variables
    let locationManager = CLLocationManager() // Add this statement
    var viewNumber:Int = 0
    var clues = [String]()
    var coords = [CLLocationCoordinate2D]()
    var timer = NSTimer()
    var timerCount = 0
    var startedTouch = false
    var audioPlayer = AVAudioPlayer()
    
    //// outlets ////
    //// outlets ////
    //// outlets ////
    @IBOutlet weak var clueText: UITextView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var dotsText: UILabel!
    @IBOutlet weak var background: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        //setup location manager
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //add notification listener
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.fireNotification(_:)), name: "locationNotification", object: nil)
        //create timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        print("view Number: \(self.viewNumber)")
        background.multipleTouchEnabled = true
        checkMark.alpha = 0.0           //set the checkmark so it can't be seen
        let huntLocations = HuntLocations()
        //set our vars
        clues = huntLocations.getClues()
        coords = huntLocations.getCoordinates()
        clueText.text = clues[viewNumber]
        clueText.font = UIFont(name: "Helvetica Neue", size: 22.0)
        clueText.textAlignment = .Center
        titleText.text = "Clue \(self.viewNumber + 1)"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //start monitoring locations
        locationManager.startMonitoringForRegion(addRegionWithCoord(coords[viewNumber]))
    }
    
    //add a region with the given coordinates
    func addRegionWithCoord(coord:CLLocationCoordinate2D) -> CLCircularRegion {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showMessage("Geofencing is not supported for this device")
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showMessage("Geofencing is Disabled in Settings")
        }
        let region = CLCircularRegion(center: coord, radius: 30, identifier:  "id")        //in meters
        //set region on entry and exit
        region.notifyOnEntry = true
//        region.notifyOnExit = true
        return region
    }
    
    ////// chain of fires ///////
    ////// chain of fires ///////
    ////// chain of fires ///////
    ////// chain of fires ///////
    
    //fires from the notification
    func fireNotification(notification: NSNotification) {
        enteredNextLocation()
    }
    
    //fires when you enter the next location
    func enteredNextLocation(){
        //Take Action on Notification
        print("got to next location")
        checkMark.alpha = 1.0           //set the checkmark so it can't be seen
        dotsText.alpha = 0.0
        playSound("success")
        //remove the last listener
        locationManager.stopMonitoringForRegion(addRegionWithCoord(coords[viewNumber]))
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(3), target: self, selector: #selector(ViewController.jumpToNextClue), userInfo: nil, repeats: false)
    }
    
    func jumpToNextClue() {
        print("jumped to next clue")
        if(self.viewNumber < 4) {
            performSegueWithIdentifier("segueToSelf", sender: nil)
        } else {        //she found me
            performSegueWithIdentifier("toYouFoundMe", sender: nil)
        }
    }
    
    //is called when a segue is called
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueToSelf") {
            let yourNextViewController = (segue.destinationViewController as! ViewController)
            var nextVal = self.viewNumber
            if(self.viewNumber + 1 <= coords.count){
                nextVal = self.viewNumber + 1
            }
            yourNextViewController.viewNumber = nextVal
            print(self.viewNumber)
        }
    }
    
    ////// timer stuff ////////
    ////// timer stuff ////////
    ////// timer stuff ////////
    ////// timer stuff ////////
    ////// timer stuff ////////
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startedTouch = true         //so we know if the screen is being tapped
        print("touches")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //makes the counter go back to 0
        print("touches end")
        timerCount = 0
        startedTouch = false
    }

    func updateTimer() {
        if startedTouch {
            timerCount += 1
            if timerCount > 5 {
                print("we re greater than 5!")
                enteredNextLocation()
                timerCount = 0
                startedTouch = false
            }
        }
    }
    
    func playSound(soundName: String) {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:sound)
            audioPlayer.prepareToPlay()
            
        }catch {
            print("Error getting the audio file")
        }
        audioPlayer.play()
    }
    
    /////// error handling //////////
    /////// error handling //////////
    /////// error handling //////////
    /////// error handling //////////
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        showMessage("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
        showMessage("Location Manager failed with the following error: \(error)")
    }
    
    //shows a message
    func showMessage(message:String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

