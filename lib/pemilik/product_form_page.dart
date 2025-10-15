import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';

/// A single page that adapts for both Add and Edit Product flows.
/// - If [initialProduct] is null: Add mode.
/// - If [initialProduct] is provided: Edit mode and fields are prefilled.
class ProductFormPage extends StatefulWidget {
  final Product? initialProduct;
  const ProductFormPage({super.key, this.initialProduct});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;

  final List<String> _categories = const [
    'Kamera',
    'Lensa',
    'Tripod',
    'Lighting',
  ];
  late String _selectedCategory;
  bool _dropdownOpen = false;

  final ImagePicker _picker = ImagePicker();
  File? _pickedImageFile;

  bool get _isEdit => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProduct;
    _titleCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
      text: p != null ? p.pricePerDay.toStringAsFixed(0) : '',
    );
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _selectedCategory =
        p?.category ?? _categories.first; // Use product category or default
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xfile != null) {
      setState(() {
        _pickedImageFile = File(xfile.path);
      });
    }
  }

  String _fileNameFromPath(String path) {
    // Avoid adding an extra dependency just to get basename
    final parts = path.split('/');
    return parts.isNotEmpty ? parts.last : path;
  }

  void _submit() {
    // For now we just pop with a filled Product object (id synthesized)
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id:
          widget.initialProduct?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _titleCtrl.text.trim(),
      imageAsset:
          _pickedImageFile?.path ?? widget.initialProduct?.imageAsset ?? '',
      pricePerDay:
          double.tryParse(
            _priceCtrl.text.replaceAll('.', '').replaceAll(',', ''),
          ) ??
          0,
      rating: widget.initialProduct?.rating ?? 0,
      owner: widget.initialProduct?.owner ?? 'Mas Amba',
      description: _descCtrl.text.trim(),
      category: _selectedCategory,
      isBooked: widget.initialProduct?.isBooked ?? false,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text(
                'Foto Produk',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              _UploadButton(
                label: _pickedImageFile != null
                    ? _fileNameFromPath(_pickedImageFile!.path)
                    : (_isEdit && widget.initialProduct!.imageAsset.isNotEmpty
                          ? _fileNameFromPath(widget.initialProduct!.imageAsset)
                          : 'Upload foto'),
                onTap: _pickImage,
              ),

              const SizedBox(height: 20),
              const Text(
                'Judul Produk',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleCtrl,
                decoration: _inputDecoration(),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Judul wajib diisi' : null,
              ),

              const SizedBox(height: 20),
              const Text('Kategori', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              _CategoryDropdown(
                value: _selectedCategory,
                isOpen: _dropdownOpen,
                onTap: () => setState(() => _dropdownOpen = !_dropdownOpen),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                    _dropdownOpen = false;
                  });
                },
                options: _categories,
              ),

              const SizedBox(height: 20),
              const Text(
                'Harga sewa/hari',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(prefixText: 'Rp '),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Harga wajib diisi'
                    : null,
              ),

              const SizedBox(height: 20),
              const Text(
                'Deskripsi Produk',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                minLines: 5,
                maxLines: 8,
                decoration: _inputDecoration(),
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C62F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Edit' : 'Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? prefixText}) {
    return InputDecoration(
      isDense: true,
      prefixText: prefixText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black87),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const _UploadButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.black87,
      strokeWidth: 1.2,
      dashPattern: const [6, 6],
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/upload.svg',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 8),
              Text(label, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final String value;
  final bool isOpen;
  final List<String> options;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  const _CategoryDropdown({
    required this.value,
    required this.isOpen,
    required this.options,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(child: Text(value)),
                SvgPicture.asset(
                  isOpen
                      ? 'assets/images/dropdown-up.svg'
                      : 'assets/images/dropdown-down.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                for (final opt in options)
                  InkWell(
                    onTap: () => onChanged(opt),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(children: [Expanded(child: Text(opt))]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
