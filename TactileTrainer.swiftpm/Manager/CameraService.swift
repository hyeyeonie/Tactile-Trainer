//
//  CameraService.swift
//  TactileTrainer
//
//  Created by 신혜연 on 2/27/26.
//

import AVFoundation
import UIKit

class CameraService: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    var onPhotoTaken: ((UIImage) -> Void)?

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.setupSession() }
            }
        default: break
        }
    }

    private func setupSession() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            session.startRunning()
        } catch {
            print("카메라 설정 오류: \(error)")
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        onPhotoTaken?(image)
    }
}
