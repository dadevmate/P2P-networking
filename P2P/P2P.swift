//
//  P2P.swift
//  P2P
//
//  Created by Nethan on 7/3/23.
//

import MultipeerConnectivity
import UIKit
class PeerToPeerNetwork: NSObject, MCSessionDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override init() {
        super.init()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID) did change state to \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Received data: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream: \(stream) with name: \(streamName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Started receiving resource: \(resourceName) from peer: \(peerID) with progress: \(progress)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Finished receiving resource: \(resourceName) from peer: \(peerID) with error: \(error?.localizedDescription ?? "")")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func send(data: Data) {
        // Send data to all connected peers
        try? mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
    }
}

func start() {
    let peerToPeerNetwork = PeerToPeerNetwork()
    let data = "Hello, universe. Nah jkjk Hello world sounds better!!".data(using: .utf8)!
    peerToPeerNetwork.send(data: data)
      
}

start()
