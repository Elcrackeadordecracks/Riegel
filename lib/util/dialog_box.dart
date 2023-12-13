import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rigel/screens/camara.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController caloriesController;
  final TextEditingController additivesController;
  final TextEditingController vitaminsController;
  final TextEditingController priceController;
  final TextEditingController rankingController;
  final TextEditingController imagesController;
  final TextEditingController quantityController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.categoryController,
    required this.caloriesController,
    required this.additivesController,
    required this.vitaminsController,
    required this.priceController,
    required this.rankingController,
    required this.imagesController,
    required this.quantityController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildFormSection("General", [
              _buildTextField(titleController, "Title"),
              _buildTextField(descriptionController, "Description"),
              _buildCategoryTextField(context),
            ]),
            _buildFormSection("Nutritional Information", [
              _buildTextField(
                  caloriesController, "Calories", TextInputType.number),
              _buildTextField(
                  additivesController, "Additives", TextInputType.number),
              _buildTextField(
                  vitaminsController, "Vitamins", TextInputType.number),
            ]),
            _buildFormSection("Pricing", [
              _buildTextField(priceController, "Price",
                  TextInputType.numberWithOptions(decimal: true)),
              _buildTextField(
                  rankingController, "Ranking", TextInputType.number),
            ]),
            _buildFormSection("Quantity and Photos", [
              _buildTextField(
                  quantityController, "Quantity", TextInputType.number),
              _buildTakePhotosButton(context),
            ]),
            _buildButtonsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        ...fields,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCategoryTextField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Select Category"),
              content: Column(
                children: [
                  _buildCategoryOption("Vitamins", context),
                  _buildCategoryOption("Supplements", context),
                ],
              ),
            );
          },
        ).then((selectedCategory) {
          if (selectedCategory != null) {
            categoryController.text = selectedCategory;
          }
        });
      },
      child:
          _buildTextField(categoryController, "Category", TextInputType.text),
    );
  }

  Widget _buildCategoryOption(String category, BuildContext context) {
    return ListTile(
      title: Text(category),
      onTap: () {
        Navigator.pop(context, category);
      },
    );
  }

  Widget _buildTakePhotosButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        // Añade el widget Center aquí
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(
                  title: "Your Title",
                  onPhotosTaken: (List<String> photos) {
                    print("Received photos: $photos");
                    String concatenatedPhotos = photos.join(", ");
                    imagesController.text = concatenatedPhotos;
                  },
                ),
              ),
            );
          },
          child: Text("Take Photos"),
        ),
      ),
    );
  }

  Widget _buildButtonsRow(BuildContext context) {
    return Container(
      alignment: Alignment.center, // Centra los botones
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra los botones horizontalmente
        children: [
          MyButton(
            text: "Save",
            onPressed: () {
              if (_validateForm()) {
                onSave();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("Complete all fields before saving."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            buttonColor: Colors.grey, // Color verde para el botón "Save"
          ),
          const SizedBox(width: 8),
          MyButton(
            text: "Cancel",
            onPressed: onCancel,
            buttonColor:
                Colors.red.shade200, // Color rojo para el botón "Cancel"
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        caloriesController.text.isNotEmpty &&
        additivesController.text.isNotEmpty &&
        vitaminsController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        rankingController.text.isNotEmpty &&
        imagesController.text.isNotEmpty &&
        quantityController.text.isNotEmpty;
  }
}
