//
//  ClassificationManager.swift
//  LiveCapturingApp
//
//  Created by A on 2020/10/21.
//

import Vision
import AVFoundation

final class ClassificationManager: NSObject {
    private let mlModel: MLModel
    private var requests = [VNRequest]()
    private let minimumConfidence: Float = 0.90
    private var currentIdentifier: String? = nil
    private var classificationCount: Int = 0
    
    init(mlModel: MLModel) {
        self.mlModel = mlModel
        super.init()
    }
    
    func configureRequest(detectingHandler: @escaping (Int, String?) -> (), successCompletion: @escaping (VNClassificationObservation) -> ()) {
        guard let visionModel = try? VNCoreMLModel(for: mlModel) else { return }
        let objectRecognition = VNCoreMLRequest(model: visionModel) {
            [unowned self] (finishedReq, err) in
//            print(finishedReq.results)
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            print(firstObservation.identifier, firstObservation.confidence)
            updateResults(results, detectingHandler: detectingHandler, successCompletion: successCompletion)
        }
        requests = [objectRecognition]
    }
    
    private func updateResults(_ results: [Any], detectingHandler: (Int, String?) -> (), successCompletion: (VNClassificationObservation) -> ()) {
        for observation in results where observation is VNClassificationObservation {
            guard let classificationObservation = observation as? VNClassificationObservation, classificationObservation.confidence > minimumConfidence else { continue }
            if currentIdentifier == classificationObservation.identifier {
                classificationCount += 1
            } else {
                currentIdentifier = classificationObservation.identifier
                classificationCount = 0
            }
            detectingHandler(classificationCount, currentIdentifier)
            guard classificationCount == 100 else { continue }
            successCompletion(classificationObservation)
            classificationCount = 0
            
        }
    }
}

extension ClassificationManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //        print("Camera was able to capture a frame:", Date())
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform(requests)
    }
}
