//
//  STLogger.swift
//  Icarus
//
//  Created by sentieo on 11/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import Foundation
import UIKit

struct Log: TextOutputStream {
    
    var string : String?
    static var log: Log = Log()
    private init() {}

    func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newWrite"), object: nil)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
    mutating func read(){
        
        let file = "log.txt" //this is the file. we will write to and read from it
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print("LOG - \(text2)")
                self.string = text2
            }
            catch {/* error handling here */}
        }

//        let fm = FileManager.default
//        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
//            if let handle = try? FileHandle(forReadingFrom: log){
//
//            }
    }
    
    mutating func writeToTextView(sender:UITextView){
        read()
        sender.text = self.string
    }
    
    func delete(){
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        do{
            if fm.fileExists(atPath: log.path){
               try fm.removeItem(atPath: log.path)
                
            }else{
                print("File does not exist")
            }
        }catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}


