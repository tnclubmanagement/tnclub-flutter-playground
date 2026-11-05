{{flutter_js}}
{{flutter_build_config}}

// This deployment targets current Chrome only. The Chromium CanvasKit build
// avoids shipping renderer variants for Safari, Firefox, and older browsers.
_flutter.loader.load({
  config: {
    renderer: "canvaskit",
    canvasKitVariant: "chromium",
  },
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
});
