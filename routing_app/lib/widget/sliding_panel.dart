import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  const PanelWidget({super.key,
  required this.controller});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: ListView(
        controller: widget.controller,
        children: [

         Row(
           children: [
             Expanded(
                 child: TextField(
                   decoration: InputDecoration(
                     filled: true,
                     hintText: "Search",
                     hintStyle: const TextStyle(color: Colors.grey),
                     prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                     fillColor: const Color.fromARGB(35, 100, 100, 100),
                     enabledBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.white),
                       borderRadius: BorderRadius.circular(12)
                     )
                   ),
                 )
             ),

             const SizedBox(width: 20,),
             const CircleAvatar(
               child: Text("AM",style: TextStyle(color: Colors.grey,fontSize: 20),),
             )
           ],
         ),
          const SizedBox(height: 20,),


        ],
      ),
    );
  }
}
