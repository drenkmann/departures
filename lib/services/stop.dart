class Stop {
  String? type;
  String? id;
  String? name;
  StationLocation? location;
  Products? products;
  List<Lines>? lines;
  String? stationDHID;
  int? distance;

  Stop(
      {this.type,
      this.id,
      this.name,
      this.location,
      this.products,
      this.lines,
      this.stationDHID,
      this.distance});

  Stop.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    name = json['name'];
    location = json['location'] != null
        ? StationLocation.fromJson(json['location'])
        : null;
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines!.add(Lines.fromJson(v));
      });
    }
    stationDHID = json['stationDHID'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['name'] = name;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (products != null) {
      data['products'] = products!.toJson();
    }
    if (lines != null) {
      data['lines'] = lines!.map((v) => v.toJson()).toList();
    }
    data['stationDHID'] = stationDHID;
    data['distance'] = distance;
    return data;
  }
}

class StationLocation {
  String? type;
  String? id;
  double? latitude;
  double? longitude;

  StationLocation({this.type, this.id, this.latitude, this.longitude});

  StationLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Products {
  bool? suburban;
  bool? subway;
  bool? tram;
  bool? bus;
  bool? ferry;
  bool? express;
  bool? regional;

  Products(
      {this.suburban,
      this.subway,
      this.tram,
      this.bus,
      this.ferry,
      this.express,
      this.regional});

  Products.fromJson(Map<String, dynamic> json) {
    suburban = json['suburban'];
    subway = json['subway'];
    tram = json['tram'];
    bus = json['bus'];
    ferry = json['ferry'];
    express = json['express'];
    regional = json['regional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suburban'] = suburban;
    data['subway'] = subway;
    data['tram'] = tram;
    data['bus'] = bus;
    data['ferry'] = ferry;
    data['express'] = express;
    data['regional'] = regional;
    return data;
  }
}

class Lines {
  String? type;
  String? id;
  String? name;
  bool? public;
  String? productName;
  String? mode;
  String? product;
  Color? color;

  Lines(
      {this.type,
      this.id,
      this.name,
      this.public,
      this.productName,
      this.mode,
      this.product,
      this.color});

  Lines.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    name = json['name'];
    public = json['public'];
    productName = json['productName'];
    mode = json['mode'];
    product = json['product'];
    color = json['color'] != null ? Color.fromJson(json['color']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['name'] = name;
    data['public'] = public;
    data['productName'] = productName;
    data['mode'] = mode;
    data['product'] = product;
    if (color != null) {
      data['color'] = color!.toJson();
    }
    return data;
  }
}

class Color {
  String? fg;
  String? bg;

  Color({this.fg, this.bg});

  Color.fromJson(Map<String, dynamic> json) {
    fg = json['fg'];
    bg = json['bg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fg'] = fg;
    data['bg'] = bg;
    return data;
  }
}
