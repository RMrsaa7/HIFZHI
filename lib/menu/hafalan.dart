import 'package:flutter/material.dart';

class HafalanPage extends StatefulWidget {
  @override
  _HafalanPageState createState() => _HafalanPageState();
}

class _HafalanPageState extends State<HafalanPage> {
  TextEditingController _namaPesertaController = TextEditingController();
  TextEditingController _nomorRegistrasiController = TextEditingController(text: '12345');
  String? _selectedSurat;
  String? _selectedSampaiSurat;
  String? _selectedAyatAwal;
  String? _selectedAyatAkhir;
  String? _selectedJuz;
  String? _selectedJenisSetoran;
  String? _selectedUstadzMusrif;
  String? _fileName;

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          height: 60,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(icon, color: Color(0xff2DA2A1)),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          height: 60,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(hint, style: TextStyle(color: Colors.black38, fontSize: 16)),
            ),
            value: value,
            icon: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_drop_down, color: Color(0xff2DA2A1)),
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Setorkan Hafalan'),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hafalan telah disetorkan!')),
                        );
                      },
                      child: Text(
                        'Ya',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Tidak',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff2DA2A1)),
        ),
        child: Text(
          'Setorkan Hafalan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Setoran Hafalan',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Color(0xff2DA2A1),
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Silahkan isi kolom yang tersedia dengan benar dan tepat!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildTextField(
                labelText: 'Nama Peserta',
                controller: _namaPesertaController,
                icon: Icons.person,
              ),
              _buildTextField(
                labelText: 'Nomor Registrasi',
                controller: _nomorRegistrasiController,
                icon: Icons.confirmation_number,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Surat',
                      items: ['Al-Fatihah', 'Al-Baqarah', 'Ali Imran'],
                      value: _selectedSurat,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSurat = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Sampai Surat',
                      items: ['An-Nisa', 'Al-Maidah', 'Al-Anam'],
                      value: _selectedSampaiSurat,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSampaiSurat = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Ayat Awal',
                      items: List.generate(286, (index) => 'Ayat ${index + 1}'),
                      value: _selectedAyatAwal,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAyatAwal = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Ayat Akhir',
                      items: List.generate(286, (index) => 'Ayat ${index + 1}'),
                      value: _selectedAyatAkhir,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAyatAkhir = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              _buildDropdown(
                hint: 'Pilih Juz',
                items: List.generate(30, (index) => 'Juz ${index + 1}'),
                value: _selectedJuz,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJuz = newValue;
                  });
                },
              ),
              _buildDropdown(
                hint: 'Pilih Jenis Setoran',
                items: ['Jenis Setoran 1', 'Jenis Setoran 2', 'Jenis Setoran 3'],
                value: _selectedJenisSetoran,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJenisSetoran = newValue;
                  });
                },
              ),
              _buildDropdown(
                hint: 'Pilih Ustadz/Ustadzah Musrif',
                items: ['Ustadz 1', 'Ustadz 2', 'Ustadzah 1'],
                value: _selectedUstadzMusrif,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUstadzMusrif = newValue;
                  });
                },
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
