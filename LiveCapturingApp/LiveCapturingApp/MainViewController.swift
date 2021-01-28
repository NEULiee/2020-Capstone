//
//  MainViewController.swift
//  LiveCapturingApp
//
//  Created by A on 2020/10/17.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var mainImage: UIImageView!
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("end").setValue("start")
        ref.child("pet").setValue(["hasLabel": "default"])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainImage.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let videoViewController = storyboard?.instantiateViewController(identifier: "VideoViewController") {
            videoViewController.modalTransitionStyle = .coverVertical
            present(videoViewController, animated: true, completion: nil)
        }
    }
}
