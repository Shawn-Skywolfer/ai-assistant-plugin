// AI Assistant Plugin - Background Script
console.log('AI Assistant Plugin loaded');

// Register header button
PluginAPI.registerHeaderButton({
  label: 'AI Assistant',
  icon: 'smart_toy',
  onClick: function () {
    PluginAPI.showIndexHtmlAsView();
  },
});

// Register menu entry
PluginAPI.registerMenuEntry({
  label: 'AI Assistant',
  icon: 'smart_toy',
  onClick: function () {
    PluginAPI.showIndexHtmlAsView();
  },
});

// Register keyboard shortcut
PluginAPI.registerShortcut({
  id: 'open_ai_assistant',
  label: 'Open AI Assistant',
  onExec: function () {
    PluginAPI.showIndexHtmlAsView();
  },
});
