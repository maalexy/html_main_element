library MainTextHTML;

import 'dart:core';
import 'dart:math';
import 'package:html/dom.dart' as html;

export 'src/MainTextHTML_base.dart';

/*
Root is the document.
It will have a ELEMENT_NODE with 'html' localname, (and maybe some other).
Element nodes can have element children. Node list will have text nodes also.
Text nodes will include every whitespace.
 */

/*
main() async {
  //*
  // *///
  /*
  var htmlFile = '''
  <div>
    <span style=”font-size: 200%;”>H</span>

    <span>ello<span>

  </div>
''';
  var document = HTMLParser.parse(htmlFile);
  */
  _walkNodes(document);
}
*/

/// Rules for readability scoring based on github.com/mozilla/readablility:
///  - Only check for certain tags (?)
///  - Large base score based on class
///  - Some points based on the tag
///  - 0 point if the paragraph has less than 25 characters (*)
///  - +1 point as base (*)
///  - +1 point for every comma in this paragraph (*)
///  - +1 point for every 100 characters, up to 3 points (*)
///  - +Sum of every direct child's score (*)
///  - +Sum/2 of every second child's score (*)
///  - +Sum/(3*level) of every child's score at level deep (*)
///  - *(1 - link_density) as a final step (*)

Map<html.Element, double> readabilityScore(html.Element root,
    [ReadabilityConfig conf]) {
  final scoreMap = calcReadabilityScore(root, conf);
  propagateScore(root, scoreMap);
  return scoreMap;
}

Map<html.Element, double> calcReadabilityScore(html.Element root,
    [ReadabilityConfig conf]) {
  var scoreMap = <html.Element, double>{};
  final rscore = localReadabilityScore(root, conf); // root score
  scoreMap[root] = rscore;
  for (final child in root.children) {
    // call for all children
    final childMap = calcReadabilityScore(child);
    scoreMap.addAll(childMap);
  }
  return scoreMap;
}

class ReadabilityConfig {
  List<String> readableTags;
  List<String> positiveClasses;
  List<String> negativeClasses;
}

final ReadabilityConfig defaultReadabilityConfig = ReadabilityConfig()
  ..readableTags = ['p', 'div', 'h2', 'h3', 'h4', 'h5', 'h6', 'td', 'pre']
  ..positiveClasses = [
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
    'story'
  ]
  ..negativeClasses = [
    'hidden',
    '^hid\$',
    ' hid\$',
    ' hid ',
    '^hid ',
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
    'widget'
  ];

double localReadabilityScore(html.Element node, [ReadabilityConfig conf]) {
  conf ??= defaultReadabilityConfig;
  if (!conf.readableTags.contains(node.localName)) {
    return 0;
  }

  var intexts = "";
  for (final cnode in node.nodes) {
    if (cnode.nodeType == html.Node.TEXT_NODE) {
      intexts += cnode.text.trim();
    }
  }

  intexts = intexts.replaceAll(RegExp('\\s+'), ' ').trim();

  if (intexts.length < 25) {
    return 0;
  }

  var score = 1.0;
  for (final cls in node.classes) {
    if (conf.positiveClasses.contains(cls)) {
      score += 25;
    }
    if (conf.negativeClasses.contains(cls)) {
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
Map<html.Element, double> propagateScore(
    html.Element node, Map<html.Element, double> scoreMap) {
  // Send score up
  final score = scoreMap[node];
  var level = 1;
  var cnode = node.parent;
  while (cnode != null && scoreMap.containsKey(cnode)) {
    if (1 == level) {
      scoreMap[cnode] += score;
    } else if (2 == level) {
      scoreMap[cnode] += score / 2;
    } else {
      scoreMap[cnode] += score / (3 * level);
    }
    print(node);
    print(cnode);
    cnode = cnode.parent;
    level += 1;
  }

  // Call recursively
  for (final child in node.children) {
    propagateScore(child, scoreMap);
  }

  return scoreMap;
}

html.Element highestScoringElement(Map<html.Element, double> scoreMap) {
  return scoreMap.entries
      .reduce((val, elem) => val.value > elem.value ? val : elem)
      .key;
}

Map<html.Element, double> scoreChange(Map<html.Element, double> scoreMap) {
  final scoreDiff = <html.Element, double>{};
  for (final entry in scoreMap.entries) {
    if (entry.key.parent != null) {
      scoreDiff[entry.key] = entry.value - scoreMap[entry.key.parent];
    } else {
      scoreDiff[entry.key] = entry.value;
    }
  }
  return scoreDiff;
}

const Map<int, String> nodeTypeName = {
  html.Node.ATTRIBUTE_NODE: 'ATTRIBUTTE_NODE',
  html.Node.CDATA_SECTION_NODE: 'CDATA_SECTION_NODE',
  html.Node.COMMENT_NODE: 'COMMENT_NODE',
  html.Node.DOCUMENT_FRAGMENT_NODE: 'DOCUMENT_FRAGMENT_NODE',
  html.Node.DOCUMENT_NODE: 'DOCUMENT_NODE',
  html.Node.DOCUMENT_TYPE_NODE: 'DOCUMENT_TYPE_NODE',
  html.Node.ELEMENT_NODE: 'ELEMENT_NODE',
  html.Node.ENTITY_NODE: 'ENTITY_NODE',
  html.Node.ENTITY_REFERENCE_NODE: 'ENTITY_REFERENCE_NODE',
  html.Node.NOTATION_NODE: 'NOTATION_NODE',
  html.Node.PROCESSING_INSTRUCTION_NODE: 'PROCESSING_INSTRUCTION_NODE',
  html.Node.TEXT_NODE: 'TEXT_NODE',
};

/*
int cnt = 0;
_walkNodes(HTML.Node node, [int parent = 0]) {
  int me = ++cnt;
  //if(node.nodeType != HTML.Node.TEXT_NODE && node.nodeType != HTML.Node.ELEMENT_NODE)
  if(node is HTML.Element) {
    print('${node.localName}');
  }
  print('${parent}>${me}\t${_nodeTypeName[node.nodeType]}: ${node.attributes}, ${node.text?.length} [${node.text}]');
  node.hasContent();
  for(final child in node.nodes) {
    _walkNodes(child, me);
  }
}
*/
