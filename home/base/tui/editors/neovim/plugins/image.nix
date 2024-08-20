{
  programs.nixvim.plugins.image = {
    enable = false;
    backend = "ueberzug";
    editorOnlyRenderWhenFocused = true;
    maxWidth = 50;
    maxHeight = 50;
    integrations.markdown.onlyRenderImageAtCursor = true;
  };
}
