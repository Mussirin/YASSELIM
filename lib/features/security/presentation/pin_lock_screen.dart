import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../core/ui/yasselim_logo.dart';
import '../bloc/security_cubit.dart';

/// 4-digit PIN lock and setup screen for protecting local journal access.
class PinLockScreen extends StatefulWidget {
  final bool isSetupMode;

  const PinLockScreen({super.key, this.isSetupMode = false});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _pin = '';

  void _onDigitTap(String digit) {
    if (_pin.length >= 4) return;
    context.read<SecurityCubit>().clearError();
    setState(() => _pin += digit);
    if (_pin.length == 4) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submitPin() async {
    final cubit = context.read<SecurityCubit>();
    if (widget.isSetupMode) {
      await cubit.setPin(_pin);
      if (mounted) Navigator.of(context).pop(true);
    } else {
      final ok = cubit.unlockWithPin(_pin);
      if (!ok) {
        setState(() => _pin = '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final secState = context.watch<SecurityCubit>().state;
    final titleKey = widget.isSetupMode ? 'pin_setup_title' : 'pin_enter_title';

    return TwilightScaffold(
      appBar: widget.isSetupMode ? AppBar() : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const YasselimLogo(size: 68, showCard: false),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppTranslations.tr(context, titleKey),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled
                        ? AppColors.brightLavender
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                );
              }),
            ),
            if (secState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                AppTranslations.tr(context, secState.errorMessage!),
                style: const TextStyle(color: AppColors.danger, fontSize: 13),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ...List.generate(9, (i) => _numKey('${i + 1}')),
                const SizedBox(width: 68, height: 68),
                _numKey('0'),
                SizedBox(
                  width: 68,
                  height: 68,
                  child: IconButton(
                    onPressed: _onBackspace,
                    icon: const Icon(Icons.backspace_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _numKey(String digit) {
    return GestureDetector(
      onTap: () => _onDigitTap(digit),
      child: Container(
        width: 68,
        height: 68,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Text(
          digit,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
