//
//  signUpVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate {
   
 @IBOutlet weak var gradientImgView: UIImageViewX!
    
    @IBOutlet weak var avaImg: UIImageView!
 
@IBOutlet var allTextFieldsInScreen: [UITextField_Attributes]!
{didSet{_ = self.allTextFieldsInScreen.map{$0.delegate = self}}}
 
    @IBOutlet var allCountTip: [UILabel]!

    @IBOutlet var allTipLabelsInScreen: [UILabel]!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    fileprivate var currentColorArrayIndex = -1
    
    fileprivate var currentTextField:UITextField!
    
    fileprivate var colorArray:[(color1:UIColor,color2:UIColor)] = []
    
    fileprivate var tempString = ""
    
    fileprivate var tempCount = 0
    
   fileprivate var picker = UIImagePickerController()
     {didSet{self.picker.delegate = self}}
   
    fileprivate var endTextField:UITextField!
    
    fileprivate let rootLayer:CALayer = {
        let rootLayer = CALayer()
        rootLayer.backgroundColor = UIColor.black.cgColor
        return rootLayer
    }()
    
    fileprivate let views = UIView()
    
fileprivate let replicatorLayer:CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: -22, y: -5, width: 20, height: 20)
        replicatorLayer.borderColor = UIColor.clear.cgColor
        replicatorLayer.cornerRadius = 5.0
        replicatorLayer.borderWidth = 1.0
    replicatorLayer.instanceCount = 9
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(-CGFloat.pi * 2 / CGFloat(9), 0, 0, 1)
        return replicatorLayer
    }()
    
  fileprivate let circle:CALayer = {
        let circle = CALayer()
        circle.frame = CGRect(origin: CGPoint.zero,size: CGSize(width: 7, height: 7))
        circle.backgroundColor = UIColor.blue.cgColor
        circle.cornerRadius = 5
        return circle
    }()
    
   fileprivate let shrinkAnimation:CABasicAnimation = {
        let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
        shrinkAnimation.fromValue = 1
        shrinkAnimation.toValue = 0.1
        shrinkAnimation.duration = 0.5
        shrinkAnimation.repeatCount = Float.infinity
        return shrinkAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
       
        //set tip texts to red
        setTipTextRed()
        
        //create tap gesture
        createScreenDismissKeyboard()
        
        //set count label attributes
        setCountLabelAttributes()
        
        //ava image layer
        setAvaImgLayer()
        
        //declare select image
        declareSelectedImage()
 
        //initialize text fields false isEnable input
        initInputFirst()
        
        //set text fields right views
        setRightViews()
        
        //set image color set
        setColorArr()
        
        //recursively run animatedBackground()
        animatedBackground()
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       //create observers
        createObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
      //remove observers
        removeObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //click sign up
    @IBAction func signUpBtn_click(_ sender: UIButton) {
 
        //dismiss keyboard
   self.view.endEditing(true)
        
//send data to server to relative columns
let user = PFUser()
user.username = allTextFieldsInScreen[0].text?.lowercased()
user.email = allTextFieldsInScreen[4].text?.lowercased()
user.password = allTextFieldsInScreen[2].text
user["fullname"] = allTextFieldsInScreen[1].text?.lowercased()
user["bio"] = allTextFieldsInScreen[6].text
user["web"] = allTextFieldsInScreen[5].text?.lowercased()
        
        //in Edited Profile it's gonna be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        //convert our image for sending to server
          guard let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5),let avaFile = PFFile(name: "ava.jpg", data: avaData) else {return}
     
     user["ava"] = avaFile
      
//save data in server
user.signUpInBackground { (success:Bool, error:Error?) in
            if success{
                
    //remember logged user
    UserDefaults.standard.set(user.username, forKey: "username")
    UserDefaults.standard.synchronize()
               
    //call login func from AppleDelegate.swift class
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.login()
            }else{print(error ?? "")}
        }
    }
   
    //click cancel
    @IBAction func cancelBtn_click(_ sender: Any) {
        
    self.dismiss(animated: true, completion: nil)
    }
}//signUpVC class over line

//custom functions
extension signUpVC {
    
    fileprivate func setTipTextRed(){
      _ = allTipLabelsInScreen.map{$0.textColor = .red}
}
    
    fileprivate func setRightViews(){
       
        _ = allTextFieldsInScreen.map{
            $0.rightView?.frame = CGRect(x: 0, y: 0, width: 30 , height:30)
            $0.rightViewMode = .never
        }
    }
    
