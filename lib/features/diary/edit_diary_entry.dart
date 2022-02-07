import 'package:alconometer/features/drinks/drinks_screen.dart';
import 'package:alconometer/models/diary_entry.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/theme/alconometer_theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditDiaryEntryArguments {
  EditDiaryEntryArguments({required this.drinkType, this.diaryEntryAndDrink, this.drink});
  final DrinkType drinkType;
  final DiaryEntryAndDrink? diaryEntryAndDrink;
  final Drink? drink;
}

class EditDiaryEntry extends ConsumerStatefulWidget {
  static const routeName = '/edit-diary-entry';

  const EditDiaryEntry({Key? key, required this.args}) : super(key: key);
  final EditDiaryEntryArguments args;

  @override
  _EditDiaryEntryState createState() => _EditDiaryEntryState();
}

class _EditDiaryEntryState extends ConsumerState<EditDiaryEntry> {
  //final _drinkFocusNode = FocusNode();
  //final _volumeFocusNode = FocusNode();
  //final _dateTimeNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  //final _drinkTextController = TextEditingController();
  //final _drinkSuggestionsBoxController = SuggestionsBoxController();
  //final _dateTimeTextController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _timeTextController = TextEditingController();

  //var _editedDrink = Drink(id: nu);

  DiaryEntry _editedDiaryEntry = DiaryEntry(id: null, dateTime: null, drinkId: null, volume: 0.0);
  Drink? _selectedDrink;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (widget.args.diaryEntryAndDrink == null) {
        // displayedDate is UTC
        final displayedDate = ref.read(appStateProvider).displayedDate;
        final now = DateTime.now();
        final dateTime = DateTime(displayedDate!.year, displayedDate.month, displayedDate.day, now.hour, now.minute, now.second, now.millisecond);
        setState(() {
          _editedDiaryEntry = DiaryEntry(
            id: _editedDiaryEntry.id,
            drinkId: widget.args.drink != null ? widget.args.drink!.id : _editedDiaryEntry.drinkId,
            dateTime: dateTime.toUtc(),
            volume: _editedDiaryEntry.volume,
          );

          if (widget.args.drink != null) {
            var drink = widget.args.drink!;
            _selectedDrink = Drink(
              id: drink.id,
              name: drink.name,
              type: drink.type,
              abv: drink.abv,
            );
          }
        });
      } else {
        setState(() {
          var diaryEntry = widget.args.diaryEntryAndDrink!.diaryEntry;
          _editedDiaryEntry = DiaryEntry(
            id: diaryEntry.id,
            drinkId: diaryEntry.drinkId,
            dateTime: diaryEntry.dateTime!.toLocal(),
            volume: diaryEntry.volume,
          );
          var drink = widget.args.diaryEntryAndDrink!.drink;
          _selectedDrink = Drink(
            id: drink.id,
            name: drink.name,
            type: drink.type,
            abv: drink.abv,
          );
          debugPrint('_editedDiaryEntry: $_editedDiaryEntry');
        });
      }
      final appSettings = ref.read(appSettingsProvider);
      _dateTextController.text = DateFormat(appSettings.dateFormat).format(_editedDiaryEntry.dateTime!.toLocal());
      _timeTextController.text = DateFormat(appSettings.timeFormat).format(_editedDiaryEntry.dateTime!.toLocal());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_selectedDrink != null ? _selectedDrink!.name : 'Add Diary Entry')),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drinks
                  const SizedBox(height: 16.0),
                  _buildDrinkSelect(context),
                  _buildVolumeField(),
                  //Text(_editedDiaryEntry.dateTime!.toLocal().toString()),
                  _buildDateField(context),
                  _buildTimeField(context),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrinkSelect(BuildContext context) {
    return DropdownSearch<Drink>(
        popupItemBuilder: _drinkPopupItemBuilder,
        selectedItem: _selectedDrink,
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Drink',
          isDense: false,
          isCollapsed: true,
        ),
        items: _getDrinks(),
        compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
        itemAsString: (Drink? d) => d!.name,
        showSearchBox: true,
        showClearButton: true,
        clearButton: const Icon(Icons.close),
        validator: (value) {
          debugPrint('value: $value');
          if (value == null) {
            return 'Please select a drink';
          }
          return null;
        },
        onChanged: (drink) {
          if (drink != null) {
            setState(() {
              _editedDiaryEntry = _editedDiaryEntry.copyWith(drinkId: drink.id);
              _selectedDrink = drink.copyWith();
            });
          } else {
            setState(() {
              _editedDiaryEntry = _editedDiaryEntry.copyWith(drinkId: null);
              _selectedDrink = null;
            });
          }
        });
  }

  TextFormField _buildVolumeField() {
    return TextFormField(
      initialValue: _editedDiaryEntry.volume != 0.0 ? _editedDiaryEntry.volume.toString() : '',
      decoration: const InputDecoration(labelText: 'Volume'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter the volume';
        }
        return null;
      },
      onSaved: (value) {
        _editedDiaryEntry = _editedDiaryEntry.copyWith(volume: double.parse(value!));
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    return TextFormField(
      controller: _dateTextController,
      decoration: const InputDecoration(labelText: 'Date', labelStyle: TextStyle(color: Colors.grey)),
      readOnly: true,
      onTap: () async {
        final currentDate = DateTime.now();
        final selectedDate = await showDatePicker(
            context: context,
            initialDate: _editedDiaryEntry.dateTime!,
            firstDate: DateTime.utc(currentDate.year - 5),
            lastDate: DateTime.utc(currentDate.year + 1),
            locale: const Locale('en', 'GB'),
            builder: (BuildContext context, Widget? child) => Theme(
                  data: appSettings.darkMode! ? AlconometerTheme.datePickerDark() : AlconometerTheme.datePickerLight(),
                  child: child!,
                ));
        if (selectedDate != null) {
          final appSettings = ref.watch(appSettingsProvider);
          setState(() {
            final localDate = _editedDiaryEntry.dateTime!.toLocal();
            final newDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, localDate.hour, localDate.minute);
            _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: newDate);
            _dateTextController.text = DateFormat(appSettings.dateFormat).format(_editedDiaryEntry.dateTime!);
          });
        }
      },
    );
  }

  Widget _buildTimeField(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    return TextFormField(
      controller: _timeTextController,
      decoration: const InputDecoration(labelText: 'Time', labelStyle: TextStyle(color: Colors.grey)),
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_editedDiaryEntry.dateTime!.toLocal()),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: appSettings.time24Hour),
              child: Theme(data: appSettings.darkMode! ? AlconometerTheme.timePickerDark() : AlconometerTheme.timePickerLight(), child: child!),
            );
          },
        );
        if (selectedTime != null) {
          final appSettings = ref.watch(appSettingsProvider);
          var selectedDate = _editedDiaryEntry.dateTime!.toLocal();
          var newDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
          setState(() {
            _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: newDate);
            _timeTextController.text = DateFormat(appSettings.timeFormat).format(_editedDiaryEntry.dateTime!);
          });
        }
      },
    );
  }

  Widget _drinkPopupItemBuilder(BuildContext context, Drink? item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
        subtitle: Text(item?.abv.toString() ?? ''),
      ),
    );
  }

  List<Drink> _getDrinks() {
    final drinksAsyncValue = ref.watch(drinksByTypeStreamProvider(widget.args.drinkType));
    List<Drink> items = [];
    drinksAsyncValue.whenData((drinks) {
      for (var drink in drinks) {
        items.add(drink);
      }
    });
    return items;
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        const SizedBox(width: 16.0),
        ElevatedButton(
            child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white)) : const Text('Save'),
            onPressed: () {
              _saveForm(ref);
            }),
      ],
    );
  }

  Future<void> _saveForm(WidgetRef ref) async {
    debugPrint('>>> _saveForm()');
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final database = ref.read(databaseProvider);
    if (_editedDiaryEntry.id == null) {
      await database.addDiaryEntry(_editedDiaryEntry);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added new diary entry'),
        duration: Duration(milliseconds: 800),
      ));
    } else {
      await database.updateDiaryEntry(_editedDiaryEntry.id!, _editedDiaryEntry);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Updated diary entry'),
        duration: Duration(milliseconds: 800),
      ));
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    //_drinkTextController.dispose();
    //_drinkSuggestionsBoxController.dispose();
  }
}
