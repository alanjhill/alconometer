import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/diary_entry.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

class EditDiaryEntryArguments {
  EditDiaryEntryArguments({required this.drinkType, this.drink, this.id});
  final DrinkType drinkType;
  final Drink? drink;
  final String? id;
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
  final _drinkTextController = TextEditingController();
  final _drinkSuggestionsBoxController = SuggestionsBoxController();
  final _dateTextController = TextEditingController();
  final _timeTextController = TextEditingController();

  var _editedDiaryEntry = DiaryEntry(id: null, dateTime: DateTime.now(), drink: const Drink.empty(), volume: 0.0, units: 0.0);
  final _formKey = GlobalKey<FormState>();

  String? _drinkId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.args.id != null) {
      final diaryEntries = ref.read(diaryEntriesProvider.notifier);
      _editedDiaryEntry = diaryEntries.findById(widget.args.id!);
      _drinkTextController.text = _editedDiaryEntry.drink!.name;
    }
    _dateTextController.text = DateFormat('yyyy-MM-dd').format(_editedDiaryEntry.dateTime!);
    _timeTextController.text = DateFormat('hh:mm').format(_editedDiaryEntry.dateTime!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final drinks = ref.read(drinksProvider);
    final drinksList = drinks;
    return Scaffold(
      appBar: AppBar(title: Text(widget.args.drink != null ? widget.args.drink!.name : 'Add Diary Entry')),
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
                  buildDrinkSelect(context, drinksList),
                  buildVolumeField(),
                  buildDateField(context),
                  buildTimeField(context),
                  buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrinkSelect(BuildContext context, List<Drink> drinks) {
    return SearchChoices.single(
      items: getDropdownItems(drinks),
      value: _editedDiaryEntry.drink,
      searchFn: searchFunction,
      onChanged: (drink) {
        if (drink != null) {
          _editedDiaryEntry = _editedDiaryEntry.copyWith(drink: drink);
        } else {
          _editedDiaryEntry = _editedDiaryEntry.copyWith(drink: const Drink.empty());
        }
      },
      isExpanded: true,
      style: Theme.of(context).textTheme.headline3,
      iconEnabledColor: Theme.of(context).primaryColor,
      underline: Container(
        height: 1.0,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1.0))),
      ),
      searchInputDecoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[900]!),
        ),
      ),
    );
  }

  List<int> searchFunction(String keyword, items) {
    List<int> ret = [];
    if (items != null && keyword.isNotEmpty) {
      keyword.split(" ").forEach((k) {
        int i = 0;
        items.forEach((item) {
          if (!ret.contains(i) && k.isNotEmpty && (item.value.name.toString().toLowerCase().contains(k.toLowerCase()))) {
            ret.add(i);
          }
          i++;
        });
      });
    }
    if (keyword.isEmpty) {
      ret = Iterable<int>.generate(items.length).toList();
    }
    return (ret);
  }

  List<DropdownMenuItem<Drink>> getDropdownItems(List<Drink> drinks) {
    List<DropdownMenuItem<Drink>> items = [];
    drinks.forEach((drink) {
      items.add(DropdownMenuItem<Drink>(child: Text(drink.name), value: drink));
    });
    return items;
  }

  TextFormField buildVolumeField() {
    return TextFormField(
      initialValue: _editedDiaryEntry.volume != 0.0 ? _editedDiaryEntry.volume.toString() : '',
      decoration: const InputDecoration(labelText: 'Volume', labelStyle: TextStyle(color: Colors.grey)),
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

  Widget buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dateTextController,
      decoration: const InputDecoration(labelText: 'Date', labelStyle: TextStyle(color: Colors.grey)),
      readOnly: true,
      onTap: () async {
        final currentDate = DateTime.now();
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: _editedDiaryEntry.dateTime!,
          firstDate: DateTime(2020),
          lastDate: DateTime(currentDate.year + 5),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Palette.primaryMaterialColor,
                  //brightness: Brightness.light,
                ),
              ),
              child: child!,
            );
          },
          locale: const Locale('en', 'GB'),
        );
        if (selectedDate != null) {
          _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: selectedDate);
          _dateTextController.text = DateFormat('yyyy-MM-dd').format(_editedDiaryEntry.dateTime!);
        }
      },
    );
  }

  Widget buildTimeField(BuildContext context) {
    return TextFormField(
      controller: _timeTextController,
      decoration: const InputDecoration(labelText: 'Time', labelStyle: TextStyle(color: Colors.grey)),
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_editedDiaryEntry.dateTime!),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (selectedTime != null) {
          var selectedDate = _editedDiaryEntry.dateTime;
          var newDate = DateTime(selectedDate!.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
          _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: newDate);
          _timeTextController.text = DateFormat('HH:mm').format(_editedDiaryEntry.dateTime!);
        }
      },
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return TextFormField(
      controller: _timeTextController,
      decoration: const InputDecoration(labelText: 'Time', labelStyle: TextStyle(color: Colors.grey)),
      onTap: () async {
        final selectedTime = await showRoundedTimePicker(
          context: context,
          locale: const Locale('en', 'GB'),
          initialTime: TimeOfDay.fromDateTime(_editedDiaryEntry.dateTime!),
          theme: ThemeData.light().copyWith(
            primaryColor: Palette.primaryColor,
            primaryTextTheme: ThemeData.light().textTheme,
            textButtonTheme: ThemeData.light().textButtonTheme,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Palette.primaryMaterialColor,
              //brightness: Brightness.light,
            ),
          ),
        );
        if (selectedTime != null) {
          var selectedDate = _editedDiaryEntry.dateTime;
          var newDate = DateTime(selectedDate!.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
          _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: newDate);
          _timeTextController.text = DateFormat('HH:mm').format(_editedDiaryEntry.dateTime!);
        }
      },
    );
  }

  Widget buildButtons(BuildContext context) {
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
            child: const Text('Save'),
            onPressed: () {
              _saveForm(ref);
            }),
      ],
    );
  }

  void _onItemSelected(Drink drink) {
    debugPrint('selected: ${drink.name}');
  }

  List<Drink> _getDrinksFilteredByName(List<Drink> drinks, String filter) {
    List<Drink> filteredDrinks = [];
    for (var drink in drinks) {
      if (drink.filterByName(filter)) {
        filteredDrinks.add(drink);
      }
    }
    debugPrint('>>> filteredDrinks: $filteredDrinks');
    return filteredDrinks;
  }

  Future<void> _presentDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _editedDiaryEntry.dateTime ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _editedDiaryEntry = _editedDiaryEntry.copyWith(dateTime: pickedDate);
      debugPrint(_editedDiaryEntry.toString());
      //_dateTextController.text = pickedDate.toString();
    });
  }

  RenderBox? _findBorderBox(RenderBox box) {
    RenderBox? borderBox;

    box.visitChildren((child) {
      if (child is RenderCustomPaint) {
        borderBox = child;
      }

      final box = _findBorderBox(child as RenderBox);
      if (box != null) {
        borderBox = box;
      }
    });

    return borderBox;
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

    final diaryEntriesNotifier = ref.read(diaryEntriesProvider.notifier);
    if (_editedDiaryEntry.id == null) {
      await diaryEntriesNotifier.addDiaryEntry(_editedDiaryEntry);
    } else {
      await diaryEntriesNotifier.updateDiaryEntry(_editedDiaryEntry.id!, _editedDiaryEntry);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _drinkTextController.dispose();
    //_drinkSuggestionsBoxController.dispose();
  }
}
