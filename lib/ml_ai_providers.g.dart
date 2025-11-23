// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_ai_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageLabeler)
const imageLabelerProvider = ImageLabelerProvider._();

final class ImageLabelerProvider
    extends $FunctionalProvider<ImageLabeler, ImageLabeler, ImageLabeler>
    with $Provider<ImageLabeler> {
  const ImageLabelerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'imageLabelerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$imageLabelerHash();

  @$internal
  @override
  $ProviderElement<ImageLabeler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageLabeler create(Ref ref) {
    return imageLabeler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageLabeler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageLabeler>(value),
    );
  }
}

String _$imageLabelerHash() => r'56a2a82761d0a2f5a40de2ff7a9cdea24392d3f2';

@ProviderFor(CameraControllerService)
const cameraControllerServiceProvider = CameraControllerServiceProvider._();

final class CameraControllerServiceProvider extends $AsyncNotifierProvider<
    CameraControllerService, cam.CameraController> {
  const CameraControllerServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cameraControllerServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cameraControllerServiceHash();

  @$internal
  @override
  CameraControllerService create() => CameraControllerService();
}

String _$cameraControllerServiceHash() =>
    r'4cb8550507425e25261f73698b0de462ece3114e';

abstract class _$CameraControllerService
    extends $AsyncNotifier<cam.CameraController> {
  FutureOr<cam.CameraController> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<cam.CameraController>, cam.CameraController>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<cam.CameraController>, cam.CameraController>,
        AsyncValue<cam.CameraController>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(availableCameras)
const availableCamerasProvider = AvailableCamerasProvider._();

final class AvailableCamerasProvider extends $FunctionalProvider<
        AsyncValue<List<cam.CameraDescription>>,
        List<cam.CameraDescription>,
        FutureOr<List<cam.CameraDescription>>>
    with
        $FutureModifier<List<cam.CameraDescription>>,
        $FutureProvider<List<cam.CameraDescription>> {
  const AvailableCamerasProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'availableCamerasProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$availableCamerasHash();

  @$internal
  @override
  $FutureProviderElement<List<cam.CameraDescription>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<cam.CameraDescription>> create(Ref ref) {
    return availableCameras(ref);
  }
}

String _$availableCamerasHash() => r'451b4d7ce40da917c4471993ef893a9c1d9e0709';

@ProviderFor(LatestAnalysisResult)
const latestAnalysisResultProvider = LatestAnalysisResultProvider._();

final class LatestAnalysisResultProvider
    extends $NotifierProvider<LatestAnalysisResult, String> {
  const LatestAnalysisResultProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'latestAnalysisResultProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$latestAnalysisResultHash();

  @$internal
  @override
  LatestAnalysisResult create() => LatestAnalysisResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$latestAnalysisResultHash() =>
    r'303a445ea8271ecca80ff243e72706f6388f785d';

abstract class _$LatestAnalysisResult extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GeneratedPoem)
const generatedPoemProvider = GeneratedPoemProvider._();

final class GeneratedPoemProvider
    extends $NotifierProvider<GeneratedPoem, String> {
  const GeneratedPoemProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedPoemProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedPoemHash();

  @$internal
  @override
  GeneratedPoem create() => GeneratedPoem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$generatedPoemHash() => r'eba5d597b6a7b1ebf603dfb3b3d77c7d59400412';

abstract class _$GeneratedPoem extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IsVisionPaused)
const isVisionPausedProvider = IsVisionPausedProvider._();

final class IsVisionPausedProvider
    extends $NotifierProvider<IsVisionPaused, bool> {
  const IsVisionPausedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isVisionPausedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isVisionPausedHash();

  @$internal
  @override
  IsVisionPaused create() => IsVisionPaused();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isVisionPausedHash() => r'40d63b96e4b93c4a497203b4676428fe4649e42b';

abstract class _$IsVisionPaused extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
