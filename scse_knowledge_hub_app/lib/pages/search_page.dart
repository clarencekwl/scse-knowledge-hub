import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/pages/question_details_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/no_glow_scroll.dart';
import 'package:scse_knowledge_hub_app/widget/question_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isFilter = false;
  late QuestionProvider _questionProvider;
  List<String> _tempSelectedTopics = [];
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.grey.shade500,
              ),
              SizedBox(height: 4),
              Text(
                'Tips',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: (() async {
                _questionProvider.lastSearchDocument = null;
                _questionProvider.listOfSearchQuestions.clear();
                _questionProvider.listOfTempSearchQuestions.clear();
                Navigator.of(context).pop();
              }),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          backgroundColor: Styles.primaryBlueColor,
          title: _searchBar(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (_questionProvider.listOfSearchQuestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 0, left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchQuery.isNotEmpty &&
                                  _questionProvider
                                      .listOfSearchQuestions.isNotEmpty)
                                RichText(
                                    text: TextSpan(
                                  style: TextStyle(
                                    color: Styles.primaryBlueColor,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Search results for: ",
                                    ),
                                    TextSpan(
                                      text: _searchQuery,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )),
                              if (_isFilter &&
                                  _questionProvider
                                      .listOfFilteredSearchQuestion.isNotEmpty)
                                Text(
                                  "Filtered Results",
                                  style: TextStyle(
                                      color: Styles.primaryBlueColor,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              if (_isFilter &&
                                  _questionProvider
                                      .listOfFilteredSearchQuestion.isEmpty)
                                Text(
                                  "There are no revelant filtered results",
                                  style: TextStyle(
                                      color: Styles.primaryBlueColor,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _showFilterDialog(context);
                            },
                            icon: Icon(Icons.filter_list)),
                        if (_isFilter)
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _tempSelectedTopics = [];
                                _isFilter = false;
                                setState(() {});
                              },
                              child: Text("Clear"),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (_searchQuery.isNotEmpty &&
                    _questionProvider.listOfSearchQuestions.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 0, left: 10, right: 10),
                      child: RichText(
                          text: TextSpan(
                        style: TextStyle(
                          color: Styles.primaryBlueColor,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "We found nothing found for: ",
                          ),
                          TextSpan(
                            text: _searchQuery,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "\nTry something else!",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: StretchingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 60),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _isFilter
                              ? _questionProvider
                                  .listOfFilteredSearchQuestion.length
                              : _questionProvider.listOfSearchQuestions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: QuestionCard(
                                question: _isFilter
                                    ? _questionProvider
                                        .listOfFilteredSearchQuestion[index]
                                    : _questionProvider
                                        .listOfSearchQuestions[index],
                                onTap: () {
                                  {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QuestionDetailsPage(
                                                  question: _isFilter
                                                      ? _questionProvider
                                                              .listOfFilteredSearchQuestion[
                                                          index]
                                                      : _questionProvider
                                                              .listOfSearchQuestions[
                                                          index],
                                                )));
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          height: 250.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tips for a Better Search Experience!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              _buildTip('Include course code (e.g. CZ4041, SC2002).'),
              _buildTip(
                  'Search for keywords (e.g. Java, FYP, MDP) instead of long sentences.'),
              _buildTip('Make use of filters provided.'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Row _searchBar() {
    return Row(
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
                borderSide:
                    BorderSide(color: Colors.transparent), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focus underline color
              ),
              prefixIconColor: Colors.white,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) async {
              _clearSearch();
              _isLoading = true;
              setState(() {});
              await _questionProvider.searchQuestions(searchString: value);
              _isLoading = false;
              setState(() {});
              _searchQuery = value;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            _clearSearch();
            setState(() {});
          },
        ),
      ],
    );
  }

  void _clearSearch() {
    _tempSelectedTopics.clear();
    _isFilter = false;
    _searchQuery = "";
    _questionProvider.lastSearchDocument = null;
    _questionProvider.listOfSearchQuestions.clear();
    _questionProvider.listOfTempSearchQuestions.clear();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Filter by Topics:',
            style: TextStyle(
                color: Styles.titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Styles.listOfTopics.length,
                    itemBuilder: (context, index) {
                      final topic = Styles.listOfTopics[index];
                      return CheckboxListTile(
                        title: Text(
                          topic,
                        ),
                        value: _tempSelectedTopics.contains(topic),
                        onChanged: (bool? value) {
                          if (value != null) {
                            if (value == true) {
                              _tempSelectedTopics.add(topic);
                            } else {
                              _tempSelectedTopics.remove(topic);
                            }
                          }

                          setState(() {});
                        },
                        activeColor: Styles.primaryLightBlueColor,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _isFilter = _questionProvider.getFilteredQuestions(
                    _tempSelectedTopics.isEmpty ? null : _tempSelectedTopics,
                    isSearch: true);
                setState(() {});
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: Styles.titleTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
