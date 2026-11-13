class Student {
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  final String name;
  final String nim;
  final String programStudi;
  final String email;

  
  static const Student initial = Student(
    name: 'Nama Mahasiswa',
    nim: '00.00.0000',
    programStudi: 'S1 Informatika',
    email: 'nama@students.amikom.ac.id',
  );

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  
  Map<String, dynamic> toJson() => {
        'name': name,
        'nim': nim,
        'programStudi': programStudi,
        'email': email,
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json['name'] as String? ?? initial.name,
        nim: json['nim'] as String? ?? initial.nim,
        programStudi: json['programStudi'] as String? ?? initial.programStudi,
        email: json['email'] as String? ?? initial.email,
      );
}
