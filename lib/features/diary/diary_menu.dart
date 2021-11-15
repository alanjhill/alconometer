import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiaryMenu extends StatefulWidget {
  const DiaryMenu({Key? key}) : super(key: key);

  @override
  _DiaryMenuState createState() => _DiaryMenuState();
}

class _DiaryMenuState extends State<DiaryMenu> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16.0,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.black,
            //gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: <Color>[Colors.black, Colors.blueGrey]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'ADD DRINK TO DIARY',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.beer),
                      SizedBox(height: 8.0),
                      Text('Beer'),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.wineGlassAlt),
                      SizedBox(height: 8.0),
                      Text(
                        'Wine',
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.glassWhiskey),
                      SizedBox(height: 8.0),
                      Text(
                        'Spirit',
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Icon(Icons.keyboard_arrow_down_outlined),
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  fixedSize: const Size(32, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
