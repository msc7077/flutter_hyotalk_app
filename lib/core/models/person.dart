class Person {
  final int id;
  final String name;
  Person({required this.id, required this.name});

  Person copyWith({int? id, String? name}) {
    return Person(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  String toString() => 'Person(id: $id, name: $name)';
}
