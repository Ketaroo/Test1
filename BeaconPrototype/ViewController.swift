//
//  ViewController.swift
//  BeaconPrototype
//
//  Created by keinakagawa on 2015/09/27.
//  Copyright © 2015年 K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func tapTest(sender: AnyObject) {
        do {
            let mycmAD = MyCommunication()
            let dic = try mycmAD.doPostAndJsonToDic("beaconID=beaconid_test",urlstr: "http://iotibeacont.mybluemix.net/timeSchedule/")
            // 最近はhttpの接続は許可されない。今回はinfo.plistで許可するように設定している。
            
            let alertController = UIAlertController(title: "テスト", message:
                dic["firstRide"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        catch {
            NSLog("テストにて想定外エラー")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

