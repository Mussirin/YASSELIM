import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the one-time premium unlock state of YASSELIM.
class PremiumState extends Equatable {
  final bool isPremium;
  final bool isProcessing;

  const PremiumState({this.isPremium = false, this.isProcessing = false});

  PremiumState copyWith({bool? isPremium, bool? isProcessing}) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [isPremium, isProcessing];
}

/// Manages the single one-time purchase flow and local entitlement persistence.
class PremiumCubit extends Cubit<PremiumState> {
  static const String premiumKey = 'yasselim_premium_unlocked_v1';

  final SharedPreferences? _prefs;

  PremiumCubit({SharedPreferences? prefs})
    : _prefs = prefs,
      super(PremiumState(isPremium: prefs?.getBool(premiumKey) ?? false));

  Future<void> purchaseOneTimePremium() async {
    emit(state.copyWith(isProcessing: true));
    await _prefs?.setBool(premiumKey, true);
    emit(const PremiumState(isPremium: true, isProcessing: false));
  }

  Future<void> restorePurchase() async {
    emit(state.copyWith(isProcessing: true));
    final unlocked = _prefs?.getBool(premiumKey) ?? state.isPremium;
    emit(PremiumState(isPremium: unlocked, isProcessing: false));
  }
}
