library MainTextHTML;

export 'src/readability.dart';

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
