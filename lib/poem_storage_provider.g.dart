// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider extends $FunctionalProvider<
        AsyncValue<SharedPreferences>,
        SharedPreferences,
        FutureOr<SharedPreferences>>
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  const SharedPreferencesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPreferencesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'50d46e3f8d9f32715d0f3efabdce724e4b2593b4';

@ProviderFor(PoemHistory)
const poemHistoryProvider = PoemHistoryProvider._();

final class PoemHistoryProvider
    extends $AsyncNotifierProvider<PoemHistory, List<PoemData>> {
  const PoemHistoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'poemHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$poemHistoryHash();

  @$internal
  @override
  PoemHistory create() => PoemHistory();
}

String _$poemHistoryHash() => r'992f4a78ffc624970745cc0242490309af4760b8';

abstract class _$PoemHistory extends $AsyncNotifier<List<PoemData>> {
  FutureOr<List<PoemData>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<PoemData>>, List<PoemData>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PoemData>>, List<PoemData>>,
        AsyncValue<List<PoemData>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
