//
//  NetworkDrivesModel.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//



// ******** NOTES:
// CHANGE BEHAVIOR: run a continuous check ONLY while Danforth network is not availalbe
// once available, then have it stop at either login or menu views
// if authentication or connection is lost while those views are open, then re-run a check from those views prior to any actions

// isConnected? -> NO -> displays DisconnectedView - start repeat loop constantly checking for when msada starts to ping - when it pings then isConnected is YES which then triggers isAuthenticated?
// isAuthenticated? -> NO -> displays LoginView - for login submission, RECHECK isConnected? to handle unkown disconnects while the LoginView is showing
// isAuthenticated? & isConnected? -> YES -> DirvesMenuView shows - for drive submission, RECHECK isConnected? and isAuthenticed? to handle unknown disconnects
// onSuccess quit app

// Turns out the password doesn't need to be modified... with kinit, you can just mount the drives without authentication.  Should re-check authorization every time drive is launched.


import SwiftUI

class NetworkDrivesModel: ObservableObject {
    
    @AppStorage("StoredUsername") var storedUsername = ""
    @AppStorage("StoredPassword") var storedPassword = ""
    @AppStorage("networkDrivesData") var networkDrivesData: Data = Data()
    
    @Published var isConnected = false
    @Published var quitChecking = false
    @Published var isAuthenticated = false
    @Published var isRefreshing = false
    
    @Published var username = ""
    @Published var password = ""
    
    @Published var drives = [NetworkDrive]()
    @Published var drivesMounted = [NetworkDrive]()
    
    @Published var buttonClicked = false
    
    private var rawDrivesData = [String]()
    
    init() {
        
        // to reset @AppStorage toggle these:
        //        storedUsername = ""
        //        storedPassword = ""
        
        username = storedUsername
        password = storedPassword
        
        print("**** NOTE ****")
        print("rawDrivesData: \(rawDrivesData)")

    }
    
    
    // MARK: - Continuous connection check
    
    @MainActor
    func connectionCheckLoop() async {
        repeat {
            guard !quitChecking else {
                return
            }
            let check = await connectionCheck()
            isConnected = check

        } while !isConnected
    }
    
    func connectionCheck() async -> Bool {
        print("* connectionCheck() called")
        var connectionResult = ""
        var connected = false
        do {
            connectionResult = try shell("ping -q -c 1 msada.ddpsc.org | grep received")
            if connectionResult.contains("Unknown host") {
                connected = false
            }
            else {
                connected = true
            }
        } catch {
            print("connectionCheck() failure")
        }
        print("connectionCheck() \(connected)")
        return connected
    }
    
    // MARK: - Authentication check
    
    func authenticationCheck() -> Bool {
        print("* authenticationCheck() called")
        var authenticationResult = ""
        var authenticated = false
        do {
            authenticationResult = try shell("echo \(password) > /tmp/.ddpsc; kinit --password-file=\"/tmp/.ddpsc\" \(username); rm /tmp/.ddpsc") // ; kdestroy")  // what's the benefit/detriment of kdestroy?
            if authenticationResult.isEmpty || authenticationResult.contains("XPC error") {
                // found that sometimes this fails at launch with an eroneous "XPC error" even though user was successfully authenticated
                authenticated = true
                storedUsername = username
                storedPassword = password
            }
            else {
                authenticated = false
            }
        } catch {
            print("authenticationCheck() failure")
        }
        //        print("authenticationCheck() for \(username):\(password) | \(authenticated) \"echo \(password) > /tmp/.ddpsc; kinit --password-file=\"/tmp/.ddpsc\" \(username); rm /tmp/.ddpsc\"") // ; kdestroy")
        print("authenticationResult() " + String(authenticationResult.isEmpty ? "true" : authenticationResult))
        return authenticated
    }
    
