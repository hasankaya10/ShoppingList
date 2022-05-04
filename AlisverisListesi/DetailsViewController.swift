//
//  DetailsViewController.swift
//  AlisverisListesi
//
//  Created by Hasan Kaya on 6.04.2022.
//

import UIKit
import CoreData
class DetailsViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var secilenUrunIsmi = ""
    var secilenUrunUUID : UUID?

    @IBOutlet weak var KaydetButonu: UIButton!
    @IBOutlet weak var fiyatTextfield: UITextField!
    @IBOutlet weak var markaTextfield: UITextField!
    @IBOutlet weak var isimTextfield: UITextField!
    @IBOutlet weak var UrunGorsel: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if secilenUrunIsmi != "" {
            KaydetButonu.isHidden = true
            if let uuidString = secilenUrunUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchRequest)
                    if sonuclar.count > 0 {
                        for sonuc in sonuclar as! [NSManagedObject] {
                            if let isim = sonuc.value(forKey: "isim") as? String {
                                isimTextfield.text = isim
                            }
                            if let marka = sonuc.value(forKey: "marka") as? String {
                                markaTextfield.text = marka
                            }
                            if let gorselData = sonuc.value(forKey: "gorsel") as? Data {
                                let image  = UIImage(data: gorselData)
                                UrunGorsel.image = image
                            }
                            if let fiyat = sonuc.value(forKey: "fiyat") as? Int {
                                fiyatTextfield.text = String(fiyat)
                            }
                            
                        }
                    }
                } catch  {
                    
                }
                
                
                
                
                
                
            }
        
        } else {
            KaydetButonu.isHidden = false
            KaydetButonu.isEnabled = false
            isimTextfield.text = ""
            fiyatTextfield.text = ""
            markaTextfield.text = ""
        }
        
        
        
        
        
        
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)
        UrunGorsel.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        UrunGorsel.addGestureRecognizer(imageGestureRecognizer)
    }
   
    @objc func gorselSec(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UrunGorsel.image = info[.editedImage] as? UIImage
        KaydetButonu.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func klavyeyiKapat(){
        view.endEditing(true)
        
    }
    
    @IBAction func kaydetButonu(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let alisveris = NSEntityDescription.insertNewObject(forEntityName: "Alisveris", into: context)
        alisveris.setValue( isimTextfield.text!, forKey: "isim")
        alisveris.setValue( markaTextfield.text!, forKey: "marka")
        if let fiyat = Int(fiyatTextfield.text!){
            alisveris.setValue(fiyat, forKey: "fiyat")
        }
        alisveris.setValue(UUID(), forKey: "id")
        let data = UrunGorsel.image!.jpegData(compressionQuality: 0.5)
        alisveris.setValue(data, forKey: "gorsel")
        do {
            try context.save()
            print("kayıt edildi")
        } catch  {
            print("hata var")
        }
        NotificationCenter.default.post(name: NSNotification.Name("veriGirildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
        
        
        
        
    }
    
}
