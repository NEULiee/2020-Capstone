//
//  LoadingDots.swift
//  LiveCapturingApp
//
//  Created by A on 2020/11/28.
//

import UIKit

class LoadingDots: UIView {
    
    @IBOutlet var dots: [UIView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initXIB()
    }
    
    func initXIB() {
        guard let view = Bundle.main.loadNibNamed("loadingDots", owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func startAnimation() {
        for index in 0..<dots.count {
//            dots[index].transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.6, delay: Double(index + 1 ) * 0.2, options: [.repeat, .autoreverse], animations: {
                self.dots[index].transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { _ in self.dots[index].transform = CGAffineTransform.identity })
        }
    }
    
}
