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

/*
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
*/


/// Rules for readability scoring based on github.com/mozilla/readablility:
///  - Only check for certain tags
///  - Large base score based on class
///  - Some points based on the tag
///  - 0 point if the paragraph has less than 25 characters (*)
///  - +1 point as base (*)
///  - +1 point for every comma in this paragraph (*)
///  - +1 point for every 100 characters, up to 3 points
///  - +Sum of every direct child's score
///  - +Sum/2 of every second child's score
///  - +Sum/(3*level) of every child's score at level deep
///  - *(1 - link_density) as a final step

Map<HTML.Element, double> _readScores;

double readabilityScore(HTML.Element node) {
  // calculate node only one time
  if(_readScores.containsKey(node)) return _readScores[node];
  // call function recursively
  for(var child in node.children) {
    readabilityScore(child);
  }

  const readable_tags = ['p', 'div', 'h2', 'h3', 'h4', 'h5', 'h6', 'td', 'pre'];

  if(!readable_tags.contains(node.localName)) {
    return _readScores[node] = 0;
  }
  if(node.text.length < 25) {
    return _readScores[node] = 0;
  }

  double score = 1;
  score += node.text.split(',').length;

  return _readScores[node] = score;
}



const Map<int, String> nodeTypeName = {
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