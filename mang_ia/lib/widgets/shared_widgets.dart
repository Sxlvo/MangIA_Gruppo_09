import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as speech_to_text;

import '../core/app_colors.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';

class AppPage extends StatelessWidget {
  const AppPage({required this.faintTitle, required this.child, super.key});

  final String faintTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FloatingSafeNav extends ConsumerWidget {
  const FloatingSafeNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTabProvider);

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            active: selected == 0,
            onTap: () => ref.read(selectedTabProvider.notifier).select(0),
          ),
          NavItem(
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart,
            label: 'Stats',
            active: selected == 1,
            onTap: () => ref.read(selectedTabProvider.notifier).select(1),
          ),
          GestureDetector(
            onTap: () {
              ref.read(selectedTabProvider.notifier).select(2);
              ref.read(scanDetailsProvider.notifier).showCamera();
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.32),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          NavItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'IA',
            active: selected == 3,
            onTap: () => ref.read(selectedTabProvider.notifier).select(3),
          ),
          NavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Esperti',
            active: selected == 4,
            onTap: () => ref.read(selectedTabProvider.notifier).select(4),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.green : AppColors.muted;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.color = AppColors.card,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.eco_outlined, color: AppColors.green, size: 26),
        SizedBox(width: 7),
        Text(
          'MangIA',
          style: TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class AvatarStack extends StatelessWidget {
  const AvatarStack({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120&h=120&fit=crop&crop=faces',
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(icon, color: AppColors.ink, size: 18),
      ),
    );
  }
}

class StepperPill extends StatelessWidget {
  const StepperPill({required this.onMinus, required this.onPlus, super.key});

  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onMinus,
            icon: const Icon(Icons.remove, color: Color(0xFF2272E8)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPlus,
            icon: const Icon(Icons.add, color: Color(0xFF2272E8)),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(action, style: const TextStyle(color: AppColors.green)),
        ),
      ],
    );
  }
}

class RecentMealTile extends StatelessWidget {
  const RecentMealTile({
    required this.icon,
    required this.title,
    required this.time,
    super.key,
  });

  final IconData icon;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF1F5F9),
            child: Icon(icon, color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                time,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackEyebrow extends StatelessWidget {
  const BackEyebrow({required this.label, this.onBack, super.key});

  final String label;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(icon: Icons.chevron_left, onTap: onBack),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class FoodPhoto extends StatelessWidget {
  const FoodPhoto({this.fit = BoxFit.cover, super.key});

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=900&h=1100&fit=crop',
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFE8DBC8),
        child: CustomPaint(painter: PlatePainter()),
      ),
    );
  }
}

class MealResultHero extends StatelessWidget {
  const MealResultHero({required this.result, super.key});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 124,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const FoodPhoto(),
                  Positioned(
                    right: 12,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.mint,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Riconosciuto',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.subtitle,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    required this.color,
    required this.border,
    required this.icon,
    required this.title,
    required this.text,
    super.key,
  });

  final Color color;
  final Color border;
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: border, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({required this.label, this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Chip(
        avatar: const Icon(Icons.eco, color: AppColors.green, size: 16),
        label: Text(label),
        backgroundColor: const Color(0xFFDFF8E8),
        side: BorderSide.none,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final align = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bg = message.isUser ? AppColors.green : Colors.white;
    final fg = message.isUser ? Colors.white : AppColors.ink;

    return Align(
      alignment: align,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 292),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(color: fg, height: 1.35, fontSize: 13),
        ),
      ),
    );
  }
}

class PromptPill extends StatelessWidget {
  const PromptPill({required this.text, this.onTap, super.key});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}

class VoiceInputButton extends StatefulWidget {
  const VoiceInputButton({required this.onRecognized, super.key});

  final ValueChanged<String> onRecognized;

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final speech_to_text.SpeechToText _speech = speech_to_text.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  bool _deliveredResult = false;

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      if (_lastWords.trim().isNotEmpty) {
        _deliveredResult = true;
        widget.onRecognized(_lastWords.trim());
      }
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
          if (_lastWords.trim().isNotEmpty && !_deliveredResult) {
            _deliveredResult = true;
            widget.onRecognized(_lastWords.trim());
            _lastWords = '';
          }
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => _isListening = false);
        final message = error.errorMsg.toLowerCase().contains('timeout')
            ? 'Nessuna voce rilevata. Su emulatore abilita il microfono host o prova su telefono reale.'
            : 'Microfono non disponibile: ${error.errorMsg}';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );

    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permesso microfono non disponibile.')),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _lastWords = '';
      _deliveredResult = false;
    });

    await _speech.listen(
      listenOptions: speech_to_text.SpeechListenOptions(
        localeId: 'it_IT',
        listenMode: speech_to_text.ListenMode.dictation,
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        cancelOnError: false,
      ),
      onResult: (result) {
        _lastWords = result.recognizedWords;
        if (result.finalResult &&
            _lastWords.trim().isNotEmpty &&
            !_deliveredResult) {
          _deliveredResult = true;
          widget.onRecognized(_lastWords.trim());
          _lastWords = '';
          if (mounted) {
            setState(() => _isListening = false);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _isListening ? 'Sto ascoltando' : 'Parla con MangIA',
      onPressed: _toggleListening,
      icon: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening ? AppColors.danger : AppColors.green,
      ),
    );
  }
}

class MatchBadge extends StatelessWidget {
  const MatchBadge({required this.rate, super.key});

  final int rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF8E8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '$rate%\nmatch',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class ExpertTag extends StatelessWidget {
  const ExpertTag({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.green, fontSize: 10),
      ),
    );
  }
}

class FilterChipPill extends StatelessWidget {
  const FilterChipPill({
    required this.label,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.green : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class SmallTrendBadge extends StatelessWidget {
  const SmallTrendBadge({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF8E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class PlatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      size.shortestSide * 0.30,
      Paint()..color = AppColors.card,
    );
    canvas.drawCircle(
      Offset(center.dx - 34, center.dy + 18),
      54,
      Paint()..color = const Color(0xFFF7F0DE),
    );
    canvas.drawCircle(
      Offset(center.dx + 48, center.dy - 24),
      42,
      Paint()..color = const Color(0xFF8A4E25),
    );
    canvas.drawCircle(
      Offset(center.dx + 44, center.dy - 28),
      24,
      Paint()..color = AppColors.green.withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