    // MARK: - Collect list of network drives
    func getDrives() {
        print("* getDrives() called")
//        var drives = [NetworkDrive]()
        rawDrivesData = [String]()
        // Mount NetLogon
        var mountResult = ""
        do {
            print("mounting smb://msada/NetLogon")
            mountResult = try shell("[ ! -e /tmp/ddpsc.NetLogon/ ] && mkdir /tmp/ddpsc.NetLogon; mount_smbfs -o nobrowse smb://msada/NetLogon /tmp/ddpsc.NetLogon")
            print(mountResult.isEmpty ? "success" : mountResult)
            
            // Check for .cmd file
            let cmdCheck = try shell("[ -e /tmp/ddpsc.NetLogon/\(username).cmd ] && echo true")
            
            // Compile Shares array from .cmd file
            if cmdCheck.contains("true") {
                print("\(username).cmd found")
                var numberOfDrives = try shell("PATHS=($(cat -v /tmp/ddpsc.NetLogon/\(username).cmd | grep 'NET USE' | awk -F ': ' '{print $2}' | awk -F '^' '{print $1}' | tr '\\' '/')); echo ${#PATHS[@]}")
                numberOfDrives.removeLast()  // removes hidden line break after result
                print("there are \(numberOfDrives) drives")
                if let num = Int(numberOfDrives) {
                    for i in 1...num {
                        // get drive data
                        var data = try shell("PATHS=($(cat -v /tmp/ddpsc.NetLogon/\(username).cmd | grep 'NET USE' | tr ' ' '%' | awk -F 'NET%USE%' '{print $2}' | awk -F '^' '{print $1}' | tr '\\' '/')); echo ${PATHS[\(i)]}")
                        data.removeLast()  // removes hidden line break after result (still a thing?) **************
                        print("\(i): \(data)")
                        
                        // append to array of raw strings instead?
                        rawDrivesData.append(data)
                        // append NetworkDrive (original)
//                        drives.append(NetworkDrive(data: data))
                    }
                }
            }
            // Compile basic Shares array
            else {
                
                rawDrivesData.append("G:%//nas01/public")
                rawDrivesData.append("R:%//nas01/research")
                // for testing
                 rawDrivesData.append("M:%//fp01/Cafe$")
                 rawDrivesData.append("N:%//fp01/Dining_Cards$")
                 rawDrivesData.append("S:%//fp01/Development")
                 rawDrivesData.append("V:%//fp01/Events$")
                 rawDrivesData.append("X:%//fp01/Phase_B_Specifications$")
                 rawDrivesData.append("Z:%//nas01/CAFECAM$")
                 rawDrivesData.append("Y:%//fp01/AgTechNext$")
                 rawDrivesData.append("O:%//fp01/Development_Events$")
                 rawDrivesData.append("T:%//fp01/techmanage$")
                 rawDrivesData.append("L:%//tbsds1515/burch_smith_lab")
            }
            
        } catch {
            print("getShares() failure")
        }
 
        // Overwrites drives array with new array
//        self.drives = drives
        // Appends Personal drive if found
        getPersonalDrive()
        
        // save the array to @AppStorage
        networkDrivesData = Storage.archiveDrivesArray(object: rawDrivesData)
        
        Task {
            await cleanupMounts()
        }

    }
    
