class ColorModels {
  final int id;
  final String colorName;
  final String? colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ColorModels({
    required this.id,
    required this.colorName,
    this.colorCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ColorModels.fromJson(Map<String, dynamic> json) {
    return ColorModels(
      id: json['id'],
      colorName: json['color_name'],
      colorCode: json['color_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color_name': colorName,
      'color_code': colorCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ColorsResponses {
  final List<ColorModels> colors;

  ColorsResponses({required this.colors});

  factory ColorsResponses.fromJson(Map<String, dynamic> json) {
    var colorList = json['colors'] as List;
    List<ColorModels> colorModels = colorList.map((i) => ColorModels.fromJson(i)).toList();
    return ColorsResponses(colors: colorModels);
  }

  Map<String, dynamic> toJson() {
    return {
      'colors': colors.map((color) => color.toJson()).toList(),
    };
  }
}
