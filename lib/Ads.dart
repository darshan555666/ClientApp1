import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class Ads {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  // BannerAd _bannerAd;

  // InterstitialAd _interstitialAd;

  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  // NativeAd createNative() {
  //   return NativeAd(
  //     adUnitId: NativeAd.testAdUnitId,
  //     targetingInfo: targetingInfo,
  //     factoryId: "",
  //   );
  // }
}
