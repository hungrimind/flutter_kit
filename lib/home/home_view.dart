import 'package:flutter/material.dart';
import 'package:flutter_kit/core/http/http_abstraction.dart';
import 'package:flutter_kit/core/utils/locator.dart';
import 'package:flutter_kit/home/home_view_model.dart';

/// Main view displaying a gallery of dog images
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel = HomeViewModel(
    http: locator.get<HttpAbstraction>(),
  );

  @override
  void initState() {
    super.initState();
    // Add a slight delay to ensure context is available for MediaQuery
    Future.microtask(() => _viewModel.initialize());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if screen is wide 
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Doggo Gallery'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _viewModel.clearGallery,
            tooltip: 'Clear Gallery',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _viewModel.showToast('Hello from Toast! 🎉'),
        label: const Text('Show Toast'),
        icon: const Icon(Icons.message),
      ),
      body: SafeArea(
        child: isWideScreen 
          ? WideLayoutWidget(viewModel: _viewModel)
          : NormalLayoutWidget(viewModel: _viewModel),
      ),
    );
  }
}

/// Widget for normal (narrow) screen layout
class NormalLayoutWidget extends StatelessWidget {
  const NormalLayoutWidget({
    super.key, 
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Controls
        ControlsWidget(viewModel: viewModel),
        
        // Featured image section
        Expanded(
          flex: 3,
          child: FeaturedImageWidget(viewModel: viewModel),
        ),
        
        // Gallery section
        Expanded(
          flex: 2,
          child: GalleryWidget(viewModel: viewModel),
        ),
      ],
    );
  }
}

/// Widget for wide screen layout
class WideLayoutWidget extends StatelessWidget {
  const WideLayoutWidget({
    super.key, 
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured image section with padding
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ControlsWidget(viewModel: viewModel),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: FeaturedImageWidget(viewModel: viewModel),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Gallery on the right
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GalleryWidget(viewModel: viewModel),
          ),
        ),
      ],
    );
  }
}

/// Widget for the controls section (fetch button and loading indicator)
class ControlsWidget extends StatelessWidget {
  const ControlsWidget({
    super.key, 
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Interactive button with hover effect
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: _HoverElevatedButton(
              onPressed: () {
                viewModel.fetchRandomDogImage();
              },
              icon: const Icon(Icons.pets),
              label: const Text('Fetch New Doggo'),
            ),
          ),
          
          // Loading indicator
          ValueListenableBuilder<bool>(
            valueListenable: viewModel.isLoading,
            builder: (context, isLoading, _) {
              if (!isLoading) return const SizedBox(height: 8);
              
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Custom elevated button with hover effect
class _HoverElevatedButton extends StatefulWidget {
  const _HoverElevatedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;

  @override
  State<_HoverElevatedButton> createState() => _HoverElevatedButtonState();
}

class _HoverElevatedButtonState extends State<_HoverElevatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transformAlignment: Alignment.center,
        transform: _isHovered 
            ? (Matrix4.identity()..scale(1.02))
            : Matrix4.identity(),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: widget.icon,
          label: widget.label,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: _isHovered 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: _isHovered ? 4 : 2,
          ),
        ),
      ),
    );
  }
}

/// Widget for the featured image display
class FeaturedImageWidget extends StatelessWidget {
  const FeaturedImageWidget({
    super.key, 
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ValueListenableBuilder<String?>(
        valueListenable: viewModel.currentDogImageUrl,
        builder: (context, imageUrl, _) {
          if (imageUrl == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pets, 
                    size: 64, 
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No doggos yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the "Fetch New Doggo" button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return Container(
            constraints: const BoxConstraints(
              minHeight: 200,
              minWidth: 200,
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                // Image
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Image load error: $error');
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline, 
                              size: 48, 
                              color: Theme.of(context).colorScheme.error
                            ),
                            const SizedBox(height: 16),
                            const Text('Could not load image'),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Error message
                ValueListenableBuilder<String?>(
                  valueListenable: viewModel.errorMessage,
                  builder: (context, errorMessage, _) {
                    if (errorMessage == null) return const SizedBox.shrink();
                    
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget for displaying the gallery of images
class GalleryWidget extends StatelessWidget {
  const GalleryWidget({
    super.key, 
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: viewModel.dogImageGallery,
      builder: (context, gallery, _) {
        if (gallery.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your gallery is empty',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Text(
                'Your Collection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: MediaQuery.of(context).size.width > 800
                  ? GridGalleryWidget(gallery: gallery, viewModel: viewModel)
                  : HorizontalGalleryWidget(gallery: gallery, viewModel: viewModel),
            ),
          ],
        );
      },
    );
  }
}

/// Widget for displaying a horizontal gallery
class HorizontalGalleryWidget extends StatelessWidget {
  const HorizontalGalleryWidget({
    super.key, 
    required this.gallery,
    required this.viewModel,
  });

  final List<String> gallery;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        final imageUrl = gallery[gallery.length - 1 - index]; // Most recent first
        
        return GalleryItemWidget(
          imageUrl: imageUrl, 
          viewModel: viewModel,
        );
      },
    );
  }
}

/// Widget for displaying a grid gallery
class GridGalleryWidget extends StatelessWidget {
  const GridGalleryWidget({
    super.key, 
    required this.gallery,
    required this.viewModel,
  });

  final List<String> gallery;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        final imageUrl = gallery[gallery.length - 1 - index]; // Most recent first
        
        return GalleryItemWidget(
          imageUrl: imageUrl, 
          viewModel: viewModel,
        );
      },
    );
  }
}

/// Widget for displaying an individual gallery item with hover effect
class GalleryItemWidget extends StatefulWidget {
  const GalleryItemWidget({
    super.key, 
    required this.imageUrl,
    required this.viewModel,
  });

  final String imageUrl;
  final HomeViewModel viewModel;

  @override
  State<GalleryItemWidget> createState() => _GalleryItemWidgetState();
}

class _GalleryItemWidgetState extends State<GalleryItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.viewModel.setCurrentImage(widget.imageUrl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 120,
          height: 120,
          margin: const EdgeInsets.only(right: 12, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: _isHovered ? 8 : 5,
                spreadRadius: _isHovered ? 2 : 1,
              ),
            ],
            border: _isHovered 
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          transformAlignment: Alignment.center,
          transform: _isHovered 
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          child: Hero(
            tag: widget.imageUrl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, _) {
                        debugPrint('Gallery image load error: $error');
                        return Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Icon(
                            Icons.error, 
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Hover overlay
                  if (_isHovered)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
