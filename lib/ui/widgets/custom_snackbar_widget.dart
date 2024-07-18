import 'package:flutter/material.dart';
import 'package:tadbiro/ui/widgets/custom_configuration_widget.dart';

class CustomSnackbarWidget extends StatefulWidget {
  const CustomSnackbarWidget({super.key});

  @override
  CustomSnackbarWidgetState createState() => CustomSnackbarWidgetState();
}

class CustomSnackbarWidgetState extends State<CustomSnackbarWidget> {
  int _count = 0;
  String _selectedPayment = 'Click';

  void showCustomCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomConfigurationWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Ro'yxatdan O'tish",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Joylar sonini tanlang",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    if (_count > 0) _count--;
                  });
                },
              ),
              Text('$_count', style: const TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    _count++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "To'lov turini tanlang",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          RadioListTile<String>(
            title: const Text('Click', style: TextStyle(fontSize: 16)),
            value: 'Click',
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() {
                _selectedPayment = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Payme', style: TextStyle(fontSize: 16)),
            value: 'Payme',
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() {
                _selectedPayment = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Naqd', style: TextStyle(fontSize: 16)),
            value: 'Naqd',
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() {
                _selectedPayment = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showCustomCongratulationsDialog(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Keyingi",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
