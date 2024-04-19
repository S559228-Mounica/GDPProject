 
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickOnLogin(_ sender: Any) {
        
        let email = emailTxt.text!.lowercased()
        
        
        if(!isValidEmail(testStr: email)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return
        }
        
        if(passwordTxt.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
            return
        }
                
        if( email == Constant.Super_ADMIN_EMAIL) {
            
            if(passwordTxt.text! != Constant.Super_ADMIN_PASS) {
                self.showAlert(message: AlertMessages.WrongPassword)
            }else {
                
                UserDefaultsManager.shared.saveData(documentID: "Head", name: Constant.Super_ADMIN_Name, email: Constant.Super_ADMIN_EMAIL, userType: UserType.SUPER_ADMIN.rawValue,department: "X" , course: "X")
                SceneDelegate.shared?.checkLogin()
            }
        }else {

            FireStoreManager.shared.login(email: email, password: self.passwordTxt.text!)
        }
              
    }
    

    func showSessionExpireAlert() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert(message:  "Session expired")
        }
        
    }
    
    func setLockImage() {
        
        self.passwordTxt.isSecureTextEntry =  !self.passwordTxt.isSecureTextEntry
        
        if(self.passwordTxt.isSecureTextEntry) {
            self.lockBtn.setImage(UIImage(systemName: "lock"), for: .normal)
        }else {
            self.lockBtn.setImage(UIImage(systemName: "lock.open"), for: .normal)
        }
    }
   
    @IBAction func clickOnLockUnlock(_ sender: Any) {
        
        setLockImage()
    }
}
