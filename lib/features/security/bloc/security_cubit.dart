import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/security/encryption_service.dart';

/// State for the 4-digit PIN lock and biometric toggle.
class SecurityState extends Equatable {
  final bool isPinEnabled;
  final bool isLocked;
  final bool biometricEnabled;
  final String? errorMessage;

  const SecurityState({
    this.isPinEnabled = false,
    this.isLocked = false,
    this.biometricEnabled = false,
    this.errorMessage,
  });

  SecurityState copyWith({
    bool? isPinEnabled,
    bool? isLocked,
    bool? biometricEnabled,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SecurityState(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isLocked: isLocked ?? this.isLocked,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isPinEnabled,
    isLocked,
    biometricEnabled,
    errorMessage,
  ];
}

/// Manages the local 4-digit PIN hash, lock screen state, and biometric setting.
class SecurityCubit extends Cubit<SecurityState> {
  static const String pinHashKey = 'yasselim_pin_hash_v1';
  static const String biometricKey = 'yasselim_biometric_v1';

  final SharedPreferences? _prefs;
  final EncryptionService _encryption;
  String? _memoryPinHash;

  SecurityCubit({SharedPreferences? prefs, EncryptionService? encryption})
    : _prefs = prefs,
      _encryption = encryption ?? EncryptionService(),
      super(_initialState(prefs));

  static SecurityState _initialState(SharedPreferences? prefs) {
    final storedHash = prefs?.getString(pinHashKey);
    final hasPin = storedHash != null && storedHash.isNotEmpty;
    final bio = prefs?.getBool(biometricKey) ?? false;
    return SecurityState(
      isPinEnabled: hasPin,
      isLocked: hasPin,
      biometricEnabled: bio,
    );
  }

  Future<void> setPin(String pin) async {
    final hash = _encryption.hashPin(pin);
    _memoryPinHash = hash;
    await _prefs?.setString(pinHashKey, hash);
    emit(state.copyWith(isPinEnabled: true, isLocked: false, clearError: true));
  }

  Future<void> disablePin() async {
    _memoryPinHash = null;
    await _prefs?.remove(pinHashKey);
    emit(
      state.copyWith(
        isPinEnabled: false,
        isLocked: false,
        biometricEnabled: false,
        clearError: true,
      ),
    );
  }

  bool unlockWithPin(String pin) {
    final storedHash = _prefs?.getString(pinHashKey) ?? _memoryPinHash;
    if (storedHash == null || storedHash.isEmpty) {
      emit(state.copyWith(isLocked: false, clearError: true));
      return true;
    }
    final candidateHash = _encryption.hashPin(pin);
    if (candidateHash == storedHash) {
      emit(state.copyWith(isLocked: false, clearError: true));
      return true;
    }
    emit(state.copyWith(errorMessage: 'pin_error'));
    return false;
  }

  void lockNow() {
    if (!state.isPinEnabled) return;
    emit(state.copyWith(isLocked: true, clearError: true));
  }

  Future<void> setBiometric(bool enabled) async {
    await _prefs?.setBool(biometricKey, enabled);
    emit(state.copyWith(biometricEnabled: enabled, clearError: true));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
