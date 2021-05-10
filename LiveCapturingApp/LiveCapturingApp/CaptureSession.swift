//
//  CaptureSession.swift
//  LiveCapturingApp
//
//  Created by A on 2020/10/21.
//
import AVFoundation

final class CaptureSession: AVCaptureSession {
    private let dataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private let videoOutputQueue = DispatchQueue(label: "videoQueue")
    weak var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate? {
        didSet {
            dataOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: DispatchQueue(label: "videoQueue"))
        }
    }
    
    override init() {
        super.init()
        configureInput()
        configureOutput()
    }
    
    private func configureInput() {
        
        guard let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front
        ).devices.first else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
    
        addInput(input)
    }
    
    private func configureOutput() {
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        addOutput(dataOutput)
    }
}
