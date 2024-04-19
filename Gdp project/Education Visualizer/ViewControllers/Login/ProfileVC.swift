
import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var loginTypeLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderWidth = 1.0
            userImageView.layer.borderColor = AppColors.primary.cgColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        nameTxt.text = UserDefaultsManager.shared.getName()
        emailTxt.text = UserDefaultsManager.shared.getEmail()
        
        switch UserDefaultsManager.shared.getUserType() {
        case .SUPER_ADMIN:
            loginTypeLbl.text = "Super Admin"
        default:
            loginTypeLbl.text = UserDefaultsManager.shared.getUserType().rawValue.capitalized
        }
    }
    
    
    
    
    @IBAction func clickOnLogout(_ sender: Any) {
        UserDefaultsManager.shared.clearUserDefaults()
        SceneDelegate.shared!.checkLogin()
    }
    
}
