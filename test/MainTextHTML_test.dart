import 'dart:io';
import 'package:html/parser.dart' as html_parser;
import 'package:MainTextHTML/MainTextHTML.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    // *///
    test('local/index.html high score test', () async {
      final htmlFile = File('test/local/index.html');
      final document = html_parser.parse(await htmlFile.readAsBytes());
      final scoreMap = readabilityScore(document.documentElement);
      final bestElem = highestScoringElement(scoreMap);
      //printTree(scoreMap, document.documentElement);
      //print('$bestElem, ${score}, ${highScoreElem.hashCode}');
      print('${bestElem.outerHtml}');
      assert(bestElem.classes.contains("cikk-torzs"));
    });
    test('local/origo.html high score test', () async {
      final htmlFile = File('test/local/origo.html');
      final document = html_parser.parse(await htmlFile.readAsBytes());
      final scoreMap = readabilityScore(document.documentElement);
      final bestElem = highestScoringElement(scoreMap);
      //printTree(scoreMap, document.documentElement);
      //print('$bestElem, ${score}, ${highScoreElem.hashCode}');
      print('${bestElem.outerHtml}');
      assert(bestElem.id.contains("article-text"));
    });
    /*///
    test('local/index.html diff score test', () async {
      final htmlFile = File('test/local/index.html');
      final document = HTMLParser.parse(await htmlFile.readAsBytes());
      final highChangeElem = highestChangeElement(document.documentElement);
      final change = scoreChange(highChangeElem);
      print('$highChangeElem, ${change}, ${highChangeElem.hashCode}');
      print('${highChangeElem.outerHtml}');
    }); // */ //
  });
}
