import '../models/models.dart';

abstract class AiNutritionApi {
  Future<ScanResult> analyzeMealPhoto(String imagePath);

  Future<ChatMessage> askQuestion({
    required List<ChatMessage> history,
    required String question,
  });
}

class MockAiNutritionApi implements AiNutritionApi {
  @override
  Future<ScanResult> analyzeMealPhoto(String imagePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    // Mago di Oz / Assignment 4:
    // qui va collegato il vero endpoint AI per analizzare foto del pasto,
    // allergeni e nutrienti. Il mock serve a simulare l'esperienza finale.
    return const ScanResult(
      recognized: true,
      title: 'Fufu con verdure',
      subtitle: 'Piatto unico - Africano',
      info:
          'Il fufu e un piatto tradizionale africano a base di amido, servito con un ricco stufato di verdure miste. Ottima fonte di carboidrati e fibre.',
      warning:
          'Questo pasto apporta poco ferro rispetto al tuo fabbisogno giornaliero. Integra con alimenti ricchi di ferro.',
      suggestions: ['Spinaci', 'Lenticchie', 'Vitamina C'],
    );
  }

  @override
  Future<ChatMessage> askQuestion({
    required List<ChatMessage> history,
    required String question,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    // Qui andra inserito il chatbot reale, ad esempio OpenAI, inviando
    // profilo utente, allergie, cronologia pasti e tono non giudicante.
    return ChatMessage(
      text:
          'Puoi integrare il ferro con spinaci, lenticchie o ceci. Abbinali a vitamina C, per esempio limone o agrumi, per favorirne l assorbimento.',
      isUser: false,
      time: DateTime.now(),
    );
  }
}
