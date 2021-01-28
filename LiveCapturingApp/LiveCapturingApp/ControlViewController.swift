//
//  ControlViewController.swift
//  LiveCapturingApp
//
//  Created by A on 2020/10/25.
//

import UIKit
import Firebase
import FirebaseDatabase


class ControlViewController: UIViewController {
    var hasLabel = ""
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let post : [String: String] = ["hasLabel": hasLabel]
        ref.child("pet").setValue(post)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if hasLabel == "label" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController")
            self.present(VC!, animated: true, completion: nil)
        }
        else { 
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CycleViewController")
            self.present(VC!, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hasLabel = "none"
        let post2 = ["hasLabel": hasLabel]
        ref.child("pet").setValue(post2)
        print("done")
    }
}


    

