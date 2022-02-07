/*final diaryEntriesProvider = StateNotifierProvider<DiaryEntriesProvider, List<DiaryEntry>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    debugPrint('>>> apiService: $apiService');
    return DiaryEntriesProvider(apiService);
  },
);*/

/*final diaryEntriesProvider = StateNotifierProvider<DiaryEntriesProvider, List<DiaryEntry>>(
  (ref) {
    final auth = ref.watch(authStateChangesProvider);
    if (auth.asData?.value != null) {
      final user = auth.asData!.value;
      return DiaryEntriesProvider(user);
    }
    return DiaryEntriesProvider(null);
  },
);*/

/*final diaryEntriesByDate = FutureProvider.autoDispose.family<List<DiaryEntry>, DateTime>((ref, dateTime) async {
  final diaryEntries = ref.watch(diaryEntriesProvider.notifier);
  final result = diaryEntries.findByDate(dateTime);
  return Future.value(result);
});*/

/*final getDiaryEntries = FutureProvider.autoDispose<List<DiaryEntry>>((ref) async {
  final diaryEntries = ref.watch(diaryEntriesProvider);
  final drinks = ref.watch(drinksProvider);
  final result = await diaryEntries.stfetchDiaryEntries(drinks);
  return result;
});

final filterDiaryEntriesByDate = FutureProvider.autoDispose.family<List<DiaryEntry>, DateTime>((ref, dateTime) async {
  final diaryEntries = ref.watch(diaryEntriesProvider);
  final drinks = ref.watch(drinksProvider);
  final result = await diaryEntries.fetchDiaryEntries(drinks);
  return result;
});*/

/*
class _DiaryEntriesProvider extends StateNotifier<List<DiaryEntryAndDrink>> {
  // Constructors
  _DiaryEntriesProvider(this.user, [state]) : super(state ?? []);

  User? user;
  bool _loaded = false;
  bool _loading = false;

  // Getters
  bool get loaded => _loaded;
  bool get loading => _loading;

  // Methods
  DiaryEntryAndDrink findById(String id) {
    return state.firstWhere((diaryEntryAndDrink) => diaryEntryAndDrink.diaryEntry.id == id);
  }

  List<DiaryEntryAndDrink> findByDate(DateTime dateTime) {
    final diaryEntries = state.where((diaryEntryAndDrink) => diaryEntryAndDrink.diaryEntry.dateTime!.day == dateTime.day).toList();
    debugPrint('diaryEntries: $diaryEntries');
    return diaryEntries;
  }

  List<DiaryEntryAndDrink> findByWeek(int weekOfYear) {
    final diaryEntries = state.where((diaryEntryAndDrink) => diaryEntryAndDrink.diaryEntry.dateTime!.weekOfYear == weekOfYear).toList();
    debugPrint('diaryEntries: $diaryEntries');
    return diaryEntries;
  }

  Future<List<DiaryEntryAndDrink>> fetchDiaryEntries([List<Drink>? drinks]) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();

    _loaded = false;
    _loading = true;

    var queryParameters = {'auth': authToken};
    queryParameters.addAll({
      'orderBy': '"dateTime"',
    });

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$userId.json', queryParameters);

    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }

      final List<DiaryEntryAndDrink> loadedDiaryEntries = [];
      extractedData.forEach((diaryEntryId, diaryEntryData) {
        final drinkId = diaryEntryData['drinkId'];
        final volume = diaryEntryData['volume'];
        final drink = drinks!.firstWhere((drink) => drink.id == drinkId);
        final units = calculateUnits(drink.abv!, volume);

        loadedDiaryEntries.add(DiaryEntry(
          id: diaryEntryId,
          drink: drink,
          dateTime: DateTime.parse(diaryEntryData['dateTime']),
          volume: volume,
          units: units,
        ));
      });
      state = loadedDiaryEntries;
      debugPrint('diaryEntries; $state');
      _loaded = true;
      _loading = false;
      return state;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> addDiaryEntry(DiaryEntry diaryEntry) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$userId.json', {'auth': authToken});

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'dateTime': diaryEntry.dateTime!.toIso8601String(),
            'drinkId': diaryEntry.drink!.id,
            'volume': diaryEntry.volume,
          },
        ),
      );

      final jsonResponse = json.decode(response.body);
      final name = jsonResponse['name'];

      final newDiaryEntry = DiaryEntry(
        id: name,
        dateTime: diaryEntry.dateTime,
        drink: diaryEntry.drink,
        volume: diaryEntry.volume,
        units: calculateUnits(diaryEntry.drink!.abv!, diaryEntry.volume!),
      );

      // TODO: Sort out the sort!
      state = [newDiaryEntry, ...state];
      _sortDiaryEntries();

      // Now we can notify the listeners
    } catch (error) {
      debugPrint('!!! $error');
      rethrow;
    }
  }

  Future<void> updateDiaryEntry(String diaryEntryId, DiaryEntry diaryEntry) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();

    final existingDiaryEntryIndex = state.indexWhere((diaryEntry) => diaryEntry.id == diaryEntryId);
    if (existingDiaryEntryIndex >= 0) {
      final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$userId/$diaryEntryId.json', {'auth': authToken});

      try {
        final response = await http.patch(
          url,
          body: json.encode(
            {
              'dateTime': diaryEntry.dateTime!.toIso8601String(),
              'drinkId': diaryEntry.drink!.id,
              'volume': diaryEntry.volume,
            },
          ),
        );

        if (response.statusCode >= 400) {
          debugPrint('!!! Could not update diary entry');
          throw HttpException('Could not update diary entry.');
        }

        state[existingDiaryEntryIndex] = diaryEntry;
        _sortDiaryEntries();
      } catch (error) {
        debugPrint(error.toString());
        rethrow;
      }
    }
  }

  void _sortDiaryEntries() {
    state.sort((DiaryEntry a, DiaryEntry b) => a.dateTime!.compareTo(b.dateTime!));
  }

  void refreshDiaryEntries(Drink drink) {
    state.where((DiaryEntry diaryEntry) => diaryEntry.drink!.id == drink.id).forEach((diaryEntry) {
      final diaryEntryIndex = state.indexWhere((item) => item.id == diaryEntry.id);
      state[diaryEntryIndex] = diaryEntry.copyWith(
        drink: drink,
        units: calculateUnits(drink.abv!, diaryEntry.volume!),
      );
    });
  }

  Future<void> deleteDiaryEntry(String diaryEntryId) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$userId/$diaryEntryId.json', {'auth': authToken});
    int? existingDiaryEntryIndex = state.indexWhere((diaryEntry) => diaryEntry.id == diaryEntryId);
    var existingDiaryEntry = state[existingDiaryEntryIndex];
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      state.insert(existingDiaryEntryIndex, existingDiaryEntry);
      throw HttpException('Could not delete diary entry.');
    } else {
      state.removeAt(existingDiaryEntryIndex);
      existingDiaryEntryIndex = null;
    }
  }

  Future<void> duplicateDiaryEntry(DiaryEntry diaryEntry) async {
    final duplicatedDiaryEntry = diaryEntry.copyWith(id: null);
    try {
      await addDiaryEntry(duplicatedDiaryEntry);
      state = state;
    } catch (error) {
      debugPrint(error.toString());
    }
    _sortDiaryEntries();
  }
}
*/