    func getPersonalDrive() {
        var mountResult = ""
        print("* getPersonalDrive() called")
        do {
            // Check Research drive first
            print("checking Research homes")
            mountResult = try shell("[ ! -e /tmp/ddpsc.research.home/ ] && mkdir /tmp/ddpsc.research.home; mount_smbfs -o nobrowse smb://nas01/research/home/ /tmp/ddpsc.research.home")
            print(mountResult.isEmpty ? "success" : mountResult)
            
            let homeCheck = try shell("[ -e /tmp/ddpsc.Research/\(username) ] && echo found")
            
            if homeCheck == "found" {
                print("\(username) home found")
                rawDrivesData.append("U:%//nas01/research/home/\(username)")
//                drives.append(NetworkDrive(data: "U:%//nas01/research/home/\(username)"))
            }
            // Next check nas01
            else {
                print("checking fp01 homes")
                mountResult = try shell("[ ! -e /tmp/ddpsc.fp01.home/ ] && mkdir /tmp/ddpsc.fp01.home; mount_smbfs -o nobrowse smb://\(username)@fp01/\(username)$ /tmp/ddpsc.fp01.home")
                print(mountResult.isEmpty ? "success" : mountResult)
                
                if mountResult.isEmpty {
                    print("\(username) home found")
                    rawDrivesData.append("U:%//\(username)@fp01/\(username)$")
//                    drives.append(NetworkDrive(data: "U:%//\(username)@fp01/\(username)$"))
                }                
            }
            
        } catch {
            print("getPersonalDrive() failed")
        }
    }
    
    func cleanupMounts() async {
        print("cleaning up mounts used for checking")
        do {
            let cleanupResult = try shell("umount /tmp/ddpsc.NetLogon; umount /tmp/ddpsc.fp01.home; umount /tmp/ddpsc.research.home")
            print(cleanupResult.isEmpty ? "success" : cleanupResult)
        } catch {
            print("cleanupNetLogon() failed")
        }
    }
    
    // MARK: - Load drives from storage
    func loadDrives() {
        print("* loadDrives() called")
        drives = [NetworkDrive]()
        rawDrivesData = Storage.loadDrivesArray(data: networkDrivesData)
        for data in rawDrivesData {
            drives.append(NetworkDrive(data: data))
        }
    }
    
//    func checkIsMounted(_ drivename: String) -> Bool {
//        var lsResult = ""
//        do {
//           lsResult = try shell("ls /tmp/ddpsc.\"\(drivename)\"/")
//        } catch {
//            print("checkIsMounted() failure")
//        }
//        if !lsResult.isEmpty {
//            return true
//        } else {
//            return false
//        }
//    }
    
    // MARK: - Mount Network Drive
    
    func mountDrive(_ drive: NetworkDrive) async -> String {
        print("* mountDrives() called")

        do {
            let pingResult = try shell("ping -q -c 1 \(drive.sharename).ddpsc.org | grep received")
            let mountResult = try shell("[ ! -e /tmp/ddpsc.\"\(drive.name)\" ] && mkdir /tmp/ddpsc.\"\(drive.name)\"; mount_smbfs smb://\(drive.address) /tmp/ddpsc.\"\(drive.name)\"")
            print("mountResult: \(mountResult.isEmpty ? "success" : mountResult)  pingResult: \(pingResult)")
            if !mountResult.contains("Permission denied") && !mountResult.contains("Unknown error") && pingResult.contains("1 packets received") {
                try shell("open -g /tmp/ddpsc.\"\(drive.name)\"; osascript -e \"tell application \\\"Finder\\\" to activate\"")
            }
            else {
                print("Unable to mount \(drive.address): Permission denied or drive not reachable")
                return "Inaccessible"
            }
        } catch {
            print("mountDrives() failure")
        }
        return "Success"
    }
    
    
    
    
    // MARK: - - - - - - - - - - - -
    // MARK: - shell script function
    // great shell scripting snippet from: https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild
    // must be used with do/try/catch
    @discardableResult
    func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}


// MARK: - convert array of strings into data for @AppStorage
class Storage: NSObject {
    
    // This should be added below your View Model
    // Modified code from https://stackoverflow.com/questions/63166706/how-to-store-nested-arrays-in-appstorage-for-swiftui
    
    static func archiveDrivesArray(object: [String]) -> Data {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            return data
        } catch {
            fatalError("archiveStringArray - Can't encode data: \(error)")
        }
    }
    
    static func loadDrivesArray(data: Data) -> [String] {
        do {
            guard let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data) as? [String] else {
                return []
            }
            
            return array
        } catch {
            fatalError("loadStringArray - Can't encode data: \(error)")
        }
    }
}

