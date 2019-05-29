//
//  ViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/14/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

// view controller of card front
class ViewController: UIViewController{

    static let cardCornerRadius: CGFloat = 25

    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacedRep.all_active = false
        self.loadData()
    }
    
    func loadData(){
        backButton.isHidden = false
        if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
            cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
            
            card.layer.cornerRadius = 4.0
            card.layer.borderWidth = 1.0
            card.layer.borderColor = UIColor.clear.cgColor
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.gray.cgColor
            card.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            card.layer.shadowRadius = 4.0
            card.layer.shadowOpacity = 1.0
            card.layer.masksToBounds = false
            card.layer.shadowPath = UIBezierPath(roundedRect: card.bounds, cornerRadius: card.layer.cornerRadius).cgPath
        }
    }
    
    func exitCardChange(){
        card.layer.backgroundColor = UIColor.black.cgColor
        cardFront.text = "Review Finished - tap to exit"
        cardFront.textColor = UIColor.gray
        backButton.isHidden = true
    }
    
    func newListCardChange(){
        cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
    }
    
    @IBAction func handleTap(_ sender: Any) {
        var loadData = false
        
        if(spacedRep.finished == true){
            spacedRep.finished = false
            print("item repeat factor")
            for item in spacedRep.reviewList{
                print(item.repeat_factor)
            }
            
            self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
        }
        else if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil"){
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
            loadData = true
        }
        else {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageCardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
            loadData = true
        }
        if (loadData == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                if(spacedRep.curReviewIndex < spacedRep.reviewList.count ){
                    if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil") {
                        self.performSegue(withIdentifier: "reveal", sender: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "revealImage", sender: nil)
                    }
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
                        spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
                        self.loadData()
                        if(spacedRep.curReviewIndex == spacedRep.reviewList.count){
                            spacedRep.curReviewIndex = spacedRep.curReviewIndex - 1
                            spacedRep.finished = true
                            self.exitCardChange()
                        }
                    }
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reveal",
            let destinationViewController = segue.destination as? CardRevealViewController {
                destinationViewController.transitioningDelegate = self
            // delay changes to current VC until after  flip animation
        }
        else if segue.identifier == "revealImage",
            let destinationViewController = segue.destination as? ImageCardRevealViewController {
            destinationViewController.transitioningDelegate = self
            // delay changes to current VC until after  flip animation
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}
