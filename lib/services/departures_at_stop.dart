class DeparturesAtStop {
  List<Departure>? departures;
  int? realtimeDataUpdatedAt;

  DeparturesAtStop({this.departures, this.realtimeDataUpdatedAt});

  DeparturesAtStop.fromJson(Map<String, dynamic> json) {
    if (json['departures'] != null) {
      departures = <Departure>[];
      json['departures'].forEach((v) {
        departures!.add(Departure.fromJson(v));
      });
    }
    realtimeDataUpdatedAt = json['realtimeDataUpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (departures != null) {
      data['departures'] = departures!.map((v) => v.toJson()).toList();
    }
    data['realtimeDataUpdatedAt'] = realtimeDataUpdatedAt;
    return data;
  }
}

class Departure {
  String? tripId;
  Stop? stop;
  String? when;
  String? plannedWhen;
  int? delay;
  String? platform;
  String? plannedPlatform;
  String? prognosisType;
  String? direction;
  Line? line;
  List<Remarks>? remarks;
  Null origin;
  Stop? destination;
  CurrentTripPosition? currentTripPosition;

  Departure(
      {this.tripId,
      this.when,
      this.plannedWhen,
      this.delay,
      this.platform,
      this.plannedPlatform,
      this.prognosisType,
      this.direction,
      this.line,
      this.remarks,
      this.origin,
      this.destination,
      this.currentTripPosition});

  Departure.fromJson(Map<String, dynamic> json) {
    tripId = json['tripId'];
    when = json['when'];
    plannedWhen = json['plannedWhen'];
    delay = json['delay'];
    platform = json['platform'];
    plannedPlatform = json['plannedPlatform'];
    prognosisType = json['prognosisType'];
    direction = json['direction'];
    line = json['line'] != null ? Line.fromJson(json['line']) : null;
    if (json['remarks'] != null) {
      remarks = <Remarks>[];
      json['remarks'].forEach((v) {
        remarks!.add(Remarks.fromJson(v));
      });
    }
    origin = json['origin'];
    destination = json['destination'] != null
        ? Stop.fromJson(json['destination'])
        : null;
    currentTripPosition = json['currentTripPosition'] != null
        ? CurrentTripPosition.fromJson(json['currentTripPosition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tripId'] = tripId;
    if (stop != null) {
      data['stop'] = stop!.toJson();
    }
    data['when'] = when;
    data['plannedWhen'] = plannedWhen;
    data['delay'] = delay;
    data['platform'] = platform;
    data['plannedPlatform'] = plannedPlatform;
    data['prognosisType'] = prognosisType;
    data['direction'] = direction;
    if (line != null) {
      data['line'] = line!.toJson();
    }
    if (remarks != null) {
      data['remarks'] = remarks!.map((v) => v.toJson()).toList();
    }
    data['origin'] = origin;
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    if (currentTripPosition != null) {
      data['currentTripPosition'] = currentTripPosition!.toJson();
    }
    return data;
  }
}

class Stop {
  String? type;
  String? id;
  String? name;
  StationLocation? location;
  Products? products;
  String? stationDHID;

  Stop(
      {this.type,
      this.id,
      this.name,
      this.location,
      this.products,
      this.stationDHID});

  Stop.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    name = json['name'];
    location = json['location'] != null
        ? StationLocation.fromJson(json['location'])
        : null;
    products = json['products'] != null
        ? Products.fromJson(json['products'])
        : null;
    stationDHID = json['stationDHID'];
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
    data['stationDHID'] = stationDHID;
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

class Line {
  String? type;
  String? id;
  String? fahrtNr;
  String? name;
  bool? public;
  String? adminCode;
  String? productName;
  String? mode;
  String? product;
  Operator? operator;
  Color? color;

  Line(
      {this.type,
      this.id,
      this.fahrtNr,
      this.name,
      this.public,
      this.adminCode,
      this.productName,
      this.mode,
      this.product,
      this.operator,
      this.color});

  Line.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    fahrtNr = json['fahrtNr'];
    name = json['name'];
    public = json['public'];
    adminCode = json['adminCode'];
    productName = json['productName'];
    mode = json['mode'];
    product = json['product'];
    operator = json['operator'] != null
        ? Operator.fromJson(json['operator'])
        : null;
    color = json['color'] != null ? Color.fromJson(json['color']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['fahrtNr'] = fahrtNr;
    data['name'] = name;
    data['public'] = public;
    data['adminCode'] = adminCode;
    data['productName'] = productName;
    data['mode'] = mode;
    data['product'] = product;
    if (operator != null) {
      data['operator'] = operator!.toJson();
    }
    if (color != null) {
      data['color'] = color!.toJson();
    }
    return data;
  }
}

class Operator {
  String? type;
  String? id;
  String? name;

  Operator({this.type, this.id, this.name});

  Operator.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['name'] = name;
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

class Remarks {
  String? type;
  String? code;
  String? text;

  Remarks({this.type, this.code, this.text});

  Remarks.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    code = json['code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['code'] = code;
    data['text'] = text;
    return data;
  }
}

class CurrentTripPosition {
  String? type;
  double? latitude;
  double? longitude;

  CurrentTripPosition({this.type, this.latitude, this.longitude});

  CurrentTripPosition.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
