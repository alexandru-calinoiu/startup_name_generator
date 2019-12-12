// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordState();
}

class RandomWordState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Startup name generator'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
          ]
      ),
      body: _buildSuggestions(),
    );
  }

  _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (context) {
              final Iterable<ListTile> tiles = _saved.map(
                      (pair) {
                    return ListTile(
                      title: Text(pair.asPascalCase, style: _biggerFont),
                    );
                  }
              );
              final divided = ListTile
                  .divideTiles(tiles: tiles, context: context)
                  .toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved suggestions'),
                ),
                body: ListView(children: divided),
              );
            }
        )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(prefix0.generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool saved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
          saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.red : null
      ),
      onTap: () {
        _onTap(pair, saved);
      },
    );
  }

  _onTap(WordPair pair, bool alreadySaved) {
    setState(() {
      alreadySaved ? _saved.remove(pair) : _saved.add(pair);
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Geneator',
      theme: ThemeData(
        primaryColor: Colors.lightGreen
      ),
      home: RandomWords(),
    );
  }
}