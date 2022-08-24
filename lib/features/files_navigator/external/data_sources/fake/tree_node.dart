class TreeNode<K,V>{
  final K key;
  final V value;
  final List<TreeNode<K, V>> children;
  TreeNode({
    required this.key,
    required this.value, 
    required this.children
  });
}