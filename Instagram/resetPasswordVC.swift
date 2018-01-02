//
//  resetPasswordVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController,UITextFieldDelegate,goBackDelegate {
 
    @IBOutlet weak var gradientImg: UIImageViewX!
    
    @IBOutlet weak var emailTxt: UITextField_Attributes!{didSet{emailTxt.delegate = self}}

    @IBOutlet weak var resetBtn: TransitionButton!
        {didSet{resetBtn.isHidden = true}}
    
    @IBOutlet weak var cancelBtn: UIButton_Attributes!{
didSet{self.cancelBtn.backDelegate = self}}

    @IBOutlet weak var distanceOfBtnAndTxtF: NSLayoutConstraint!
  {didSet{distanceOfBtnAndTxtF.constant = 0.0}}
    
    @IBOutlet weak var resetBtnHeight: NSLayoutConstraint!
{didSet{resetBtnHeight.constant = 0.0}}
    
   fileprivate var currentTextField: UITextField?
    
    fileprivate var currentColorArrayIndex = -1
    
    fileprivate var colorArray:[(color1:UIColor,color2:UIColor)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//add gradient colors on buttons
        initInputFirst()
  
       //create view gesture
        createViewGesture()
        
        //set image color set
        setColorArr()
        
        //recursively run animatedBackground()
        animatedBackground()
    }

//when users open this VC, the keyboard will appear at once
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
  //convert emailTxt to first responder
         createFirstResponder()
        
        //create observers
        setUpObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    deinit {
        //deallocate observers
        deallocateObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetBtn_click(_ sender: TransitionButton) {

 resetBtn.isEnabled = false
        
sender.startAnimation()
        
//request for reseting password
PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success:Bool, error:Error?) in
            
    if success{
            
    //show alert message
let alert = UIAlertController(title: "Email for reseting password", message: "has been sent to texted Email", preferredStyle: .alert)
                
    //if press OK call self.dismiss... function
   let ok = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    
     self.dismiss(animated: true, completion: nil)
})
           alert.addAction(ok)
        sender.stopAnimation(animationStyle: .normal, revertAfterDelay: 1, completion: {
   [unowned self] in
self.present(alert, animated: true, completion: nil)
        })
        self.resetBtn.isEnabled = true
        }
    else {
     sender.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
        [unowned self] in
        self.resetBtn.isEnabled = true})
        print(error ?? "")
    }
        }
    }
   
    @IBAction func emailTextFieldTap(_ sender: UITextField) {

        resetBtn.isHidden = (emailTxt.text?.isEmpty)!
        
        if resetBtn.isHidden{
        NotificationCenter.default.post(name: NSNotification.Name.init("didHidden"), object: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name.init("disHidden"), object: nil)
        }
    }
}//class over line

//custom functions
extension resetPasswordVC {

    fileprivate func createViewGesture(){
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    //convert emailTxt to first responder
    fileprivate func createFirstResponder(){
         emailTxt.becomeFirstResponder()
    }

    //add gradient colors on buttons
    fileprivate  func initInputFirst(){
       
        self.resetBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex: "FDFC47"), UIColor(hex: "24FE41")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0), gradientAnimation: CABasicAnimation())
        
        self.cancelBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex: "C02425"), UIColor(hex: "F0CB35")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0), gradientAnimation: CABasicAnimation())
    }
    
    //set image color set
    fileprivate func setColorArr(){
     colorArray.append(contentsOf: [(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),(color1: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),(color1: #colorLiteral(red: 0.01960784314, green: 0.4588235294, blue: 0.9019607843, alpha: 1), color2: #colorLiteral(red: 0.007843137255, green: 0.1058823529, blue: 0.4745098039, alpha: 1)),(color1: #colorLiteral(red: 0.168627451, green: 0.1960784314, blue: 0.6980392157, alpha: 1), color2: #colorLiteral(red: 0.3607843137, green: 0.1450980392, blue: 0.5529411765, alpha: 1))])
}
    
    //recursively run animatedBackground()
    fileprivate func animatedBackground(){
        
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        UIView.transition(with: gradientImg, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.gradientImg.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.gradientImg.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackground()
        }
    }
}

//custom functions selectors
extension resetPasswordVC{
    @objc fileprivate func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

//observers
extension resetPasswordVC{
    
    fileprivate func setUpObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didResetBtnHidden(argu:)), name: NSNotification.Name.init("didHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disResetBtnHidden(argu:)), name: NSNotification.Name.init("disHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(argu:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(argu:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func deallocateObservers(){
        
       NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension resetPasswordVC{
    
    @objc fileprivate func didResetBtnHidden(argu:Notification){
        self.distanceOfBtnAndTxtF.constant = 0.0
        self.resetBtnHeight.constant = 0.0
    }
    
    @objc fileprivate func disResetBtnHidden(argu:Notification){
        self.distanceOfBtnAndTxtF.constant = 58.0
        self.resetBtnHeight.constant = self.cancelBtn.bounds.size.height
    }
    
    @objc fileprivate func keyboardDidShow(argu:Notification){
        
        let info = argu.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        guard let editingTextField = currentTextField?.frame.origin.y else
        {return}
        
        if self.view.frame.origin.y >= 0{
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextField > keyboardY - 60{
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0.0, y: self.view.frame.origin.y - (editingTextField - (keyboardY - 60)), width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                }, completion: nil)
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(argu:Notification){
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }, completion: nil)
    }
}

//UITextFieldDelegate
extension resetPasswordVC{
    
    //get current textfield context
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    //the delegate or datasource function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxt.resignFirstResponder()
        return true
    }
}

extension resetPasswordVC{
    
    func goBackFromPage() {
        self.dismiss(animated: true, completion: nil)
    }
}