    fileprivate func createScreenDismissKeyboard(){
        let gestrue = UITapGestureRecognizer.init(target: self, action: #selector(tapGestrue))
        self.view.addGestureRecognizer(gestrue)
    }
    
    fileprivate func setCountLabelAttributes(){
_ = allCountTip.map{
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 3
}
}
    
    fileprivate  func setAvaImgLayer(){
        
        //round ava
avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        
        //clip image
        avaImg.clipsToBounds = true
        avaImg.layer.borderWidth = 3
        avaImg.layer.borderColor = UIColor.white.cgColor
    }
    
    //initialize text fields false isEnable input
 fileprivate func initInputFirst(){
    
    signUpBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex:"dE6161"),UIColor(hex:"2657EB")], locations: [0.0, 0.5, 1.0], stP: CGPoint(x:0.0,y:0.0), edP: CGPoint(x:1.0,y:0.0), gradientAnimation: CABasicAnimation())
    
    cancelBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex: "FC5C7D"), UIColor(hex: "6A82FB")], locations:[0.0,1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0), gradientAnimation: CABasicAnimation())
    }
    
    //declare select image
 fileprivate func declareSelectedImage(){
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true //user can click image
        avaImg.addGestureRecognizer(avaTap)
    }
    
     //set image color set
    fileprivate func setColorArr(){
colorArray.append(contentsOf: [(color1: #colorLiteral(red: 0.2039215686, green: 0.9098039216, blue: 0.6196078431, alpha: 1), color2: #colorLiteral(red: 0.05882352941, green: 0.2039215686, blue: 0.262745098, alpha: 1)),(color1: #colorLiteral(red: 0.03529411765, green: 0.2117647059, blue: 0.2156862745, alpha: 1), color2: #colorLiteral(red: 0.2666666667, green: 0.6274509804, blue: 0.5529411765, alpha: 1)),(color1: #colorLiteral(red: 0.4039215686, green: 0.6980392157, blue: 0.4352941176, alpha: 1), color2: #colorLiteral(red: 0.2980392157, green: 0.6352941176, blue: 0.8039215686, alpha: 1)),(color1: #colorLiteral(red: 0, green: 0.7647058824, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 1, blue: 0.1098039216, alpha: 1)),(color1: #colorLiteral(red: 0.968627451, green: 0.6156862745, blue: 0, alpha: 1), color2: #colorLiteral(red: 0.3921568627, green: 0.9529411765, blue: 0.5490196078, alpha: 1))])
}
    
    //recursively run animatedBackground()
    fileprivate func animatedBackground(){
        
currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
UIView.transition(with: gradientImgView, duration: 2, options: [.transitionCrossDissolve], animations: {
self.gradientImgView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
self.gradientImgView.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackground()
        }
    }
    
fileprivate func setCountTip(with someoneCount:UILabel,someoneLimitCount:UILabel){
 
currentTextField.rightViewMode = .never
tempCount = (currentTextField.text?.count)!
if tempCount == 0{
someoneCount.textColor = UIColor.red
}else{someoneCount.textColor = someoneLimitCount.textColor}
if tempCount == Int(someoneLimitCount.text!)!{
someoneCount.text = someoneLimitCount.text
tempString = currentTextField.text!
}else if tempCount > Int(someoneLimitCount.text!)!{
someoneCount.text = someoneLimitCount.text
currentTextField.text = tempString
}else {someoneCount.text = "\(tempCount)"}
}
    
   fileprivate func progressIndicator(){
    
replicatorLayer.addSublayer(circle)
circle.removeAllAnimations()
circle.add(shrinkAnimation, forKey: nil)
replicatorLayer.instanceDelay = shrinkAnimation.duration / CFTimeInterval(9)
rootLayer.addSublayer(replicatorLayer)
    }
    
}

//custom functions selectors
extension signUpVC{
    
    @objc fileprivate func tapGestrue(){
        self.view.endEditing(true)
    }
    
    //choose the photo from the phone library
@objc fileprivate func loadImg(recognizer:UITapGestureRecognizer){
        
        //picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

//observers
extension signUpVC{
    
    fileprivate func createObservers(){
        
NotificationCenter.default.addObserver(self, selector: #selector(setCountTip(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
NotificationCenter.default.addObserver(self, selector: #selector(checkText(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
    }
    
    fileprivate func removeObservers(){
        NotificationCenter.default.removeObserver(self)
 }
}

//observers selectors
extension signUpVC{
    
@objc fileprivate func setCountTip(_:Notification){
        
_ = [10,20,30,40,70].enumerated().map{ (offset,element) in
    
    if element == currentTextField.tag{
setCountTip(with: allCountTip[offset * 2], someoneLimitCount: allCountTip[offset * 2 + 1])
       }
  }
}
    
    @objc fileprivate func checkText(_:Notification){
progressIndicator()
self.views.layer.addSublayer(rootLayer)
        
endTextField.rightView = self.views
endTextField.rightViewMode = .always
if endTextField.tag == 10 {
    guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
   allTipLabelsInScreen[0].text = "username can't be nil"
        return
    }
    
guard Validate.username((endTextField?.text)!).isRight else {
    allTipLabelsInScreen[0].text = "username can only include letters,numbers,dot,underline"
    return
    }
    
    let query = PFQuery.init(className: "_User")
    query.whereKey("username", equalTo: endTextField.text!)
    query.findObjectsInBackground(block: { (objects, error) in
        if error == nil{
            if objects!.count > 0{
DispatchQueue.main.async{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
self.allTipLabelsInScreen[0].text = "username has been taken"}
} else {
DispatchQueue.main.async{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always}
            }
        }else {print(error!.localizedDescription)}
    })
}

        if endTextField.tag == 20 {
guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
allTipLabelsInScreen[1].text = "fullname can't be nil"
   return
}
            
guard Validate.fullname((endTextField?.text)!).isRight else {
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
allTipLabelsInScreen[1].text = "fullname can only include letters,numbers,dot,underline"
    return
}
            
let query = PFQuery.init(className: "_User")
query.whereKey("fullname", equalTo: endTextField.text!)
query.findObjectsInBackground(block: { (objects, error) in
if error == nil{
    if objects!.count > 0{
DispatchQueue.main.async{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
self.allTipLabelsInScreen[1].text = "fullname has been taken"}
} else {
DispatchQueue.main.async{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always}}
}else {print(error!.localizedDescription)}
})
}
        
    if endTextField.tag == 30{
guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
allTipLabelsInScreen[2].text = "password can't be nil"
    return
}
        
guard Validate.password((endTextField?.text)!).isRight else {
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
    self.endTextField.rightViewMode = .always
allTipLabelsInScreen[2].text = "password can only include letters,numbers"
    return
    }
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always
}
        
if endTextField.tag == 40{
 
guard endTextField.text != "" else{
     endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
  endTextField.rightViewMode = .always
allTipLabelsInScreen[3].text = "repeat must be done"
        return
    }
    
if endTextField.text != allTextFieldsInScreen[2].text{
    self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
    self.endTextField.rightViewMode = .always
allTipLabelsInScreen[3].text = "Twice inputs is not same"
}else {self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
    self.endTextField.rightViewMode = .always
    }
}
    
    if endTextField.tag == 50{
guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
allTipLabelsInScreen[4].text = "email can't be nil"
return
}
        
guard Validate.email((endTextField?.text)!).isRight else{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
allTipLabelsInScreen[4].text = "email scheme must 4-7 words, and 2-3 letters after dot"
    return
}
            
let query = PFQuery.init(className: "_User")
query.whereKey("email", equalTo: endTextField.text!)
query.findObjectsInBackground(block: { (objects, error) in
if error == nil{
if objects!.count > 0{
DispatchQueue.main.async {
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
self.allTipLabelsInScreen[4].text = "email has been taken"
}
} else {
DispatchQueue.main.async {
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always}}
}else {print(error!.localizedDescription)}
})
}
       
        if endTextField.tag == 60{
guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
allTipLabelsInScreen[5].text = "web can't be nil"
return
}
guard Validate.URL((endTextField?.text)!).isRight else{
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
self.endTextField.rightViewMode = .always
allTipLabelsInScreen[5].text = "URL format is www.xxxxx.xxx, and xxx must 2-3 letters"
    return
}
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always
}
        
  if endTextField.tag == 70{
    guard endTextField.text != "" else{
endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
endTextField.rightViewMode = .always
allTipLabelsInScreen[6].text = "bio can't be nil"
               return
    }
    
self.endTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
self.endTextField.rightViewMode = .always
        }
    }
}

//UITextFieldDelegate
extension signUpVC{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
textField.rightViewMode = .never
 allTipLabelsInScreen[textField.tag / 10 - 1].text = ""
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        endTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
_ = allTextFieldsInScreen.map{ $0.resignFirstResponder()}
        
        return true
    }
}

//UIImagePickerControllerDelegate
extension signUpVC{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

//UIScrollViewDelegate
extension signUpVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
let verticalIndicator = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
verticalIndicator.backgroundColor = UIColor.orange
    }
    
}

