import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapService {
  static Future<List<MapObject>> getDirection(Point from, Point to) async {
    final result = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(point: from, requestPointType: RequestPointType.wayPoint),
        RequestPoint(point: to, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 1,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    final drivingResults = await result.$2;

    if (drivingResults.error != null) {
      print("Joylashuv olinmadi!");
      return [];
    }

    final points = drivingResults.routes!.map((rout) {
      return PolylineMapObject(
        mapId: MapObjectId(UniqueKey().toString()),
        polyline: rout.geometry,
      );
    }).toList();

    return points;
  }

  static Future<List<PlacemarkMapObject>> performSearch(String query) async {
    const searchOptions = SearchOptions(
      searchType: SearchType.geo,
    );

    final searchResponse = await YandexSearch.searchByText(
      searchText: query,
      geometry: Geometry.fromBoundingBox(
        const BoundingBox(
          southWest: Point(latitude: 55.0, longitude: 37.0),
          northEast: Point(latitude: 56.0, longitude: 38.0),
        ),
      ),
      searchOptions: searchOptions,
    );

    final searchResult = await searchResponse.$2;

    if (searchResult.error != null) {
      print("Natijalar topilmadi!");
      return [];
    }

    final placeMark = searchResult.items!.map((item) {
      return PlacemarkMapObject(
        mapId: MapObjectId(item.name),
        point: item.geometry.first.point!,
        onTap: (PlacemarkMapObject self, Point point) {
          print("Tapped on: ${item.name}");
        },
      );
    }).toList();

    return placeMark;
  }
}
