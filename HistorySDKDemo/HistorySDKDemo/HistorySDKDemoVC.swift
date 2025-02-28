//
//  ViewController.swift
//  AuthSDKDemo
//

import UIKit
import CoreSDK
import AuthSDK
import HistorySDK

class HistorySDKDemoVC: UIViewController, HSDKTokenRefreshCallback {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAuthSDK()
    }

    // MARK: - Methods
    private func setupAuthSDK() {
        let auth0ClientID = "DL8XpUmzegVl9dR8QpO9djDifTY7nGyd" // Auth0 client ID gotten from the mCards team
        let auth0Domain = "mcards-test.au.auth0.com" // Auth0 Domain gotten from the mCards team
        let auth0Audience = "https://staging.mcards.com/api" // Auth0 audience gotten from the mCards team
        
        let args = Auth0Args(
            auth0ClientID: auth0ClientID,
            auth0Domain: auth0Domain,
            auth0Audience: auth0Audience)
        
        // Configure the SDK
        AuthSdkProvider.shared.configure(args: args)
        
        // Set logging to the console and/or Firebase
        AuthSdkProvider.shared.setLogging(debugMode: true, loggingCallback: LoggingHandler())
        
        
    }
    
    func setupHistorySDK(withToken token: String) {
        HistorySdkProvider.shared.configure(accessToken: token, debugMode: true, tokenRefreshCallback: self, loggingCallback: LoggingHandler())
        
        HistorySdkProvider.shared.getPaginatedActivities(cardId: "aa7de81f-36a5-45dc-80ab-e214270b73d7", sourceIndex: nil, pageSize: nil) { result in
            print(result)
        }
    }
    
    func refreshJWTs(completion: @escaping (CoreSDK.JWTs) -> Void) {
        
    }
    
    private func login(forceAuth: Bool) {
        let savedPhoneNumber = "" // Save phone number used to pre-populate the login form
        let forceAuth = forceAuth // Forces credentials entry if true
        let regionCode: RegionCode? = nil // Forces login into a specific region
        let deepLink: DeepLink? = nil // Parsed DeepLink object if the app was launched from a Firebase Link
        
        /* 
         Provide the dynamic link url from a firebase dynamic link e.g.
         
         let dynamicLink: DynamicLink
         deepLink = DeepLink(dynamicLinkURL: dynamicLink.url)
         */
        
        let loginArgs = LoginArgs(
            savedPhoneNumber: savedPhoneNumber,
            forceAuth: forceAuth,
            regionCode: regionCode,
            deepLink: deepLink)
        
        activityIndicator.startAnimating()
        
        AuthSdkProvider.shared.login(args: loginArgs) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let authSuccess):
                // Get any required data
                let accessToken = authSuccess.jwts.accessToken
                // Start using the SDK
                self?.setupHistorySDK(withToken: accessToken)
            case .failure(let error):
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    
    private func logout() {
        activityIndicator.startAnimating()
        
        AuthSdkProvider.shared.logout { [weak self] success in
            self?.activityIndicator.stopAnimating()
            
            let logoutMessage = success ? "Success" : "Failure"
            print("Logout result: \(logoutMessage)")
        }
    }
    
    // MARK: - Actions
    @IBAction func tappedLogin(_ sender: Any) {
        login(forceAuth: true)
    }
    
    @IBAction func tappedQuietLogin(_ sender: Any) {
        login(forceAuth: false)
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        logout()
    }
}

class LoggingHandler: LoggingCallback {
    func log(message: String) {
        // Implement Crashlytics log
        // Crashlytics.crashlytics().log(message)
    }
    
    func logNonFatal(nsError: NSError) {
        // Implement Crashlytics log non-fatal
        // Crashlytics.crashlytics().record(error: nsError)
    }
}
