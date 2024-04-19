import UIKit

class AdminAccountVC: UIViewController {
   
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var departmentTxt: UITextField!
    var picker = PickerView()
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
   }

    
    @IBAction func clickOnDepartment(_ sender: Any) {
        
        let departmentList = Array(courses.keys)
        self.picker.stringArray = departmentList
        
        self.picker.modalPresentationStyle = .overCurrentContext
        self.picker.onDone = { [self] index in
        self.departmentTxt.text =  picker.stringArray[index]
        }
        self.present(self.picker, animated: true, completion: nil)
        
    }

    
    @IBAction func clickOnCreate(_ sender: Any) {
        self.view.endEditing(true)
        if(self.validate()) {
            
            let password = generateRandomPassword()
            FireStoreManager.shared.signUp(userType: .ADMIN, name: self.nameTxt.text!, email:  self.emailTxt.text!, password: password , department: self.departmentTxt.text!, course: "")
        
    }
    
}
    
    func validate() ->Bool {
        
        if(self.nameTxt.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter nameTxt.")
            return false
        }
        
        if !(self.nameTxt.text!.isValidName) {
            showAlertAnyWhere(message: "Please enter valid nameTxt.")
            return false
        }
        
        if(!isValidEmail(testStr: emailTxt.text!)) {
             showAlertAnyWhere(message: "Please enter valid emailTxt.")
            return false
        }
        
        
        if(self.departmentTxt.text!.isEmpty) {
             showAlertAnyWhere(message: "Please select departmentTxt")
            return false
        }
        
        return true
    }
}


 
