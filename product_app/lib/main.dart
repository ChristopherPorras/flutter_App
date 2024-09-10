import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Para convertir la respuesta JSON a un formato de mapa

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List products = [];  // Lista para almacenar los productos obtenidos de la API

  @override
  void initState() {
    super.initState();
    fetchProducts();  // Llama a la función que obtiene los productos cuando la pantalla se carga
  }

  // Función que realiza la solicitud HTTP a la API del backend
  fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5183/api/Products'));  // Cambia la URL si es necesario

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);  // Decodifica la respuesta JSON y la almacena en la lista de productos
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())  // Muestra un indicador de carga mientras se obtienen los productos
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]['name']),  // Muestra el nombre del producto
                  subtitle: Text("\$${products[index]['price']}"),  // Muestra el precio del producto
                );
              },
            ),
    );
  }
}
