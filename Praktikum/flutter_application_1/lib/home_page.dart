// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/galeri_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _contacts = [];

  DateTime _dueDate = DateTime.now();
  final currentDate = DateTime.now();
  Color _currentColor = Colors.deepPurple;
  late String _selectedFileName =
      ''; // Variabel untuk menyimpan nama file yang dipilih

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.first;
    setState(() {
      _selectedFileName = file.name; // Menyimpan nama file yang dipilih
      _openFile(file);
    });
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
    print(file.name);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? validateName(String value) {
    Pattern pattern = r'^[A-Z][a-z]+(\s[A-Z][a-z]+)+$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'min 2 kata, dimulai dengan huruf kapital, dan tidak boleh mengandung angka atau karakter khusus';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String value) {
    Pattern pattern = r'^0[0-9]{7,14}$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Min 8 digit, max 15 digit, dan diawali dengan angka 0';
    } else {
      return null;
    }
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _editContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Contact', style: GoogleFonts.montserrat()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _contacts[index]['name'],
              onChanged: (value) {
                _contacts[index]['name'] = value;
              },
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              initialValue: _contacts[index]['phone'],
              onChanged: (value) {
                _contacts[index]['phone'] = value;
              },
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: SafeArea(
          child: Container(
        width: 300,
        color: Colors.white70,
        child: ListTileTheme(
            textColor: Colors.black,
            iconColor: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    width: 50,
                    height: 50,
                    'assets/images/alta.jpg',
                    alignment: Alignment.center,
                  ),
                ),
                ListTile(
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                          title: '',
                        ),
                      ),
                    );
                  },
                  selected: _selectedIndex == 0,
                  leading: const Icon(Icons.home),
                  title: Text('Contacts', style: GoogleFonts.poppins()),
                ),
                ListTile(
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryPage(),
                      ),
                    );
                  },
                  selected: _selectedIndex == 1,
                  leading: const Icon(Icons.image_outlined),
                  title: Text('Gallery', style: GoogleFonts.poppins()),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            )),
      )),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildForm(context),
            ),
            const Divider(
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildDatePicker(context),
            ),
            const Divider(
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildColorPicker(context),
            ),
            const Divider(
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildFilePicker(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String name = nameController.text;
                    final String phone = phoneController.text;
                    setState(() {
                      // Menyimpan data ke dalam list kontak
                      _contacts.add({
                        'name': name,
                        'phone': phone,
                        'date': DateFormat('dd-MM-yyyy').format(
                            _dueDate), // Menyimpan tanggal dalam format tertentu
                        'color': _currentColor
                            .toString(), // Menyimpan warna sebagai string
                        'file':
                            _selectedFileName, // Menyimpan nama file yang dipilih
                      });
                    });
                    print(
                        'Nama: $name,\nNomor Telepon: $phone, \nSelected File: $_selectedFileName, \nColor: $_currentColor, \nDate: $_dueDate');
                    nameController.clear();
                    phoneController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Submit Successful!',
                            style: GoogleFonts.poppins()),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: Text("Submit", style: GoogleFonts.poppins()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('List Contacts', style: GoogleFonts.poppins()),
            ),
            buildContactList(context),
          ],
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) => validateName(value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
              validator: (value) => validatePhoneNumber(value!),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date', style: GoogleFonts.poppins()),
              Text(
                DateFormat('dd-MM-yyyy').format(_dueDate),
              ),
            ],
          ),
        ),
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.date_range_outlined),
            label: Text("Select", style: GoogleFonts.poppins()),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.deepPurple,
              side: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            onPressed: () async {
              final selectDate = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: DateTime(1990),
                lastDate: DateTime(currentDate.year + 5),
              );
              setState(() {
                if (selectDate != null) {
                  _dueDate = selectDate;
                }
              });
              debugPrint(selectDate.toString());
            },
          ),
        ),
      ],
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Color', style: GoogleFonts.poppins()),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor,
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.colorize),
            label: Text("Pick Color", style: GoogleFonts.poppins()),
            style: OutlinedButton.styleFrom(
              foregroundColor: _currentColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick a color!', style: GoogleFonts.poppins()),
                    content: BlockPicker(
                      pickerColor: _currentColor,
                      onColorChanged: (color) {
                        setState(() {
                          _currentColor = color;
                        });
                        debugPrint(color.toString());
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Save'))
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('File', style: GoogleFonts.poppins()),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.file_present_rounded),
            label: Text("Pick a file", style: GoogleFonts.poppins()),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.deepPurple,
              side: const BorderSide(
                color: Colors.deepPurple,
              ),
            ),
            onPressed: _pickFile,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_selectedFileName, style: GoogleFonts.poppins())),
      ],
    );
  }

  Widget buildContactList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        Color color = _contacts[index]['color'] != null
            ? Color(int.parse(
                _contacts[index]['color']!.split('(0x')[1].split(')')[0],
                radix: 16))
            : Colors.transparent;

        return ListTile(
          title: Text('Contact ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${_contacts[index]['name']!},',
                  style: GoogleFonts.poppins()),
              Text('Nomor: ${_contacts[index]['phone']!}',
                  style: GoogleFonts.poppins()),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Color: ',
                    style: GoogleFonts.poppins(),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('File: ${_contacts[index]['file']}',
                  style: GoogleFonts.poppins()),
              const Divider(),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editContact(index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteContact(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
