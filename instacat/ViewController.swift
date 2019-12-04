//
//  ViewController.swift
//  instacat
//
//  Created by mbtec22 on 11/19/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    

    @IBOutlet weak var LoginInfoLabel: UILabel!
    @IBOutlet weak var LogoutButtom: UIBarButtonItem!
    @IBOutlet weak var LoginButton: UIBarButtonItem!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var customImageFlowLayout: CustomImageFlowLayout!
    var images = [CatInsta]()
    
    var dbRef: DatabaseReference!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        dbRef = Database.database().reference().child("images")
        loadDB()
        
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
        
        
    }
    
    func loadDB(){
        dbRef.observe(DataEventType.value, with: {(snapshot) in
            var newImages = [CatInsta]()
            for catInstaSnapshot in snapshot.children{
                let catInstaObject = CatInsta(snapshot: catInstaSnapshot as! DataSnapshot)
                newImages.append(catInstaObject)
            }
            self.images = newImages
            self.imageCollection.reloadData()
                })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.LoginButton.isEnabled = false
            self.LogoutButtom.isEnabled = true
            self.LoginInfoLabel.text = "Hello " + (Auth.auth().currentUser?.email)!
            
        }else{
            self.LoginButton.isEnabled = true
            self.LogoutButtom.isEnabled = false
            self.LoginInfoLabel.text = "Hola inicie sesion porfavor"
        }
    }
    
    @IBAction func LogoutButtonClick(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            do {
                try Auth.auth().signOut()
                self.LoginButton.isEnabled = true
                self.LogoutButtom.isEnabled = false
                self.LoginInfoLabel.text = "Hola inicie sesion porfavor"
            }catch let signOutError as NSError{
                print("Error signing out : @",signOutError)
            }
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        let image = images[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "image1"))
        return cell
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            var data = Data()
            data = pickedImage.jpegData(compressionQuality: 0.8)!
            
            let imageRef = Storage.storage().reference().child("images/" + randomString(20));
            
            _ = imageRef.putData(data, metadata: nil){ (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                let downloadURL = metadata.storageReference
                print(downloadURL?.debugDescription as Any)
                
                let key = self.dbRef.childByAutoId().key
                let image = ["url": downloadURL?.debugDescription]
                
                let childUpdates = ["/\(key)": image]
                self.dbRef.updateChildValues(childUpdates)
                
            }
        }
        
    }
    
    
    @IBAction func loadImageButtomClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func randomString(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return  randomString
    }
    
    
}

