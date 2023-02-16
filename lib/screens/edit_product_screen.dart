import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editingProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var isInit = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    if (_editingProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(_editingProduct.id!, _editingProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editingProduct);
    }
    Navigator.of(context).pop();
  }

  void _updateImgUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editingProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          'title': _editingProduct.title,
          'price': _editingProduct.price.toString(),
          'description': _editingProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editingProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImgUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initValues['title'],
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (newValue) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    isFavorite: _editingProduct.isFavorite,
                    title: newValue!,
                    description: _editingProduct.description,
                    imageUrl: _editingProduct.imageUrl,
                    price: _editingProduct.price,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                decoration: const InputDecoration(
                  label: Text('Price'),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (newValue) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    isFavorite: _editingProduct.isFavorite,
                    title: _editingProduct.title,
                    description: _editingProduct.description,
                    imageUrl: _editingProduct.imageUrl,
                    price: double.parse(newValue!),
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  } else if (double.parse(value) < 0) {
                    return 'Please enter a value greater than zero';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (newValue) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    isFavorite: _editingProduct.isFavorite,
                    title: _editingProduct.title,
                    description: newValue!,
                    imageUrl: _editingProduct.imageUrl,
                    price: _editingProduct.price,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  } else if (value.length < 10) {
                    return 'Please enter at least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Wrong image');
                            },
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (newValue) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          isFavorite: _editingProduct.isFavorite,
                          title: _editingProduct.title,
                          description: _editingProduct.description,
                          imageUrl: newValue!,
                          price: _editingProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        } else if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid image URL';
                        } else if (!value.endsWith('png') &&
                            !value.endsWith('jpg') &&
                            !value.endsWith('jpeg')) {
                          return 'Please enter a valid image URL';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
