//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Paul Colombier on 05/02/2020.
//  Copyright © 2020 Paul Colombier. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!

    var captureSession = AVCaptureSession()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get la caméra arrière pour capturer des vidéos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Impossible d'accéder à la caméra arrière de l'iPhone")
            return
        }
        
        do {
            // Get une 'instance' de la classe AVCaptureDeviceInput avec captureDevice.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set le input sur la captureSession.
            captureSession.addInput(input)
            
            // Initialisez un objet AVCaptureMetadataOutput et défini comme Output de la captureSession.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set le MetadataObjectsDelegate et utilise le dispatch par défaut pour exécuter le call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            print(error)
            return
        }
        
        // Initialise le videoPreviewLayer et l'ajoute en tant que sous-calque au calque de la vue viewPreview.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move le message label et la top bar sur le front
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)
        
        // Initialise la qrCodeFrameView pour highlight le QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper methods
    
    //Ajout des données liées au QrCode à la list
    func addData(objectData: Any) {
        var arrayData = [Any]()
        arrayData = UserDefaults.standard.array(forKey: "CodePromoArray") as? [[String: String]] ?? []
        arrayData.append(objectData)
        UserDefaults.standard.set(arrayData, forKey: "CodePromoArray")
    }

    //Lecture du QrCode -> popup
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        var objectData = [String: String]()
        switch decodedURL {
        case "1" :
            objectData = ["id": "1",
            "title": "Carrefour",
            "discount": "-10%",
            "endDate": "10/04/2020"]
        case "2":
            objectData = ["id": "2",
            "title": "Darty",
            "discount": "-20%",
            "endDate": "01/01/2021"]
        case "3":
            objectData = ["id": "3",
            "title": "McDonalds",
            "discount": "-15%",
            "endDate": "29/06/2020"]
        case "4":
            objectData = ["id": "4",
            "title": "Nike",
            "discount": "-5%",
            "endDate": "10/02/2020"]
        case "5":
            objectData = ["id": "5",
            "title": "Apple",
            "discount": "-10%",
            "endDate": "23/09/2020"]
        case "6":
            objectData = ["id": "6",
            "title": "Asus",
            "discount": "-30%",
            "endDate": "11/11/2020"]
        case "7":
            objectData = ["id": "7",
            "title": "Jules",
            "discount": "-20%",
            "endDate": "14/05/2020"]
        case "8":
            objectData = ["id": "8",
            "title": "Swarovski",
            "discount": "-10%",
            "endDate": "28/08/2020"]
        case "9":
            objectData = ["id": "8",
            "title": "Uniqlo",
            "discount": "-15%",
            "endDate": "19/04/2020"]
        case "10":
            objectData = ["id": "10",
            "title": "L'entrecôte",
            "discount": "-10%",
            "endDate": "01/03/2020"]
        default :
            //QrCode non connu de la bdd
            let alert = UIAlertController(title: "QrCode non reconnu", message: "Ce QrCode n'est pas reconnu comme code promotionnel par nos services.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "J'ai compris", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        
        // Demande si on ajoute le code promo à la liste
        let alertPrompt = UIAlertController(title: "Un QrCode a été détecté !", message: "Voulez-vous ajouter le QrCode id: \(decodedURL) ?", preferredStyle: .actionSheet)
        
        // Si Confirmation alors
        let confirmAction = UIAlertAction(title: "Ajouter", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            self.addData(objectData: objectData)
        })
        // Si annulation
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    layer.videoOrientation = orientation
    videoPreviewLayer?.frame = self.view.bounds
    }

    // Gestion orientation caméra
    override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if let connection =  self.videoPreviewLayer?.connection  {
      let currentDevice: UIDevice = UIDevice.current
      let orientation: UIDeviceOrientation = currentDevice.orientation
      let previewLayerConnection : AVCaptureConnection = connection
      
      if previewLayerConnection.isVideoOrientationSupported {
        switch (orientation) {
        case .portrait:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .landscapeRight:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .landscapeLeft:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .portraitUpsideDown:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        default:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        }
      }
    }
    }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check si le metadataObjects array n'est pas null et contient au moins un objet.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Pas de QR Code détecté"
            return
        }
        
        // Get le metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // Si les métadonnées trouvées sont égales aux métadonnées du code QR, mettre à jour le texte de l'étiquette d'état et définissez les limites
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
