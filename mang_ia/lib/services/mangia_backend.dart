import '../models/models.dart';

abstract class MangiaBackend {
  Future<void> saveWaterGlasses(int glasses);

  Future<List<Expert>> fetchExperts(UserProfile profile);
}

class MockMangiaBackend implements MangiaBackend {
  @override
  Future<void> saveWaterGlasses(int glasses) async {
    // Qui andra collegato Firebase/Firestore o il backend reale per salvare
    // idratazione, pasti recenti, preferenze, allergie e progressi.
  }

  @override
  Future<List<Expert>> fetchExperts(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // In produzione il match sara calcolato dal backend usando obiettivi,
    // budget, disponibilita, allergeni e stile alimentare.
    return const [
      Expert(
        name: 'Dott.ssa Elena Rossi',
        specialty: 'Nutrizionista Clinica',
        location: 'Roma',
        matchRate: 96,
        price: '60 euro/sessione',
        availableToday: true,
        tags: ['Nutrizione sportiva', 'Plant-based', 'Carenze minerali'],
        reason:
            'Ti aiuta a integrare il ferro e a creare pasti sostenibili per giornate intense.',
        imageUrl:
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=240&h=240&fit=crop&crop=faces',
      ),
      Expert(
        name: 'Dott. Marco Ferretti',
        specialty: 'Dietista',
        location: 'Milano',
        matchRate: 91,
        price: '50 euro/sessione',
        availableToday: false,
        tags: ['Metabolismo', 'Dieta mediterranea', 'Stili di vita attivi'],
        reason:
            'Lavora su abitudini pratiche per chi ha poco tempo e pasti fuori casa.',
        imageUrl:
            'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=240&h=240&fit=crop&crop=faces',
      ),
      Expert(
        name: 'Dott.ssa Sofia Mancini',
        specialty: 'Biologa Nutrizionista',
        location: 'Napoli',
        matchRate: 84,
        price: '45 euro/sessione',
        availableToday: true,
        tags: ['Intolleranze', 'Cucina africana', 'Benessere olistico'],
        reason:
            'Profilo adatto se vuoi mantenere piatti culturali adattandoli ai tuoi bisogni.',
        imageUrl:
            'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=240&h=240&fit=crop&crop=faces',
      ),
    ];
  }
}
