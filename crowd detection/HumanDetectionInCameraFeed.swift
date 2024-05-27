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
        
        // MARK: - Entire Screen
        ZStack{
            // Set the background color for the entire screen
            Color(Color.darkGrey).edgesIgnoringSafeArea(.all)
            
            // MARK: - All Content
            VStack{
                
                // camera container
                VStack{
                    // camera gray container
                    ZStack{
                        Color.grey
                            .cornerRadius(22)
                            .shadow(radius: 5)
                        
                        // camera container
                        VStack{
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
                        }
                        .padding(30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                .frame(width: 750, height: 750)
                .padding(.horizontal,30)
                
                VStack {
                    HStack (alignment: .top){
                        
                        VStack{
                            // alert container
                            VStack{
                                ZStack{
                                    Color.grey
                                        .cornerRadius(22)
                                        .shadow(radius: 5)
                                    
                                    // alert vstack
                                    VStack{
                                        //alert and more
                                        HStack{
                                            Text("Alerts")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                            
                                            Spacer()
                                            
                                            Text("more")
                                                .font(.title3)
                                                .foregroundColor(Color.white)
                                            Image(systemName: "chevron.right")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                            
                                            
                                        }
                                        //                            .padding(.horizontal)
                                        
                                        // alert desc container
                                        VStack{
                                            ZStack{
                                                (captureDelegate.peopleCount > 4 ? Color.uiPink : Color.lightgreen)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 5)
                                                
                                                HStack{
                                                    Text(captureDelegate.peopleCount > 4 ? "High crowd density detected!":"Not crowded")
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(captureDelegate.peopleCount > 4 ? Color.maroon : Color.darkGreen)
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: captureDelegate.peopleCount > 4 ? "bell.fill" : "checkmark.circle.fill")
                                                        .font(.title3)
                                                        .foregroundColor(captureDelegate.peopleCount > 4 ? Color.maroon : Color.darkGreen)
                                                }
                                                .padding(.horizontal, 30)
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        //                            .padding(.horizontal)
                                        
                                        
                                    }.padding()
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.leading)
                            }
                            .frame(width: 500, height: 130)
                            
                            VStack{
                                
                                
                                
                                HStack{
                                    VStack{
                                        ZStack{
//                                            Color.yellowcolor
//                                                .cornerRadius(17)
//                                                .shadow(radius: 5)
                                            
                                            RoundedRectangle(cornerRadius: 17)
                                                                .stroke(Color.yellowcolor, lineWidth: 2)
                                            
                                            Text("change car number")
                                                .font(.title3)
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(.yellowcolor)
                                                
                                        }
                                        
                                    }
                                    .padding(.trailing)
                                    
                                    
                                    
                                    VStack{
                                        ZStack{
                                            Color.lightPurple
                                                .cornerRadius(17)
                                                .shadow(radius: 5)
                                            
                                            Text("open dashboard")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                        }
                                        
                                    }
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.leading)
                            .padding(.top)
                        }
                        
                        
                        
                        
                        
                        // count container
                        VStack{
                            ZStack{
                                Color.grey
                                    .cornerRadius(22)
                                    .shadow(radius: 5)
                                
                                
                                //count contents
                                VStack{
                                    Text("Passenger Count")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    
                                    
                                    Text("\(captureDelegate.peopleCount)")
                                        .font(.custom("String", fixedSize: 70))
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .onAppear{
                                            setupCaptureSession()
                                        }
                                        .onDisappear{
                                            captureSession.stopRunning()
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.horizontal)
                        }
                        .frame(width:250, height: 200)
                    }
                }
                .frame(width: 750,height: 200)
                .padding(.horizontal,30)
                
                
                
                
                
                
                
                
                // Count container
                //                Text("Human Detected: \(captureDelegate.peopleCount)")
                //                    .font(.title)
                //                    .padding()
                //                    .foregroundColor(Color.white)
                //                    .onAppear{
                //                        setupCaptureSession()
                //                    }
                //                    .onDisappear{
                //                        captureSession.stopRunning()
                //                    }
            }
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
