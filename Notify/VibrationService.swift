//
//  VibrationService.swift
//  devapptest
//
//  Created by André de Souza on 16/04/24.
//
// haptics
//import Foundation
//import CoreHaptics
//import AVFAudio
//
//final class VibrationService {
//    static let shared = VibrationService()
//    static var timer: Timer?
//    static var engine: CHHapticEngine?
//    
//    static func playCallVibrationPattern() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
//            print("Haptics not supported on this device.")
//            return
//        }
//        
//        prepareHaptics()
//        
//        var events = [CHHapticEvent]()
//        
//        let vibrationDuration: TimeInterval = 1.0
//        let pauseDuration: TimeInterval = 0.5
//        
//        for i in 0..<5 {
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
//            let startTime = TimeInterval(i) * (vibrationDuration + pauseDuration)
//            let vibrationEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: startTime, duration: vibrationDuration)
//            
//            events.append(vibrationEvent)
//        }
//        
//        do {
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            let player = try engine?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//        } catch {
//            print("Failed to play pattern: \(error.localizedDescription).")
//        }
//    }
//    
//    static func stopHaptic() {
//        self.prepareHaptics()
//        engine?.stop(completionHandler: { (error) in
//            if let error = error {
//                print("Haptic engine stop error: \(error)")
//            }
//        })
//    }
//    
//    static func prepareHaptics() {
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
//                try AVAudioSession.sharedInstance().setActive(true)
//                
//                VibrationService.engine = try CHHapticEngine()
//                
//                engine?.stoppedHandler = { reason in
//                    print("Haptic engine stopped: \(reason)")
//                }
//                
//                engine?.resetHandler = {
//                    print("Haptic engine reset")
//                    do {
//                        try VibrationService.engine?.start()
//                    } catch {
//                        print("Failed to restart haptic engine: \(error)")
//                    }
//                }
//                
//                try VibrationService.engine?.start()
//            } catch {
//                print("Haptic engine Creation Error: \(error)")
//            }
//        }
//}
/// Play a short single vibration, like a tac
//    static func tacVibrate() {
//        AudioServicesPlaySystemSound(1519) // one tack
//    }
//
//    /// Play three shorts tac vibration, like a tac tac tac
//    static func threeTacVibrate() {
//        AudioServicesPlaySystemSound(1521)
//    }
//
//    /// Play a strong boom vibration
//    static func boomVibrate() {
//        AudioServicesPlaySystemSound(1520)
//    }
//
//    /// Play a long vibrations trr trr, it sounds like an error
//    static func longVibrate() {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // heavy tack
//    }
//
//    /// Stops the short single vibration, like a tac
//    static func stopTacVibrate() {
//        AudioServicesDisposeSystemSoundID(1519) // one tack
//    }
//
//    /// Stops the three shorts tac vibration, like a tac tac tac
//    static func stopThreeTacVibrate() {
//        AudioServicesDisposeSystemSoundID(1521)
//    }
//
//    /// Stops the strong boom vibration
//    static func stopBoomVibrate() {
//        AudioServicesDisposeSystemSoundID(1520)
//    }
//
//    /// Stops the long vibrations
//    static func stopLongVibrate() {
//        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate) // heavy tack
//    }
import AVFoundation
import UIKit
import CoreHaptics

final class VibrationService {
    static let shared = VibrationService()
    private var audioPlayer: AVAudioPlayer?
    private var vibrationTimer: Timer?
    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }
    
    // Configurar a sessão de áudio
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    // Iniciar reprodução do áudio silencioso
    private func startSilentAudio() {
        
        // Start the background music:
        if let musicPath = Bundle.main.path(forResource:
                                                "alert_sound.caf", ofType: nil) {
            print("SHOULD HEAR MUSIC NOW", musicPath)
            let url = URL(fileURLWithPath: musicPath)

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
            catch { print("Couldn't load music file") }
        }
    }
    
    // Preparar o motor de háptica
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Creation Error: \(error)")
        }
    }
    
    // Função para vibrar
    @objc private func vibrate() {
        let vibrationID: SystemSoundID = 4095
        AudioServicesPlaySystemSound(vibrationID)
    }
    
    // Iniciar vibração contínua
    func startContinuousVibration() {
        setupAudioSession()
        startSilentAudio()
        vibrationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: true)
    }
    
    // Parar vibração contínua
    func stopContinuousVibration() {
        print("parando...")
        audioPlayer?.stop()
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
}


