import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '購物計算機',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // 確保使用的是 Material 2 主題
      ),
      home: const ShoppingCalculator(),
    );
  }
}

class ShoppingCalculator extends StatefulWidget {
  const ShoppingCalculator({Key? key}) : super(key: key);

  @override
  ShoppingCalculatorState createState() => ShoppingCalculatorState();
}

class ShoppingCalculatorState extends State<ShoppingCalculator> {
  final List<TextEditingController> amountControllers = List.generate(
    20,
    (index) => TextEditingController(),
  );

  final List<int> quantityValues = List.generate(20, (index) => 0);
  int totalQuantity = 0;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // 初始化數量為默認值，例如 1
    for (int i = 0; i < quantityValues.length; i++) {
      quantityValues[i] = 1; // 默認設置為 1
    }
    // 如果不需要即時計算，可以省略這段程式碼
    // for (var controller in amountControllers) {
    //   controller.addListener(_calculate);
    // }
  }

  @override
  void dispose() {
    // 清理 controller
    for (var controller in amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('購物計算機'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  child: const Text('計算'),
                ),
                ElevatedButton(
                  onPressed: _clear,
                  child: const Text('清除'),
                ),
                Text('總數量: $totalQuantity'),
                Text('總金額: \$${totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 16.0),
            for (int i = 0; i < 20; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountControllers[i],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: '商品 ${i + 1}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  DropdownButton<int>(
                    value: quantityValues[i],
                    onChanged: (newValue) {
                      setState(() {
                        quantityValues[i] = newValue!;
                        _calculate(); // 數量改變時立即重新計算
                      });
                    },
                    items: [0, 1, 2, 3, 4, 5]
                        .map((value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    int quantity = 0;
    double amount = 0.0;

    for (int i = 0; i < 20; i++) {
      double itemPrice =
          double.tryParse(amountControllers[i].text.trim()) ?? 0.0;

      if (itemPrice > 0) {
        // 只有當商品金額有效時，才計算數量
        quantity += quantityValues[i];
        amount += itemPrice * quantityValues[i];
      }
    }

    setState(() {
      totalQuantity = quantity;
      totalAmount = amount;
    });
  }

  void _clear() {
    for (int i = 0; i < 20; i++) {
      amountControllers[i].clear();
      quantityValues[i] = 0;
    }
    setState(() {
      totalQuantity = 0;
      totalAmount = 0.0;
    });
  }
}
