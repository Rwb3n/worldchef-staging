# Cookbook: Fastify Image Upload to Supabase

**Pattern:** Multipart Form Handling with Supabase Storage
**Source:** `image_upload_endpoint.md` stub
**Validated in:** Cycle 4

This is the canonical pattern for handling file uploads from the client.

### 1. Backend: Fastify Plugin and Route

Use `fastify-multipart` to handle the incoming file stream.

```typescript
// src/plugins/multipart_plugin.ts
import fp from 'fastify-plugin';
import multipart from '@fastify/multipart';

export default fp(async (fastify) => {
  fastify.register(multipart, {
    limits: {
      fileSize: 5 * 1024 * 1024, // 5MB limit
    },
  });
});

// src/routes/images.ts
import { createClient } from '@supabase/supabase-js';

fastify.post('/v1/images/upload', { preHandler: [fastify.authenticate] }, async (req, reply) => {
  const data = await req.file();
  if (!data) {
    return reply.code(400).send({ error: 'No file uploaded.' });
  }

  // Example: user/{userId}/recipe_hero_{timestamp}.jpg
  const path = `user/${(req as any).user.sub}/recipe_hero_${Date.now()}.${data.filename.split('.').pop()}`;

  const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!);

  const { error } = await supabase.storage
    .from('worldchef-images') // Your bucket name
    .upload(path, data.file, {
      contentType: data.mimetype,
      upsert: true,
    });

  if (error) {
    throw error;
  }

  const { data: { publicUrl } } = supabase.storage.from('worldchef-images').getPublicUrl(path);

  reply.send({ url: publicUrl });
});
```
### 2. Frontend: Flutter Upload Logic
Use the image_picker and dio packages to send the file.
```dart
// lib/services/image_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final _dio = Dio();
  final _picker = ImagePicker();

  Future<String?> pickAndUploadImage() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) return null;

    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final response = await _dio.post(
      'https://your-api.com/v1/images/upload',
      data: formData,
      options: Options(headers: {"Authorization": "Bearer YOUR_JWT"}),
    );

    return response.data['url'];
  }
}
``` 