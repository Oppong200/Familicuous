import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class TImelineView extends StatelessWidget {
  const TImelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Timeline'),
          actions: [
            IconButton(
              onPressed: null,
              icon: Icon(
                UniconsLine.plus_square,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Card(
              elevation: 0,
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/6785291/pexels-photo-6785291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                        ),
                      ),
                      title: Text(
                        'Ella Begovic',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        'posted 8 hours ago',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                      ),
                      trailing: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    const Text('data'),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.pexels.com/photos/8806013/pexels-photo-8806013.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                UniconsLine.thumbs_up,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                UniconsLine.comment_lines,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: null,
                            icon:  Icon(
                              UniconsLine.telegram_alt,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
