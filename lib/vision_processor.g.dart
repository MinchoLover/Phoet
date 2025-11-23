// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_processor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(visionProcessor)
const visionProcessorProvider = VisionProcessorProvider._();

final class VisionProcessorProvider extends $FunctionalProvider<VisionProcessor,
    VisionProcessor, VisionProcessor> with $Provider<VisionProcessor> {
  const VisionProcessorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'visionProcessorProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$visionProcessorHash();

  @$internal
  @override
  $ProviderElement<VisionProcessor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VisionProcessor create(Ref ref) {
    return visionProcessor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisionProcessor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisionProcessor>(value),
    );
  }
}

String _$visionProcessorHash() => r'7422009ecc8f63f5ca423613e921739dfd5a05f6';
