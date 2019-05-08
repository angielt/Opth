//
//  SearchToCardViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/8/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SearchToCardViewController: UIViewController {
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //parse.csv(data: "/Users/cathyhsieh/Desktop/temp.txt")
        
        self.loadData()
    }
    
    func loadData(){
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
    }
    
    func newListCardChange(){
        cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
    }
    
    @IBAction func handleTap(_ sender: Any) {
        if(spacedRep.finished == true){
            self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
        }
            
        else if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil"){
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
        }
        else {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageCardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if(spacedRep.curReviewIndex < spacedRep.reviewList.count ){
                //self.present(viewController, animated: true, completion: nil)
                if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil") {
                    self.performSegue(withIdentifier: "searchReveal", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "searchRevealImage", sender: nil)
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
                    spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
                    //                    print("spaced rep index" + String(spacedRep.curReviewIndex) + String(spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName))
                    self.loadData() // loads data for next card
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

extension SearchToCardViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}

