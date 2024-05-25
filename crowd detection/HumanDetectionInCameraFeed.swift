//
//  HumanDetectionInCameraFeed.swift
//  crowd detection
//
//  Created by Dhau Embun Azzahra on 25/05/24.
//

import SwiftUI
import AVFoundation

struct HumanDetectionInCameraFeed: View {
    let captureSession = AVCaptureSession()
    let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    
    @ObservedObject var captureDelegate = CaptureDelegate()
    
    var body: some View {
        ZStack {
            VideoPreviewView(session: captureSession)
                .overlay(ForEach(captureDelegate.detectedRectangles.indices, id: \.self){ index in
                    
                    GeometryReader{ geometry in
                        Rectangle()
                            .path(in: CGRect(
                                x: captureDelegate.detectedRectangles[index].minY*geometry.size.height,
                                y: captureDelegate.detectedRectangles[index].minX*geometry.size.width,
                                width: captureDelegate.detectedRectangles[index].height*geometry.size.height,
                                height: captureDelegate.detectedRectangles[index].width*geometry.size.width
                            ))
                            .stroke(Color.red, lineWidth: 2.0)
                        
                    }
                    
                })
        }
        .aspectRatio(contentMode: .fit)
        
        Text("Human Count: \(captureDelegate.peopleCount)")
            .font(.title).padding()
            .onAppear{
                setupCaptureSession()
            }
            .onDisappear{
                captureSession.stopRunning()
            }
    }
    
    func setupCaptureSession(){
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .back)
        else{
            print("failed to create device")
            return
        }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Failed to create AVCaptureDeviceInput")
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(captureDelegate, queue: captureSessionQueue)
        
        captureSession.beginConfiguration()
        
        if captureSession.canAddInput(videoDeviceInput){
            captureSession.addInput(videoDeviceInput)
        }
        
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.commitConfiguration()
        DispatchQueue.global().async {
            captureSession.startRunning()
        }
        
    }
    
}



struct VideoPreviewView : UIViewRepresentable{
    let session : AVCaptureSession
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer{
                previewLayer.frame = uiView.bounds
            }
        }
    }
}

#Preview {
    HumanDetectionInCameraFeed()
}
