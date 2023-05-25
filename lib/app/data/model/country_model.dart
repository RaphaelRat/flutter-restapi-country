import 'dart:convert';

List<Country> countryFromJson(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  Name? name;
  List<String>? capital;
  List<String>? continents;
  Flags? flags;

  Country({
    this.name,
    this.capital,
    this.continents,
    this.flags,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json["name"] == null ? null : Name.fromJson(json["name"]),
      capital: json["capital"] == null ? [] : List<String>.from(json["capital"]!.map((x) => x)),
      continents: json["continents"] == null ? [] : List<String>.from(json["continents"]!.map((x) => x)),
      flags: json["flags"] == null ? null : Flags.fromJson(json["flags"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name?.toJson(),
        "capital": capital == null ? [] : List<dynamic>.from(capital!.map((x) => x)),
        "continents": continents == null ? [] : List<dynamic>.from(continents!.map((x) => x)),
        "flags": flags?.toJson(),
      };
}

class Flags {
  String? png;
  String? svg;
  String? alt;

  Flags({
    this.png,
    this.svg,
    this.alt,
  });

  factory Flags.fromJson(Map<String, dynamic> json) => Flags(
        png: json["png"],
        svg: json["svg"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "png": png,
        "svg": svg,
        "alt": alt,
      };
}

class Name {
  String? common;
  String? official;

  Name({
    this.common,
    this.official,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        common: json["common"],
        official: json["official"],
      );

  Map<String, dynamic> toJson() => {
        "common": common,
        "official": official,
      };
}

