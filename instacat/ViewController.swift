//
//  ViewController.swift
//  instacat
//
//  Created by mbtec22 on 11/19/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
    
class ViewController: UIViewController, UICollectionViewDataSource {
    
    

    @IBOutlet weak var LoginInfoLabel: UILabel!
    @IBOutlet weak var LogoutButtom: UIBarButtonItem!
    @IBOutlet weak var LoginButton: UIBarButtonItem!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var customImageFlowLayout: CustomImageFlowLayout!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
        
        
    }
    
    func loadImages(){
        images.append(UIImage(named: "image1")!)
        images.append(UIImage(named: "image1")!)
        images.append(UIImage(named: "image1")!)
        images.append(UIImage(named: "image1")!)
        images.append(UIImage(named: "image1")!)
        images.append(UIImage(named: "image1")!)
        self.imageCollection.reloadData()
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
        cell.imageView.image = image;
        return cell
    }
    

}

