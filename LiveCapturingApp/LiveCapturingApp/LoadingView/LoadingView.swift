//
//  LoadingView.swift
//  LiveCapturingApp
//
//  Created by A on 2020/11/28.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var omgImageView: UIImageView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var labelImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initXIB()
    }
    
    func initXIB() {
        guard let view = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func startAnimation() {
        let originTransform = self.labelImageView.transform
        let translatedTransform = originTransform.translatedBy(x: 120.0, y: 0)
        self.labelImageView.transform = translatedTransform
        
        UIView.animate(withDuration: 2.0, delay: 0.2) {
            self.labelImageView.transform = originTransform
        } completion: { (_) in
            UIView.animate(withDuration: 2.0) {
                self.labelImageView.transform = translatedTransform
            } completion: { (_) in
                UIView.animate(withDuration: 2.0) {
                    self.labelImageView.transform = originTransform
                } completion: { (_) in
                    UIView.animate(withDuration: 2.0) {
                        self.labelImageView.transform = translatedTransform
                    }
                    completion: { (_) in
                        UIView.animate(withDuration: 2.0) {
                            self.labelImageView.transform = originTransform
                        }
                    }
                }
            }
        }
        
        
        
        
    }
}
