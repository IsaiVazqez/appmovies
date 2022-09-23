import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/credits_response.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.getMovieCast(
          movieId,
        ),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 150),
              height: 180,
              child: const CupertinoActivityIndicator(),
            );
          }

          final List<Cast> cast = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Casting',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    itemBuilder: (_, int index) {
                      return _CastCard(actor: cast[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.height * 0.17,
      height: size.height * 0.8,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(actor.fullProfilePath),
                width: 130,
                height: 175,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
