/// Support for doing something awesome.
///
/// More dartdocs go here.
library MainTextHTML;

export 'src/MainTextHTML_base.dart';

import 'dart:core';
import 'dart:io';
import 'package:html/dom.dart' as HTML;
import 'package:html/parser.dart' as HTMLParser;

/*
Root is the document.
It will have a ELEMENT_NODE with 'html' localname, (and maybe some other).
Element nodes can have element children. Node list will have text nodes also.
Text nodes will include every whitespace.
 */

main() async {
  //*
  var htmlFile = File('local/index.html');
  var document = HTMLParser.parse(await htmlFile.readAsBytes());
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


Map<HTML.Node, double> _storedScores;

/// Rules for scoring:
///  - +1 point for every inner character in TEXT_NODEs
///  - +50% of each child's score
double score(HTML.Node node) {
  if(_storedScores.containsKey(node)) return _storedScores[node];
  var s = 0.0; // score
  if(node.nodeType == HTML.Node.TEXT_NODE) {
    s += node.text.length;
  }
  for (final child in node.nodes) {
    s += 0.5 * score(child);
  }

  return _storedScores[node] = s;
}

const Map<int, String> _nodeTypeName = {
  HTML.Node.ATTRIBUTE_NODE: 'ATTRIBUTTE_NODE',
  HTML.Node.CDATA_SECTION_NODE: 'CDATA_SECTION_NODE',
  HTML.Node.COMMENT_NODE: 'COMMENT_NODE',
  HTML.Node.DOCUMENT_FRAGMENT_NODE: 'DOCUMENT_FRAGMENT_NODE',
  HTML.Node.DOCUMENT_NODE: 'DOCUMENT_NODE',
  HTML.Node.DOCUMENT_TYPE_NODE: 'DOCUMENT_TYPE_NODE',
  HTML.Node.ELEMENT_NODE: 'ELEMENT_NODE',
  HTML.Node.ENTITY_NODE: 'ENTITY_NODE',
  HTML.Node.ENTITY_REFERENCE_NODE: 'ENTITY_REFERENCE_NODE',
  HTML.Node.NOTATION_NODE: 'NOTATION_NODE',
  HTML.Node.PROCESSING_INSTRUCTION_NODE: 'PROCESSING_INSTRUCTION_NODE',
  HTML.Node.TEXT_NODE: 'TEXT_NODE',
};
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