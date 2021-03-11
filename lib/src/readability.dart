import 'dart:core';
import 'dart:math';
import 'package:html/dom.dart' as html;
import 'utils.dart';

/// Rules for readability scoring based on github.com/mozilla/readablility:
///  - Only check for certain tags (conf.readableTags)
///  - Large score (+-25) based on class (conf.positiveClasses/negativeClasses)
///  /* - Some points based on the tag */
///  - 0 point if the paragraph has less than 25 characters
///  - +1 point as base
///  - +1 point for every comma in this paragraph
///  - +1 point for every 100 characters, up to 3 points
///  - *(1 - link_density) after these steps
///  - +Sum of every direct child's score
///  - +Sum/2 of every second child's score
///  - +Sum/(3*level) of every child's score at level deep

Map<html.Element, double> readabilityScore(html.Element root,
    [ReadabilityConfig? conf]) {
  final scoreMap = _calcReadabilityScore(root, conf);
  _propagateScore(root, scoreMap);
  return scoreMap;
}

/// Returns the highest scoring element under root
/// using readability algorithm with conf configuration.
html.Element readabilityMainElement(html.Element root,
    [ReadabilityConfig? conf]) {
  return highestScoringElement(readabilityScore(root, conf));
}

Map<html.Element, double> _calcReadabilityScore(html.Element root,
    [ReadabilityConfig? conf]) {
  var scoreMap = <html.Element, double>{};
  final rscore = _localReadabilityScore(root, conf); // root score
  scoreMap[root] = rscore;
  for (final child in root.children) {
    // call for all children
    final childMap = _calcReadabilityScore(child);
    scoreMap.addAll(childMap);
  }
  return scoreMap;
}

/// Configuration class for readability algorithm
/// Class and tag names should be lowercase characters
class ReadabilityConfig {
  /// List of the readable tags which should be tested by the algorithm
  final List<String>? readableTags;

  /// List of positive classes, where elements should have +25 points.
  final List<String>? positiveClasses;

  /// List of negative classes, where elements should have -25 points.
  final List<String>? negativeClasses;

  /// Constructor for the configuration class
  ReadabilityConfig(
      {this.readableTags, this.positiveClasses, this.negativeClasses});
}

double _localReadabilityScore(html.Element node, [ReadabilityConfig? conf]) {
  conf ??= defaultReadabilityConfig;
  if (!conf.readableTags!.contains(node.localName!.toLowerCase())) {
    return 0;
  }

  var intexts = '';
  for (final cnode in node.nodes) {
    if (cnode.nodeType == html.Node.TEXT_NODE) {
      intexts += cnode.text!.trim();
    }
  }

  intexts = intexts.replaceAll(RegExp('\\s+'), ' ').trim();

  if (intexts.length < 25) {
    return 0;
  }

  var score = 1.0;
  for (final cls in node.classes) {
    if (conf.positiveClasses!.contains(cls.toLowerCase())) {
      score += 25;
    }
    if (conf.negativeClasses!.contains(cls.toLowerCase())) {
      score -= 25;
    }
  }
  score += intexts.split(',').length;

  score += min((intexts.length / 100).floorToDouble(), 3.0);

  if (node.children.isNotEmpty) {
    var linkNum = 0;
    for (final elem in node.children) {
      if (elem.localName == 'a') {
        linkNum += 1;
      }
    }
    final linkDensity = linkNum / node.children.length;
    score *= (1 - linkDensity);
  }

  return score;
}

/* First propagate THEN call child. somehow this is a better order.
 */
Map<html.Element, double> _propagateScore(
    html.Element node, Map<html.Element, double> scoreMap) {
  // Send score up
  final score = scoreMap[node]!;
  var level = 1;
  var cnode = node.parent;
  while (cnode != null && scoreMap.containsKey(cnode)) {
    if (1 == level) {
      scoreMap[cnode] = scoreMap[cnode]! + score;
    } else if (2 == level) {
      scoreMap[cnode] = scoreMap[cnode]! + score / 2;
    } else {
      scoreMap[cnode] = scoreMap[cnode]! + score / (3 * level);
    }
    print(node);
    print(cnode);
    cnode = cnode.parent;
    level += 1;
  }

  // Call recursively
  for (final child in node.children) {
    _propagateScore(child, scoreMap);
  }

  return scoreMap;
}

/// Default configuration for the readability algorithm.
final ReadabilityConfig defaultReadabilityConfig = ReadabilityConfig(
  readableTags: [
    'p',
    'div',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'td',
    'pre',
  ],
  positiveClasses: [
    'article',
    'body',
    'content',
    'entry',
    'hentry',
    'h-entry',
    'main',
    'page',
    'pagination',
    'post',
    'text',
    'blog',
    'story',
  ],
  negativeClasses: [
    'hidden',
    ' hid ',
    'banner',
    'combx',
    'comment',
    'com-',
    'contact',
    'foot',
    'footer',
    'footnote',
    'gdpr',
    'masthead',
    'media',
    'meta',
    'outbrain',
    'promo',
    'related',
    'scroll',
    'share',
    'shoutbox',
    'sidebar',
    'skyscraper',
    'sponsor',
    'shopping',
    'tags',
    'tool',
    'widget',
  ],
);
