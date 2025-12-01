import UIKit
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()
    
    // Pre-initialized generators for faster response
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        // Prepare all generators on init
        prepareAll()
    }
    
    /// Prepare all generators for faster haptic response
    func prepareAll() {
        DispatchQueue.main.async { [weak self] in
            self?.impactLight.prepare()
            self?.impactMedium.prepare()
            self?.impactHeavy.prepare()
            self?.notificationGenerator.prepare()
            self?.selectionGenerator.prepare()
        }
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let generator: UIImpactFeedbackGenerator
            switch style {
            case .light:
                generator = self.impactLight
            case .medium:
                generator = self.impactMedium
            case .heavy:
                generator = self.impactHeavy
            default:
                generator = self.impactMedium
            }
            
            generator.impactOccurred()
            generator.prepare() // Re-prepare for next use
        }
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.notificationGenerator.notificationOccurred(type)
            self.notificationGenerator.prepare() // Re-prepare for next use
        }
    }
    
    func selection() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectionGenerator.selectionChanged()
            self.selectionGenerator.prepare() // Re-prepare for next use
        }
    }
}
