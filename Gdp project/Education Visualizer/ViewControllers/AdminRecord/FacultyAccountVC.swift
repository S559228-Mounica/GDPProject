import UIKit

class FacultyAccountVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var courseLbl: UILabel!
    var checkboxDialogVC : CheckboxDialogViewController!
    var selectedValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickOnSignup(_ sender: Any) {
        
        self.view.endEditing(true)
        if(self.validate()) {
            
            
            let selectedValuesString: String
            if selectedValues.count == 1 {
                selectedValuesString = selectedValues[0]
            } else {
                selectedValuesString = selectedValues.joined(separator: ",")
            }
            
            
            let password = generateRandomPassword()
            let department = UserDefaultsManager.shared.getDepartment()
            
            FireStoreManager.shared.signUp(userType: .FACULTY, name: self.nameTxt.text!, email:  self.emailTxt.text!, password: password , department: department, course: selectedValuesString)
            
        }
        
    }
    
    
    func validate() ->Bool {
        
        if(self.nameTxt.text!.isEmpty) {
            showAlertAnyWhere(message: "Please enter name.")
            return false
        }
        
        if !(self.nameTxt.text!.isValidName) {
            showAlertAnyWhere(message: "Please enter valid name.")
            return false
        }
        
        
        if(!isValidEmail(testStr: emailTxt.text!)) {
            showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
        
        if(self.courseLbl.text!.isEmpty || self.courseLbl.text == "Select Courses") {
            showAlertAnyWhere(message: "Please select course.")
            return false
        }
        
        return true
    }
    
    @IBAction func clickOnCourses(_ sender: Any) {
        let department = UserDefaultsManager.shared.getDepartment()
        
        guard let departmentCourses = courses[department] else {
            
            return
        }
        
        var tableData: [(name: String, translated: String)] = []
        
        for course in departmentCourses {
            tableData.append((course, course))
        }
        
        self.checkboxDialogVC = CheckboxDialogViewController()
        self.checkboxDialogVC.titleDialog = "Courses"
        self.checkboxDialogVC.tableData = tableData
        self.checkboxDialogVC.componentName = DialogCheckboxViewEnum.courses
        self.checkboxDialogVC.componentName = DialogCheckboxViewEnum.courses
        self.checkboxDialogVC.delegateDialogTableView = self
        self.checkboxDialogVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogVC, animated: false, completion: nil)
    }
    
}


extension FacultyAccountVC:CheckboxDialogViewDelegate {
    
    
    func pickerValueChanged(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        
        self.selectedValues = values.map{$0.value}
        for item in values {
            self.courseLbl.text! +=  " \(item.value)"
        }
        
    }
}


