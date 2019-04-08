import 'package:html/dom.dart';

print_tree(Map<Element, dynamic> tree, Element root) {
  print(_string_child(tree, root, 0));
}

String _string_child(Map<Element, dynamic> tree, Element elem, int depth) {
  var par = '';
  for(int i = 0; i < depth; ++i) {
    par += '#'; // indent character
  }
  par += '$par$elem: ${tree[elem]}\n';
  for(final child in elem.children) {
    par += _string_child(tree, child, depth + 1);
  }
  return par;
}