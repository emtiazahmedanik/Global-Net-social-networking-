class Category {
  final String id;
  final String name;
  final String? icon;
  final String? emoji;
  final bool isSelected;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.emoji,
    this.isSelected = false,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? emoji,
    bool? isSelected,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
