//
//  MacPasswordValidation.swift
//  Danforth Password Change
//
//  Created by Alex Tosspon on 3/19/23.
//

import SwiftUI
import Combine

class MacPasswordValidation: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var oldPassword: String = ""
    @Published var oldPasswordCheck: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordCheck: String = ""
    @Published var verifyPassword: String = ""
    @Published var verifyPasswordCheck: String = ""
    @Published var errorMessageLine1: String = ""
    @Published var errorMessageLine2: String = ""
    @Published var passwordHint: String = ""
    @Published var passwordHintFixed: String = ""
    
    @Published var changeAllowed: Bool = false
    
    private var passwordMatch: String = ""
    
    
    init() {
        
        fullName = getFullName()
        
        $oldPassword
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .map { password in
                self.errorMessageLine1 = ""
                self.errorMessageLine2 = ""
                if !self.oldPasswordIsValid() && password != "" {
                    self.errorMessageLine1 = "Old password is incorrect"
                }
                self.isChangeAllowed()
                return self.oldPasswordIsValid() ? "checkmark" : "xmark"
                
            }
            .assign(to: &$oldPasswordCheck)
        
        $newPassword
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .map { password in
                self.passwordMatch = password
                self.errorMessageLine1 = ""
                self.errorMessageLine2 = ""
                if !password.isPasswordStrong && password != "" {
                    self.errorMessageLine1 = "Recommended: 10 characters, with a capital,"
                    self.errorMessageLine2 = "a lowercase, a number, and a special symbol"
                }
                return password.isPasswordStrong ? "checkmark" : "xmark"
            }
            .assign(to: &$newPasswordCheck)
        
        $verifyPassword
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .map { password in
                if password == self.passwordMatch {
                    self.errorMessageLine1 = ""
                    self.errorMessageLine2 = ""
                }
                else if password != self.passwordMatch && password != "" {
                    self.errorMessageLine1 = "Passwords do not match"
                    self.errorMessageLine2 = ""
                }
                self.isChangeAllowed()
                return password == self.newPassword && self.newPassword != "" ? "checkmark" : "xmark"
            }
            .assign(to: &$verifyPasswordCheck)
        
        $passwordHint
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .map { hint in
                var fixedHint = hint
                fixedHint = fixedHint.replacingOccurrences(of: "\"", with: "\\\"")
                fixedHint = fixedHint.replacingOccurrences(of: "$", with: "\\$")
                fixedHint = fixedHint.replacingOccurrences(of: "!", with: "\\!")
                fixedHint = fixedHint.replacingOccurrences(of: "\\", with: "\\\\")
                fixedHint = fixedHint.replacingOccurrences(of: "`", with: "\\`")
//              fixedHint = fixedHint.replacingOccurrences(of: "?", with: "\\?")    // not needed
//              fixedHint = fixedHint.replacingOccurrences(of: "'", with: "\\\'")   // not needed

                return fixedHint
                
            }
            .assign(to: &$passwordHintFixed)
        
    }
    
    // MARK: - allow "Change" button to activate
    func isChangeAllowed() {
        if oldPasswordIsValid() && newPassword != "" && verifyPassword == newPassword {
            self.changeAllowed = true
        }
        else {
            self.changeAllowed = false
        }
    }
    
    // MARK: - Function to pull full name of logged in user
    func getFullName() -> String {
        var fullname = ""
        do {
            try fullname = shell("dscl . read /Users/$(whoami) RealName | tail -1 | cut -c 2-")
        }
        catch {
            print("couldn't query dscl for fullname")
        }
        fullname.removeLast()
        return fullname
    }
    
    // MARK: - Function to get logged in username
    func getUsername() -> String {
        var name = ""
        do {
            try name = shell("whoami")
        }
        catch {
            print("couldn't run whoami")
        }
        name.removeLast()
        return name
    }
    
    // MARK: - Function to test the current password of the logged in user
    func oldPasswordIsValid() -> Bool {
        var check = ""
        do {
            try check = shell("dscl . authonly \(getUsername()) \(oldPassword)")
        }
        catch {
            print("oldPasswordIsValid() failed")
        }
        if check == "" {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - shell script funciton
    // great shell scripting snippet from: https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild
    // must be used with do/try/catch
    @discardableResult
    func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil
        
        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    // MARK: - function for setting Mac password
    func setMacPassword() {
        let userName = getUsername()
        do {
            try shell("dscl . passwd /Users/\(userName) \(oldPassword) \(newPassword)")
            try shell("dscl . delete /Users/\(userName) hint; dscl . merge /Users/\(userName) hint \"\(passwordHint)\"")
        }
        catch {
            print("setMacPassword() failed")
        }
    }
}
