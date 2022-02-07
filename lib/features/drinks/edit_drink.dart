import 'package:alconometer/features/home/tab_manager.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/database.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drinkStreamProvider = StreamProvider.autoDispose.family<Drink, String>((ref, drinkId) {
  final database = ref.watch(databaseProvider);
  return database.drinkStream(drinkId);
});

class EditDrinkArguments {
  EditDrinkArguments({required this.drinkType, this.drink});
  final DrinkType drinkType;
  final Drink? drink;
}

class EditDrink extends ConsumerStatefulWidget {
  static const routeName = '/edit-drink';

  EditDrink({Key? key, required this.args}) : super(key: key);
  final EditDrinkArguments args;

  @override
  _EditDrinkState createState() => _EditDrinkState();
}

class _EditDrinkState extends ConsumerState<EditDrink> {
  //final _drinkTypeController = TextEditingController();
  //final _nameController = TextEditingController();
  //final _abvController = TextEditingController();
  final _drinkTypeFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _abvFocusNode = FocusNode();

  var _editedDrink = Drink(id: null, name: '', type: DrinkType.beer, abv: 0.0);

/*  var _initialValues = {
    'drinkType': DrinkType.beer,
    'name': '',
    'abv': '',
  };*/

  final _formKey = GlobalKey<FormState>();

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
      debugPrint('>>> didChangeDependencies');
      if (widget.args.drink == null) {
        setState(() {
          _editedDrink = Drink(
            id: _editedDrink.id,
            type: widget.args.drinkType,
            name: _editedDrink.name,
            abv: _editedDrink.abv,
          );
        });
      } else {
        setState(() {
          _editedDrink = widget.args.drink!;
          debugPrint('_editedDrink: $_editedDrink');
        });
      }
      debugPrint('<<< didChangeDependencies');
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(_editedDrink.name)),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                      const SizedBox(height: 16.0),
                      DropdownButton<DrinkType>(
                        isDense: false,
                        value: _editedDrink.type,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.button!.color,
                        ),
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (DrinkType? drinkType) {
                          debugPrint('value: $drinkType');
                          setState(() {
                            _editedDrink = _editedDrink.copyWith(type: drinkType!);
                          });
                        },
                        items: DrinkType.values.map((DrinkType drinkType) {
                          return DropdownMenuItem<DrinkType>(
                            value: drinkType,
                            child: Text(
                              getDrinkTypeText(drinkType),
                              style: const TextStyle(fontSize: 24.0),
                            ),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                          initialValue: _editedDrink.name,
                          decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.grey)),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedDrink = _editedDrink.copyWith(name: value!);
                          }),
                      TextFormField(
                          initialValue: _editedDrink.abv != 0.0 ? _editedDrink.abv.toString() : '',
                          decoration: const InputDecoration(labelText: 'ABV', labelStyle: TextStyle(color: Colors.grey)),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the ABV value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedDrink = _editedDrink.copyWith(abv: double.parse(value!));
                          }),
                      Row(
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
                            onPressed: _saveForm,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _saveForm() async {
    debugPrint('>>> _saveForm()');
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    //final drinks = ref.read(drinksStreamProvider);
    final database = ref.read<Database?>(databaseProvider)!;
    if (_editedDrink.id == null) {
      await database.addDrink(_editedDrink);
      final tabManager = ref.read(tabManagerProvider);
      tabManager.goToDrinks();
      //tabManager.goToTab(_editedDrink.type);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added new drink'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    } else {
      await database.updateDrink(_editedDrink.id!, _editedDrink);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated drink'),
          duration: Duration(milliseconds: 1000),
        ),
      );
      //await drinks.updateDrink(_editedDrink.id!, _editedDrink);
      //final diaryEntries = ref.read(drinksStreamProvider);
      //diaryEntries.refreshDiaryEntries(_editedDrink);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
