//
//  CycleViewController.swift
//  LiveCapturingApp
//
//  Created by A on 2020/11/28.
//

import UIKit
import Firebase
import AudioToolbox

class CycleViewController: UIViewController {

    private var loadingDots: LoadingDots?
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingDots()
        checkServer()
    }
    
    func setLoadingDots() {
        let loadingDotsFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingDots = LoadingDots(frame: loadingDotsFrame)
        guard let loading = loadingDots else { return }
        
        loading.center = self.view.center
        loading.startAnimation()
        self.view.addSubview(loading)
    }
    
    func checkServer() {
        ref.child("end").observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value
            print(value as! String)
            if value as! String == "finish" {
                AudioServicesPlaySystemSound(1029)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
                self.present(VC!, animated: true, completion: nil)
            }
        }
    }
    


}
