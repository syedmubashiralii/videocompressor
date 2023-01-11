//

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class QualityPicker extends StatefulWidget {
  List dropdown;
  QualityPicker({super.key, required this.dropdown});

  @override
  State<QualityPicker> createState() => _QualityPickerState();
}

class _QualityPickerState extends State<QualityPicker> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.shade900,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Select Compression Quality",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, index);
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(children: [
                  for (int i = 0; i < widget.dropdown.length; i++) ...[
                    ListTile(
                      leading: Icon(
                        index == i ? Icons.done : Icons.high_quality,
                        color: Colors.white,
                      ),
                      onTap: () {
                        index = i;
                        
                        setState(() {});
                      },
                      title: Text(
                        widget.dropdown[i].toString(),
                        style: const TextStyle(
                          fontFamily: "poppins",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]
                ]),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, index);
                  },
                  child: const Text(
                    "Done",
                    style:
                        TextStyle(fontFamily: "poppins", color: Colors.white),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
