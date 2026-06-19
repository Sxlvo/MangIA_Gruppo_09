import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../services/ai_nutrition_api.dart';
import '../services/mangia_backend.dart';

final selectedTabProvider = NotifierProvider<SelectedTabController, int>(
  SelectedTabController.new,
);

final scanDetailsProvider = NotifierProvider<ScanDetailsController, bool>(
  ScanDetailsController.new,
);

final manualMealFormProvider = NotifierProvider<ManualMealFormController, bool>(
  ManualMealFormController.new,
);

final waterGlassesProvider = NotifierProvider<WaterController, int>(
  WaterController.new,
);

final vitalityScoreProvider = Provider<int>((ref) {
  final water = ref.watch(waterGlassesProvider);
  return math.min(100, 48 + (water * 4));
});

final aiApiProvider = Provider<AiNutritionApi>((ref) => MockAiNutritionApi());

final backendProvider = Provider<MangiaBackend>((ref) => MockMangiaBackend());

final scanResultProvider = FutureProvider<ScanResult>((ref) {
  return ref.read(aiApiProvider).analyzeMealPhoto('mock_fufu_photo.jpg');
});

final chatMessagesProvider =
    NotifierProvider<ChatController, List<ChatMessage>>(ChatController.new);

final analysisChatProvider =
    NotifierProvider<AnalysisChatController, List<ChatMessage>>(
      AnalysisChatController.new,
    );

final expertsProvider = FutureProvider<List<Expert>>((ref) {
  return ref.read(backendProvider).fetchExperts(const UserProfile());
});

final expertFiltersProvider =
    NotifierProvider<ExpertFiltersController, Set<ExpertFilter>>(
      ExpertFiltersController.new,
    );

final hydrationSettingsProvider =
    NotifierProvider<HydrationSettingsController, HydrationSettings>(
      HydrationSettingsController.new,
    );

final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  return availableCameras();
});

class SelectedTabController extends Notifier<int> {
  @override
  int build() => 0;

  void select(int value) => state = value;
}

class ScanDetailsController extends Notifier<bool> {
  @override
  bool build() => false;

  void showDetails() => state = true;

  void showCamera() => state = false;
}

class ManualMealFormController extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

class WaterController extends Notifier<int> {
  static const target = 10;

  @override
  int build() => 5;

  void increment() {
    state = math.min(target, state + 1);
    ref.read(backendProvider).saveWaterGlasses(state);
  }

  void decrement() {
    state = math.max(0, state - 1);
    ref.read(backendProvider).saveWaterGlasses(state);
  }
}

enum HydrationUnit { glasses, milliliters, liters }

extension HydrationUnitLabel on HydrationUnit {
  String get label {
    return switch (this) {
      HydrationUnit.glasses => 'Bicchieri',
      HydrationUnit.milliliters => 'Millilitri',
      HydrationUnit.liters => 'Litri',
    };
  }
}

class HydrationSettings {
  const HydrationSettings({
    this.unit = HydrationUnit.glasses,
    this.glassMl = 250,
  });

  final HydrationUnit unit;
  final int glassMl;

  HydrationSettings copyWith({HydrationUnit? unit, int? glassMl}) {
    return HydrationSettings(
      unit: unit ?? this.unit,
      glassMl: glassMl ?? this.glassMl,
    );
  }

  String totalLabel(int glasses) {
    final ml = glasses * glassMl;
    return switch (unit) {
      HydrationUnit.glasses => '$glasses/${WaterController.target} bicchieri',
      HydrationUnit.milliliters => '$ml ml',
      HydrationUnit.liters => '${(ml / 1000).toStringAsFixed(2)} L',
    };
  }

  String targetLabel() {
    final ml = WaterController.target * glassMl;
    return switch (unit) {
      HydrationUnit.glasses => '${WaterController.target} bicchieri',
      HydrationUnit.milliliters => '$ml ml',
      HydrationUnit.liters => '${(ml / 1000).toStringAsFixed(1)} L',
    };
  }
}

class HydrationSettingsController extends Notifier<HydrationSettings> {
  @override
  HydrationSettings build() => const HydrationSettings();

  void setUnit(HydrationUnit unit) {
    state = state.copyWith(unit: unit);
  }

  void setGlassMl(int ml) {
    state = state.copyWith(glassMl: ml.clamp(100, 500));
  }
}

class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        text:
            'Ciao! Sono MangIA, il tuo assistente nutrizionale personale. Hai analizzato il tuo pasto di oggi: il fufu con verdure ha una buona base, ma manca un po di ferro.',
        isUser: false,
        time: DateTime.now(),
      ),
      ChatMessage(
        text:
            'Puoi chiedermi qualsiasi cosa: suggerimenti per i pasti, come integrare nutrienti mancanti o alternative compatibili con il tuo stile di vita.',
        isUser: false,
        time: DateTime.now(),
      ),
    ];
  }

  Future<void> send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final userMessage = ChatMessage(
      text: clean,
      isUser: true,
      time: DateTime.now(),
    );
    state = [...state, userMessage];
    final reply = await ref
        .read(aiApiProvider)
        .askQuestion(history: state, question: clean);
    state = [...state, reply];
  }
}

class AnalysisChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        text:
            'Sono qui sul risultato del pasto. Posso aiutarti a migliorare ferro, equilibrio e alternative senza uscire da questa pagina.',
        isUser: false,
        time: DateTime.now(),
      ),
    ];
  }

  Future<void> send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final userMessage = ChatMessage(
      text: clean,
      isUser: true,
      time: DateTime.now(),
    );
    state = [...state, userMessage];
    final reply = await ref
        .read(aiApiProvider)
        .askQuestion(history: state, question: clean);
    state = [...state, reply];
  }
}

enum ExpertFilter { budget, specialty, availability }

class ExpertFiltersController extends Notifier<Set<ExpertFilter>> {
  @override
  Set<ExpertFilter> build() => {};

  void toggle(ExpertFilter filter) {
    final next = {...state};
    if (!next.add(filter)) {
      next.remove(filter);
    }
    state = next;
  }

  void clear() => state = {};
}
