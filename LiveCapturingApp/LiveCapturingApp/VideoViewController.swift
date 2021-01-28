//
//  ViewController.swift
//  LiveCapturingApp
//
//  Created by A on 2020/10/03.
//

import UIKit
import AVFoundation
import Vision

class VideoViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    private let session: CaptureSession = CaptureSession()
    private var classificationManager: ClassificationManager! {
        didSet {
            session.sampleBufferDelegate = classificationManager
        }
    }
    private var currentObservation: VNClassificationObservation?
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePreviewLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureClassification()
        session.startRunning()
    }
    
    private func configureClassification() {
        guard let classifier = try? petClassifier(configuration: MLModelConfiguration()) else { return }
        classificationManager = ClassificationManager(mlModel: classifier.model)
        classificationManager.configureRequest(detectingHandler: {
            [weak self] count, label in
            DispatchQueue.main.async {
                self?.resultLabel.text = "Detecting .. \(label!)  \(count)%"
            }
        }, successCompletion: {
            [weak self] observation in
            DispatchQueue.main.async {
                self?.resultLabel.text = "\(observation.identifier) 입니다!"
            }
            self?.session.stopRunning()
            print("종료")
            sleep(1)
            DispatchQueue.main.async {
                let VC = self?.storyboard?.instantiateViewController(withIdentifier: "ControlViewController") as? ControlViewController
                VC?.hasLabel = observation.identifier
                self?.present(VC!, animated: true, completion: nil)
            }
            
        })
    }
    
    private func configurePreviewLayer() {
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = contentView.bounds
        contentView.layer.addSublayer(previewLayer)
    }
    
    
    
    
    
    
}

