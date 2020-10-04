//
//  ImagePicker.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import UIKit
import Firebase
struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown    : Bool
    @Binding var image      : UIImage?
    @Binding var userID    : String
    @EnvironmentObject var userData: UserData
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
       
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, image: $image, userID: $userData.userID)
          
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    func uploadImage() {
   
      
       
  
}
}
class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    @Binding var isShown    : Bool
    @Binding var image      : UIImage?
    @Binding var userID    : String
    init(isShown : Binding<Bool>, image: Binding<UIImage?>, userID: Binding<String>) {
        _isShown = isShown
        _image   = image
        _userID   = userID
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image =  uiImage
        isShown = false
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storage = Storage.storage().reference()
        storage.child(userID).putData(image!.jpegData(compressionQuality: 0.4)!, metadata: metadata) { meta, error in
            if let error = error {
                print(error)
                return
            }

           
        }
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
