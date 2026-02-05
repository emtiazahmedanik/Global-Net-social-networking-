import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildProductImageCarousel(List<dynamic> imageUrls) {
  // Convert dynamic to String and filter invalid URLs
  final List<String> validImageUrls = imageUrls
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .toList();

  // Show placeholder if no images
  if (validImageUrls.isEmpty) {
    return const SizedBox(
      height: 300,
      child: Center(
        child: Text(
          'No images available',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  return Column(
    children: [
      // Carousel
      CarouselSlider(
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: validImageUrls.length > 1,
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
        items: validImageUrls.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),

      const SizedBox(height: 12),
    ],
  );
}