import 'package:vido/features/files_navigator/external/fake/tree_node.dart';

class Tree<K, V>{
  final TreeNode<K, V> root;
  Tree({
    required this.root
  });
  void addAt(K key, V value){
    final searched = _getSearched(key, root);
    searched?.children.add(TreeNode<K, V>(
      key: key,
      value: value,
      children: []
    ));
  }

  V getParent(K key){
    final List<TreeNode<K, V>> parents = [];
    _getSearchedParent(key, root, parents);
    return parents.last.value;
  }

  V getAt(K key){
    return _getSearched(key, root)!.value;
  }

  bool _getSearchedParent(K searchedKey, TreeNode<K, V> currentNode, List<TreeNode<K, V>> parents){
    if(searchedKey == currentNode.key){
      return true;
    }else{
      parents.add(currentNode);
      final currentChildren = currentNode.children;
      bool searchedIsFound = false;
      for(final child in currentChildren){
        searchedIsFound = _getSearchedParent(searchedKey, child, parents);
        if(searchedIsFound){
          break;
        }
      }
      if(!searchedIsFound){
        parents.removeLast();
      }
      return searchedIsFound;
    }
  }

  List<V> getChildren(K key){
    final parent = _getSearched(key, root);
    if(parent != null){
      return parent.children.map(
        (c) => c.value
      ).toList();
    }else{
      return const [];
    }
  }

  TreeNode<K, V>? _getSearched(K searchedKey, TreeNode<K, V> currentNode){
    if(searchedKey == currentNode.key){
      return currentNode;
    }else{
      final currentChildren = currentNode.children;
      for(final child in currentChildren){
        final searched = _getSearched(searchedKey, child);
        if(searched != null){
          return searched;
        }
      }
      return null;
    }
  }
}