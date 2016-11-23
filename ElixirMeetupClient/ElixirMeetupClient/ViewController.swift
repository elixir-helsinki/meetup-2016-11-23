//
//  ViewController.swift
//  ElixirMeetupClient
//
//  Created by Teemu Harju on 22/11/2016.
//  Copyright © 2016 Teemu Harju. All rights reserved.
//

import UIKit

import FirebaseMessaging

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.text! += textField.text! + "\n"
        
        
        // send message
        FIRMessaging.messaging().sendMessage(["msg": textField.text!], to: "639605443504@gcm.googleapis.com", withMessageID: UUID().uuidString, timeToLive: 3600)
        
        textField.text! = ""
        
        return true
    }

}

