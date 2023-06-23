import 'package:flutter/material.dart';

import '../../../utils/task.dart';

class checklist extends StatefulWidget {
  checklist({
    super.key,
    required this.checks,
  });

  List<Check>? checks;

  @override
  State<checklist> createState() => _checklistState();
}

class _checklistState extends State<checklist> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          border: Border.all(color: theme.inversePrimary),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          widget.checks == null
              ? const SizedBox.shrink()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.checks!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Checkbox(
                              value: widget.checks![index].isChecked,
                              activeColor: theme.primary,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.checks![index].isChecked = value!;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            initialValue: widget.checks![index].title,
                            textInputAction: TextInputAction.done,
                            onChanged: (text) {
                              widget.checks![index].title = text;
                            },
                            onTapOutside: (context) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            maxLines: null,
                            style: const TextStyle(fontSize: 17),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    widget.checks ??= <Check>[];
                    widget.checks!.add(Check());
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                child: const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 16),
                )),
          )
        ],
      ),
    );
  }
}
