import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedSearchTopics = [];
  bool _isLoading = false;
  late QuestionProvider _questionProvider;
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    _questionProvider.listOfSearchQuestions.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _questionProvider = Provider.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.primaryBlueColor,
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white),
                  controller: _searchController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent), // Underline color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Focus underline color
                    ),
                    prefixIconColor: Colors.white,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) async {
                    _isLoading = true;
                    _searchQuery = value;
                    setState(() {});
                    await _questionProvider.searchQuestions(
                        searchString: value);
                    _isLoading = false;
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _questionProvider.lastSearchDocument = null;
                  _questionProvider.listOfSearchQuestions.clear();
                  _questionProvider.listOfTempSearchQuestions.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_questionProvider.listOfSearchQuestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Search results for: ",
                          style: TextStyle(
                            color: Styles.primaryBlueColor,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _searchQuery,
                            style: TextStyle(
                              color: Styles.primaryBlueColor,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          offset: Offset(0, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.filter_list),
                          itemBuilder: (BuildContext context) {
                            return Styles.listOfTopics.map((String topic) {
                              return PopupMenuItem(
                                value: topic,
                                child: CheckboxListTile(
                                  title: Text(topic),
                                  value: _selectedSearchTopics.contains(topic),
                                  onChanged: (value) {
                                    if (value != null) {
                                      if (value) {
                                        _selectedSearchTopics.add(topic);
                                      } else {
                                        _selectedSearchTopics.remove(topic);
                                      }
                                    }
                                    log("selected topic is: $_selectedSearchTopics");
                                    setState(() {});
                                  },
                                ),
                              );
                            }).toList();
                          },
                          onSelected: (String selectedTopic) {
                            // Handle the selected topic if needed
                            log("Selected Topic: $selectedTopic");
                          },
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 60),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _questionProvider.listOfSearchQuestions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: QuestionCard(
                            question:
                                _questionProvider.listOfSearchQuestions[index],
                            onTap: () {
                              {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QuestionDetailsPage(
                                        question: _questionProvider
                                            .listOfSearchQuestions[index])));
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                            color: Styles.primaryBlueColor)),
                  ))
          ],
        ),
      ),
    );
  }
}
