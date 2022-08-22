// To parse this JSON data, do
//
//     final farm = farmFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<Farm> farmFromJson(String str) =>
    List<Farm>.from(json.decode(str).map((x) => Farm.fromJson(x)));

String farmToJson(List<Farm> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Farm {
  Farm({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.fields,
    this.square,
    this.isOrganic,
  });

  num? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? createdById;
  List<Field>? fields;
  num? square;
  bool? isOrganic;

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdById: json["createdById"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
        square: json["square"].toDouble(),
        isOrganic: json["isOrganic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "createdById": createdById,
        "fields": List<dynamic>.from(fields!.map((x) => x.toJson())),
        "square": square,
        "isOrganic": isOrganic,
      };
}

class Field {
  Field({
    this.id,
    this.name,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.jsonFigure,
    this.farmId,
    this.actualArea,
    this.boundaryArea,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.sections,
    this.lastRefreshDate,
    this.stantionId,
  });

  num? id;
  String? name;
  num? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? jsonFigure;
  num? farmId;
  num? actualArea;
  num? boundaryArea;
  String? postalCode;
  String? latitude;
  String? longitude;
  List<Section>? sections;
  DateTime? lastRefreshDate;
  String? stantionId;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json["id"],
        name: json["name"],
        createdById: json["createdById"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        jsonFigure: json["jsonFigure"],
        farmId: json["farmId"],
        actualArea: json["actualArea"].toDouble(),
        boundaryArea: json["boundaryArea"].toDouble(),
        postalCode: json["postalCode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
        lastRefreshDate: json["lastRefreshDate"] == null
            ? null
            : DateTime.parse(json["lastRefreshDate"]),
        stantionId: json["stantionId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdById": createdById,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "jsonFigure": jsonFigure,
        "farmId": farmId,
        "actualArea": actualArea,
        "boundaryArea": boundaryArea,
        "postalCode": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "sections": List<dynamic>.from(sections!.map((x) => x.toJson())),
        "lastRefreshDate":
            lastRefreshDate == null ? null : lastRefreshDate!.toIso8601String(),
        "stantionId": stantionId,
      };
}

class Section {
  Section({
    this.id,
    this.createdById,
    this.fieldId,
    this.createdAt,
    this.updatedAt,
    this.cropId,
    this.crop,
    this.cropVarietyId,
    this.cropVariety,
    this.name,
    this.jsonFigure,
    this.actualArea,
    this.targetYield,
    this.plantingDensity,
    this.targetYieldUnitType,
    this.plantingDate,
    this.harvestDate,
    this.budBreak,
  });

  num? id;
  num? createdById;
  num? fieldId;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? cropId;
  Crop? crop;
  num? cropVarietyId;
  CropVariety? cropVariety;
  String? name;
  String? jsonFigure;
  num? actualArea;
  num? targetYield;
  num? plantingDensity;
  String? targetYieldUnitType;
  DateTime? plantingDate;
  DateTime? harvestDate;
  DateTime? budBreak;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        createdById: json["createdById"],
        fieldId: json["fieldId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        cropId: json["cropId"],
        crop: Crop.fromJson(json["crop"]),
        cropVarietyId: json["cropVarietyId"],
        cropVariety: CropVariety.fromJson(json["cropVariety"]),
        name: json["name"],
        jsonFigure: json["jsonFigure"],
        actualArea: json["actualArea"].toDouble(),
        targetYield: json["targetYield"],
        plantingDensity: json["plantingDensity"],
        targetYieldUnitType: json["targetYieldUnitType"],
        plantingDate: DateTime.parse(json["plantingDate"]),
        harvestDate: DateTime.parse(json["harvestDate"]),
        budBreak: DateTime.parse(json["budBreak"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdById": createdById,
        "fieldId": fieldId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "cropId": cropId,
        "crop": crop!.toJson(),
        "cropVarietyId": cropVarietyId,
        "cropVariety": cropVariety!.toJson(),
        "name": name,
        "jsonFigure": jsonFigure,
        "actualArea": actualArea,
        "targetYield": targetYield,
        "plantingDensity": plantingDensity,
        "targetYieldUnitType": targetYieldUnitType,
        "plantingDate": plantingDate!.toIso8601String(),
        "harvestDate": harvestDate!.toIso8601String(),
        "budBreak": budBreak!.toIso8601String(),
      };
}

class Crop {
  Crop({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.name,
    this.cropClassificationType,
    this.lbsPerBushel,
  });

  num? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? createdById;
  String? name;
  num? cropClassificationType;
  num? lbsPerBushel;

  factory Crop.fromJson(Map<String, dynamic> json) => Crop(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdById: json["createdById"],
        name: json["name"],
        cropClassificationType: json["cropClassificationType"],
        lbsPerBushel: json["lbsPerBushel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "createdById": createdById,
        "name": name,
        "cropClassificationType": cropClassificationType,
        "lbsPerBushel": lbsPerBushel,
      };
}

// enum CropName { TOMATO, CORN, AVOCADO, POTATO, CUCUMBER, COFFEE }

// final cropNameValues = EnumValues({
//   "Avocado": CropName.AVOCADO,
//   "Coffee": CropName.COFFEE,
//   "Corn": CropName.CORN,
//   "Cucumber": CropName.CUCUMBER,
//   "Potato": CropName.POTATO,
//   "Tomato": CropName.TOMATO
// });

class CropVariety {
  CropVariety({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.cropClassificationType,
    this.cropId,
    this.name,
    this.minIdealTemperature,
    this.maxIdealTemperature,
    this.minThresholdTemperature,
    this.maxThresholdTemperature,
    this.temperatureUnitType,
    this.harvestType,
    this.minYield,
    this.maxYield,
    this.yieldUnitType,
    this.notes,
    this.isActive,
    this.cropGrowthStages,
  });

  num? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? createdById;
  num? cropClassificationType;
  num? cropId;
  CropVarietyName? name;
  num? minIdealTemperature;
  num? maxIdealTemperature;
  num? minThresholdTemperature;
  num? maxThresholdTemperature;
  num? temperatureUnitType;
  num? harvestType;
  num? minYield;
  num? maxYield;
  num? yieldUnitType;
  String? notes;
  bool? isActive;
  List<dynamic>? cropGrowthStages;

  factory CropVariety.fromJson(Map<String, dynamic> json) => CropVariety(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdById: json["createdById"],
        cropClassificationType: json["cropClassificationType"],
        cropId: json["cropId"],
        name: cropVarietyNameValues.map![json["name"]],
        minIdealTemperature: json["minIdealTemperature"],
        maxIdealTemperature: json["maxIdealTemperature"],
        minThresholdTemperature: json["minThresholdTemperature"],
        maxThresholdTemperature: json["maxThresholdTemperature"],
        temperatureUnitType: json["temperatureUnitType"],
        harvestType: json["harvestType"],
        minYield: json["minYield"],
        maxYield: json["maxYield"],
        yieldUnitType: json["yieldUnitType"],
        notes: json["notes"],
        isActive: json["isActive"],
        cropGrowthStages:
            List<dynamic>.from(json["cropGrowthStages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "createdById": createdById,
        "cropClassificationType": cropClassificationType,
        "cropId": cropId,
        "name": cropVarietyNameValues.reverse![name],
        "minIdealTemperature": minIdealTemperature,
        "maxIdealTemperature": maxIdealTemperature,
        "minThresholdTemperature": minThresholdTemperature,
        "maxThresholdTemperature": maxThresholdTemperature,
        "temperatureUnitType": temperatureUnitType,
        "harvestType": harvestType,
        "minYield": minYield,
        "maxYield": maxYield,
        "yieldUnitType": yieldUnitType,
        "notes": notes,
        "isActive": isActive,
        "cropGrowthStages": List<dynamic>.from(cropGrowthStages!.map((x) => x)),
      };
}

enum CropVarietyName { GENERAL, THE_2700_GDD_HYBRIDS, HASS, ARABICA }

final cropVarietyNameValues = EnumValues({
  "Arabica": CropVarietyName.ARABICA,
  "General": CropVarietyName.GENERAL,
  "Hass": CropVarietyName.HASS,
  "2700 GDD Hybrids": CropVarietyName.THE_2700_GDD_HYBRIDS
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    // ignore: unnecessary_new
    reverseMap ??= map!.map((k, v) => new MapEntry(v, k));
    return reverseMap;
  }
}
