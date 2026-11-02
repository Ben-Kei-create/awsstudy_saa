import Combine
import GoogleMobileAds
import UserMessagingPlatform

@MainActor
final class InterstitialAds: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published private(set) var privacyOptionsRequired = false
    private var ad: InterstitialAd?
    private var completion: (() -> Void)?
    private var started = false
    private var loading = false
    private var canLoadAds = false

    // Both configurations use test IDs until a dedicated SAA AdMob app is configured.
    private var unitID: String {
        Bundle.main.object(forInfoDictionaryKey: "AdMobInterstitialUnitID") as? String ?? ""
    }
    private var usesTestAds: Bool { unitID == "ca-app-pub-3940256099942544/4411468910" }

    func prepare() async {
        if !started {
            started = true
            if usesTestAds {
                canLoadAds = true
            } else {
                do {
                    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                        ConsentInformation.shared.requestConsentInfoUpdate(with: RequestParameters()) { error in
                            if let error { continuation.resume(throwing: error) }
                            else { continuation.resume() }
                        }
                    }
                    try await ConsentForm.loadAndPresentIfRequired(from: nil)
                } catch {
                    print("Ad consent unavailable: \(error.localizedDescription)")
                }
                canLoadAds = ConsentInformation.shared.canRequestAds
                privacyOptionsRequired = ConsentInformation.shared.privacyOptionsRequirementStatus == .required
            }
            if canLoadAds { await MobileAds.shared.start() }
        }
        await load()
    }

    private func load() async {
        guard canLoadAds, !loading, ad == nil else { return }
        loading = true
        defer { loading = false }
        do {
            ad = try await InterstitialAd.load(with: unitID, request: Request())
            ad?.fullScreenContentDelegate = self
        } catch {
            print("Interstitial unavailable: \(error.localizedDescription)")
        }
    }

    func show(completion: @escaping () -> Void) {
        guard self.completion == nil else { return }
        guard let ad else {
            completion()
            return
        }
        do {
            try ad.canPresent(from: nil)
            self.completion = completion
            ad.present(from: nil)
        } catch {
            self.ad = nil
            completion()
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) { finish() }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        finish()
    }

    private func finish() {
        ad = nil
        let action = completion
        completion = nil
        action?()
        Task { await load() }
    }

    func showPrivacyOptions() async {
        ad = nil
        do { try await ConsentForm.presentPrivacyOptionsForm(from: nil) }
        catch { print("Privacy options unavailable: \(error.localizedDescription)") }
        canLoadAds = ConsentInformation.shared.canRequestAds
        await load()
    }
}
