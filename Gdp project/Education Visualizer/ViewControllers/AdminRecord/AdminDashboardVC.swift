

import UIKit

class AdminDashboardVC: UIViewController {
    
    @IBAction func clickOnVisualization(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VisualizationRecordVC") as! VisualizationRecordVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
