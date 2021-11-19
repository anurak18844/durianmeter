import 'package:flutter/material.dart';
import '../globalVariable.dart';
import 'utils.dart';
class SliderForSetdata extends StatefulWidget {
  @override
  _SliderForSetdataState createState() => _SliderForSetdataState();
}

class _SliderForSetdataState extends State<SliderForSetdata> {
  int indexTop = 0;
  double valueBottom = 20;

  @override
  Widget build(BuildContext context) => SliderTheme(
    data: SliderThemeData(
      /// ticks in between
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // buildSliderSideLabel(),
        // const SizedBox(height: 16),
        buildSliderTopLabel(),
      ],
    ),
  );


  Widget buildSliderTopLabel() {
    setState(() {
      indexTop = indexTopForSet;
    });
    final labels = ['50','55','60','65','70', '75', '80', '85', '90' , '95' , '100'];
    final double min = 0;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Utils.modelBuilder(
              labels,
                  (index, label) {
                final selectedColor = Colors.teal;
                final unselectedColor = Colors.black26;
                final isSelected = index <= indexTop;
                final color = isSelected ? selectedColor : unselectedColor;
                return buildLabel(label: label.toString(), color: color, width: 30);
              },
            ),
          ),
        ),
        Slider(
          activeColor: Colors.teal,
          inactiveColor: Colors.teal.shade100,
          autofocus: true,
          value: indexTop.toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          // label: labels[indexTop],
          onChanged: (value){
            setState(() {
              this.indexTop = value.toInt();
              int indexofMaturity = this.indexTop;
              if(indexofMaturity==0){
                maturityScore = 50;
                indexTopForSet = 0;
              }
              else if(indexofMaturity==1){
                maturityScore = 55;
                indexTopForSet = 1;
              }
              else if(indexofMaturity==2){
                maturityScore = 60;
                indexTopForSet = 2;
              }
              else if(indexofMaturity==3){
                maturityScore = 65;
                indexTopForSet = 3;
              }
              else if(indexofMaturity==4){
                maturityScore = 70;
                indexTopForSet = 4;
              }
              else if(indexofMaturity==5){
                maturityScore = 75;
                indexTopForSet = 5;
              }
              else if(indexofMaturity==6){
                maturityScore = 80;
                indexTopForSet = 6;
              }
              else if(indexofMaturity==7){
                maturityScore = 85;
                indexTopForSet = 7;
              }
              else if(indexofMaturity==8){
                maturityScore = 90;
                indexTopForSet = 8;
              }
              else if(indexofMaturity==9){
                maturityScore = 95;
                indexTopForSet = 9;
              }
              else{
                maturityScore = 100;
                indexTopForSet = 10;
              }
            }
            );
          },
          // onChanged: (value) => setState(() => this.indexTop = value.toInt()),
        ),
      ],
    );
  }
  Widget buildLabel({
    @required String? label,
    @required double? width,
    @required Color? color,
  }) =>
      Container(
        width: width,
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ).copyWith(color: color),
        ),
      );

  Widget buildSideLabel(double value) => Container(
    width: 25,
    child: Text(
      value.round().toString(),
      style: TextStyle(fontSize: 14,),
    ),
  );
}
