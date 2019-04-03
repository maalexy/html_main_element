import 'dart:io';
import 'package:html/parser.dart' as HTMLParser;
import 'package:html/dom.dart' as HTML;
import 'package:MainTextHTML/MainTextHTML.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
    });

    test('local/index.html test', () async {
      final htmlFile = File('local/index.html');
      final document = HTMLParser.parse(await htmlFile.readAsBytes());
      final HTML.Element highScoreElem = highestScoringElement(document.body);
      final score = readabilityScore(highScoreElem);
      final HTML.Element highChangeElem = highestChangeElement(document.body);
      final change = scoreChange(highChangeElem);
      print('$highScoreElem, ${score}, ${highScoreElem.hashCode}');
      print('$highChangeElem, ${change}, ${highChangeElem.hashCode}');
    });
  });
}
