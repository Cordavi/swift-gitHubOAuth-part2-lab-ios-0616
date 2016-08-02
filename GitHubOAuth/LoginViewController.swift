//
//  LoginViewController.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

class LoginViewController: UIViewController {
   
   @IBOutlet weak var loginImageView: UIImageView!
   @IBOutlet weak var loginButton: UIButton!
   @IBOutlet weak var imageBackgroundView: UIView!
   
   let numberOfOctocatImages = 10
   var octocatImages: [UIImage] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpImageViewAnimation()
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: Notification.closeSafariVC, object: nil)
   }
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      if imageBackgroundView.layer.cornerRadius == 0 {
         configureButton()
      }
   }
   
   
   @IBAction func loginButtonTapped(sender: UIButton) {
      let gitHubOauthURL = NSURL(string: GitHubAPIClient.URLRouter.oauth)
      if let gitHubOauthURL = gitHubOauthURL {
         let gitHubOauth = SFSafariViewController(URL: gitHubOauthURL)
         presentViewController(gitHubOauth, animated: true, completion: nil)
      }
   }
   
   func safariLogin(notification: NSNotification) {
      if let accessCodeURL = notification.object as? NSURL {
         GitHubAPIClient.startAccessTokenRequest(url: accessCodeURL, completionHandler: { response in
            print(response)
         })
      }
      dismissViewControllerAnimated(true, completion: nil)
   }
}

//Inside the safariLogin(_:) method of the LoginViewController, call the startAccessTokenRequest(url:completionHandler:) method from the GitHubAPIClient.
//Pass the URL received back from GitHub to the url parameter of the startAccessTokenRequest(url:completionHandler:) method.
//Hint: Remember the notification argument passed in from safariLogin(_:) has the url stored in the object property.

// MARK: Set Up View
extension LoginViewController {
   
   private func configureButton()
   {
      self.imageBackgroundView.layer.cornerRadius = 0.5 * self.imageBackgroundView.bounds.size.width
      self.imageBackgroundView.clipsToBounds = true
   }
   
   private func setUpImageViewAnimation() {
      
      for index in 1...numberOfOctocatImages {
         if let image = UIImage(named: "octocat-\(index)") {
            octocatImages.append(image)
         }
      }
      
      self.loginImageView.animationImages = octocatImages
      self.loginImageView.animationDuration = 2.0
      self.loginImageView.startAnimating()
      
   }
}







