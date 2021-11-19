import 'package:flutter/material.dart';
import '../globalVariable.dart';
import 'utils.dart';
class SliderForResponse extends StatefulWidget {
  @override
  _SliderForResponseState createState() => _SliderForResponseState();
}

class _SliderForResponseState extends State<SliderForResponse> {
  int indexTop = indexTopForShow;
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
        buildSliderTopLabel(),
      ],
    ),
  );


  Widget buildSliderTopLabel() {
    setState(() {
      this.indexTop = indexTopForShow;
      print("this is indextopfor show :" + indexTopForShow.toString());
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
              indexTopForShow = value.toInt();
              print("this is indextopfor slide" + indexTopForShow.toString());
              //this.indexTop = value.toInt();
              int indexofMaturity = indexTopForShow;

              if(indexofMaturity==0){
                maturityScore = 0;
              }
              else if(indexofMaturity==1){
                maturityScore = 55;
              }
              else if(indexofMaturity==2){
                maturityScore = 60;
              }
              else if(indexofMaturity==3){
                maturityScore = 65;
              }
              else if(indexofMaturity==4){
                maturityScore = 70;
              }
              else if(indexofMaturity==5){
                maturityScore = 75;
              }
              else if(indexofMaturity==6){
                maturityScore = 80;
              }
              else if(indexofMaturity==7){
                maturityScore = 85;
              }
              else if(indexofMaturity==8){
                maturityScore = 90;
              }
              else if(indexofMaturity==9){
                maturityScore = 95;
              }
              else{
                maturityScore = 100;
              }
              print(maturityScore);
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
