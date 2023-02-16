//
//  ImagePicker.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/12/22.
// https://www.youtube.com/watch?v=a05eLxsbCCw
// https://medium.com/swlh/how-to-open-the-camera-and-photo-library-in-swiftui-9693f9d4586b


import Foundation
import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}

//
//struct ImagePicker : UIViewControllerRepresentable {
//
//    @Binding var selectedImage: UIImage?
//    @Binding var isPickerShowing: Bool
//    @Environment(\.presentationMode) var isPresented
//    var sourceType: UIImagePickerController.SourceType
//
//
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary //can change to camera
//        imagePicker.delegate = context.coordinator  //calls a method to pass the photo selected
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//}
//
//class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //reciever to get image
//
//    var parent: ImagePicker
//
//    init(_ picker: ImagePicker){
//        self.parent = picker
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        //run code when user has canceled picker ui
//        print("image canceled")
//        parent.isPickerShowing = false
//
//
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        //run code when user has selected an image
//        print("image selected")
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            //we got the image
//            DispatchQueue.main.async{
//                self.parent.selectedImage = image
//            }
//        }
//        //dismiss picker
//        parent.isPickerShowing = false
//    }
//}
