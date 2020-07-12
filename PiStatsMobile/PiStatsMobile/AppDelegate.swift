//
//  AppDelegate.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 11/07/2020.
//

import UIKit
import BackgroundTasks
import WidgetKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // TODO, I can't set the background fetch since scenePhase is not working https://twitter.com/fcbunn/status/1281900924798226432?s=21
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.bunn.PiStatsMobile.updatePiholes", using: nil) { task in
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
        WidgetCenter.shared.reloadAllTimelines()

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("YEA")
    }
    /*
     func scheduleAppRefresh() {
     let request = BGAppRefreshTaskRequeste(identifier: dev.bunn...)
     request.earlierBeginDate = Date(....
     
     do {
     try BGTaskScheduler.shared.submit(request)
     } catch {
     bleh
     }
     */
    private func handleAppRefresh(task: BGAppRefreshTask) {
        //scheduleAppRefresh
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        //let operations = Operations.getOperationsToFetchLatestEntries(....
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        //let lastOperation = operations.last!
            //lastOperation.completionBlock = { task.setTaskCompleted(success: !lastOperation.isCancelled)
        
    }
}
