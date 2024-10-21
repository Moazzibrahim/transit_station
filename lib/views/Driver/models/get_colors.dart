class ColorModel {
  final int id;
  final String colorName;
  final String? colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ColorModel({
    required this.id,
    required this.colorName,
    this.colorCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
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

class ColorsResponse {
  final List<ColorModel> colors;

  ColorsResponse({required this.colors});

  factory ColorsResponse.fromJson(Map<String, dynamic> json) {
    var colorList = json['colors'] as List;
    List<ColorModel> colorModels = colorList.map((i) => ColorModel.fromJson(i)).toList();
    return ColorsResponse(colors: colorModels);
  }

  Map<String, dynamic> toJson() {
    return {
      'colors': colors.map((color) => color.toJson()).toList(),
    };
  }
}
