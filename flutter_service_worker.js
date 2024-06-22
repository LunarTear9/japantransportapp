'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "2437e0c88195f9da772a2cb9b4e01c9d",
"assets/AssetManifest.bin.json": "69ad49102ad2ab169486a2da9139f231",
"assets/AssetManifest.json": "6894575bc78ed5a9568b8025f9e6ec0f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "dbb94a521d2fe63d28b4caa551f00306",
"assets/lib/assets/(1)21.png": "ce361a278a3a1aef32e94675b5f5eca3",
"assets/lib/assets/1200px-Fukutoshin_Line_Shibuya_Station_002%2520(1).jpg": "5e1956618326004fd8893447c9b35971",
"assets/lib/assets/2(1)10.png": "4bd97d0a982c475cd046b76bc1124cb1",
"assets/lib/assets/2(1)11.png": "4dfe9e2d8939a88a7e09e496f26d2507",
"assets/lib/assets/2(1)12.png": "71b2b9dc1c7382543e32a50a5afbb53b",
"assets/lib/assets/2(1)13.png": "303f9075bf4c3ffebc764d52b574a01e",
"assets/lib/assets/2(1)14.png": "1eec16e4f9f48d538c5c5c8109b165a7",
"assets/lib/assets/2(1)15.png": "5c0c70c33a6e98b38164fa9cefaaeabb",
"assets/lib/assets/2(1)16.png": "360c29e563b5119ca17b6c691acaeae3",
"assets/lib/assets/2(1)17.png": "4a9ccf21ba5aea41c4c54025dfbb1615",
"assets/lib/assets/2(1)18.png": "4336bdf20a2d101dcbd739c8835f8d57",
"assets/lib/assets/2(1)19.png": "cbf3803a12bc37d5d3e584bd7590341f",
"assets/lib/assets/2(1)2.png": "0d7950ff02c35dce29e0e0ef37d42c27",
"assets/lib/assets/2(1)20.png": "f5b4df5755d7f6d874bd829e93bd208a",
"assets/lib/assets/2(1)3.png": "8dc0c69f10a2f237095721ca45a62259",
"assets/lib/assets/2(1)4.png": "471ff3e256940152515fdab91497bb39",
"assets/lib/assets/2(1)5.png": "7c9c1fe166e8c35a1c6034c3a50449dd",
"assets/lib/assets/2(1)6.png": "080f8469b2d8d62f9f6c52c7aaedde42",
"assets/lib/assets/2(1)7.png": "5f6eaf41e514dd4de56e9e94f860c6f3",
"assets/lib/assets/2(1)8.png": "6401350f8c3d85a2cc4dd75ccac782cb",
"assets/lib/assets/2(1)9.png": "72987da8276eb40ca2fdd5d0099ad820",
"assets/lib/assets/2.png": "3c2f68cd5f7e2909e4a6db312122d76b",
"assets/lib/assets/A.png": "ab0acccace64d14763cbf3423b0ce13a",
"assets/lib/assets/A2.png": "aac6fa925a4a934c91047dc661a82976",
"assets/lib/assets/C-Off.png": "ff26c719004a776c80ef811e2d19d564",
"assets/lib/assets/C.png": "b5d3026a9e6c7b5d6f62c6caf433892b",
"assets/lib/assets/E.png": "9121e0752dc4d724d874de57bd37f218",
"assets/lib/assets/F-Off.png": "634cc027634cfedcd26cf62553900501",
"assets/lib/assets/F.png": "9330f6c58844443bd2253c6e4b8ee08b",
"assets/lib/assets/G-Off.png": "da5afec90bab55bfbded1f73449f6a96",
"assets/lib/assets/G-removebg-preview.png": "da5afec90bab55bfbded1f73449f6a96",
"assets/lib/assets/H-Off.png": "6251e74289d6e3af9fd46b60f4200238",
"assets/lib/assets/H-removebg-preview.png": "6251e74289d6e3af9fd46b60f4200238",
"assets/lib/assets/M-Off.png": "5524a4556b28ba0af4ee88d413d9fa9b",
"assets/lib/assets/M-removebg-preview.png": "5524a4556b28ba0af4ee88d413d9fa9b",
"assets/lib/assets/map_style.json": "25cc40522ab5247c9f02f5f4a3a0c25a",
"assets/lib/assets/N-Off.png": "8e4d88c578e97ba0645a7e92fa18673c",
"assets/lib/assets/N-removebg-preview.png": "8e4d88c578e97ba0645a7e92fa18673c",
"assets/lib/assets/s.png": "9199fb9d0ae4be0a1fd4ae2367bc32a0",
"assets/lib/assets/s2.png": "f5c8697e91075d4fd07ec62aaac4d7f4",
"assets/lib/assets/T-Off.png": "f38752be497654e1fc4ea19bab4625bc",
"assets/lib/assets/T-removebg-preview.png": "f38752be497654e1fc4ea19bab4625bc",
"assets/lib/assets/Y-Off.png": "06e01a2c6257d77365cf536123e411db",
"assets/lib/assets/Y-removebg-preview.png": "06e01a2c6257d77365cf536123e411db",
"assets/lib/assets/Z-Off.png": "671ba187c5037ccac23ae20f3d59c83d",
"assets/lib/assets/Z-removebg-preview.png": "671ba187c5037ccac23ae20f3d59c83d",
"assets/NOTICES": "43c2e3b4bf93ce5b4f3bd43a70cebc26",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "89c9ea6ca65a5b2304cc066ecfcaf705",
"/": "89c9ea6ca65a5b2304cc066ecfcaf705",
"main.dart.js": "0a82fd2f9bee8aac24cb30f04f8f6c06",
"manifest.json": "b72134679e75754c4fb4bd18189194a3",
"version.json": "cf83f9c9bfebfe31eeb07d42a77e85b4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
