import 'dart:io';
import 'package:html/parser.dart' as html_parser;

import 'package:MainTextHTML/html_main_element.dart';
import 'package:MainTextHTML/src/print_tree.dart';

main() async {
  // Load and parse html document
  final htmlFile = File('test/local/index.html');
  final document = html_parser.parse(await htmlFile.readAsBytes());
  // Genererate score map and get score for every html element
  final scoreMapReadability = readabilityScore(document.documentElement);
  printTree(scoreMapReadability, document.documentElement);
  // Get the best scoring html element
  final bestElemReadability = readabilityMainElement(document.documentElement);
  print(bestElemReadability.outerHtml);
}