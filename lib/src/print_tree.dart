import 'package:html/dom.dart';

print_tree(Map<Element, dynamic> tree, Element root) {
  _print_child(tree, root, 0);
}

_print_child(Map<Element, dynamic> tree, Element elem, int depth) {
  var par = '';
  for(int i = 0; i < depth; ++i) {
    par += ' '; // space character
  }
  print('$par$elem: ${tree[elem]}');
  for(final child in elem.children) {
    _print_child(tree, child, depth + 1);
  }
}