import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsScreen extends StatefulWidget {
  final String location;
  DetailsScreen(this.location);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}
class ParkingSlot{
  int location;
  bool isOccupied;
  ParkingSlot(this.location,this.isOccupied);
}
class _DetailsScreenState extends State<DetailsScreen> {

  List<ParkingSlot> parkingSlots = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tower "+ widget.location.toString()),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //     Padding(
          // padding: const EdgeInsets.all(18.0),
          // child: parkingSlots.length > 0 ?OrientationBuilder(
          //         builder:(context,orientation)=> GridView.builder(
          //       itemCount: parkingSlots.length,
          //       itemBuilder: (itemBuilder, index) => parkingSlots.length <=0 ? CircularProgressIndicator() : GridItem(towers[index]),
          //       gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: orientation == Orientation.portrait ? 2 : 3),
          //   ),
          // ): Center(child: CircularProgressIndicator(backgroundColor: Colors.blue,)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Row(children: <Widget>[

            Text("Occupied  ",style: TextStyle(fontSize: 20),),
            Container(
              width: 25,
              height: 25,
              color: Colors.red,
            )
            ],),
            Row(children: <Widget>[

            Text("Available  ",style: TextStyle(fontSize: 20),),
            Container(
              width: 25,
              height: 25,
              color: Colors.green,
            )
            ],),
          ],
          ),
          GridItem(ParkingSlot(1, true)),
        ],
      ),
    );
  }
}

class GridItem extends StatefulWidget {
  ParkingSlot parkingSlot;
  GridItem(this.parkingSlot);
  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width:100,
      decoration: BoxDecoration(color: widget.parkingSlot.isOccupied ? Colors.blue : Colors.red,borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(widget.parkingSlot.location.toString()))
              , 
            ],)
          
          );
    
  }
}