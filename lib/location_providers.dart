import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// 1. Location Permission Provider
final locationPermissionProvider = FutureProvider<LocationPermission>((ref) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 권한이 거부되었습니다.');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.');
  }
  return permission;
});

// 2. Current Position Provider
final currentPositionProvider = FutureProvider<Position>((ref) async {
  // 먼저 권한 상태를 확인합니다.
  final permission = await ref.watch(locationPermissionProvider.future);
  
  // 권한이 허용된 경우에만 위치 서비스를 확인합니다.
  if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다. 기기 설정에서 활성화해주세요.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  
  // 권한이 허용되지 않은 경우, locationPermissionProvider의 에러가 이미 UI에 표시될 것이므로
  // 여기서는 추가적인 에러를 반환하지 않거나, 좀 더 구체적인 에러를 반환할 수 있습니다.
  // locationPermissionProvider가 처리하므로 이 부분은 이론상 도달하기 어렵습니다.
  return Future.error('위치 권한이 부여되지 않았습니다.');
});

// 3. Current Address Provider (Reverse Geocoding)
final currentAddressProvider = FutureProvider<String>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      // Join non-empty address parts for a cleaner format
      final addressParts = [
        place.administrativeArea,
        place.locality,
        place.thoroughfare,
        place.subThoroughfare,
      ];
      final address = addressParts.where((part) => part != null && part.isNotEmpty).join(' ');
      
      return address.isNotEmpty ? address : '주소를 찾을 수 없습니다.';
    }
    return '주소를 찾을 수 없습니다.';
  } catch (e) {
    return '주소 변환 중 오류 발생: $e';
  }
});
