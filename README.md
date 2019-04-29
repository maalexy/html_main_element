# html_main_element

Detects the main element of a HTML web page, which represents the core article of that page 
using a similar algorithm to [Readability](https://github.com/mozilla/readability). 

## Usage

A simple usage example:

```dart
import 'dart:io';
import 'package:html/parser.dart' as html_parser;

import 'package:html_main_element/html_main_element.dart';

void main() async {
  // Load and parse html document
  final htmlFile = File('test/local/index.html');
  final document = html_parser.parse(await htmlFile.readAsBytes());
  // Genererate score map and get score for every html element
  final scoreMapReadability = readabilityScore(document.documentElement);
  // Get the best scoring html element
  final bestElemReadability = readabilityMainElement(document.documentElement);
  print(bestElemReadability.outerHtml);
}
```
