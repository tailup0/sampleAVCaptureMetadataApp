//
//  ViewController.swift
//  sampleAVCaptureMetadataApp
//
//  Created by Muneharu Onoue on 2017/04/03.
//  Copyright © 2017年 Muneharu Onoue. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var previewlayer: AVCaptureVideoPreviewLayer!
    var faceView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        input = try? AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else { return }
        session.addInput(input)
        
        output = AVCaptureMetadataOutput()
        let queue = DispatchQueue.global()
        output.setMetadataObjectsDelegate(self, queue: queue)
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeFace]
        
        previewlayer = AVCaptureVideoPreviewLayer(session: session)
        previewlayer.frame = view.bounds
        previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewlayer)

        faceView = UIView()
        faceView.layer.borderColor = UIColor.red.cgColor
        faceView.layer.borderWidth = 3
        view.addSubview(faceView)
        
        session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for faceObj in metadataObjects {
            guard let face = faceObj as? AVMetadataFaceObject else { continue }
            guard let adjustedFace = previewlayer.transformedMetadataObject(for: face) else { continue }
            DispatchQueue.main.async {
                self.faceView.layer.cornerRadius = adjustedFace.bounds.width/2
                self.faceView.frame = adjustedFace.bounds
            }
        }
    }
    
}

