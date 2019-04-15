import 'dart:io';
import 'package:html/parser.dart' as HTMLParser;
import 'package:MainTextHTML/MainTextHTML.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    // *///
    test('local/index.html high score test', () async {
      final htmlFile = File('test/local/index.html');
      final document = HTMLParser.parse(await htmlFile.readAsBytes());
      final highScoreElem = highestScoringElement(document.documentElement);
      final score = readabilityScore(highScoreElem);
      print('$highScoreElem, ${score}, ${highScoreElem.hashCode}');
      print('${highScoreElem.outerHtml}');
    }); // *///
    test('local/index.html diff score test', () async {
      final htmlFile = File('test/local/index.html');
      final document = HTMLParser.parse(await htmlFile.readAsBytes());
      final highChangeElem = highestChangeElement(document.documentElement);
      final change = scoreChange(highChangeElem);
      print('$highChangeElem, ${change}, ${highChangeElem.hashCode}');
      print('${highChangeElem.outerHtml}');
    });
  });
}
