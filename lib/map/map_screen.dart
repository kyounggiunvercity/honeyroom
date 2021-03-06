import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'map_cluster/map_helper.dart';
import 'map_cluster/map_marker_cluster.dart';
import 'map_support/google_map_service.dart';
import 'map_support/map_marker.dart';
import 'package:http/http.dart' as http;

final String baseUrl =
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
const String API_KEY = 'AIzaSyBjJS0R3g8LUziS9ucwWHmgQr4wXJvIXio';
String value;

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Completer<GoogleMapController> _controller = Completer();

  /// 마커들의 모음 클러스터 마커 까지 포함
  Set<Marker> _markers = Set();

  /// 사용자의 위치
  LatLng _center;
  Position currentLocation;
  String myAddr = '';

  /// 선택된 위치
  LatLng selectedLocation;
  String selectedAddress;

  /// 지도 loading 초기화
  bool loading = false;

  /// 지도 처음 줌 level
  double _currentZoom = 15;

  /// 마커 아이콘 변수
  Uint8List markerIcon;

  /// Minimum zoom at which the markers will cluster
  int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  int _maxClusterZoom = 19;

  /// Color of the cluster circle
  Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  Color _clusterTextColor = Colors.white;

  /// 클러스터 manager
  Fluster<MapMarker> _clusterManager;

  /// 구글 지도 컨트롤러 받아오고, 지도 로딩 & 마커 초기화
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      loading = false;
    });
  }

  /// 사용자 위치 표시 하기
  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    myAddr = await GoogleMapServices.getAddrFromLocation(
        currentLocation.latitude, currentLocation.longitude);
    _setMyLocation(currentLocation.latitude, currentLocation.longitude, myAddr);
  }

  /// 내가 위치 터치하면 옮겨 지는 부분
  _selectLocation(LatLng loc) async {
    setState(() {
      loading = true;
      _setMyLocation(loc.latitude, loc.longitude, selectedAddress);
    });
    selectedAddress = await GoogleMapServices.getAddrFromLocation(
        loc.latitude, loc.longitude);
    setState(() {
      loading = false;
      selectedLocation = loc;
    });
  }

  /// 먀커 커스터마이즈
  void setCustomMarker(addr) async {
    markerIcon = await getBytesFromCanvas(300, 100, addr);
  }

  /// 마커 처음 찍어주는 부분
  void _setMyLocation(latitude, longtitude, Addr) {
    var _latitude = latitude;
    var _longtitude = longtitude;
    setCustomMarker(Addr);
    setState(() async {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(_latitude, _longtitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {},
        infoWindow: InfoWindow(
          title: '나의 위치',
          snippet: Addr,
        ),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker('내 위치');
    getUserLocation();
  }

  /// 클러스터 마커 가져오기
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      loading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.brown,
          appBar: AppBar(

              /// 여기에 필터링 된 정보 띄우면 됨!!
              ///
              title: Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepOrange),
              ),
              leading: TextButton(
                onPressed: () {},
                child: SizedBox(
                  height: 40,
                  width: 40,

                  /// 검색 버튼 만들거면 iconbutton으로 수정 하면된다.
                  child: Icon(
                    Icons.search,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              backgroundColor: Colors.brown,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.star,
                    color: Colors.deepOrange,
                  ),
                  tooltip: 'favorite',
                  onPressed: () {
                    /// 여기에 다가 즐겨찾기 페이지로 넘어가게 하면 됨
                  },
                )
              ]),
          body: Stack(
            children: <Widget>[
              _center == null
                  ? Center(child: CircularProgressIndicator())
                  : ModalProgressHUD(
                      inAsyncCall: loading,
                      child: GoogleMap(
                        onTap: _selectLocation,
                        initialCameraPosition:
                            CameraPosition(target: _center, zoom: _currentZoom),
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        markers: _markers,
                        onCameraMove: (position) =>
                            _updateMarkers(position.zoom),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 60, right: 10),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      onPressed: () {
                        stateStterSearch();
                      },
                      label: Text(
                        '현 위치 아파트',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.yellow),
                      ),
                      elevation: 8,
                      icon: Icon(
                        Icons.gps_fixed_outlined,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      backgroundColor: Colors.brown,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        stateStterPointSearch();
                      },
                      label: Text('주변 아파트',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.yellow)),
                      elevation: 8,
                      icon: Icon(
                        Icons.map,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      backgroundColor: Colors.brown,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  /// 현재 위치 기반 아파트 찾기
  void stateStterSearch() {
    setState(() {
      _search(currentLocation.latitude, currentLocation.longitude);
    });
  }

  /// 옮기 기반 위치 아파트 찾기
  void stateStterPointSearch() {
    setState(() {
      _pointSearch(selectedLocation.latitude, selectedLocation.longitude);
    });
  }

  /// 검색 통해서 나온 아파트들 마커 찍어주는 부분인데 여기가 아마 아이콘이 업데이트 안되는거 같어 변수는 잘들어가
  void _search(dynamic latitude, dynamic longtitude) async {
    setState(() {
      _markers.clear();
      getUserLocation();
      loading = true;
    });

    var _latitude = latitude;
    var _longtitude = longtitude;
    var _places = '아파트';
    final String url =
        '$baseUrl?key=$API_KEY&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));
    final List<MapMarker> markers = [];

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(_center, 16));

        setState(() {
          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            setCustomMarker(foundPlaces[i]['name']);
            _markers.add(
              Marker(
                  markerId: MarkerId(foundPlaces[i]['place_id']),
                  position: LatLng(
                    foundPlaces[i]['geometry']['location']['lat'],
                    foundPlaces[i]['geometry']['location']['lng'],
                  ),
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                  infoWindow: InfoWindow(
                    title: foundPlaces[i]['name'],
                    snippet: foundPlaces[i]['vicinity'],
                  ),
                  onTap: () {}),
            );
          }

          loading = false;
        });
      }
    } else {
      print('Fail to fetch place data');
    }
  }

  /// 위랑 똑같음
  void _pointSearch(dynamic latitude, dynamic longtitude) async {
    var _latitude = latitude;
    var _longtitude = longtitude;
    var _places = '아파트';
    setState(() {
      loading = true;
      _markers.clear();
      _setMyLocation(_latitude, _longtitude, selectedAddress);
    });
    final String url =
        '$baseUrl?key=$API_KEY&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            setCustomMarker(foundPlaces[i]['name']);
            _markers.add(
              Marker(
                  markerId: MarkerId(foundPlaces[i]['place_id']),
                  position: LatLng(
                    foundPlaces[i]['geometry']['location']['lat'],
                    foundPlaces[i]['geometry']['location']['lng'],
                  ),
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                  infoWindow: InfoWindow(
                    title: foundPlaces[i]['name'],
                    snippet: foundPlaces[i]['vicinity'],
                  ),
                  onTap: () {}),
            );
          }
          loading = false;
        });
      }
    } else {
      print('Fail to fetch place data');
    }
  }
}
